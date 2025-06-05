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
      'byte': _luaByte,
      'char': _luaChar,
      'find': _luaFind,
      'format': _luaFormat,
      'gmatch': _luaGmatch,
      'gsub': _luaGsub,
      'len': _luaLen,
      'lower': _luaLower,
      'rep': _luaRep,
      'reverse': _luaReverse,
      'sub': _luaSub,
      'upper': _luaUpper,
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
  var init = initBase?.getOrThrow().toInt() ?? 1;

  // Handle negative positions
  if (init < 0) {
    init = string.length + init + 1;
    if (init < 1) {
      init = 1;
    }
  }

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

  if (plain) {
    // Plain string search - literal string matching
    final index = string.indexOf(pattern, init - 1);
    if (index >= 0) {
      return Success([
        LuaInteger.fromInt(index + 1),
        LuaInteger.fromInt(index + pattern.length),
      ]);
    } else {
      return Success([LuaNil()]);
    }
  } else {
    // Pattern matching
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
            return LuaString(
                (capture as LuaStringPatternCaptureString).string!);
          }
        }),
      ]);
    } else {
      return Success([LuaNil()]);
    }
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
    Future<ResultDart<String, String>?> f(List<String> captures) async {
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

Future<LuaCallResult?> _luaByte(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.byte',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();

  // Get start position (default 1)
  final iBase = arguments.getIntegerRepresentation(1);
  if (iBase != null && iBase.isError()) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'string.byte',
        order: 2,
      ),
    );
  }
  final i = iBase?.getOrThrow().toInt() ?? 1;

  // Get end position (default start position)
  final jBase = arguments.getIntegerRepresentation(2);
  if (jBase != null && jBase.isError()) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'string.byte',
        order: 3,
      ),
    );
  }
  final j = jBase?.getOrThrow().toInt() ?? i;

  if (i < 1 || i > string.length || j < i) {
    return const Success([]);
  }

  final result = <LuaValue>[];
  final endIndex = j > string.length ? string.length : j;
  for (var index = i; index <= endIndex; index++) {
    final codeUnit = string.codeUnitAt(index - 1);
    result.add(LuaInteger.fromInt(codeUnit));
  }

  return Success(result);
}

Future<LuaCallResult?> _luaChar(
  LuaContext context,
  LuaArguments arguments,
) async {
  final result = <int>[];

  for (var i = 0; i < arguments.length; i++) {
    final intBase = arguments.getIntegerRepresentation(i);
    if (intBase == null || intBase.isError()) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'string.char',
          order: i + 1,
          expected: 'integer',
          actual: arguments.getTypeName(i),
        ),
      );
    }

    final value = intBase.getOrThrow().toInt();
    if (value < 0 || value > 255) {
      return Failure(
        LuaException.badArgumentError(
          function: 'string.char',
          order: i + 1,
          message: 'value out of range (0-255): $value',
        ),
      );
    }
    result.add(value);
  }

  return Success([LuaString(String.fromCharCodes(result))]);
}

Future<LuaCallResult?> _luaGmatch(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.gmatch',
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
        function: 'string.gmatch',
        order: 2,
        expected: 'string',
        actual: patternBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final pattern = patternBase.getOrThrow();

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
  final matches = <List<LuaValue>>[];
  var start = 0;

  while (start < string.length) {
    final matchResult = code.match(string, start: start);
    if (matchResult.isError()) {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          matchResult.exceptionOrNull()!,
        ),
      );
    }

    final match = matchResult.getOrThrow();
    if (!match.matched) {
      break;
    }

    if (match.captures.isNotEmpty) {
      // Return captures
      final captureValues = match.captures.map((capture) {
        if (capture is LuaStringPatternCaptureIndex) {
          return LuaInteger.fromInt(capture.index + 1);
        } else {
          return LuaString((capture as LuaStringPatternCaptureString).string!);
        }
      }).toList();
      matches.add(captureValues);
    } else {
      // Return whole match
      matches.add([LuaString(string.substring(match.start, match.end + 1))]);
    }

    start = match.end + 1;
    if (match.start == match.end) {
      start++; // Avoid infinite loop on empty matches
    }
  }

  // Return iterator function
  var index = 0;
  Future<LuaCallResult?> iterator(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    if (index >= matches.length) {
      return const Success([]);
    }
    return Success(matches[index++]);
  }

  return Success([LuaNativeFunction('gmatch_iterator', iterator)]);
}

Future<LuaCallResult?> _luaLen(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.len',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();
  return Success([LuaInteger.fromInt(string.length)]);
}

Future<LuaCallResult?> _luaLower(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.lower',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();
  return Success([LuaString(string.toLowerCase())]);
}

Future<LuaCallResult?> _luaUpper(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.upper',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();
  return Success([LuaString(string.toUpperCase())]);
}

Future<LuaCallResult?> _luaReverse(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.reverse',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();
  return Success([LuaString(string.split('').reversed.join())]);
}

Future<LuaCallResult?> _luaRep(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.rep',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();

  final nBase = arguments.getIntegerRepresentation(1);
  if (nBase == null || nBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.rep',
        order: 2,
        expected: 'integer',
        actual: arguments.getTypeName(1),
      ),
    );
  }
  final n = nBase.getOrThrow().toInt();

  if (n < 0) {
    return Success([LuaString('')]);
  }

  final sepBase = arguments.getRawValue<String>(2);
  final sep = sepBase?.getOrThrow() ?? '';

  if (n == 0) {
    return Success([LuaString('')]);
  }

  final parts = List.filled(n, string);
  return Success([LuaString(parts.join(sep))]);
}

Future<LuaCallResult?> _luaSub(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.sub',
        order: 1,
        expected: 'string',
        actual: stringBase?.exceptionOrNull()?.luaType.name,
      ),
    );
  }
  final string = stringBase.getOrThrow();

  final iBase = arguments.getIntegerRepresentation(1);
  if (iBase == null || iBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.sub',
        order: 2,
        expected: 'integer',
        actual: arguments.getTypeName(1),
      ),
    );
  }
  var i = iBase.getOrThrow().toInt();

  final jBase = arguments.getIntegerRepresentation(2);
  var j = jBase?.getOrThrow().toInt() ?? -1;

  // Handle negative indices
  if (i < 0) {
    i = string.length + i + 1;
  }
  if (j < 0) {
    j = string.length + j + 1;
  }

  // Clamp to valid range
  i = i.clamp(1, string.length + 1);
  j = j.clamp(0, string.length);

  if (i > j) {
    return Success([LuaString('')]);
  }

  return Success([LuaString(string.substring(i - 1, j))]);
}
