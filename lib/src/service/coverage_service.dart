import 'dart:async';
import 'dart:io';

import 'package:coverage_service/generated/coverage.pbgrpc.dart';
import 'package:coverage_service/src/service/commands.dart';
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
  final Commands commands;

  CoverageService({Commands commands}) : this.commands = commands ?? Commands();

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
    logger.info('start coverage');
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
    String reportOn = request.reportOn;
    if (!request.hasReportOn()) {
      reportOn = 'lib';
    }
    if (isFlutter) {
      requestLogger.fine('Flutter project');
      packageCoverage = FlutterPackageCoverage(request.deleteFolder, commands);
    } else {
      requestLogger.fine('Dart project');
      packageCoverage =
          DartPackageCoverage(reportOn, request.deleteFolder, commands);
    }
    await packageCoverage.generateCoverage(projectDirectory.path);
    requestLogger.info('genhtml');
    final genHtmlResult =
        await commands.genHtmlCommand.genHtml(projectDirectory.path);
    requestLogger.info('rewrite lcov path');
    await _rewriteLcovPath(projectDirectory.path);
    requestLogger.info('rename /tmp/$id to /tmp/rushio-gen-coverage-$id');
    projectDirectory =
        await projectDirectory.rename('/tmp/rushio-gen-coverage-$id');
    if (request.deleteFolder) {
      await projectDirectory.delete(recursive: true);
    }
    requestLogger.info('extract coverage percentage');
    final String out = genHtmlResult.stdout;
    final percentageLineRegExp = RegExp(r'^\s+lines.+: (\d+.\d*)%.+$');
    final line = out.split('\n').firstWhere(
        (line) => percentageLineRegExp.hasMatch(line),
        orElse: () => null);
    if (line == null) {
      requestLogger.severe('no percentage found in the output of genhtml');
      throw GrpcError.invalidArgument('NO_PERCENTAGE');
    }
    final coverage =
        num.tryParse(percentageLineRegExp.firstMatch(line).group(1));
    requestLogger.info('send coverage for $name $coverage%');
    return GetCoverageResponse()..coverage = coverage;
  }

  Future<void> _rewriteLcovPath(String projectDirectory) async {
    final projectId = projectDirectory.split('/').last;
    final lcov = File('$projectDirectory/coverage/lcov.info');
    final lines = await lcov.readAsLines();
    final regExpString = '^SF:\/tmp\/$projectId/(.*)\$';
    final regExp = RegExp(regExpString);
    final newLines = <String>[];
    for (final line in lines) {
      if (regExp.hasMatch(line)) {
        final match = regExp.firstMatch(line);
        final keep = match.group(1);
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
