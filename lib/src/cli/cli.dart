import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:coverage_service/src/generated/coverage.pbgrpc.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

typedef ClientChannel ClientChannelBuilder();

class Cli {
  final String projectPath;
  final bool deleteFolder;
  final ClientChannelBuilder clientChannelBuilder;

  ClientChannel _clientChannel;
  CoverageServiceClient _coverageServiceClient;
  Directory _d;

  Cli(this.projectPath, this.deleteFolder, this.clientChannelBuilder) {
    _clientChannel = clientChannelBuilder();
    _coverageServiceClient = CoverageServiceClient(_clientChannel);
    _d = Directory(projectPath);
  }

  Future<double> getCoverage(String id) async {
    final files = _d.listSync(recursive: true);
    final archive = Archive();
    for (final file in files) {
      final stat = file.statSync();
      if (stat.type == FileSystemEntityType.file) {
        File f = file;
        final path = f.path.substring(projectPath.length);
        final archiveFile = ArchiveFile(path, stat.size, f.readAsBytesSync());
        archive.addFile(archiveFile);
      }
    }
    final bytes = ZipEncoder().encode(archive);
    final response = await _coverageServiceClient.getCoverage(
      GetCoverageRequest()
        ..zip = bytes
        ..deleteFolder = deleteFolder
        ..id = id ?? '',
    );
    return response.coverage;
  }

  Future<void> shutdown() async {
    await _clientChannel.shutdown();
  }
}
