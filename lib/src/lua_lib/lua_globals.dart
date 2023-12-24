import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_environment.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/file.dart';
import 'package:tradaul/src/utils/number.dart';

class LuaGlobals extends LuaNativeModule {
  LuaGlobals() : super(name: '_G');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    final module = LuaTable()
      ..stringKeySet('_G', context.environment.variables)
      ..stringKeySet('_VERSION', LuaString('Lua ${LuaContext.luaVersion}'))
      ..addNativeCalls({
        'assert': _luaAssert,
        'collectgarbage': _luaCollectgarbage,
        'error': _luaError,
        'load': _luaLoad,
        'loadfile': _luaLoadfile,
        'require': _luaRequire,
        'next': _luaNext,
        'pairs': _luaPairs,
        'ipairs': _luaIpairs,
        'pcall': _luaPcall,
        'xpcall': _luaXpcall,
        'print': _luaPrint,
        'rawequal': _luaRawequal,
        'rawlen': _luaRawlen,
        'rawget': _luaRawget,
        'rawset': _luaRawset,
        'select': _luaSelect,
        'tonumber': _luaTonumber,
        'tostring': _luaTostring,
        'type': _luaType,
        'getmetatable': _luaGetmetatable,
        'setmetatable': _luaSetmetatable,
      });
    context.environment.variables.merge(module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaAssert(
  LuaContext context,
  LuaArguments arguments,
) async {
  final value = arguments.get(0);
  if (value == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'assert',
        order: 1,
        expected: 'value',
      ),
    );
  } else if (value != LuaNil() && value != LuaFalse()) {
    return Success(arguments.arguments);
  }

  final message = arguments.get(1) ?? LuaString('assertion failed!');
  return _luaError(context, LuaArguments([message]));
}

Future<LuaCallResult?> _luaCollectgarbage(
  LuaContext context,
  LuaArguments arguments,
) async {
  final option = arguments.getString(0) ?? 'collect';
  switch (option) {
    case 'step':
    case 'isrunning':
      return Success([LuaFalse()]);
    case 'count':
    case 'collect':
    case 'stop':
    case 'restart':
    case 'setpause':
    case 'setstepmul':
      return Success([LuaInteger.fromInt(0)]);
    default:
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'invalid option "$option"',
        ),
      );
  }
}

Future<LuaCallResult?> _luaError(
  LuaContext context,
  LuaArguments arguments,
) async {
  // TODO: level
  String? message;

  final value = arguments.arguments.firstOrNull;
  if (value == null || value == LuaNil()) {
    message = '(error object is a nil value)';
  } else if (value is LuaString) {
    // TODO: add location info
    message = value.luaToString();
  } else {
    // TODO: support metamethod
    message = value.luaToString();
  }

  return Failure(LuaException(LuaExceptionType.userError, message));
}

Future<LuaCallResult?> _luaLoad(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.module) {
    return Failure(context.denyPermission('"load" is not permitted'));
  }

  final chunk = arguments.get(0);
  if (chunk == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'load',
        order: 1,
        expected: 'string or function',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  var chunkName = 'chunk';
  if (arguments.length >= 2) {
    final name = arguments.getString(1);
    if (name == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'load',
          order: 2,
          expected: 'string',
          actual: arguments.getTypeName(1),
        ),
      );
    }
    chunkName = name;
  }

  var mode = 'bt';
  if (arguments.length >= 3) {
    final argMode = arguments.getString(2);
    if (argMode == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'load',
          order: 3,
          expected: 'string',
          actual: arguments.getTypeName(2),
        ),
      );
    }
    mode = argMode;
  }

  if (!((mode.contains('t') && chunk is LuaString) ||
      (mode.contains('b') && chunk is LuaClosure))) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'load',
        order: 3,
        expected: 'string or function',
        actual: arguments.getTypeName(2),
      ),
    );
  }

  var environment = context.environment;
  if (arguments.length >= 4) {
    final table = arguments.get<LuaTable>(3);
    if (table == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'load',
          order: 4,
          expected: 'table',
          actual: arguments.getTypeName(3),
        ),
      );
    }
    environment = LuaEnvironment(
      variables: table,
    );
  }

  return _executeLoadedChunk(context, chunk, chunkName, environment);
}

Future<LuaCallResult?> _luaLoadfile(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.module ||
      !context.options.permissions.stdio) {
    return Failure(context.denyPermission('"load" is not permitted'));
  }

  final luaFileName = arguments.get(0);
  String? fileName;
  if (luaFileName == null) {
    await for (final input in context.system.stdin) {
      fileName = input.toString();
      break;
    }
  } else {
    fileName = luaFileName.luaToString();
  }
  if (fileName == null) {
    return Failure(LuaException(LuaExceptionType.runtimeError, 'no file name'));
  }

  // read file
  final readResult = FileUtils.read(fileName);
  if (readResult.isError()) {
    return Success([LuaNil(), LuaString(readResult.exceptionOrNull()!)]);
  }
  final source = readResult.getOrThrow();

  var mode = 't';
  if (arguments.length >= 2) {
    final argMode = arguments.getString(1);
    if (argMode == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'loadfile',
          order: 2,
          expected: 'string',
          actual: arguments.getTypeName(1),
        ),
      );
    }
    mode = argMode;
  }

  if (mode.contains('b')) {
    return Failure(
      LuaException(
        LuaExceptionType.runtimeError,
        'loadfile() does not support binary mode',
      ),
    );
  }

  var environment = context.environment;
  if (arguments.length >= 3) {
    final table = arguments.get<LuaTable>(2);
    if (table == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'load',
          order: 3,
          expected: 'table',
          actual: arguments.getTypeName(2),
        ),
      );
    }
    environment = LuaEnvironment(
      variables: table,
    );
  }

  return _executeLoadedChunk(context, LuaString(source), fileName, environment);
}

Future<LuaCallResult?> _executeLoadedChunk(
  LuaContext context,
  LuaValue chunk,
  String chunkName,
  LuaEnvironment environment,
) async {
  // compile
  LuaClosure? closure;
  if (chunk is LuaString) {
    final result = context.compile(chunk.value, path: chunkName);
    if (result!.isError()) {
      final message = result.exceptionOrNull()!.toDisplayString();
      return Success([LuaNil(), LuaString(message)]);
    }
    final code = result.getOrThrow();
    closure = LuaClosure(
      code: code.chunk,
      upvalueStacks: [],
      environment: environment,
    );
  } else {
    final base = chunk as LuaClosure;
    closure = LuaClosure(
      code: base.code,
      upvalueStacks: [],
      environment: environment,
    );
  }

  // return compiled chunk as function
  Future<LuaCallResult?> loader(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    final result = await context.executeClosure(closure!, path: chunkName);
    if (result.isSuccess()) {
      return Success(result.getOrThrow());
    } else {
      final error = result.exceptionOrNull()!.toDisplayString();
      return Failure(LuaException(LuaExceptionType.runtimeError, error));
    }
  }

  return Success([LuaNativeFunction(chunkName, loader)]);
}

Future<LuaCallResult?> _luaRequire(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length == 0) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'require',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final name = arguments.get(0)!.luaToString();
  final result = await context.moduleManager.import(name);
  if (result.isSuccess()) {
    return Success(result.getOrThrow());
  } else {
    return Failure(result.exceptionOrNull()!);
  }
}

Future<LuaCallResult?> _luaPrint(
  LuaContext context,
  LuaArguments arguments,
) async {
  final s = arguments.arguments.map((e) => e.luaToDisplayString()).join('\t');
  context.system.writeLine(s);
  return null;
}

Future<LuaCallResult?> _luaRawequal(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.raw) {
    return Failure(context.denyPermission('"rawequal" is not permitted'));
  }

  final a = arguments.get(0);
  if (a == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawequal',
        order: 1,
        expected: 'value',
      ),
    );
  }

  final b = arguments.get(1);
  if (b == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawequal',
        order: 2,
        expected: 'value',
      ),
    );
  }

  return Success([LuaBoolean.fromBool(a.luaEquals(b))]);
}

Future<LuaCallResult?> _luaRawlen(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.raw) {
    return Failure(context.denyPermission('"rawlen" is not permitted'));
  }

  final value = arguments.get(0);
  if (value == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawlen',
        order: 1,
        expected: 'value',
      ),
    );
  } else if (value is LuaString) {
    return Success([LuaInteger.fromInt(value.value.length)]);
  } else if (value is LuaTable) {
    return Success([LuaInteger.fromInt(value.length)]);
  } else {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawlen',
        order: 1,
        expected: 'string or table',
        actual: arguments.getTypeName(0),
      ),
    );
  }
}

Future<LuaCallResult?> _luaRawget(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.raw) {
    return Failure(context.denyPermission('"rawget" is not permitted'));
  }

  final table = arguments.arguments.firstOrNull;
  if (table == null || table is! LuaTable) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawget',
        order: 1,
        expected: 'table',
      ),
    );
  }

  final key = arguments.get(1);
  if (key == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawget',
        order: 2,
        expected: 'value',
        actual: arguments.getTypeName(1),
      ),
    );
  }

  return Success([table.get(key) ?? LuaNil()]);
}

Future<LuaCallResult?> _luaRawset(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (!context.options.permissions.raw) {
    return Failure(context.denyPermission('"rawset" is not permitted'));
  }

  final table = arguments.arguments.firstOrNull;
  if (table == null || table is! LuaTable) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawset',
        order: 1,
        expected: 'table',
      ),
    );
  }

  final key = arguments.get(1);
  if (key == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawset',
        order: 2,
        expected: 'value',
        actual: arguments.getTypeName(1),
      ),
    );
  }

  final value = arguments.get(2);
  if (value == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'rawset',
        order: 3,
        expected: 'value',
        actual: arguments.getTypeName(2),
      ),
    );
  }

  final error = table.set(key, value);
  if (error == null) {
    return Success([table]);
  } else {
    return Failure(error);
  }
}

Future<LuaCallResult?> _luaSelect(
  LuaContext context,
  LuaArguments arguments,
) async {
  final index = arguments.getInt(0);
  final length = arguments.getString(0);
  if (index == null && (length == null || length != '#')) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'select',
        order: 1,
        expected: "integer or '#'",
      ),
    );
  }

  if (length != null) {
    return Success([LuaInteger.fromInt(arguments.length - 1)]);
  } else if (index == 0) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'select',
        order: 1,
        expected: "integer or '#'",
        actual: 'index out of range',
      ),
    );
  } else {
    final subIndex = index! < 0 ? arguments.length + index : index;
    if (subIndex < arguments.length) {
      return Success(arguments.arguments.sublist(subIndex));
    } else {
      return const Success([]);
    }
  }
}

Future<LuaCallResult?> _luaTonumber(
  LuaContext context,
  LuaArguments arguments,
) async {
  final luaValue = arguments.arguments.firstOrNull;
  if (luaValue == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'tonumber',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final luaBase = arguments.get(1);
  if (luaBase == null) {
    if (luaValue is LuaNumber) {
      return Success([luaValue]);
    } else if (luaValue is LuaString) {
      return Success([NumberParser.parseLuaValue(luaValue.value) ?? LuaNil()]);
    } else {
      return Success([LuaNil()]);
    }
  }

  var base = 2;
  if (luaBase is LuaString) {
    final intValue = NumberUtils.toIntRepresentation(luaBase.value);
    if (intValue == null) {
      return Failure(
        LuaException.noIntegerRepresentation(
          function: 'tonumber',
          order: 2,
        ),
      );
    } else {
      base = intValue.toInt();
    }
  } else if (luaBase is LuaInteger) {
    base = luaBase.value.toInt();
  } else if (luaBase is LuaFloat) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'tonumber',
        order: 2,
      ),
    );
  } else {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'tonumber',
        order: 2,
        expected: 'integer',
        actual: luaBase.luaType.name,
      ),
    );
  }

  if (base < 2 || base > 36) {
    return Failure(
      LuaException.badArgumentError(
        function: 'tonumber',
        order: 2,
        message: 'base out of range [2, 36]',
      ),
    );
  }

  if (luaValue is LuaInteger) {
    return Success([luaValue]);
  } else if (luaValue is LuaFloat) {
    return Failure(
      LuaException.noIntegerRepresentation(
        function: 'tonumber',
        order: 1,
      ),
    );
  } else if (luaValue is LuaString) {
    final intValue = int.tryParse(luaValue.value, radix: base);
    if (intValue == null) {
      return Success([LuaNil()]);
    } else {
      return Success([LuaInteger.fromInt(intValue)]);
    }
  } else {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'tonumber',
        order: 1,
        expected: 'string',
        actual: luaValue.luaType.name,
      ),
    );
  }
}

Future<LuaCallResult?> _luaTostring(
  LuaContext context,
  LuaArguments arguments,
) async {
  final value = arguments.arguments.firstOrNull;
  if (value == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'tostring',
        order: 1,
        expected: 'value',
      ),
    );
  }

  if (value is LuaTable) {
    var result = await context.invokeMetamethod(
      target: value,
      name: LuaMetamethodNames.tostring,
      arguments: [value],
    );
    result ??= await context.invokeMetamethod(
      target: value,
      name: LuaMetamethodNames.name,
      arguments: [value],
    );

    if (result != null) {
      if (result.isSuccess()) {
        final newValue = result.getOrThrow().first;
        if (newValue is LuaString) {
          return Success([newValue]);
        } else {
          return Failure(
            LuaException(
              LuaExceptionType.runtimeError,
              "'__tostring' must return a string",
            ),
          );
        }
      } else {
        return Failure(result.exceptionOrNull()!);
      }
    }
  }
  return Success([LuaString(value.luaToDisplayString())]);
}

Future<LuaCallResult?> _luaType(
  LuaContext context,
  LuaArguments arguments,
) async {
  final value = arguments.arguments.firstOrNull;
  if (value == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'type',
        order: 1,
        expected: 'value',
      ),
    );
  }

  return Success([LuaString(value.luaType.name)]);
}

LuaNativeFunction _createNextFunction(LuaTable table) {
  final entries = table.entries;
  return LuaNativeFunction('next', (context, arguments) async {
    final table = arguments.get<LuaTable>(0);
    if (arguments.length < 1 || table == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'next',
          expected: 'table',
          actual: arguments.getTypeName(0),
          order: 1,
        ),
      );
    }

    final index = arguments.get<LuaValue>(1);
    final nextIndex = table.nextTableIndex(index);
    if (nextIndex == null) {
      return Success([LuaNil()]);
    } else {
      return Success([nextIndex, table.get(nextIndex) ?? LuaNil()]);
    }
  });
}

Future<LuaCallResult?> _luaNext(
  LuaContext context,
  LuaArguments arguments,
) async {
  return null;
}

Future<LuaCallResult?> _luaPairs(
  LuaContext context,
  LuaArguments arguments,
) async {
  final table = arguments.get<LuaTable>(0);
  if (arguments.length != 1 || table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'pairs',
        expected: 'table',
        actual: arguments.getTypeName(0),
        order: 1,
      ),
    );
  }

  return Success([_createNextFunction(table), table, LuaNil()]);
}

LuaNativeFunction _createIpairNextFunction(LuaTable table) {
  const func = 'next<ipair>';
  return LuaNativeFunction(func, (context, arguments) async {
    final table = arguments.get<LuaTable>(0);
    if (arguments.length < 1 || table == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: func,
          expected: 'table',
          actual: arguments.getTypeName(0),
          order: 1,
        ),
      );
    }

    final index = arguments.get<LuaNumber>(1);
    if (index == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: func,
          expected: 'number',
          actual: arguments.getTypeName(1),
          order: 2,
        ),
      );
    }

    final intIndex = NumberUtils.toIntRepresentation(index.rawValue);
    if (intIndex == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: func,
          expected: 'integer',
          actual: arguments.getTypeName(1),
          order: 1,
        ),
      );
    }

    final nextIndex = table.nextSequenceIndex(intIndex.toInt());
    if (nextIndex == null) {
      return Success([LuaNil()]);
    } else {
      final value = table.getAt(nextIndex);
      if (value == null) {
        return Failure(
          LuaException(
            LuaExceptionType.runtimeError,
            'next<ipair> failed to get value at $nextIndex',
          ),
        );
      }
      return Success([LuaInteger.fromInt(nextIndex), value]);
    }
  });
}

Future<LuaCallResult?> _luaIpairs(
  LuaContext context,
  LuaArguments arguments,
) async {
  final table = arguments.get<LuaTable>(0);
  if (arguments.length != 1 || table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'ipairs',
        expected: 'table',
        actual: arguments.getTypeName(0),
        order: 1,
      ),
    );
  }

  return Success(
    [_createIpairNextFunction(table), table, LuaInteger.fromInt(0)],
  );
}

Future<LuaCallResult?> _luaGetmetatable(
  LuaContext context,
  LuaArguments arguments,
) async {
  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'getmetatable',
        expected: 'table',
        order: 1,
      ),
    );
  }

  final metatable = context.environment.getMetatable(table);
  return Success([metatable ?? LuaNil()]);
}

Future<LuaCallResult?> _luaSetmetatable(
  LuaContext context,
  LuaArguments arguments,
) async {
  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'setmetatable',
        expected: 'table',
        order: 1,
      ),
    );
  }

  var metatable = arguments.get(1);
  if (metatable == null || (metatable is! LuaTable && metatable is! LuaNil)) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'setmetatable',
        expected: 'table or nil',
        order: 2,
        actual: metatable?.luaType.name,
      ),
    );
  }
  if (metatable is LuaNil) {
    metatable = null;
  }
  context.environment.setMetatable(table, metatable as LuaTable?);
  return Success([table]);
}

Future<LuaCallResult?> _luaPcall(
  LuaContext context,
  LuaArguments arguments,
) async {
  final func = arguments.get(0);
  if (func == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'pcall',
        expected: 'function',
        order: 1,
      ),
    );
  }

  List<LuaValue> funcArgs;
  if (arguments.length == 1) {
    funcArgs = [];
  } else {
    funcArgs = arguments.arguments.sublist(1);
  }

  final invocation = LuaValueInvocation(target: func, arguments: funcArgs);
  final result = await context.invoke(invocation);
  if (result.isSuccess()) {
    return Success([LuaTrue(), ...result.getOrDefault([])]);
  } else {
    final error = result.exceptionOrNull()!;
    return Success([LuaFalse(), LuaString(error.message)]);
  }
}

Future<LuaCallResult?> _luaXpcall(
  LuaContext context,
  LuaArguments arguments,
) async {
  final func = arguments.get(0);
  if (func == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'xpcall',
        expected: 'function',
        order: 1,
      ),
    );
  }

  final handler = arguments.get(1);
  if (handler == null || handler is! LuaFunction) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'xpcall',
        expected: 'function',
        order: 2,
        actual: handler?.luaType.name,
      ),
    );
  }

  List<LuaValue> funcArgs;
  if (arguments.length == 2) {
    funcArgs = [];
  } else {
    funcArgs = arguments.arguments.sublist(2);
  }

  final invocation = LuaValueInvocation(target: func, arguments: funcArgs);
  final result = await context.invoke(invocation);
  if (result.isSuccess()) {
    return Success([LuaTrue(), ...result.getOrDefault([])]);
  } else {
    final invocation = LuaValueInvocation(target: handler, arguments: []);
    final result = await context.invoke(invocation);
    if (result.isSuccess()) {
      return Success([LuaFalse(), ...result.getOrDefault([])]);
    } else {
      return Success([LuaFalse(), LuaString('error in error handling')]);
    }
  }
}
