import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

const _luaRandomSeedKey = '_luaRandomseed';

class LuaMathModule extends LuaNativeModule {
  factory LuaMathModule() {
    return _instance;
  }

  LuaMathModule._() : super(name: 'math');

  static final _instance = LuaMathModule._();

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.table) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..bind('huge', LuaBinding(onGet: () => Success(LuaFloat.infinity)))
      ..bind('pi', LuaBinding(onGet: () => Success(LuaFloat(math.pi))))
      ..bind(
        'maxinteger',
        LuaBinding(onGet: () => Success(LuaInteger(LuaInteger.max))),
      )
      ..bind(
        'mininteger',
        LuaBinding(onGet: () => Success(LuaInteger(LuaInteger.min))),
      )
      ..addNativeCalls({
        'abs': _luaAbs,
        'acos': _luaAcos,
        'asin': _luaAsin,
        'atan': _luaAtan,
        'ceil': _luaCeil,
        'cos': _luaCos,
        'deg': _luaDeg,
        'exp': _luaExp,
        'floor': _luaFloor,
        'log': _luaLog,
        'max': _luaMax,
        'min': _luaMin,
        'modf': _luaModf,
        'rad': _luaRad,
        'random': _luaRandom,
        'randomseed': _luaRandomseed,
        'sin': _luaSin,
        'sqrt': _luaSqrt,
        'tan': _luaTan,
        'tointeger': _luaTointeger,
        'type': _luaType,
        'ult': _luaUlt,
      });
    context.environment.variables.stringKeySet('math', module);

    // initialize random seed
    context.environment.setUserData(
      this,
      _luaRandomSeedKey,
      DateTime.now().millisecondsSinceEpoch,
    );

    return Success(module);
  }
}

Future<LuaCallResult?> _luaAbs(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.abs',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaInteger(number.abs())]);
  } else if (number is double) {
    return Success([LuaFloat(number.abs())]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaAcos(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.acos',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.acos(number.toDouble()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.acos(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaAsin(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.asin',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.asin(number.toDouble()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.asin(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaAtan(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.atan',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.atan(number.toDouble()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.atan(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaCeil(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.ceil',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaInteger(number)]);
  } else if (number is double) {
    return Success([LuaInteger.fromInt(number.ceil())]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaCos(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.cos',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.cos(number.toInt()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.cos(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaDeg(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.deg',
        order: 1,
        expected: 'number',
      ),
    );
  }

  LuaFloat toDegrees(double radians) {
    return LuaFloat(radians * (180 / math.pi));
  }

  if (number is Int64) {
    return Success([toDegrees(number.toDouble())]);
  } else if (number is double) {
    return Success([toDegrees(number)]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaExp(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.exp',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.exp(number.toInt()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.exp(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaFloor(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.floor',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaInteger(number)]);
  } else if (number is double) {
    return Success([LuaInteger.fromInt(number.floor())]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaLog(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.log',
        order: 1,
        expected: 'number',
      ),
    );
  }

  var base = arguments.getNumber(1);
  if (base == null) {
    base = math.e;
  } else if (base is Int64) {
    base = base.toDouble();
  } else if (base is! LuaFloat) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.log',
        order: 2,
        expected: 'number',
      ),
    );
  }

  final x = number is Int64 ? number.toInt() : number;
  return Success([LuaFloat(math.log(x as num) / math.log(base as num))]);
}

Future<LuaCallResult?> _luaMax(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.max',
        order: 1,
        expected: 'number',
      ),
    );
  }

  var max = arguments.get(0)!;
  for (var i = 1; i < arguments.length; i++) {
    final value = arguments.get(i)!;
    final invocation = LuaBinaryInvocation(LuaOperator.lessThan, max, value);
    final result = await context.invoke(invocation);
    if (result.isSuccess()) {
      max = result.getOrThrow().firstOrNull?.isTrue ?? false ? value : max;
    } else {
      return Failure(result.exceptionOrNull()!);
    }
  }

  return Success([max]);
}

Future<LuaCallResult?> _luaMin(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.min',
        order: 1,
        expected: 'number',
      ),
    );
  }

  var min = arguments.get(0)!;
  for (var i = 1; i < arguments.length; i++) {
    final value = arguments.get(i)!;
    final invocation = LuaBinaryInvocation(LuaOperator.lessThan, value, min);
    final result = await context.invoke(invocation);
    if (result.isSuccess()) {
      min = result.getOrThrow().firstOrNull?.isTrue ?? false ? value : min;
    } else {
      return Failure(result.exceptionOrNull()!);
    }
  }

  return Success([min]);
}

Future<LuaCallResult?> _luaModf(
  LuaContext context,
  LuaArguments arguments,
) async {
  final value = arguments.get(0);
  if (value == null || value is! LuaNumber) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.modf',
        order: 1,
        expected: 'number',
      ),
    );
  }

  List<LuaValue> modf(double value) {
    if (value.isInfinite) {
      return [LuaFloat(value), LuaFloat(0)];
    } else if (value.isNaN) {
      return [LuaFloat.nan, LuaFloat.nan];
    }

    final integerPart = value.truncateToDouble();
    final fractionalPart = value - integerPart;
    if (integerPart > LuaInteger.max.toDouble() ||
        integerPart < LuaInteger.min.toDouble()) {
      return [LuaFloat(integerPart), LuaFloat(fractionalPart)];
    } else {
      return [
        LuaInteger.fromInt(integerPart.toInt()),
        LuaFloat(fractionalPart),
      ];
    }
  }

  if (value is LuaInteger) {
    return Success([value, LuaFloat(0)]);
  } else if (value is LuaFloat) {
    return Success(modf(value.value));
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaRad(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.rad',
        order: 1,
        expected: 'number',
      ),
    );
  }

  LuaFloat toRadians(double degrees) {
    return LuaFloat(degrees * (math.pi / 180.0));
  }

  if (number is Int64) {
    return Success([toRadians(number.toDouble())]);
  } else if (number is double) {
    return Success([toRadians(number)]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaRandom(
  LuaContext context,
  LuaArguments arguments,
) async {
  final argCount = arguments.length;

  late final math.Random random;
  final module = context.environment.variables.stringKeyGet('math');
  if (module != null) {
    // NOTE: seed is rounded to 32bit integer
    final seed =
        context.environment.getUserData(LuaMathModule(), _luaRandomSeedKey);
    if (seed is int) {
      random = math.Random(seed);
    }
  } else {
    random = math.Random();
  }

  if (argCount == 0) {
    return Success([LuaFloat(random.nextDouble())]);
  } else if (argCount == 1) {
    final n = arguments.getInt(0);
    if (n == null || n <= 0) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'math.random',
          order: 1,
          expected: 'integer',
        ),
      );
    }
    return Success([LuaInteger.fromInt(random.nextInt(n) + 1)]);
  } else if (argCount == 2) {
    final m = arguments.getInt(0);
    final n = arguments.getInt(1);
    if (m == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'math.random',
          order: 1,
          expected: 'integer',
        ),
      );
    } else if (n == null) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'math.random',
          order: 2,
          expected: 'integer',
        ),
      );
    } else if (n < m) {
      return Failure(
        LuaException.badArgumentTypeError(
          function: 'math.random',
          order: 1,
          expected: 'interval is empty',
        ),
      );
    } else {
      return Success([LuaInteger.fromInt(random.nextInt(n - m + 1) + m)]);
    }
  } else {
    return Failure(
      LuaException.wrongNumberOfArguments(
        function: 'math.random',
        expected: '0-2',
      ),
    );
  }
}

// NOTE: 128 bit seed is not supported
// seed is rounded to 32bit
Future<LuaCallResult?> _luaRandomseed(
  LuaContext context,
  LuaArguments arguments,
) async {
  var seed = DateTime.now().millisecondsSinceEpoch;
  if (arguments.length > 0) {
    final argSeed = arguments.getNumber(0);
    if (argSeed is! Int64) {
      return Failure(
        LuaException.noIntegerRepresentation(
          function: 'math.randomseed',
          order: 1,
        ),
      );
    }
    seed = argSeed.toInt();
  }

  context.environment.setUserData(LuaMathModule(), _luaRandomSeedKey, seed);
  return Success([LuaInteger.fromInt(seed), LuaInteger.fromInt(0)]);
}

Future<LuaCallResult?> _luaSin(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.sin',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.sin(number.toInt()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.sin(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaSqrt(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.sqrt',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.sqrt(number.toInt()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.sqrt(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaTan(
  LuaContext context,
  LuaArguments arguments,
) async {
  final number = arguments.getNumber(0);
  if (number == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.tan',
        order: 1,
        expected: 'number',
      ),
    );
  }

  if (number is Int64) {
    return Success([LuaFloat(math.tan(number.toInt()))]);
  } else if (number is double) {
    return Success([LuaFloat(math.tan(number))]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaTointeger(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.tointeger',
        order: 1,
        expected: 'number',
      ),
    );
  }

  final value = arguments.getNumber(0);
  if (value is Int64) {
    return Success([LuaInteger(value)]);
  } else if (value is LuaFloat) {
    return Success([LuaInteger.fromInt(value.value.toInt())]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaType(
  LuaContext context,
  LuaArguments arguments,
) async {
  if (arguments.arguments.isEmpty) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.type',
        order: 1,
        expected: 'number',
      ),
    );
  }

  final value = arguments.get(0)!;
  if (value is LuaInteger) {
    return Success([LuaString('integer')]);
  } else if (value is LuaFloat) {
    return Success([LuaString('float')]);
  } else {
    return Success([LuaNil()]);
  }
}

Future<LuaCallResult?> _luaUlt(
  LuaContext context,
  LuaArguments arguments,
) async {
  final a = arguments.getNumber(0);
  if (a == null || a is! Int64) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.ult',
        order: 1,
        expected: 'integer',
      ),
    );
  }

  final b = arguments.getNumber(1);
  if (b == null || b is! Int64) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'math.ult',
        order: 2,
        expected: 'integer',
      ),
    );
  }

  bool ult(int a, int b) {
    return a.toUnsigned(32) < b.toUnsigned(32);
  }

  return Success([LuaBoolean.fromBool(ult(a.toInt(), b.toInt()))]);
}
