import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:coverage_service/coverage_service.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(print);

  final port =
      int.tryParse(Platform.environment['COVERAGE_SERVICE_PORT'] ?? '') ??
          40000;
  final services = [
    CoverageService(),
  ];
  final server = Server(services);
  await server.serve(port: port);
  Logger.root.info('Server listening on port ${server.port}');
}
