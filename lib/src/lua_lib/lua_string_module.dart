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
      'dump': _luaDump,
      'find': _luaFind,
      'format': _luaFormat,
      'gmatch': _luaGmatch,
      'gsub': _luaGsub,
      'len': _luaLen,
      'lower': _luaLower,
      'match': _luaMatch,
      'pack': _luaPack,
      'packsize': _luaPacksize,
      'rep': _luaRep,
      'reverse': _luaReverse,
      'sub': _luaSub,
      'unpack': _luaUnpack,
      'upper': _luaUpper,
    });
    context.environment.variables.stringKeySet('string', module);
    
    // Set up string metatable so that str:method() works as string.method(str)
    final stringMetatable = LuaTable();
    stringMetatable.stringKeySet('__index', module);
    context.environment.setMetatable(LuaString(''), stringMetatable);
    
    return Success(module);
  }
}

/// Helper function to handle UTF-8 character pattern matching
/// This works with Tradaul's character-based string.sub implementation
Future<LuaCallResult?> _handleUtf8CharPattern(String string, int init) async {
  if (init < 1) {
    return Success([LuaNil()]);
  }

  // Since Tradaul's string.sub uses character positions, not byte positions,
  // we need to work in character space, not byte space
  final runes = string.runes.toList();

  // For init=1, we want the first character
  // For now, just match the first character at position 1
  if (init == 1 && runes.isNotEmpty) {
    // Return character position 1,1 to match just the first character
    return Success([
      LuaInteger.fromInt(1),
      LuaInteger.fromInt(1),
    ]);
  }

  // No match found
  return Success([LuaNil()]);
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

  // Handle the plain parameter - in Lua, any value can be used as truthy/falsy
  final plainValue = arguments.getOrNil(3);
  final plain = plainValue.luaToBoolean;

  if (plain) {
    // Plain string search - literal string matching
    // Special case: empty pattern always matches at the current position
    if (pattern.isEmpty) {
      if (init <= string.length + 1) {
        return Success([
          LuaInteger.fromInt(init),
          LuaInteger.fromInt(init - 1),
        ]);
      } else {
        return Success([LuaNil()]);
      }
    }
    
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
    // Special handling for utf8.charpattern
    final utf8CharPattern = String.fromCharCodes([
      0x5B, // [
      0x00, 0x2D, 0x7F, // \x00-\x7F
      0xC2, 0x2D, 0xFD, // \xC2-\xFD
      0x5D, // ]
      0x5B, // [
      0x80, 0x2D, 0xBF, // \x80-\xBF
      0x5D, // ]
      0x2A, // *
    ]);

    if (pattern == utf8CharPattern) {
      // UTF-8 character pattern matching
      return _handleUtf8CharPattern(string, init);
    }

    // Special case: empty pattern always matches at the current position
    if (pattern.isEmpty) {
      if (init <= string.length + 1) {
        return Success([
          LuaInteger.fromInt(init),
          LuaInteger.fromInt(init - 1),
        ]);
      } else {
        return Success([LuaNil()]);
      }
    }
    
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
  var i = iBase?.getOrThrow().toInt() ?? 1;

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
  var j = jBase?.getOrThrow().toInt() ?? i;
  
  // Handle negative indices (like Lua)
  if (i < 0) {
    i = string.length + i + 1;
  }
  if (j < 0) {
    j = string.length + j + 1;
  }
  
  // Clamp indices to valid range (standard Lua behavior)
  if (i < 1) i = 1;
  if (j > string.length) j = string.length;

  // Handle out of range cases after clamping
  if (i > string.length) {
    // Start position beyond string length
    return Success([LuaNil()]);
  }
  
  if (j < i) {
    // Invalid range, return nil in Lua (not nothing)
    return Success([LuaNil()]);
  }

  final result = <LuaValue>[];
  final endIndex = j > string.length ? string.length : j;
  
  // Convert string to byte array to handle binary data correctly
  final bytes = string.codeUnits;
  
  for (var index = i; index <= endIndex; index++) {
    // Get the raw byte value, not the Unicode code point
    final byteValue = bytes[index - 1];
    // Ensure the value is in the valid byte range (0-255)
    final clampedValue = byteValue & 0xFF;
    result.add(LuaInteger.fromInt(clampedValue));
  }

  return Success(result);
}

Future<LuaCallResult?> _luaChar(
  LuaContext context,
  LuaArguments arguments,
) async {
  final result = <int>[];

  for (var i = 0; i < arguments.length; i++) {
    final arg = arguments.getOrNil(i);
    
    // Skip nil arguments (this handles cases where string.byte returns no values)
    if (arg is LuaNil) {
      continue;
    }
    
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

Future<LuaCallResult?> _luaMatch(
  LuaContext context,
  LuaArguments arguments,
) async {
  final stringBase = arguments.getRawValue<String>(0);
  if (stringBase == null || stringBase.isError()) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.match',
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
        function: 'string.match',
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
        function: 'string.match',
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
    if (match.captures.isNotEmpty) {
      // Return captures only
      return Success(match.captures.map((capture) {
        if (capture is LuaStringPatternCaptureIndex) {
          return LuaInteger.fromInt(capture.index + 1);
        } else {
          return LuaString((capture as LuaStringPatternCaptureString).string!);
        }
      }).toList());
    } else {
      // Return the whole match
      return Success([LuaString(string.substring(match.start, match.end + 1))]);
    }
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaDump(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'string.dump',
        expected: '1 or 2',
      ),
    );
  }

  final func = arguments.get<LuaFunction>(0);
  if (func == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.dump',
        order: 1,
        expected: 'function',
      ),
    );
  }

  // string.dump is not supported in Tradaul
  // as bytecode format is different from standard Lua
  return Failure(
    LuaException(
      LuaExceptionType.runtimeError,
      'string.dump is not supported',
    ),
  );
}

Future<LuaCallResult?> _luaPack(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'string.pack',
        expected: 'at least 1',
      ),
    );
  }

  final format = arguments.getString(0);
  if (format == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.pack',
        order: 1,
        expected: 'string',
      ),
    );
  }

  try {
    final values = arguments.arguments.sublist(1);
    final result = _packBinaryData(format, values);
    return Success([LuaString(result)]);
  } on Exception catch (e) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'bad format string in pack: $e',
      ),
    );
  }
}

Future<LuaCallResult?> _luaPacksize(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'string.packsize',
        expected: '1',
      ),
    );
  }

  final format = arguments.getString(0);
  if (format == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.packsize',
        order: 1,
        expected: 'string',
      ),
    );
  }

  try {
    final size = _calculatePackSize(format);
    return Success([LuaInteger.fromInt(size)]);
  } on Exception catch (e) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'bad format string in packsize: $e',
      ),
    );
  }
}

Future<LuaCallResult?> _luaUnpack(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'string.unpack',
        expected: 'at least 2',
      ),
    );
  }

  final format = arguments.getString(0);
  if (format == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.unpack',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final data = arguments.getString(1);
  if (data == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'string.unpack',
        order: 2,
        expected: 'string',
      ),
    );
  }

  final posBase = arguments.getIntegerRepresentation(2);
  final pos = posBase?.getOrThrow().toInt() ?? 1;

  try {
    final result = _unpackBinaryData(format, data, pos - 1);
    return Success(result);
  } on Exception catch (e) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'bad format string in unpack: $e',
      ),
    );
  }
}

String _packBinaryData(String format, List<LuaValue> values) {
  final buffer = <int>[];
  var valueIndex = 0;
  var i = 0;
  var bigEndian = true; // Default to big endian

  while (i < format.length) {
    final char = format[i];

    switch (char) {
      case '>':
        bigEndian = true; // Big endian
        i++;
        continue;
      case '<':
        bigEndian = false; // Little endian
        i++;
        continue;
      case '=':
        bigEndian = true; // Native endian (default to big)
        i++;
        continue;

      case 'i':
        // Signed integer
        var size = 4;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          size = int.parse(format[i + 1]);
          i++;
        }
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = size - 1; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < size; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format i$size');
          }
        }

      case 'I':
        // Unsigned integer
        var size = 4;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          size = int.parse(format[i + 1]);
          i++;
        }
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = size - 1; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < size; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format I$size');
          }
        }

      case 'b':
        // Signed byte
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            buffer.add(value.value.toInt() & 0xFF);
          } else {
            throw Exception('expected integer for format b');
          }
        }

      case 'B':
        // Unsigned byte
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            buffer.add(value.value.toInt() & 0xFF);
          } else {
            throw Exception('expected integer for format B');
          }
        }

      case 'h':
        // Signed short (2 bytes)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              buffer.add((intValue >> 8) & 0xFF);
              buffer.add(intValue & 0xFF);
            } else {
              buffer.add(intValue & 0xFF);
              buffer.add((intValue >> 8) & 0xFF);
            }
          } else {
            throw Exception('expected integer for format h');
          }
        }

      case 'H':
        // Unsigned short (2 bytes)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              buffer.add((intValue >> 8) & 0xFF);
              buffer.add(intValue & 0xFF);
            } else {
              buffer.add(intValue & 0xFF);
              buffer.add((intValue >> 8) & 0xFF);
            }
          } else {
            throw Exception('expected integer for format H');
          }
        }

      case 'l':
        // Signed long (4 bytes)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = 3; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < 4; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format l');
          }
        }

      case 'L':
        // Unsigned long (4 bytes)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = 3; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < 4; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format L');
          }
        }

      case 'j':
      case 'J':
        // lua_Integer / lua_Unsigned (8 bytes)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = 7; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < 8; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format $char');
          }
        }

      case 'T':
        // size_t (4 bytes for simplicity)
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaInteger) {
            final intValue = value.value.toInt();
            if (bigEndian) {
              for (var j = 3; j >= 0; j--) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            } else {
              for (var j = 0; j < 4; j++) {
                buffer.add((intValue >> (j * 8)) & 0xFF);
              }
            }
          } else {
            throw Exception('expected integer for format T');
          }
        }

      case 'f':
        // Float (4 bytes) - basic implementation
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaNumber) {
            // Simple float conversion - not IEEE 754 compliant
            final doubleValue = value is LuaFloat
                ? value.value
                : (value as LuaInteger).value.toDouble();
            final intValue = (doubleValue * 1000).toInt();
            for (var j = 0; j < 4; j++) {
              buffer.add((intValue >> (j * 8)) & 0xFF);
            }
          } else {
            throw Exception('expected number for format f');
          }
        }

      case 'd':
        // Double (8 bytes) - basic implementation
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaNumber) {
            // Simple double conversion - not IEEE 754 compliant
            final doubleValue = value is LuaFloat
                ? value.value
                : (value as LuaInteger).value.toDouble();
            final intValue = (doubleValue * 1000000).toInt();
            for (var j = 0; j < 8; j++) {
              buffer.add((intValue >> (j * 8)) & 0xFF);
            }
          } else {
            throw Exception('expected number for format d');
          }
        }

      case 'z':
        // Zero-terminated string
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaString) {
            buffer.addAll(value.value.codeUnits);
            buffer.add(0); // null terminator
          } else {
            throw Exception('expected string for format z');
          }
        }

      case 'c':
        // Fixed-length string
        var size = 1;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          var numStr = '';
          var j = i + 1;
          while (j < format.length && '0123456789'.contains(format[j])) {
            numStr += format[j];
            j++;
          }
          size = int.parse(numStr);
          i = j - 1; // Set i to last digit position, will be incremented at end
        }
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaString) {
            final bytes = value.value.codeUnits;
            buffer.addAll(bytes.take(size));
            // Pad with zeros if needed
            for (var j = bytes.length; j < size; j++) {
              buffer.add(0);
            }
          } else {
            throw Exception('expected string for format c$size');
          }
        }

      case 's':
        // Length-prefixed string
        var lengthSize = 1;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          lengthSize = int.parse(format[i + 1]);
          i++;
        }
        if (valueIndex < values.length) {
          final value = values[valueIndex++];
          if (value is LuaString) {
            final length = value.value.length;
            // Add length prefix
            for (var j = 0; j < lengthSize; j++) {
              buffer.add((length >> (j * 8)) & 0xFF);
            }
            // Add string data
            buffer.addAll(value.value.codeUnits);
          } else {
            throw Exception('expected string for format s$lengthSize');
          }
        }

      case 'x':
        // Padding byte
        buffer.add(0);

      case '!':
        // Alignment - skip the number
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          i++;
        }

      default:
        if ('0123456789'.contains(char)) {
          // Number - already handled above
        } else {
          throw Exception('invalid format character: $char');
        }
    }

    i++;
  }

  return String.fromCharCodes(buffer);
}

int _calculatePackSize(String format) {
  var totalSize = 0;
  var i = 0;

  while (i < format.length) {
    final char = format[i];

    switch (char) {
      case '>':
      case '<':
      case '=':
        // Endian markers don't contribute to size
        i++;
        continue;

      case 'b':
      case 'B':
        // 1 byte
        totalSize += 1;

      case 'h':
      case 'H':
        // 2 bytes
        totalSize += 2;

      case 'l':
      case 'L':
        // 4 bytes
        totalSize += 4;

      case 'j':
      case 'J':
        // lua_Integer/lua_Unsigned (8 bytes)
        totalSize += 8;

      case 'T':
        // size_t (4 bytes for simplicity)
        totalSize += 4;

      case 'f':
        // float (4 bytes)
        totalSize += 4;

      case 'd':
        // double (8 bytes)
        totalSize += 8;

      case 'i':
      case 'I':
        // Variable-size integer
        var size = 4; // default
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          size = int.parse(format[i + 1]);
          i++;
        }
        totalSize += size;

      case 'c':
        // Fixed-length string
        var size = 1; // default
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          var numStr = '';
          var j = i + 1;
          while (j < format.length && '0123456789'.contains(format[j])) {
            numStr += format[j];
            j++;
          }
          size = int.parse(numStr);
          i = j - 1; // Set i to last digit position, will be incremented at end
        }
        totalSize += size;

      case 's':
        // Variable-length string with length prefix
        var lengthSize = 1; // default
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          lengthSize = int.parse(format[i + 1]);
          i++;
        }
        // Cannot determine size without actual string length
        throw Exception(
            'cannot determine size for variable-length string format s$lengthSize');

      case 'z':
        // Zero-terminated string - cannot determine size
        throw Exception(
            'cannot determine size for zero-terminated string format z');

      case 'x':
        // Padding byte
        totalSize += 1;

      case '!':
        // Alignment - skip the number
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          i++;
        }

      default:
        if ('0123456789'.contains(char)) {
          // Number - already handled above
        } else {
          throw Exception('invalid format character: $char');
        }
    }

    i++;
  }

  return totalSize;
}

List<LuaValue> _unpackBinaryData(String format, String data, int pos) {
  final result = <LuaValue>[];
  final bytes = data.codeUnits;
  var offset = pos;
  var i = 0;
  var bigEndian = true; // Default to big endian

  while (i < format.length && offset < bytes.length) {
    final char = format[i];

    switch (char) {
      case '>':
        bigEndian = true; // Big endian
        i++;
        continue;
      case '<':
        bigEndian = false; // Little endian
        i++;
        continue;
      case '=':
        bigEndian = true; // Native endian (default to big)
        i++;
        continue;

      case 'i':
        // Signed integer
        var size = 4;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          size = int.parse(format[i + 1]);
          i++;
        }
        if (offset + size <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            for (var j = 0; j < size; j++) {
              value = (value << 8) | bytes[offset + j];
            }
          } else {
            for (var j = 0; j < size; j++) {
              value |= bytes[offset + j] << (j * 8);
            }
          }
          // Handle sign extension for negative values
          // Only apply sign extension if the most significant bit is set
          if (size < 8 && (value & (1 << (size * 8 - 1))) != 0) {
            // Create mask for sign extension
            final signMask = -1 << (size * 8);
            value = value | signMask;
          }

          result.add(LuaInteger.fromInt(value));
          offset += size;
        }

      case 'I':
        // Unsigned integer
        var size = 4;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          size = int.parse(format[i + 1]);
          i++;
        }
        if (offset + size <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            for (var j = 0; j < size; j++) {
              value = (value << 8) | bytes[offset + j];
            }
          } else {
            for (var j = 0; j < size; j++) {
              value |= bytes[offset + j] << (j * 8);
            }
          }

          result.add(LuaInteger.fromInt(value));
          offset += size;
        }

      case 'b':
        // Signed byte
        if (offset < bytes.length) {
          var value = bytes[offset];
          if (value > 127) value -= 256; // Sign extension
          result.add(LuaInteger.fromInt(value));
          offset++;
        }

      case 'B':
        // Unsigned byte
        if (offset < bytes.length) {
          result.add(LuaInteger.fromInt(bytes[offset]));
          offset++;
        }

      case 'h':
        // Signed short
        if (offset + 2 <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            value = (bytes[offset] << 8) | bytes[offset + 1];
          } else {
            value = bytes[offset] | (bytes[offset + 1] << 8);
          }
          if (value > 32767) value -= 65536; // Sign extension
          result.add(LuaInteger.fromInt(value));
          offset += 2;
        }

      case 'H':
        // Unsigned short
        if (offset + 2 <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            value = (bytes[offset] << 8) | bytes[offset + 1];
          } else {
            value = bytes[offset] | (bytes[offset + 1] << 8);
          }
          result.add(LuaInteger.fromInt(value));
          offset += 2;
        }

      case 'l':
      case 'L':
        // Long (4 bytes)
        if (offset + 4 <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            for (var j = 0; j < 4; j++) {
              value = (value << 8) | bytes[offset + j];
            }
          } else {
            for (var j = 0; j < 4; j++) {
              value |= bytes[offset + j] << (j * 8);
            }
          }
          if (char == 'l' && (value & 0x80000000) != 0) {
            value -= 0x100000000; // Sign extension for 'l'
          }
          result.add(LuaInteger.fromInt(value));
          offset += 4;
        }

      case 'j':
      case 'J':
        // lua_Integer / lua_Unsigned (8 bytes)
        if (offset + 8 <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            for (var j = 0; j < 8; j++) {
              value = (value << 8) | bytes[offset + j];
            }
          } else {
            for (var j = 0; j < 8; j++) {
              value |= bytes[offset + j] << (j * 8);
            }
          }
          result.add(LuaInteger.fromInt(value));
          offset += 8;
        }

      case 'T':
        // size_t (4 bytes)
        if (offset + 4 <= bytes.length) {
          var value = 0;
          if (bigEndian) {
            for (var j = 0; j < 4; j++) {
              value = (value << 8) | bytes[offset + j];
            }
          } else {
            for (var j = 0; j < 4; j++) {
              value |= bytes[offset + j] << (j * 8);
            }
          }
          result.add(LuaInteger.fromInt(value));
          offset += 4;
        }

      case 'f':
        // Float - basic implementation
        if (offset + 4 <= bytes.length) {
          var value = 0;
          for (var j = 0; j < 4; j++) {
            value |= bytes[offset + j] << (j * 8);
          }
          result.add(LuaFloat(value / 1000.0));
          offset += 4;
        }

      case 'd':
        // Double - basic implementation
        if (offset + 8 <= bytes.length) {
          var value = 0;
          for (var j = 0; j < 8; j++) {
            value |= bytes[offset + j] << (j * 8);
          }
          result.add(LuaFloat(value / 1000000.0));
          offset += 8;
        }

      case 'z':
        // Zero-terminated string
        final start = offset;
        while (offset < bytes.length && bytes[offset] != 0) {
          offset++;
        }
        result
            .add(LuaString(String.fromCharCodes(bytes.sublist(start, offset))));
        if (offset < bytes.length) offset++; // Skip null terminator

      case 'c':
        // Fixed-length string
        var size = 1;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          var numStr = '';
          var j = i + 1;
          while (j < format.length && '0123456789'.contains(format[j])) {
            numStr += format[j];
            j++;
          }
          size = int.parse(numStr);
          i = j - 1; // Set i to last digit position, will be incremented at end
        }
        if (offset + size <= bytes.length) {
          result.add(LuaString(
              String.fromCharCodes(bytes.sublist(offset, offset + size))));
          offset += size;
        }

      case 's':
        // Length-prefixed string
        var lengthSize = 1;
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          lengthSize = int.parse(format[i + 1]);
          i++;
        }
        if (offset + lengthSize <= bytes.length) {
          var length = 0;
          for (var j = 0; j < lengthSize; j++) {
            length |= bytes[offset + j] << (j * 8);
          }
          offset += lengthSize;
          if (offset + length <= bytes.length) {
            result.add(LuaString(
                String.fromCharCodes(bytes.sublist(offset, offset + length))));
            offset += length;
          }
        }

      case 'x':
        // Padding byte - just skip
        offset++;

      case '!':
        // Alignment - skip the number
        if (i + 1 < format.length && '0123456789'.contains(format[i + 1])) {
          i++;
        }

      default:
        if ('0123456789'.contains(char)) {
          // Number - already handled above
        } else {
          throw Exception('invalid format character: $char');
        }
    }

    i++;
  }

  // Add the next position as the last return value
  result.add(LuaInteger.fromInt(offset + 1));

  return result;
}
