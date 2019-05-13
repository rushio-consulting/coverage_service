import 'package:coverage_service/coverage_cli.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

Future<void> main(List<String> args) async {
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen(print);

  final options = parseOptions(args);
  if (options.help) {
    print(parser.usage);
    return;
  }
  if (!options.projectPathWasParsed) {
    throw ArgumentError('You must set `--project-path`');
  }
  final cli = Cli(
    options.projectPath,
    options.deleteFolder,
    () => ClientChannel(
          '127.0.0.1',
          port: 40000,
          options: ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        ),
  );
  final coverage = await cli.getCoverage(options.id, options.reportOn);
  await cli.shutdown();
  Logger.root.info('coverage: $coverage%');
  print(coverage);
}
