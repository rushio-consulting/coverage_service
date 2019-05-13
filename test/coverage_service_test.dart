import 'dart:io';

import 'package:coverage_service/generated/coverage.pb.dart';
import 'package:coverage_service/src/service/coverage_service.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart';
import 'package:mockito/mockito.dart';

class MockCoverageService extends Mock implements CoverageService {}

class MockProcesses extends Mock implements Processes {}

void main() {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen(print);
  final service = CoverageService();
  final mockProcesses = MockProcesses();
  final mockableService = CoverageService(processes: mockProcesses);

  test('dart project', () async {
    final file = File('test/dart_project.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()..zip = bytes;
    final response = await service.getCoverage(null, request);
    expect(response.coverage, 100);
  }, timeout: Timeout(Duration(minutes: 1)));

  test('no zip', () async {
    final request = GetCoverageRequest();
    try {
      await service.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'NO_ZIP');
    }
  });

  test('no pubspec', () async {
    final file = File('test/no_pubspec.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()..zip = bytes;
    try {
      await service.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'NO_PUBSPEC');
    }
  });

  test('flutter project', () async {
    final file = File('test/flutter_project.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()..zip = bytes;
    final response = await service.getCoverage(null, request);
    expect(response.coverage, 96.0);
  });

  test('dart project with no coverage.dart', () async {
    final file = File('test/no_coverage.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()..zip = bytes;
    try {
      await service.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'DOESNT_CONTAINS_COVERAGE');
    }
  });

  test('dart project with no coverage.dart and delete project', () async {
    final file = File('test/no_coverage.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()
      ..zip = bytes
      ..deleteFolder = true;
    try {
      await service.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'DOESNT_CONTAINS_COVERAGE');
    }
  });

  test('no pubspec and delete folder', () async {
    final file = File('test/no_pubspec.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()
      ..zip = bytes
      ..deleteFolder = true;
    try {
      await service.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'NO_PUBSPEC');
    }
  });

  test('dart project and delete folder', () async {
    final file = File('test/dart_project.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()
      ..zip = bytes
      ..deleteFolder = true;
    final response = await service.getCoverage(null, request);
    expect(response.coverage, 100);
  }, timeout: Timeout(Duration(minutes: 1)));

  test('dart project and delete folder with no genhtml output', () async {
    final file = File('test/dart_project.zip');
    final bytes = file.readAsBytesSync();

    final request = GetCoverageRequest()
      ..zip = bytes
      ..deleteFolder = true;
    when(mockProcesses.genHtml(any))
        .thenAnswer((_) => Future.value(ProcessResult(0, 0, '', '')));
    try {
      await mockableService.getCoverage(null, request);
      expect(true, false);
    } on GrpcError catch (e) {
      expect(e.code, StatusCode.invalidArgument);
      expect(e.message, 'NO_PERCENTAGE');
    }
  }, timeout: Timeout(Duration(minutes: 1)));
}
