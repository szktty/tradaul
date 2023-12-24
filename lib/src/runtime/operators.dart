// ignore_for_file: require_trailing_commas

import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/number.dart';
import 'package:tradaul/src/utils/type_dispatch.dart';

typedef ArithmeticFourOperationsTypeDispatch
    = TypeDispatch3<Int64, double, String, LuaValue>;
typedef ArithmeticBitwiseTypeDispatch = TypeDispatch2<Int64, double, LuaValue>;
typedef StringOperationsTypeDispatch
    = TypeDispatch3<Int64, double, String, LuaValue>;

abstract class ArithmeticOperatorDispatcher {
  static LuaException _invalidTypeError(String op, dynamic a, dynamic b) {
    return LuaException(
      LuaExceptionType.runtimeError,
      'attempt to $op ${a.runtimeType} with ${b.runtimeType}',
    );
  }

  static LuaValue _redispatchStrings(
    LuaValue Function(dynamic, dynamic) f,
    String op,
    dynamic a,
    dynamic b,
  ) {
    Int64? aInt;
    Int64? bInt;
    double? aDouble;
    double? bDouble;

    if (a is Int64) {
      aInt = a;
    } else if (a is double) {
      aDouble = a;
    } else if (a is String) {
      aInt = NumberParser.parseInt64(a);
      if (aInt == null) {
        aDouble = NumberParser.parseDouble(a);
      }
    }

    if (b is Int64) {
      bInt = b;
    } else if (b is double) {
      bDouble = b;
    } else if (b is String) {
      bInt = NumberParser.parseInt64(b);
      if (bInt == null) {
        bDouble = NumberParser.parseDouble(b);
      }
    }

    if ((aInt != null || aDouble != null) &&
        (bInt != null || bDouble != null)) {
      return f(aInt ?? aDouble, bInt ?? bDouble);
    } else {
      throw _invalidTypeError('add', a, b);
    }
  }

  static final ArithmeticFourOperationsTypeDispatch addition = TypeDispatch3(
    t1T1: (a, b) => LuaInteger(a + b),
    t1T2: (a, b) => LuaFloat(a.toDouble() + b),
    t1T3: (a, b) => _redispatchStrings(addition.dispatch, 'add', a, b),
    t2T1: (a, b) => LuaFloat(a + b.toDouble()),
    t2T2: (a, b) => LuaFloat(a + b),
    t2T3: (a, b) => _redispatchStrings(addition.dispatch, 'add', a, b),
    t3T1: (a, b) => _redispatchStrings(addition.dispatch, 'add', a, b),
    t3T2: (a, b) => _redispatchStrings(addition.dispatch, 'add', a, b),
    t3T3: (a, b) => _redispatchStrings(addition.dispatch, 'add', a, b),
  );

  static final ArithmeticFourOperationsTypeDispatch subtraction = TypeDispatch3(
    t1T1: (a, b) => LuaInteger(a - b),
    t1T2: (a, b) => LuaFloat(a.toDouble() - b),
    t1T3: (a, b) => _redispatchStrings(subtraction.dispatch, 'subtract', a, b),
    t2T1: (a, b) => LuaFloat(a - b.toDouble()),
    t2T2: (a, b) => LuaFloat(a - b),
    t2T3: (a, b) => _redispatchStrings(subtraction.dispatch, 'subtract', a, b),
    t3T1: (a, b) => _redispatchStrings(subtraction.dispatch, 'subtract', a, b),
    t3T2: (a, b) => _redispatchStrings(subtraction.dispatch, 'subtract', a, b),
    t3T3: (a, b) => _redispatchStrings(subtraction.dispatch, 'subtract', a, b),
  );

  static final ArithmeticFourOperationsTypeDispatch multiplication =
      TypeDispatch3(
    t1T1: (a, b) => LuaInteger(a * b),
    t1T2: (a, b) => LuaFloat(a.toDouble() * b),
    t1T3: (a, b) =>
        _redispatchStrings(multiplication.dispatch, 'multiply', a, b),
    t2T1: (a, b) => LuaFloat(a * b.toDouble()),
    t2T2: (a, b) => LuaFloat(a * b),
    t2T3: (a, b) =>
        _redispatchStrings(multiplication.dispatch, 'multiply', a, b),
    t3T1: (a, b) =>
        _redispatchStrings(multiplication.dispatch, 'multiply', a, b),
    t3T2: (a, b) =>
        _redispatchStrings(multiplication.dispatch, 'multiply', a, b),
    t3T3: (a, b) =>
        _redispatchStrings(multiplication.dispatch, 'multiply', a, b),
  );

  static final ArithmeticFourOperationsTypeDispatch division = TypeDispatch3(
    t1T1: (a, b) => LuaFloat(a.toDouble() / b.toDouble()),
    t1T2: (a, b) => LuaFloat(a.toDouble() / b),
    t1T3: (a, b) => _redispatchStrings(division.dispatch, 'divide', a, b),
    t2T1: (a, b) => LuaFloat(a / b.toDouble()),
    t2T2: (a, b) => LuaFloat(a / b),
    t2T3: (a, b) => _redispatchStrings(division.dispatch, 'divide', a, b),
    t3T1: (a, b) => _redispatchStrings(division.dispatch, 'divide', a, b),
    t3T2: (a, b) => _redispatchStrings(division.dispatch, 'divide', a, b),
    t3T3: (a, b) => _redispatchStrings(division.dispatch, 'divide', a, b),
  );

  static LuaFloat _floorDivideDoubles(double a, double b) {
    if (NumberUtils.isDivisionInfinity(a, b)) {
      return LuaFloat.infinityOfSign(a.sign);
    } else {
      var div = a ~/ b;
      if ((a < 0) != (b < 0) && a % b != 0) {
        div--;
      }
      return LuaFloat(div.toDouble());
    }
  }

  static final ArithmeticFourOperationsTypeDispatch floorDivision =
      TypeDispatch3(
    t1T1: (a, b) {
      var div = a ~/ b;
      if ((a < 0) != (b < 0) && a % b != 0) {
        div--;
      }
      return LuaInteger(div);
    },
    t1T2: (a, b) => _floorDivideDoubles(a.toDouble(), b),
    t1T3: (a, b) =>
        _redispatchStrings(floorDivision.dispatch, 'floorDivide', a, b),
    t2T1: (a, b) => _floorDivideDoubles(a, b.toDouble()),
    t2T2: _floorDivideDoubles,
    t2T3: (a, b) =>
        _redispatchStrings(floorDivision.dispatch, 'floorDivide', a, b),
    t3T1: (a, b) =>
        _redispatchStrings(floorDivision.dispatch, 'floorDivide', a, b),
    t3T2: (a, b) =>
        _redispatchStrings(floorDivision.dispatch, 'floorDivide', a, b),
    t3T3: (a, b) =>
        _redispatchStrings(floorDivision.dispatch, 'floorDivide', a, b),
  );

  static final ArithmeticFourOperationsTypeDispatch modulus = TypeDispatch3(
    t1T1: (a, b) => LuaInteger(a % b),
    t1T2: (a, b) => LuaFloat(a.toDouble() % b),
    t1T3: (a, b) => _redispatchStrings(modulus.dispatch, 'mod', a, b),
    t2T1: (a, b) => LuaFloat(a % b.toDouble()),
    t2T2: (a, b) => LuaFloat(a % b),
    t2T3: (a, b) => _redispatchStrings(modulus.dispatch, 'mod', a, b),
    t3T1: (a, b) => _redispatchStrings(modulus.dispatch, 'mod', a, b),
    t3T2: (a, b) => _redispatchStrings(modulus.dispatch, 'mod', a, b),
    t3T3: (a, b) => _redispatchStrings(modulus.dispatch, 'mod', a, b),
  );

  static final ArithmeticFourOperationsTypeDispatch exponentiation =
      TypeDispatch3(
    t1T1: (a, b) => LuaNumber.fromNum(pow(a.toDouble(), b.toDouble())),
    t1T2: (a, b) => LuaNumber.fromNum(pow(a.toDouble(), b)),
    t1T3: (a, b) => _redispatchStrings(exponentiation.dispatch, 'pow', a, b),
    t2T1: (a, b) => LuaNumber.fromNum(pow(a, b.toDouble())),
    t2T2: (a, b) => LuaNumber.fromNum(pow(a, b)),
    t2T3: (a, b) => _redispatchStrings(exponentiation.dispatch, 'pow', a, b),
    t3T1: (a, b) => _redispatchStrings(exponentiation.dispatch, 'pow', a, b),
    t3T2: (a, b) => _redispatchStrings(exponentiation.dispatch, 'pow', a, b),
    t3T3: (a, b) => _redispatchStrings(exponentiation.dispatch, 'pow', a, b),
  );

  static LuaValue _applyDoubleAsInt(
      Int64 Function(Int64, Int64) f, dynamic a, dynamic b) {
    final aInt = NumberUtils.toIntRepresentation(a);
    final bInt = NumberUtils.toIntRepresentation(b);
    if (aInt == null || bInt == null) {
      throw LuaException(LuaExceptionType.badArgument,
          'attempt to apply no integer representation');
    }
    return LuaInteger(f(aInt, bInt));
  }

  static LuaValue _bitwiseAnd(dynamic a, dynamic b) =>
      _applyDoubleAsInt((Int64 a, Int64 b) => a & b, a, b);

  static final ArithmeticBitwiseTypeDispatch bitwiseAnd = TypeDispatch2(
    t1T1: (a, b) => LuaInteger(a & b),
    t1T2: _bitwiseAnd,
    t2T1: _bitwiseAnd,
    t2T2: _bitwiseAnd,
  );

  static LuaValue _bitwiseOr(dynamic a, dynamic b) =>
      _applyDoubleAsInt((Int64 a, Int64 b) => a | b, a, b);

  static final ArithmeticBitwiseTypeDispatch bitwiseOr = TypeDispatch2(
    t1T1: (a, b) => LuaInteger(a | b),
    t1T2: _bitwiseOr,
    t2T1: _bitwiseOr,
    t2T2: _bitwiseOr,
  );

  static LuaValue _bitwiseXor(dynamic a, dynamic b) =>
      _applyDoubleAsInt((Int64 a, Int64 b) => a ^ b, a, b);

  static final ArithmeticBitwiseTypeDispatch bitwiseXor = TypeDispatch2(
    t1T1: (a, b) => LuaInteger(a ^ b),
    t1T2: _bitwiseXor,
    t2T1: _bitwiseXor,
    t2T2: _bitwiseXor,
  );

  static LuaValue _rightShift(dynamic a, dynamic b) => _applyDoubleAsInt(
      (Int64 a, Int64 b) =>
          b.isNegative ? a << b.abs().toInt() : a >> b.toInt(),
      a,
      b);

  static final ArithmeticBitwiseTypeDispatch rightShift = TypeDispatch2(
    t1T1: (a, b) =>
        b < 0 ? LuaInteger(a << (-b).toInt()) : LuaInteger(a >> b.toInt()),
    t1T2: _rightShift,
    t2T1: _rightShift,
    t2T2: _rightShift,
  );

  static LuaValue _leftShift(dynamic a, dynamic b) => _applyDoubleAsInt(
      (Int64 a, Int64 b) =>
          b.isNegative ? a >> b.abs().toInt() : a << b.toInt(),
      a,
      b);

  static final ArithmeticBitwiseTypeDispatch leftShift = TypeDispatch2(
    t1T1: (a, b) =>
        b < 0 ? LuaInteger(a >> (-b.toInt())) : LuaInteger(a << b.toInt()),
    t1T2: _leftShift,
    t2T1: _leftShift,
    t2T2: _leftShift,
  );
}

abstract class StringOperatorDispatcher {
  static LuaValue _concatenate(dynamic a, dynamic b) {
    final aStr = _toStringRepresentation(a);
    final bStr = _toStringRepresentation(b);
    if (aStr == null || bStr == null) {
      throw LuaException(LuaExceptionType.badArgument,
          'attempt to concatenate a ${aStr ?? bStr} value');
    }
    return LuaString('$aStr$bStr');
  }

  static String? _toStringRepresentation(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is Int64) {
      return value.toString();
    } else if (value is double) {
      return value.toString();
    } else {
      return null;
    }
  }

  static final StringOperationsTypeDispatch concatenation = TypeDispatch3(
    t1T1: _concatenate,
    t1T2: _concatenate,
    t1T3: _concatenate,
    t2T1: _concatenate,
    t2T2: _concatenate,
    t2T3: _concatenate,
    t3T1: _concatenate,
    t3T2: _concatenate,
    t3T3: _concatenate,
  );
}
