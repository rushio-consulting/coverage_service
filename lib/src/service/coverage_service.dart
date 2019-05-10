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
    final uuid = Uuid();
    final id = uuid.v1();
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
      packageCoverage = FlutterPackageCoverage();
    } else {
      requestLogger.fine('Dart project');
      packageCoverage = DartPackageCoverage();
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
    requestLogger.info('extract coverage percentage');
    final String out = genHtmlResult.stdout;
    final percentageLineRegExp = RegExp(r'^\s+lines.+: (\d+.\d*)%.+$');
    final line = out.split('\n').firstWhere(
        (line) => percentageLineRegExp.hasMatch(line),
        orElse: () => null);
    if (line == null) {
      await projectDirectory.delete(recursive: true);
      throw GrpcError.internal('NO_PERCENTAGE_FOUND');
    }
    final coverage =
        num.tryParse(percentageLineRegExp.firstMatch(line).group(1));
    if (coverage == null) {
      await projectDirectory.delete(recursive: true);
      throw GrpcError.internal('NO_PERCENTAGE_FOUND');
    }
    await projectDirectory.delete(recursive: true);
    requestLogger.info('send coverage for $name $coverage%');
    return GetCoverageResponse()..coverage = coverage;
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
