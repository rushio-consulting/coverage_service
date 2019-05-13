import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'package:coverage_service/src/service/coverage/base.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

class DartPackageCoverage extends Coverage {
  DartPackageCoverage(String reportOn, bool deleteFolder)
      : super(reportOn, deleteFolder);

  @override
  Future<void> generateCoverage(Logger requestLogger, String path) async {
    final projectDirectory = Directory(path);
    if (!await File('${projectDirectory.path}/test/coverage.dart').exists()) {
      if (deleteFolder) {
        await projectDirectory.delete(recursive: true);
      }
      throw GrpcError.invalidArgument('DOESNT_CONTAINS_COVERAGE');
    }
    requestLogger.info('pub get');
    await Process.run(
      'pub',
      [
        'get',
      ],
      workingDirectory: projectDirectory.path,
    );
    requestLogger.info('get observatory uri');
    final observatoryUri = await _getObservatoryUri(projectDirectory.path);
    requestLogger.info('collect_coverage');
    await Process.run(
      'collect_coverage',
      [
        '--uri=$observatoryUri',
        '--out=coverage/coverage.json',
        '--wait-paused',
        '--resume-isolates',
      ],
      workingDirectory: projectDirectory.path,
    );
    requestLogger.info('format_coverage');
    await Process.run(
      'format_coverage',
      [
        '--lcov',
        '--in=coverage/coverage.json',
        '--out=coverage/lcov.info',
        '--packages=.packages',
        '--report-on=$reportOn',
      ],
      workingDirectory: projectDirectory.path,
    );
  }

  Future<String> _getObservatoryUri(String workingDirectory) async {
    final completer = Completer<String>();
    final observatoryPort = Random.secure().nextInt(40000) + 10000;
    final dartResult = await Process.start(
      'dart',
      [
        '--enable-vm-service=$observatoryPort',
        '--pause-isolates-on-exit',
        'test/coverage.dart'
      ],
      workingDirectory: workingDirectory,
    );
    final lineStartWith = 'Observatory listening on ';
    dartResult.stdout
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((line) {
      if (line.startsWith(lineStartWith)) {
        completer.complete(line.substring(lineStartWith.length));
      }
    });
    return completer.future;
  }
}
