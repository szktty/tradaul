import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

class LuaUtf8Module extends LuaNativeModule {
  LuaUtf8Module() : super(name: 'utf8');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.utf8) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..addNativeCalls({
        'char': _luaChar,
        'codepoint': _luaCodepoint,
        'codes': _luaCodes,
        'len': _luaLen,
        'offset': _luaOffset,
      });
    
    // Add utf8.charpattern constant
    // This pattern matches a single UTF-8 encoded character
    module.stringKeySet(
      'charpattern',
      LuaString('[\0-\x7F\xC2-\xFD][\x80-\xBF]*'),
    );
    
    context.environment.variables.stringKeySet('utf8', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaChar(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length == 0) {
    return const Success([]);
  }

  final buffer = StringBuffer();
  
  for (var i = 0; i < arguments.length; i++) {
    final codepoint = arguments.getInt(i);
    if (codepoint == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'utf8.char',
          order: i + 1,
          expected: 'integer',
        ),
      );
    }

    if (codepoint < 0 || codepoint > 0x10FFFF) {
      return Failure(
        LuaException.badArgumentError(
          function: 'utf8.char',
          order: i + 1,
          message: 'value out of range',
        ),
      );
    }

    // Invalid UTF-16 surrogates
    if (codepoint >= 0xD800 && codepoint <= 0xDFFF) {
      return Failure(
        LuaException.badArgumentError(
          function: 'utf8.char',
          order: i + 1,
          message: 'value out of range',
        ),
      );
    }

    buffer.writeCharCode(codepoint);
  }

  return Success([LuaString(buffer.toString())]);
}

Future<LuaCallResult?> _luaCodepoint(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.codepoint',
        expected: 'at least 1',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.codepoint',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final start = arguments.getInt(1) ?? 1;
  final end = arguments.getInt(2) ?? start;

  // Convert to 0-based indices
  final startIdx = start - 1;
  final endIdx = end - 1;

  if (startIdx < 0 || startIdx >= s.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'utf8.codepoint',
        order: 2,
        message: 'out of range',
      ),
    );
  }

  if (endIdx < startIdx || endIdx >= s.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'utf8.codepoint',
        order: 3,
        message: 'out of range',
      ),
    );
  }

  final results = <LuaValue>[];
  final runes = s.runes.toList();
  
  // Find the rune indices corresponding to byte positions
  var bytePos = 0;
  var runeStart = -1;
  var runeEnd = -1;
  
  for (var i = 0; i < runes.length; i++) {
    if (bytePos == startIdx) {
      runeStart = i;
    }
    if (bytePos <= endIdx) {
      runeEnd = i;
    }
    
    // Calculate byte length of this rune
    final codePoint = runes[i];
    if (codePoint <= 0x7F) {
      bytePos += 1;
    } else if (codePoint <= 0x7FF) {
      bytePos += 2;
    } else if (codePoint <= 0xFFFF) {
      bytePos += 3;
    } else {
      bytePos += 4;
    }
  }

  if (runeStart < 0 || runeEnd < 0) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'invalid UTF-8 code',
      ),
    );
  }

  for (var i = runeStart; i <= runeEnd; i++) {
    results.add(LuaInteger.fromInt(runes[i]));
  }

  return Success(results);
}

Future<LuaCallResult?> _luaCodes(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.codes',
        expected: '1',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.codes',
        order: 1,
        expected: 'string',
      ),
    );
  }

  var position = 0;
  final runes = s.runes.toList();
  var runeIndex = 0;

  // Iterator function
  Future<LuaCallResult?> iterator(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    if (runeIndex >= runes.length) {
      return const Success([]);
    }

    final codePoint = runes[runeIndex];
    final currentPosition = position;
    
    // Calculate byte length of this rune
    if (codePoint <= 0x7F) {
      position += 1;
    } else if (codePoint <= 0x7FF) {
      position += 2;
    } else if (codePoint <= 0xFFFF) {
      position += 3;
    } else {
      position += 4;
    }
    
    runeIndex++;
    
    return Success([
      LuaInteger.fromInt(currentPosition + 1), // 1-based position
      LuaInteger.fromInt(codePoint),
    ]);
  }

  return Success([
    LuaNativeFunction('utf8.codes_iterator', iterator),
    LuaString(s),
    LuaInteger.fromInt(0),
  ]);
}

Future<LuaCallResult?> _luaLen(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.len',
        expected: '1 to 3',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.len',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final start = arguments.getInt(1) ?? 1;
  final end = arguments.getInt(2) ?? -1;

  // Convert to 0-based indices
  var startIdx = start - 1;
  var endIdx = end < 0 ? s.length + end : end - 1;

  if (startIdx < 0) startIdx = 0;
  if (endIdx >= s.length) endIdx = s.length - 1;

  if (startIdx > endIdx) {
    return Success([LuaInteger.fromInt(0)]);
  }

  try {
    // Validate UTF-8 and count characters
    final substring = s.substring(startIdx, endIdx + 1);
    final runes = substring.runes.toList();
    
    // Check for invalid UTF-8
    for (final rune in runes) {
      if (rune >= 0xD800 && rune <= 0xDFFF) {
        // Invalid surrogate
        return Success([LuaNil(), LuaInteger.fromInt(startIdx + 1)]);
      }
    }
    
    return Success([LuaInteger.fromInt(runes.length)]);
  } on Exception {
    // Invalid UTF-8
    return Success([LuaNil(), LuaInteger.fromInt(startIdx + 1)]);
  }
}

Future<LuaCallResult?> _luaOffset(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'utf8.offset',
        expected: '2 or 3',
      ),
    );
  }

  final s = arguments.getString(0);
  if (s == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.offset',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final n = arguments.getInt(1);
  if (n == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'utf8.offset',
        order: 2,
        expected: 'integer',
      ),
    );
  }

  final i = arguments.getInt(2) ?? (n >= 0 ? 1 : s.length + 1);

  if (n == 0) {
    // Special case: return start of character at position i
    if (i < 1 || i > s.length + 1) {
      return Success([LuaNil()]);
    }
    return Success([LuaInteger.fromInt(i)]);
  }

  // Convert string to runes and track byte positions
  final runes = s.runes.toList();
  final bytePositions = <int>[0]; // Byte position of each character
  
  var bytePos = 0;
  for (final rune in runes) {
    if (rune <= 0x7F) {
      bytePos += 1;
    } else if (rune <= 0x7FF) {
      bytePos += 2;
    } else if (rune <= 0xFFFF) {
      bytePos += 3;
    } else {
      bytePos += 4;
    }
    bytePositions.add(bytePos);
  }

  // Find the starting character index
  var charIndex = -1;
  for (var j = 0; j < bytePositions.length - 1; j++) {
    if (bytePositions[j] < i && i <= bytePositions[j + 1]) {
      charIndex = j;
      break;
    }
  }

  if (charIndex < 0) {
    if (i == 1) {
      charIndex = 0;
    } else if (i == s.length + 1) {
      charIndex = runes.length;
    } else {
      return Success([LuaNil()]);
    }
  }

  // Move n characters
  final targetIndex = charIndex + n;
  
  if (targetIndex < 0 || targetIndex > runes.length) {
    return Success([LuaNil()]);
  }

  if (targetIndex == runes.length) {
    return Success([LuaInteger.fromInt(s.length + 1)]);
  }

  return Success([LuaInteger.fromInt(bytePositions[targetIndex] + 1)]);
}
