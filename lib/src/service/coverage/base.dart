import 'package:logging/logging.dart';

abstract class Coverage {
  final String reportOn;
  final bool deleteFolder;

  Coverage(this.reportOn, this.deleteFolder);

  Future<void> generateCoverage(Logger requestLogger, String path);
}
