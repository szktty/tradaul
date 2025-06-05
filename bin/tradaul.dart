import 'dart:io';

import 'package:args/args.dart';
import 'package:tradaul/src/utils/file.dart';
import 'package:tradaul/tradaul.dart';

const String appName = 'Tradaul';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Display this help message',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Display the version of $appName',
    )
    ..addFlag('verbose', negatable: false, help: 'Enable verbose output')
    ..addFlag('debug', negatable: false, help: 'Enable debug mode')
    ..addFlag('syntax', abbr: 'c', negatable: false, help: 'Check syntax only')
    ..addOption('execute', abbr: 'e', help: 'Pass string as source code');

  ArgResults args;
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    printError(e.message);
    exit(1);
  }

  if (args['help'] == true) {
    printUsage(parser.usage);
    return;
  }

  if (args['version'] == true) {
    stdout.write('$appName ${LuaContext.thisVersion}');
    return;
  }

  final verbose = args['verbose'] as bool;
  final debug = args['debug'] as bool;
  final syntax = args['syntax'] as bool;
  final script = args['execute'] as String?;

  final remaining = args.rest;

  if (remaining.isEmpty && script == null) {
    printUsage(parser.usage);
    return;
  }

  var logLevel = LuaLogLevel.error;
  if (verbose) {
    logLevel = LuaLogLevel.verbose;
  } else if (debug) {
    logLevel = LuaLogLevel.debug;
  }

  final options = LuaContextOptions(
    debug: debug,
    logLevel: logLevel,
    checkSyntaxOnly: syntax,
  );
  final context = await LuaContext.create(name: '<stdin>', options: options);

  if (script != null) {
    final result = await context.execute(script, path: '<stdin>');
    checkResult(result);
  }

  if (remaining.isNotEmpty) {
    final path = remaining.first;
    final allArgs = [Platform.script.toFilePath(), ...arguments];
    final base = allArgs.indexOf(path);
    final before = allArgs.sublist(0, base);
    final after = allArgs.sublist(base);

    final loadResult = FileUtils.read(path);
    String? source;
    try {
      source = loadResult.getOrThrow();
    } on String catch (e) {
      printError(e);
      exit(1);
    } on Exception catch (e) {
      printError('$e');
      exit(1);
    }
    final result = await context.execute(
      source!,
      path: path,
      arguments: (before, after),
    );
    checkResult(result);
  }
}

void printUsage(String usage) {
  stdout
    ..writeln('Usage: $appName [OPTIONS] [SCRIPT [ARGS]]')
    ..writeln(usage);
}

void printError(String message) {
  stdout.writeln('Error: $message');
}

void checkResult(LuaExecutionResult result) {
  final context = result.exceptionOrNull();
  if (context != null) {
    printError(context.toString());
    exit(1);
  }
}
