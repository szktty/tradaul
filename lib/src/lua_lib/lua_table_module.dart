import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
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

    final module = LuaTable()
      ..addNativeCalls({
        'concat': _luaConcat,
        'insert': _luaInsert,
        'move': _luaMove,
        'pack': _luaPack,
        'remove': _luaRemove,
        'sort': _luaSort,
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

Future<LuaCallResult?> _luaMove(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 4) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'table.move',
        expected: '4 or 5',
      ),
    );
  }

  final a1 = arguments.get<LuaTable>(0);
  if (a1 == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.move',
        order: 1,
        expected: 'table',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  final f = arguments.getInt(1);
  if (f == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.move',
        order: 2,
        expected: 'integer',
        actual: arguments.getTypeName(1),
      ),
    );
  }

  final e = arguments.getInt(2);
  if (e == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.move',
        order: 3,
        expected: 'integer',
        actual: arguments.getTypeName(2),
      ),
    );
  }

  final t = arguments.getInt(3);
  if (t == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.move',
        order: 4,
        expected: 'integer',
        actual: arguments.getTypeName(3),
      ),
    );
  }

  // Target table (defaults to source table if not provided)
  final a2 = arguments.length >= 5 ? arguments.get<LuaTable>(4) ?? a1 : a1;

  // Copy elements from a1[f..e] to a2[t..]
  if (f <= e) {
    // Determine copy direction to handle overlapping ranges
    if (a1 == a2 && t > f) {
      // Copy backwards for overlapping ranges in same table
      for (var i = e; i >= f; i--) {
        final sourceKey = LuaInteger.fromInt(i);
        final targetKey = LuaInteger.fromInt(t + (i - f));
        final value = a1.get(sourceKey) ?? LuaNil();
        a2.set(targetKey, value);
      }
    } else {
      // Copy forwards
      for (var i = f; i <= e; i++) {
        final sourceKey = LuaInteger.fromInt(i);
        final targetKey = LuaInteger.fromInt(t + (i - f));
        final value = a1.get(sourceKey) ?? LuaNil();
        a2.set(targetKey, value);
      }
    }
  }

  return Success([a2]);
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

  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.unpack',
        order: 1,
        expected: 'table',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  // Get start index (default 1)
  final i = arguments.length >= 2 ? arguments.getInt(1) ?? 1 : 1;

  // Get end index (default table length)
  final j = arguments.length >= 3
      ? arguments.getInt(2) ?? table.length
      : table.length;

  // In Lua, table.unpack stops at the first nil value unless end is specified
  if (j < i) {
    return const Success([]);
  }

  final result = <LuaValue>[];
  final endIndex = arguments.length >= 3 ? j : table.length;

  for (var index = i; index <= endIndex; index++) {
    final key = LuaInteger.fromInt(index);
    final value = table.get(key);

    // If no explicit end index and we hit nil, stop unpacking
    if (arguments.length < 3 && (value == null || value is LuaNil)) {
      break;
    }

    result.add(value ?? LuaNil());
  }

  return Success(result);
}

Future<LuaCallResult?> _luaConcat(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.concat',
        order: 1,
        expected: 'table',
      ),
    );
  }

  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.concat',
        order: 1,
        expected: 'table',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  // Get separator (default empty string)
  final sep = arguments.length >= 2 ? arguments.getString(1) ?? '' : '';

  // Get start index (default 1)
  final i = arguments.length >= 3 ? arguments.getInt(2) ?? 1 : 1;

  // Get end index (default table length)
  final j = arguments.length >= 4
      ? arguments.getInt(3) ?? table.length
      : table.length;

  final parts = <String>[];
  for (var index = i; index <= j; index++) {
    final key = LuaInteger.fromInt(index);
    final value = table.get(key);
    if (value != null && value is! LuaNil) {
      if (value is LuaString) {
        parts.add(value.value);
      } else if (value is LuaNumber) {
        parts.add(value.luaRepresentation);
      } else {
        return Failure(
          LuaException.badArgumentError(
            function: 'table.concat',
            order: 1,
            message: 'invalid value '
                '(${value.luaType.name}) at index $index in table for concat',
          ),
        );
      }
    }
  }

  return Success([LuaString(parts.join(sep))]);
}

Future<LuaCallResult?> _luaPack(
  LuaContext context,
  LuaArguments arguments,
) async {
  final result = LuaTable();

  // Add all arguments to the table with 1-based indexing
  for (var i = 0; i < arguments.length; i++) {
    final key = LuaInteger.fromInt(i + 1);
    result.set(key, arguments.arguments[i]);
  }

  // Set the 'n' field to the number of arguments
  result.stringKeySet('n', LuaInteger.fromInt(arguments.length));

  return Success([result]);
}

Future<LuaCallResult?> _luaSort(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length < 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'table.sort',
        expected: '1 or 2',
      ),
    );
  }

  final table = arguments.get<LuaTable>(0);
  if (table == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'table.sort',
        order: 1,
        expected: 'table',
      ),
    );
  }

  // Get the array part of the table
  final list = <LuaValue>[];
  var i = 1;
  while (true) {
    final value = table.get(LuaInteger.fromInt(i));
    if (value == null || value.isNil) {
      break;
    }
    list.add(value);
    i++;
  }

  if (list.isEmpty) {
    return const Success([]);
  }

  // Sort the list
  final comparator = arguments.get<LuaFunction>(1);

  if (comparator != null) {
    // Custom comparator function
    try {
      await _quickSort(context, list, 0, list.length - 1, comparator);
    } on Exception {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'invalid order function for sorting',
        ),
      );
    }
  } else {
    // Default comparison (less than)
    try {
      await _quickSort(context, list, 0, list.length - 1, null);
    } on Exception {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'attempt to compare incompatible values',
        ),
      );
    }
  }

  // Write back to table
  for (var j = 0; j < list.length; j++) {
    table.set(LuaInteger.fromInt(j + 1), list[j]);
  }

  return const Success([]);
}

Future<void> _quickSort(
  LuaContext context,
  List<LuaValue> list,
  int low,
  int high,
  LuaFunction? comparator,
) async {
  if (low < high) {
    final pi = await _partition(context, list, low, high, comparator);
    await _quickSort(context, list, low, pi - 1, comparator);
    await _quickSort(context, list, pi + 1, high, comparator);
  }
}

Future<int> _partition(
  LuaContext context,
  List<LuaValue> list,
  int low,
  int high,
  LuaFunction? comparator,
) async {
  final pivot = list[high];
  var i = low - 1;

  for (var j = low; j < high; j++) {
    final shouldSwap = await _compareValues(
      context,
      list[j],
      pivot,
      comparator,
    );

    if (shouldSwap) {
      i++;
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  final temp = list[i + 1];
  list[i + 1] = list[high];
  list[high] = temp;

  return i + 1;
}

Future<bool> _compareValues(
  LuaContext context,
  LuaValue a,
  LuaValue b,
  LuaFunction? comparator,
) async {
  if (comparator != null) {
    // Use custom comparator
    final invocation = LuaValueInvocation(
      target: comparator,
      arguments: [a, b],
    );
    final result = await context.invoke(invocation);
    if (result.isError()) {
      throw result.exceptionOrNull()!;
    }
    final values = result.getOrThrow();
    return values.isNotEmpty && values.first.luaToBoolean;
  } else {
    // Default comparison: a < b
    if (a.isNumber && b.isNumber) {
      final aNum = a as LuaNumber;
      final bNum = b as LuaNumber;
      return aNum.toDouble() < bNum.toDouble();
    } else if (a.isString && b.isString) {
      final aStr = a as LuaString;
      final bStr = b as LuaString;
      return aStr.value.compareTo(bStr.value) < 0;
    } else {
      throw Exception(
        'attempt to compare ${a.luaType.name} with ${b.luaType.name}',
      );
    }
  }
}
