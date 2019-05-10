import 'package:logging/logging.dart';

abstract class Coverage {
  Future<void> getCoverage(Logger requestLogger, String path);
}
