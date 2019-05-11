import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

@CliOptions()
class Options {
  @CliOption(
    abbr: 'p',
    help: 'Required. The path of the project you want to get coverage',
  )
  final String projectPath;

  final bool projectPathWasParsed;

  @CliOption(
    negatable: false,
    help: 'Delete folder after getting coverage',
    abbr: 'd',
    defaultsTo: false,
  )
  final bool deleteFolder;

  @CliOption(
    abbr: 'i',
    help: 'Specify id for the generated folder',
  )
  final String id;

  @CliOption(
    negatable: false,
    help: 'Print usage information',
    defaultsTo: false,
    abbr: 'h',
  )
  final bool help;

  Options(
    this.projectPath, {
    this.help = false,
    this.projectPathWasParsed,
    this.deleteFolder = false,
    this.id,
  });
}

ArgParser get parser => _$parserForOptions;
