import 'dart:io';

import 'package:coverage_service/src/service/coverage/base.dart';
import 'package:logging/logging.dart';

class FlutterPackageCoverage extends Coverage {
  FlutterPackageCoverage(bool deleteFolder) : super(deleteFolder);

  @override
  Future<void> generateCoverage(Logger requestLogger, String path) async {
    requestLogger.fine('flutter test --coverage');
    final projectDirectory = Directory(path);
    await Process.run(
      'flutter',
      ['test', '--coverage'],
      workingDirectory: projectDirectory.path,
    );
  }
}
