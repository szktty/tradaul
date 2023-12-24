import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_string_format.dart';
import 'package:tradaul/src/runtime/lua_string_pattern.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/errors.dart';

class LuaStringModule extends LuaNativeModule {
  LuaStringModule() : super(name: 'string');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.string) {
      return Success(LuaNil());
    }

    final module = LuaTable();
    module.addNativeCalls({
      'find': _luaFind,
      'format': _luaFormat,
      'gsub': _luaGsub,
    });
    context.environment.variables.stringKeySet('string', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaFind(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.find',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();

  final patternBase = arguments.getRawValue<String>(1);
  if (patternBase == null || patternBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.find',
        order: 2,
        expected: 'string',
        actual: patternBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final pattern = patternBase.getOrThrow();

  final initBase = arguments.getIntegerRepresentation(2);
  if (initBase != null && initBase.isError()) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'string.find',
        order: 3,
      ),
    );
  }
  final init = initBase?.getOrThrow().toInt() ?? 1;

  final plainBase = arguments.getRawValue<bool>(3);
  if (plainBase != null && plainBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.find',
        order: 4,
        expected: 'boolean',
        actual: plainBase.exceptionOrNull()!.luaType.name,
      ),
    );
  }
  final plain = plainBase?.getOrThrow() ?? false;

  // TODO: partial match if `plain` is true

  final compileResult = LuaStringPattern.compile(pattern);
  if (compileResult.isError()) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        compileResult.exceptionOrNull()!,
      ),
    );
  }

  final code = compileResult.getOrThrow();
  final matchResult = code.match(string, start: init - 1);
  if (matchResult.isError()) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        matchResult.exceptionOrNull()!,
      ),
    );
  }

  final match = matchResult.getOrThrow();
  if (match.matched) {
    return Success([
      LuaInteger.fromInt(match.start + 1),
      LuaInteger.fromInt(match.end + 1),
      ...match.captures.map((capture) {
        if (capture is LuaStringPatternCaptureIndex) {
          return LuaInteger.fromInt(capture.index + 1);
        } else {
          return LuaString((capture as LuaStringPatternCaptureString).string!);
        }
      }),
    ]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaFormat(
  LuaContext context,
  LuaArguments arguments,
) async {
  final formatBase = arguments.get(0);
  if (formatBase is LuaNumber) {
    return Success([LuaString(formatBase.luaRepresentation)]);
  } else if (formatBase == null || formatBase is! LuaString) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.format',
        order: 1,
        expected: 'string',
        actual: formatBase?.luaType.name,
      ),
    );
  }

  final format = formatBase.value;
  final formatArgs = arguments.length > 1
      ? arguments.arguments.sublist(1)
      : const <LuaValue>[];

  final result = LuaStringFormatter.format(format, formatArgs);
  if (result.isSuccess()) {
    return Success([LuaString(result.getOrThrow())]);
  } else {
    return Failure(LuaException.wrap(result.exceptionOrNull()!));
  }
}

Future<LuaCallResult?> _luaGsub(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.gsub',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();

  final patternBase = arguments.getRawValue<String>(1);
  if (patternBase == null || patternBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.gsub',
        order: 2,
        expected: 'string',
        actual: patternBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final pattern = patternBase.getOrThrow();

  final replBase = arguments.get(2);
  if (replBase == null ||
      (replBase is! LuaString &&
          replBase is! LuaTable &&
          replBase is! LuaFunction)) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.gsub',
        order: 3,
        expected: 'string, table or function',
        actual: replBase?.luaType.name,
      ),
    );
  }

  Object repl;
  LuaException? replException;
  if (replBase is LuaString) {
    repl = replBase.value;
  } else if (replBase is LuaTable) {
    repl = replBase;
  } else if (replBase is LuaFunction) {
    Future<Result<String, String>?> f(List<String> captures) async {
      final arguments = captures.map(LuaString.new).toList();
      final invocation =
          LuaValueInvocation(target: replBase, arguments: arguments);
      final result = await context.invoke(invocation);
      if (result.isSuccess()) {
        final replaced = result.getOrThrow().firstOrNull;
        if (replaced == null) {
          return null;
        } else if (replaced is LuaString) {
          return Success(replaced.value);
        } else if (replaced is LuaNumber) {
          return Success(replaced.luaRepresentation);
        } else {
          return Failure(
            'invalid replacement value (a ${replaced.luaType.name}))',
          );
        }
      } else {
        replException = result.exceptionOrNull();
        return Failure(replException!.message);
      }
    }

    repl = f;
  } else {
    throw UnreachableError();
  }

  final limitBase = arguments.getIntegerRepresentation(3);
  if (limitBase != null && limitBase.isError()) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'string.gsub',
        order: 4,
      ),
    );
  }
  final limit = limitBase?.getOrThrow().toInt();

  final compileResult = LuaStringPattern.compile(pattern);
  if (compileResult.isError()) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        compileResult.exceptionOrNull()!,
      ),
    );
  }

  final code = compileResult.getOrThrow();
  final result = await code.replaceAll(string, repl, limit);
  if (result.isError()) {
    return Failure(
      replException ??
          LuaException(
            LuaExceptionType.runtimeError,
            result.exceptionOrNull()!,
          ),
    );
  }

  final matched = result.getOrThrow();
  return Success([
    LuaString(matched.$1),
    LuaInteger.fromInt(matched.$2),
  ]);
}
