import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

class LuaDebugModule extends LuaNativeModule {
  LuaDebugModule() : super(name: 'debug');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    // Debug module is always available (no permission check needed)
    // as debug functions are useful for development

    final module = LuaTable()
      ..addNativeCalls({
        'getmetatable': _luaGetmetatable,
        'setmetatable': _luaSetmetatable,
        'getuservalue': _luaGetuservalue,
        'setuservalue': _luaSetuservalue,
        'traceback': _luaTraceback,
        'getinfo': _luaGetinfo,
        'gethook': _luaGethook,
        'setlocal': _luaSetlocal,
      });

    context.environment.variables.stringKeySet('debug', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaGetmetatable(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.getmetatable',
        expected: '1',
      ),
    );
  }

  final value = arguments.get(0)!;
  final metatable = context.environment.getMetatable(value, isRaw: true);

  return Success([metatable ?? LuaNil()]);
}

Future<LuaCallResult?> _luaSetmetatable(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.setmetatable',
        expected: '2',
      ),
    );
  }

  final value = arguments.get(0)!;
  final metatable = arguments.get<LuaTable>(1);

  context.environment.setMetatable(value, metatable);

  return Success([value]);
}

Future<LuaCallResult?> _luaGetuservalue(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.getuservalue',
        expected: '1 or 2',
      ),
    );
  }

  final userdata = arguments.get(0);
  if (userdata == null || !userdata.isUserData) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'debug.getuservalue',
        order: 1,
        expected: 'userdata',
      ),
    );
  }

  // For now, return nil and "other" as we don't have user values
  return Success([LuaNil(), LuaString('other')]);
}

Future<LuaCallResult?> _luaSetuservalue(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.setuservalue',
        expected: '2 or 3',
      ),
    );
  }

  final userdata = arguments.get(0);
  if (userdata == null || !userdata.isUserData) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'debug.setuservalue',
        order: 1,
        expected: 'userdata',
      ),
    );
  }

  // For now, just return the userdata
  return Success([userdata]);
}

Future<LuaCallResult?> _luaTraceback(
  LuaContext context,
  LuaArguments arguments,
) async {
  final thread = arguments.get(0);
  String? message;

  if (thread is LuaString) {
    // First argument is the message
    message = thread.value;
  } else if (thread == null || thread.isThread) {
    // First argument is thread or nil
    message = arguments.getString(1);
  } else {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'debug.traceback',
        order: 1,
        expected: 'thread or string',
      ),
    );
  }

  // Build a simple traceback
  final buffer = StringBuffer();

  if (message != null && message.isNotEmpty) {
    buffer.writeln(message);
  }

  buffer.writeln('stack traceback:');

  // Add simplified stack trace
  // Note: Tradaul doesn't have detailed stack trace info
  buffer.writeln('\t[Lua]: in main chunk');

  return Success([LuaString(buffer.toString())]);
}

Future<LuaCallResult?> _luaGetinfo(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.getinfo',
        expected: 'at least 1',
      ),
    );
  }

  // Create info table with basic information
  final info = LuaTable();

  // Basic implementation - return minimal info
  info.stringKeySet('source', LuaString('@<unknown>'));
  info.stringKeySet('short_src', LuaString('<unknown>'));
  info.stringKeySet('linedefined', LuaInteger.fromInt(-1));
  info.stringKeySet('lastlinedefined', LuaInteger.fromInt(-1));
  info.stringKeySet('what', LuaString('Lua'));
  info.stringKeySet('currentline', LuaInteger.fromInt(-1));
  info.stringKeySet('nups', LuaInteger.fromInt(0));
  info.stringKeySet('nparams', LuaInteger.fromInt(0));
  info.stringKeySet('isvararg', LuaFalse());
  info.stringKeySet('name', LuaNil());
  info.stringKeySet('namewhat', LuaString(''));
  info.stringKeySet('istailcall', LuaFalse());

  return Success([info]);
}

Future<LuaCallResult?> _luaGethook(
  LuaContext context,
  LuaArguments arguments,
) async {
  // No hook support - return nil, empty string, 0
  return Success([LuaNil(), LuaString(''), LuaInteger.fromInt(0)]);
}

Future<LuaCallResult?> _luaSetlocal(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 3) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'debug.setlocal',
        expected: '3 or 4',
      ),
    );
  }

  // Not supported - return nil
  return Success([LuaNil()]);
}
