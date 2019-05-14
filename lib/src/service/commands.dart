import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';

class Commands {
  final logger = Logger('CoverageService.Commands');

  Future<ProcessResult> genHtml(String projectDirectoryPath) {
    final arguments = ['genhtml', '-o', 'coverage', 'coverage/lcov.info'];
    return _run(arguments, projectDirectoryPath);
  }

  Future<ProcessResult> flutterTest(String projectDirectoryPath) {
    final arguments = ['flutter', 'test', '--coverage'];
    return _run(arguments, projectDirectoryPath);
  }

  Future<ProcessResult> pubGet(String projectDirectoryPath) {
    final arguments = ['pub', 'get'];
    return _run(arguments, projectDirectoryPath);
  }

  Future<Process> startObservatory(String projectDirectoryPath) {
    final observatoryPort = Random.secure().nextInt(40000) + 10000;
    final arguments = [
      'dart',
      '--enable-vm-service=$observatoryPort',
      '--pause-isolates-on-exit',
      'test/coverage.dart'
    ];
    return _start(arguments, projectDirectoryPath);
  }

  Future<ProcessResult> collectCoverage(
      String projectDirectoryPath, String observatoryUri) {
    final arguments = [
      'collect_coverage',
      '--uri=$observatoryUri',
      '--out=coverage/coverage.json',
      '--wait-paused',
      '--resume-isolates',
    ];
    return _run(arguments, projectDirectoryPath);
  }

  Future<ProcessResult> formatCoverage(String projectDirectoryPath,
      {String reportOn = 'lib'}) {
    final arguments = [
      'format_coverage',
      '--lcov',
      '--in=coverage/coverage.json',
      '--out=coverage/lcov.info',
      '--packages=.packages',
      '--report-on=$reportOn',
    ];
    return _run(arguments, projectDirectoryPath);
  }

  Future<Process> _start(List<String> arguments, String workingDirectory) {
    return Process.start(
      arguments.first,
      arguments.skip(1).toList(),
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  Future<ProcessResult> _run(List<String> arguments, String workingDirectory) {
    logger.info('launch ${arguments.join(' ')}');
    return Process.run(
      arguments.first,
      arguments.skip(1).toList(),
      workingDirectory: workingDirectory,
      runInShell: true,
      stdoutEncoding: utf8,
    );
  }
}
