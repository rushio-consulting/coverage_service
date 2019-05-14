import 'package:coverage_service/src/service/commands.dart';
import 'package:coverage_service/src/service/coverage/base.dart';

class FlutterPackageCoverage extends Coverage {
  FlutterPackageCoverage(bool deleteFolder, Commands commands)
      : super(deleteFolder, commands);

  @override
  Future<void> generateCoverage(String path) async {
    await commands.flutterTest(path);
  }
}
