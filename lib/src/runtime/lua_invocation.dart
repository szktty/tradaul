import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

enum LuaOperator {
  plus('+'),
  minus('-'),
  multiply('*'),
  divide('/'),
  modulo('%'),
  power('^'),
  floorDivide('//'),
  bitwiseAnd('&'),
  bitwiseOr('|'),
  bitwiseXor('~'),
  bitwiseNot('~'),
  bitwiseLeftShift('<<'),
  bitwiseRightShift('>>'),
  negation('-'),
  length('#'),
  equal('=='),
  lessThan('<'),
  lessThanOrEqual('<='),
  greaterThan('>'),
  greaterThanOrEqual('>='),
  concat('..');

  const LuaOperator(this.name);

  final String name;

  @override
  String toString() => name;

  bool get isArithmetic => [
        plus,
        minus,
        multiply,
        divide,
        modulo,
        power,
        floorDivide,
        negation,
      ].contains(this);

  bool get isBitwise => [
        bitwiseAnd,
        bitwiseOr,
        bitwiseXor,
        bitwiseNot,
        bitwiseLeftShift,
        bitwiseRightShift,
      ].contains(this);

  bool get isRelational => [
        equal,
        lessThan,
        lessThanOrEqual,
        greaterThan,
        greaterThanOrEqual,
      ].contains(this);
}

abstract class LuaMetamethodNames {
  static const add = '__add';
  static const sub = '__sub';
  static const mul = '__mul';
  static const div = '__div';
  static const mod = '__mod';
  static const pow = '__pow';
  static const unm = '__unm';
  static const idiv = '__idiv';
  static const band = '__band';
  static const bor = '__bor';
  static const bxor = '__bxor';
  static const bnot = '__bnot';
  static const shl = '__shl';
  static const shr = '__shr';
  static const concat = '__concat';
  static const len = '__len';
  static const eq = '__eq';
  static const lt = '__lt';
  static const le = '__le';
  static const index = '__index';
  static const newindex = '__newindex';
  static const call = '__call';
  static const tostring = '__tostring';
  static const gc = '__gc';
  static const close = '__close';
  static const mode = '__mode';
  static const name = '__name';
  static const pairs = '__pairs';
  static const metatable = '__metatable';
}

// TODO: le, lt, ge, gt
abstract class LuaInvocation {
  LuaInvocation({required this.arguments, this.isRaw = false});

  factory LuaInvocation.function(
    String name,
    List<LuaValue> arguments, {
    bool isRaw = false,
  }) =>
      LuaFunctionInvocation(
        name: name,
        arguments: arguments,
        isRaw: isRaw,
      );

  factory LuaInvocation.method(
    LuaTable target,
    String name,
    List<LuaValue> arguments, {
    bool isRaw = false,
  }) =>
      LuaMethodInvocation(
        target: target,
        name: name,
        arguments: arguments,
        isRaw: isRaw,
      );

  factory LuaInvocation.value(
    LuaValue callable,
    List<LuaValue> arguments, {
    bool isRaw = false,
  }) =>
      LuaValueInvocation(
        target: callable,
        arguments: arguments,
        isRaw: isRaw,
      );

  factory LuaInvocation.addition(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.plus,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.subtraction(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.minus,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.multiplication(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.multiply,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.division(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.divide,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.floorDivision(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.floorDivide,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.modulus(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.modulo,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.exponentiation(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.power,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.negation(
    LuaValue value, {
    bool isRaw = false,
  }) =>
      LuaUnaryInvocation(
        LuaOperator.negation,
        value,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseAnd(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.bitwiseAnd,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseOr(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.bitwiseOr,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseXor(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.bitwiseXor,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseNot(
    LuaValue value, {
    bool isRaw = false,
  }) =>
      LuaUnaryInvocation(
        LuaOperator.bitwiseNot,
        value,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseLeftShift(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.bitwiseLeftShift,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.bitwiseRightShift(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.bitwiseRightShift,
        left,
        right,
        isRaw: isRaw,
      );

  factory LuaInvocation.equal(
    LuaValue left,
    LuaValue right, {
    bool isRaw = false,
  }) =>
      LuaBinaryInvocation(
        LuaOperator.equal,
        left,
        right,
        isRaw: isRaw,
      );

  final List<LuaValue> arguments;
  final bool isRaw;
}

final class LuaFunctionInvocation extends LuaInvocation {
  LuaFunctionInvocation({
    required this.name,
    required super.arguments,
    super.isRaw = false,
  });

  final String name;
}

final class LuaMethodInvocation extends LuaInvocation {
  LuaMethodInvocation({
    required this.target,
    required this.name,
    required super.arguments,
    super.isRaw = false,
  });

  final LuaTable target;
  final String name;
}

final class LuaValueInvocation extends LuaInvocation {
  LuaValueInvocation({
    required this.target,
    required super.arguments,
    super.isRaw = false,
  });

  final LuaValue target;
}

final class LuaBinaryInvocation extends LuaInvocation {
  LuaBinaryInvocation(
    this.operator,
    LuaValue left,
    LuaValue right, {
    super.isRaw = false,
  }) : super(arguments: [left, right]);

  final LuaOperator operator;
}

final class LuaUnaryInvocation extends LuaInvocation {
  LuaUnaryInvocation(
    this.operator,
    LuaValue value, {
    super.isRaw = false,
  }) : super(arguments: [value]);

  final LuaOperator operator;
}
