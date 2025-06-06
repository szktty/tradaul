import 'package:fixnum/fixnum.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_module_options.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

class LuaOsModule extends LuaNativeModule {
  LuaOsModule() : super(name: 'os');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.os) {
      return Success(LuaNil());
    }

    final module = LuaTable();
    module.addNativeCalls({
      'clock': _luaClock,
      'date': _luaDate,
      'difftime': _luaDifftime,
      'execute': _luaExecute,
      'exit': _luaExit,
      'getenv': _luaGetenv,
      'remove': _luaRemove,
      'rename': _luaRename,
      'setlocale': _luaSetlocale,
      'time': _luaTime,
      'tmpname': _luaTmpname,
    });
    context.environment.variables.stringKeySet('os', module);
    return Success(module);
  }
}

Future<LuaCallResult?> _luaClock(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 0) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.clock',
        expected: '0',
      ),
    );
  }

  final callback = context.options.osCallbacks?.clock;
  if (callback != null) {
    final result = await callback();
    if (result.isSuccess()) {
      return Success([LuaFloat(result.getOrThrow())]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.clock failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  // Default implementation using DateTime
  final now = DateTime.now();
  final seconds = now.millisecondsSinceEpoch / 1000.0;
  return Success([LuaFloat(seconds)]);
}

Future<LuaCallResult?> _luaDate(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length > 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.date',
        expected: '0 to 2',
      ),
    );
  }

  var format = arguments.getString(0) ?? '%c';
  final timeArg = arguments.getInt(1);

  // Check for UTC prefix
  final isUtc = format.startsWith('!');
  if (isUtc) {
    format = format.substring(1);
  }

  // Get the time to format
  LuaOsDateTime dateTimeDesc;
  if (timeArg != null) {
    final dt =
        DateTime.fromMillisecondsSinceEpoch(timeArg * 1000, isUtc: isUtc);
    dateTimeDesc = LuaOsDateTime(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      second: dt.second,
      utc: isUtc,
    );
  } else {
    final dt = isUtc ? DateTime.now().toUtc() : DateTime.now();
    dateTimeDesc = LuaOsDateTime(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      second: dt.second,
      utc: isUtc,
    );
  }

  // Handle invalid table specifiers first - return as-is
  if (format.startsWith('*') && format != '*t') {
    return Success([LuaString(format)]);
  }

  // Use callback if available
  final formatCallback = context.options.osCallbacks?.format;
  if (formatCallback != null) {
    final result = await formatCallback(format, dateTimeDesc, utc: isUtc);
    if (result.isSuccess()) {
      final formatResult = result.getOrThrow();
      if (format == '*t') {
        final table = LuaTable();
        final dt = formatResult.dateTime;
        table.stringKeySet('year', LuaInteger.fromInt(dt.year));
        table.stringKeySet('month', LuaInteger.fromInt(dt.month));
        table.stringKeySet('day', LuaInteger.fromInt(dt.day));
        table.stringKeySet('hour', LuaInteger.fromInt(dt.hour));
        table.stringKeySet('min', LuaInteger.fromInt(dt.minute));
        table.stringKeySet('sec', LuaInteger.fromInt(dt.second));
        table.stringKeySet('wday', LuaInteger.fromInt(dt.day % 7 + 1));
        table.stringKeySet('yday', LuaInteger.fromInt(dt.day));
        table.stringKeySet('isdst', LuaFalse());
        return Success([table]);
      } else {
        return Success([LuaString(formatResult.string)]);
      }
    }
  }

  // Default implementation
  if (format == '*t') {
    // Return table representation
    final table = LuaTable();
    table.stringKeySet('year', LuaInteger.fromInt(dateTimeDesc.year));
    table.stringKeySet('month', LuaInteger.fromInt(dateTimeDesc.month));
    table.stringKeySet('day', LuaInteger.fromInt(dateTimeDesc.day));
    table.stringKeySet('hour', LuaInteger.fromInt(dateTimeDesc.hour));
    table.stringKeySet('min', LuaInteger.fromInt(dateTimeDesc.minute));
    table.stringKeySet('sec', LuaInteger.fromInt(dateTimeDesc.second));
    table.stringKeySet('wday', LuaInteger.fromInt(dateTimeDesc.day % 7 + 1));
    table.stringKeySet('yday', LuaInteger.fromInt(dateTimeDesc.day));
    table.stringKeySet('isdst', LuaFalse());
    return Success([table]);
  }

  // Simple format conversion
  var result = format;
  result =
      result.replaceAll('%Y', dateTimeDesc.year.toString().padLeft(4, '0'));
  result =
      result.replaceAll('%m', dateTimeDesc.month.toString().padLeft(2, '0'));
  result = result.replaceAll('%d', dateTimeDesc.day.toString().padLeft(2, '0'));
  result =
      result.replaceAll('%H', dateTimeDesc.hour.toString().padLeft(2, '0'));
  result =
      result.replaceAll('%M', dateTimeDesc.minute.toString().padLeft(2, '0'));
  result =
      result.replaceAll('%S', dateTimeDesc.second.toString().padLeft(2, '0'));
  result = result.replaceAll('%c', '$dateTimeDesc');

  return Success([LuaString(result)]);
}

Future<LuaCallResult?> _luaDifftime(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.difftime',
        expected: '2',
      ),
    );
  }

  final t2 = arguments.getInt(0);
  final t1 = arguments.getInt(1);

  if (t2 == null || t1 == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'os.difftime',
        order: t2 == null ? 1 : 2,
        expected: 'number',
      ),
    );
  }

  final callback = context.options.osCallbacks?.timeDifference;
  if (callback != null) {
    final result = await callback(Int64(t2), Int64(t1));
    if (result.isSuccess()) {
      return Success([LuaInteger.fromInt(result.getOrThrow().toInt())]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.difftime failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  return Success([LuaInteger.fromInt(t2 - t1)]);
}

Future<LuaCallResult?> _luaExecute(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length > 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.execute',
        expected: '0 or 1',
      ),
    );
  }

  final command = arguments.getString(0);

  final callback = context.options.osCallbacks?.execute;
  if (callback != null && command != null) {
    final result = await callback(command);
    if (result.isSuccess()) {
      final status = result.getOrThrow();
      return Success([
        LuaBoolean.fromBool(status.success),
        if (status.code != null) LuaInteger.fromInt(status.code!) else LuaNil(),
        if (status.signal != null)
          LuaInteger.fromInt(status.signal!)
        else
          LuaNil(),
      ]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.execute failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  // Default behavior - always return success for security
  if (command == null) {
    return Success([LuaTrue()]);
  }
  return Success([LuaTrue(), LuaInteger.fromInt(0), LuaNil()]);
}

Future<LuaCallResult?> _luaExit(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length > 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.exit',
        expected: '0 to 2',
      ),
    );
  }

  final codeArg = arguments.get(0);
  // closeArg is ignored in this implementation

  int? code;
  bool? status;

  if (codeArg != null) {
    if (codeArg is LuaBoolean) {
      status = codeArg.value;
    } else if (codeArg is LuaInteger) {
      code = codeArg.value.toInt();
    } else {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'os.exit',
          order: 1,
          expected: 'boolean or number',
        ),
      );
    }
  }

  // Note: close parameter is ignored in this implementation

  final callback = context.options.osCallbacks?.exit;
  if (callback != null) {
    final result = await callback(status: status, code: code);
    if (result.isSuccess()) {
      // This shouldn't actually return since it should exit
      return const Success([]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.exit failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  // Default behavior - don't actually exit, just return
  return const Success([]);
}

Future<LuaCallResult?> _luaGetenv(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.getenv',
        expected: '1',
      ),
    );
  }

  final varname = arguments.getString(0);
  if (varname == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'os.getenv',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final callback = context.options.osCallbacks?.getEnvironmentVariable;
  if (callback != null) {
    final result = await callback(varname);
    if (result != null && result.isSuccess()) {
      return Success([LuaString(result.getOrThrow())]);
    } else {
      return Success([LuaNil()]);
    }
  }

  // Default behavior - return nil
  return Success([LuaNil()]);
}

Future<LuaCallResult?> _luaRemove(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.remove',
        expected: '1',
      ),
    );
  }

  final filename = arguments.getString(0);
  if (filename == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'os.remove',
        order: 1,
        expected: 'string',
      ),
    );
  }

  final callback = context.options.osCallbacks?.removeFile;
  if (callback != null) {
    final result = await callback(filename);
    if (result.isSuccess()) {
      return Success([LuaTrue()]);
    } else {
      final error = result.exceptionOrNull()!;
      return Success([LuaNil(), LuaString(error.message)]);
    }
  }

  // Default behavior - always succeed for security
  return Success([LuaTrue()]);
}

Future<LuaCallResult?> _luaRename(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.rename',
        expected: '2',
      ),
    );
  }

  final oldname = arguments.getString(0);
  final newname = arguments.getString(1);

  if (oldname == null || newname == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'os.rename',
        order: oldname == null ? 1 : 2,
        expected: 'string',
      ),
    );
  }

  final callback = context.options.osCallbacks?.renameFileOrDirectory;
  if (callback != null) {
    final result = await callback(oldname, newname);
    if (result.isSuccess()) {
      return Success([LuaTrue()]);
    } else {
      final error = result.exceptionOrNull()!;
      return Success([LuaNil(), LuaString(error.message)]);
    }
  }

  // Default behavior - always succeed for security
  return Success([LuaTrue()]);
}

Future<LuaCallResult?> _luaSetlocale(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length > 2) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.setlocale',
        expected: '0 to 2',
      ),
    );
  }

  final locale = arguments.getString(0) ?? 'C';
  final categoryStr = arguments.getString(1) ?? 'all';

  LuaLocaleCategory category;
  switch (categoryStr) {
    case 'all':
      category = LuaLocaleCategory.all;
    case 'collate':
      category = LuaLocaleCategory.collate;
    case 'ctype':
      category = LuaLocaleCategory.ctype;
    case 'monetary':
      category = LuaLocaleCategory.monetary;
    case 'numeric':
      category = LuaLocaleCategory.numeric;
    case 'time':
      category = LuaLocaleCategory.time;
    default:
      return Failure(
        LuaException.badArgumentError(
          function: 'os.setlocale',
          order: 2,
          message: 'invalid category "$categoryStr"',
        ),
      );
  }

  final callback = context.options.osCallbacks?.setLocale;
  if (callback != null) {
    final result = await callback(locale, category);
    if (result.isSuccess()) {
      return Success([LuaString(result.getOrThrow())]);
    } else {
      return Success([LuaNil()]);
    }
  }

  // Default behavior - return the locale
  return Success([LuaString(locale)]);
}

Future<LuaCallResult?> _luaTime(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length > 1) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.time',
        expected: '0 or 1',
      ),
    );
  }

  LuaOsDateTime? dateTime;
  if (arguments.length == 1) {
    final tableArg = arguments.get<LuaTable>(0);
    if (tableArg == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'os.time',
          order: 1,
          expected: 'table',
        ),
      );
    }

    final year = tableArg.stringKeyGet('year');
    final month = tableArg.stringKeyGet('month');
    final day = tableArg.stringKeyGet('day');

    if (year is! LuaInteger || month is! LuaInteger || day is! LuaInteger) {
      return Failure(
        LuaException.badArgumentError(
          function: 'os.time',
          order: 1,
          message: 'field "year", "month", and "day" are required',
        ),
      );
    }

    final hour =
        (tableArg.stringKeyGet('hour') as LuaInteger?)?.value.toInt() ?? 12;
    final min =
        (tableArg.stringKeyGet('min') as LuaInteger?)?.value.toInt() ?? 0;
    final sec =
        (tableArg.stringKeyGet('sec') as LuaInteger?)?.value.toInt() ?? 0;

    dateTime = LuaOsDateTime(
      year: year.value.toInt(),
      month: month.value.toInt(),
      day: day.value.toInt(),
      hour: hour,
      minute: min,
      second: sec,
    );
  }

  final callback = context.options.osCallbacks?.time;
  if (callback != null) {
    final result = await callback(dateTime);
    if (result.isSuccess()) {
      return Success([LuaInteger.fromInt(result.getOrThrow().toInt())]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.time failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  // Default implementation
  DateTime dt;
  if (dateTime != null) {
    dt = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  } else {
    dt = DateTime.now();
  }

  final timestamp = dt.millisecondsSinceEpoch ~/ 1000;
  return Success([LuaInteger.fromInt(timestamp)]);
}

Future<LuaCallResult?> _luaTmpname(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.length != 0) {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'os.tmpname',
        expected: '0',
      ),
    );
  }

  final callback = context.options.osCallbacks?.temporaryFileName;
  if (callback != null) {
    final result = await callback();
    if (result.isSuccess()) {
      return Success([LuaString(result.getOrThrow())]);
    } else {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'os.tmpname failed: ${result.exceptionOrNull()}',
        ),
      );
    }
  }

  // Default implementation - generate a simple temporary filename
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return Success([LuaString('lua_$timestamp.tmp')]);
}
