import 'dart:io';

import 'package:coverage_service/src/generated/coverage.pbgrpc.dart';
import 'package:coverage_service/src/service/coverage_service.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen(print);
  final service = CoverageService();

  test('get coverage', () async {
    final file = File('test/test_project.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()..zip = bytes;
    final response = await service.getCoverage(null, request);
    expect(response.coverage, 100);
  }, timeout: Timeout(Duration(minutes: 1)));
}
