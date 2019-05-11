import 'package:logging/logging.dart';

abstract class Coverage {
  final bool deleteFolder;

  Coverage(this.deleteFolder);

  Future<void> getCoverage(Logger requestLogger, String path);
}
