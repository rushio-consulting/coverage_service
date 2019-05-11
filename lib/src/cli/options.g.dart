// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) =>
    Options(result['project-path'] as String,
        help: result['help'] as bool,
        projectPathWasParsed: result.wasParsed('project-path'),
        deleteFolder: result['delete-folder'] as bool,
        id: result['id'] as String);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('project-path',
      abbr: 'p',
      help: 'Required. The path of the project you want to get coverage')
  ..addFlag('delete-folder',
      abbr: 'd',
      help: 'Delete folder after getting coverage',
      defaultsTo: false,
      negatable: false)
  ..addOption('id', abbr: 'i', help: 'Specify id for the generated folder')
  ..addFlag('help',
      abbr: 'h',
      help: 'Print usage information',
      defaultsTo: false,
      negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
