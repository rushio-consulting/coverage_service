import 'package:coverage_service/src/service/commands.dart';

abstract class Coverage {
  final Commands commands;
  final bool deleteFolder;

  Coverage(this.deleteFolder, this.commands);

  Future<void> generateCoverage(String path);
}
