import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

@CliOptions()
class Options {
  @CliOption(
      abbr: 'p',
      help: 'Required. The path of the project you want to get coverage')
  final String projectPath;

  final bool projectPathWasParsed;

  @CliOption(negatable: false, help: 'Print usage information')
  final bool help;

  Options(this.projectPath, {this.help = false, this.projectPathWasParsed});
}

ArgParser get parser => _$parserForOptions;
