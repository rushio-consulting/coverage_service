import 'dart:io';

import 'package:archive/archive.dart';
import 'package:coverage_service/coverage_cli.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

Future<void> main(List<String> args) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(print);

  final options = parseOptions(args);
  if (options.help) {
    print(parser.usage);
    return;
  }
  if (!options.projectPathWasParsed) {
    throw ArgumentError('You must set `--project-path`');
  }
  final channel = ClientChannel(
    '127.0.0.1',
    port: 40000,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );
  final coverageServiceClient = CoverageServiceClient(channel);
  final directory = Directory(options.projectPath);
  final archive = _createArchive(directory);
  final bytes = ZipEncoder().encode(archive);
  final response = await coverageServiceClient.getCoverage(
    GetCoverageRequest()
      ..zip = bytes
      ..deleteFolder = options.deleteFolder
      ..id = options.id ?? ''
      ..reportOn = options.reportOn ?? '',
  );
  await channel.shutdown();
  final coverage = response.coverage;
  Logger.root.info('coverage: $coverage%');
  print(coverage);
}

Archive _createArchive(Directory directory) {
  final files = directory.listSync(recursive: true);
  final archive = Archive();
  for (final file in files) {
    final stat = file.statSync();
    if (stat.type == FileSystemEntityType.file) {
      File f = file;
      final path = f.path.substring(directory.path.length);
      if (path.startsWith('build')) {
        continue;
      }
      final archiveFile = ArchiveFile(path, stat.size, f.readAsBytesSync());
      archive.addFile(archiveFile);
    }
  }
  return archive;
}
