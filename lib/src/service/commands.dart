import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class Command {
  final logger = Logger('CoverageService.Command');

  @protected
  Future<Process> start(List<String> arguments, String workingDirectory) {
    return Process.start(
      arguments.first,
      arguments.skip(1).toList(),
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  @protected
  Future<ProcessResult> run(List<String> arguments, String workingDirectory) {
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

class GenHtmlCommand extends Command {
  Future<ProcessResult> genHtml(String projectDirectoryPath) {
    final arguments = ['genhtml', '-o', 'coverage', 'coverage/lcov.info'];
    return run(arguments, projectDirectoryPath);
  }
}

class FlutterTestCommand extends Command {
  Future<ProcessResult> flutterTest(String projectDirectoryPath) {
    final arguments = ['flutter', 'test', '--coverage'];
    return run(arguments, projectDirectoryPath);
  }
}

class PubGetCommand extends Command {
  Future<ProcessResult> pubGet(String projectDirectoryPath) {
    final arguments = ['pub', 'get'];
    return run(arguments, projectDirectoryPath);
  }
}

class StartObservatoryCommand extends Command {
  Future<Process> startObservatory(String projectDirectoryPath) {
    final observatoryPort = Random.secure().nextInt(40000) + 10000;
    final arguments = [
      'dart',
      '--enable-vm-service=$observatoryPort',
      '--pause-isolates-on-exit',
      'test/coverage.dart'
    ];
    return start(arguments, projectDirectoryPath);
  }
}

class CollectCoverageCommand extends Command {
  Future<ProcessResult> collectCoverage(
      String projectDirectoryPath, String observatoryUri) {
    final arguments = [
      'collect_coverage',
      '--uri=$observatoryUri',
      '--out=coverage/coverage.json',
      '--wait-paused',
      '--resume-isolates',
    ];
    return run(arguments, projectDirectoryPath);
  }
}

class FormatCoverageCommand extends Command {
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
    return run(arguments, projectDirectoryPath);
  }
}

class Commands {
  final PubGetCommand pubGetCommand;
  final StartObservatoryCommand startObservatoryCommand;
  final CollectCoverageCommand collectCoverageCommand;
  final FormatCoverageCommand formatCoverageCommand;

  final FlutterTestCommand flutterTestCommand;

  final GenHtmlCommand genHtmlCommand;

  Commands({
    PubGetCommand pubGetCommand,
    StartObservatoryCommand startObservatoryCommand,
    CollectCoverageCommand collectCoverageCommand,
    FormatCoverageCommand formatCoverageCommand,
    FlutterTestCommand flutterTestCommand,
    GenHtmlCommand genHtmlCommand,
  })  : this.pubGetCommand = pubGetCommand ?? PubGetCommand(),
        this.startObservatoryCommand =
            startObservatoryCommand ?? StartObservatoryCommand(),
        this.collectCoverageCommand =
            collectCoverageCommand ?? CollectCoverageCommand(),
        this.formatCoverageCommand =
            formatCoverageCommand ?? FormatCoverageCommand(),
        this.flutterTestCommand = flutterTestCommand ?? FlutterTestCommand(),
        this.genHtmlCommand = genHtmlCommand ?? GenHtmlCommand();
}
