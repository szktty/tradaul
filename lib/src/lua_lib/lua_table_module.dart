import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

class LuaTableModule extends LuaNativeModule {
  LuaTableModule() : super(name: 'table');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.table) {
      return Success(LuaNil());
    }

    final module = LuaTable();
    module.addNativeCalls({
      'insert': _luaInsert,
      'remove': _luaRemove,
      'unpack': _luaUnpack,
    });
    context.environment.variables.stringKeySet('table', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaInsert(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'table.insert',
        expected: '2 or 3',
      ),
    );
  }

  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.insert',
        order: 1,
        expected: 'table',
      ),
    );
  }

  var pos = table.length;
  LuaValue? value;
  if (arguments.length <= 2) {
    value = arguments.get(1);
    if (value == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'table.insert',
          order: 2,
          expected: 'value',
        ),
      );
    }
  } else {
    final luaInt = arguments.getInt(1);
    if (luaInt == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'table.insert',
          order: 2,
          expected: 'integer',
        ),
      );
    }
    pos = luaInt - 1;

    value = arguments.get(2);
    if (value == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'table.insert',
          order: 3,
          expected: 'value',
        ),
      );
    }
  }

  if (pos < 0 || pos > table.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'table.insert',
        order: 2,
        message: 'position out of bounds',
      ),
    );
  }

  table.insert(pos, value);
  return const Success([]);
}

Future<LuaCallResult?> _luaRemove(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'table.remove',
        expected: '1 or 2',
      ),
    );
  }

  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.remove',
        order: 1,
        expected: 'table',
      ),
    );
  }

  final luaPos = arguments.get(1);
  if (luaPos != null && luaPos is! LuaInteger) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.remove',
        order: 2,
        expected: 'integer',
      ),
    );
  }
  final pos =
      luaPos == null ? table.length : (luaPos as LuaInteger).value.toInt();

  if ((table.length == 0 && (pos == 0 || pos == 1)) ||
      (pos - 1) == table.length) {
    return Success([LuaNil()]);
  } else if (pos > table.length) {
    return Failure(
      LuaException.badArgumentError(
        function: 'table.remove',
        order: 2,
        message: 'position out of bounds ($pos > ${table.length})',
      ),
    );
  }

  return Success([table.remove(pos - 1) ?? LuaNil()]);
}

Future<LuaCallResult?> _luaUnpack(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.unpack',
        order: 1,
        expected: 'table',
      ),
    );
  }

  final value = arguments.arguments[0];
  if (value is LuaString) {
    return Success([value]);
  } else {
    return Success([LuaString(value.luaRepresentation)]);
  }
}
