import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:coverage_service/coverage_service.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  final serviceLogFile = await getLogFile();
  Logger.root.onRecord.listen((logRecord) {
    serviceLogFile.writeAsStringSync('$logRecord\n', mode: FileMode.append);
  });

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

Future<File> getLogFile() async {
  final fileName = 'coverage_service_server';
  int count = 0;
  File f = File('$fileName.$count.log');
  while (f.existsSync()) {
    count++;
    f = File('$fileName.$count.log');
  }
  return f;
}
