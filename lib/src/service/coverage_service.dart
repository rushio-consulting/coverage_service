import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coverage_service/src/generated/coverage.pbgrpc.dart';
import 'package:coverage_service/src/service/coverage/base.dart';
import 'package:coverage_service/src/service/coverage/dart.dart';
import 'package:coverage_service/src/service/coverage/flutter.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:yaml/yaml.dart';

class CoverageService extends CoverageServiceBase {
  final logger = Logger('CoverageService');

  @override
  Future<GetCoverageResponse> getCoverage(
      ServiceCall call, GetCoverageRequest request) async {
    if (!request.hasZip()) {
      throw GrpcError.invalidArgument('NO_ZIP');
    }
    final bytes = request.zip;
    final id =
        request.hasId() && request.id.isNotEmpty ? request.id : _generateId();
    logger.fine('id is $id');
    var projectDirectory = Directory('/tmp/$id');
    logger.info('start coverage ');
    logger.info('extract from zip');
    final archive = ZipDecoder().decodeBytes(bytes);
    for (ArchiveFile file in archive) {
      final fileName = file.name;
      if (file.isFile) {
        final f = File('${projectDirectory.path}/$fileName');
        await f.create(recursive: true);
        await f.writeAsBytes(file.content);
      } else {
        final d = Directory('${projectDirectory.path}/$fileName');
        await d.create(recursive: true);
      }
    }
    logger.info('end extract from zip');
    final pubspec = File('${projectDirectory.path}/pubspec.yaml');
    if (!await pubspec.exists()) {
      if (request.deleteFolder) {
        await projectDirectory.delete(recursive: true);
      }
      throw GrpcError.invalidArgument('NO_PUBSPEC');
    }
    logger.fine('get project name');
    final name = await _getProjectName(pubspec);
    final requestLogger = Logger('CoverageService.$name');
    requestLogger.fine('Check if it\'s Flutter');
    final isFlutter = await _isFlutterProject(pubspec);
    Coverage packageCoverage;
    if (isFlutter) {
      requestLogger.fine('Flutter project');
      packageCoverage = FlutterPackageCoverage(request.deleteFolder);
    } else {
      requestLogger.fine('Dart project');
      packageCoverage = DartPackageCoverage(request.deleteFolder);
    }
    await packageCoverage.getCoverage(requestLogger, projectDirectory.path);
    requestLogger.info('genhtml');
    final genHtmlResult = await Process.run(
      'genhtml',
      ['-o', 'coverage', 'coverage/lcov.info'],
      workingDirectory: projectDirectory.path,
      runInShell: true,
      stdoutEncoding: utf8,
    );
    requestLogger.info('rewrite lcov path');
    await _rewriteLcovPath(projectDirectory.path);
    requestLogger.info('rename /tmp/$id to /tmp/rushio-gen-coverage-$id');
    projectDirectory =
        await projectDirectory.rename('/tmp/rushio-gen-coverage-$id');
    requestLogger.info('extract coverage percentage');
    final String out = genHtmlResult.stdout;
    final percentageLineRegExp = RegExp(r'^\s+lines.+: (\d+.\d*)%.+$');
    final line = out.split('\n').firstWhere(
        (line) => percentageLineRegExp.hasMatch(line),
        orElse: () => null);
    if (line == null) {
      if (request.deleteFolder) {
        await projectDirectory.delete(recursive: true);
      }
      throw GrpcError.internal('NO_PERCENTAGE_FOUND');
    }
    final coverage =
        num.tryParse(percentageLineRegExp.firstMatch(line).group(1));
    if (coverage == null) {
      if (request.deleteFolder) {
        await projectDirectory.delete(recursive: true);
      }
      throw GrpcError.internal('NO_PERCENTAGE_FOUND');
    }
    if (request.deleteFolder) {
      await projectDirectory.delete(recursive: true);
    }
    requestLogger.info('send coverage for $name $coverage%');
    return GetCoverageResponse()..coverage = coverage;
  }

  Future<void> _rewriteLcovPath(String projectDirectory) async {
    final projectId = projectDirectory.split('/').last;
    final lcov = File('$projectDirectory/coverage/lcov.info');
    final lines = await lcov.readAsLines();
    final regExpString = '^SF:\/tmp\/$projectId/(.*)\$';
    logger.info(regExpString);
    final regExp = RegExp(regExpString);
    final newLines = <String>[];
    for (final line in lines) {
      logger.info(line);
      if (regExp.hasMatch(line)) {
        final match = regExp.firstMatch(line);
        final keep = match.group(1);
        logger.info(keep);
        newLines.add(line.replaceFirst(line, 'SF:$keep'));
      } else {
        newLines.add(line);
      }
    }
    await lcov.writeAsString(newLines.join('\n'));
  }

  String _generateId() {
    final uuid = Uuid();
    return uuid.v1();
  }

  Future<String> _getProjectName(File pubspec) async {
    var yaml = loadYaml(pubspec.readAsStringSync());
    return yaml['name'];
  }

  Future<bool> _isFlutterProject(File pubspec) async {
    var yaml = loadYaml(pubspec.readAsStringSync());
    return (yaml['environment'] as YamlMap)?.containsKey('flutter') == true ||
        (yaml['dependencies'] as YamlMap)?.value?.containsKey('flutter') ==
            true ||
        yaml['flutter'] != null;
  }
}
