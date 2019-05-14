import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coverage_service/src/service/commands.dart';
import 'package:coverage_service/src/service/coverage/base.dart';
import 'package:grpc/grpc.dart';

class DartPackageCoverage extends Coverage {
  final String reportOn;

  DartPackageCoverage(this.reportOn, bool deleteFolder, Commands commands)
      : super(deleteFolder, commands);

  @override
  Future<void> generateCoverage(String path) async {
    final projectDirectory = Directory(path);
    if (!await File('${projectDirectory.path}/test/coverage.dart').exists()) {
      if (deleteFolder) {
        await projectDirectory.delete(recursive: true);
      }
      throw GrpcError.invalidArgument('DOESNT_CONTAINS_COVERAGE');
    }
    await commands.pubGetCommand.pubGet(projectDirectory.path);
    final observatoryUri = await _getObservatoryUri(projectDirectory.path);
    await commands.collectCoverageCommand
        .collectCoverage(projectDirectory.path, observatoryUri);
    await commands.formatCoverageCommand
        .formatCoverage(projectDirectory.path, reportOn: reportOn);
  }

  Future<String> _getObservatoryUri(String workingDirectory) async {
    final completer = Completer<String>();
    final dartResult = await commands.startObservatoryCommand
        .startObservatory(workingDirectory);
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
