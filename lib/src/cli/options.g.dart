// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) =>
    Options(result['project-path'] as String,
        help: result['help'] as bool,
        projectPathWasParsed: result.wasParsed('project-path'));

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('project-path',
      abbr: 'p',
      help: 'Required. The path of the project you want to get coverage')
  ..addFlag('help', help: 'Print usage information', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
