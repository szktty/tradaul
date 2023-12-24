import 'package:fixnum/fixnum.dart';

enum LuaValueType {
  nil,
  boolean,
  number,
  string,
  table,
  function,
  thread,
  userdata;

  String get name {
    switch (this) {
      case LuaValueType.nil:
        return 'nil';
      case LuaValueType.boolean:
        return 'boolean';
      case LuaValueType.number:
        return 'number';
      case LuaValueType.string:
        return 'string';
      case LuaValueType.table:
        return 'table';
      case LuaValueType.function:
        return 'function';
      case LuaValueType.thread:
        return 'thread';
      case LuaValueType.userdata:
        return 'userdata';
    }
  }
}

abstract class LuaValue {
  bool get isNil => luaType == LuaValueType.nil;

  bool get isTrue => this is LuaTrue;

  bool get isFalse => this is LuaFalse;

  bool get isBoolean => luaType == LuaValueType.boolean;

  bool get isNumber => isInteger || isFloat;

  bool get isInteger => false;

  bool get isFloat => false;

  bool get isString => luaType == LuaValueType.string;

  bool get isTable => luaType == LuaValueType.table;

  bool get isFunction => luaType == LuaValueType.function;

  bool get isThread => luaType == LuaValueType.thread;

  bool get isUserData => luaType == LuaValueType.userdata;

  LuaValueType get luaType;

  String get luaRepresentation => toString();

  String luaToString() => luaRepresentation;

  /// string for display in output (e.g. `print`)
  /// in string type, returns unquoted string
  String luaToDisplayString() => luaToString();

  bool luaEquals(LuaValue other);

  int get luaHashCode;

  bool get luaToBoolean => true;

  dynamic get rawValue;
}

final class LuaNil extends LuaValue {
  factory LuaNil() {
    return _instance;
  }

  LuaNil._();

  static final LuaNil _instance = LuaNil._();

  @override
  LuaValueType get luaType => LuaValueType.nil;

  @override
  String toString() {
    return '#nil';
  }

  @override
  String get luaRepresentation => 'nil';

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaNil;
  }

  @override
  int get luaHashCode => -1;

  @override
  bool get luaToBoolean => false;

  @override
  dynamic get rawValue => null;
}

abstract class LuaBoolean extends LuaValue {
  // ignore: avoid_positional_boolean_parameters
  static LuaBoolean fromBool(bool value) {
    return value ? LuaTrue() : LuaFalse();
  }

  bool get value;

  @override
  String toString() {
    return '#$value';
  }

  @override
  LuaValueType get luaType => LuaValueType.boolean;

  @override
  String get luaRepresentation => value ? 'true' : 'false';

  @override
  bool get luaToBoolean => value;

  @override
  dynamic get rawValue => value;
}

final class LuaTrue extends LuaBoolean {
  factory LuaTrue() {
    return _instance;
  }

  LuaTrue._();

  static final _instance = LuaTrue._();

  @override
  bool get value => true;

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaTrue;
  }

  @override
  int get luaHashCode => -2;
}

final class LuaFalse extends LuaBoolean {
  factory LuaFalse() {
    return _instance;
  }

  LuaFalse._();

  static final _instance = LuaFalse._();

  @override
  bool get value => false;

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaFalse;
  }

  @override
  int get luaHashCode => -3;
}

abstract class LuaNumber extends LuaValue {
  static LuaNumber fromNum(dynamic value) {
    if (value is int) {
      return LuaInteger.fromInt(value);
    } else if (value is Int64) {
      return LuaInteger(value);
    } else if (value is double) {
      return LuaFloat(value);
    } else {
      throw ArgumentError('value must be int, Int64 or double');
    }
  }

  @override
  LuaValueType get luaType => LuaValueType.number;

  double toDouble() => throw UnimplementedError('toDouble of $runtimeType');

  Int64? toIntegerRepresentation() => null;
}

final class LuaInteger extends LuaNumber {
  LuaInteger(this.value);

  LuaInteger.fromInt(int value) : value = Int64(value);

  static const Int64 max = Int64.MAX_VALUE;
  static const Int64 min = Int64.MIN_VALUE;

  final Int64 value;

  @override
  bool get isInteger => true;

  @override
  bool luaEquals(LuaValue other) {
    if (this == other) {
      return true;
    } else if (other is LuaInteger) {
      return other.value == value;
    } else if (other is LuaFloat) {
      return other.value == value.toDouble();
    } else {
      return false;
    }
  }

  @override
  int get luaHashCode => value.hashCode;

  @override
  String toString() {
    return '#$value';
  }

  @override
  String get luaRepresentation => value.toString();

  @override
  dynamic get rawValue => value;

  @override
  double toDouble() => value.toDouble();

  @override
  Int64? toIntegerRepresentation() => value;
}

final class LuaFloat extends LuaNumber {
  factory LuaFloat(double value) {
    if (value.isNaN) {
      return nan;
    } else {
      return LuaFloat._(value);
    }
  }

  LuaFloat._(this.value);

  static final nan = LuaFloat._(double.nan);

  static final infinity = LuaFloat._(double.infinity);

  static final negativeInfinity = LuaFloat._(double.negativeInfinity);

  static LuaFloat infinityOfSign(double sign) {
    if (sign > 0) {
      return infinity;
    } else if (sign < 0) {
      return negativeInfinity;
    } else if (sign.isNaN) {
      return nan;
    } else {
      throw ArgumentError('sign must be non-zero');
    }
  }

  final double value;

  @override
  bool get isFloat => true;

  bool get isNaN => value.isNaN;

  @override
  bool luaEquals(LuaValue other) {
    if (this == nan) {
      return false;
    } else if (this == other) {
      return true;
    } else if (other is LuaInteger) {
      return other.value.toDouble() == value;
    } else if (other is LuaFloat) {
      return other.value == value;
    } else {
      return false;
    }
  }

  @override
  int get luaHashCode => value.hashCode;

  @override
  String toString() {
    return '#$value';
  }

  @override
  String get luaRepresentation => this == nan ? 'nan' : value.toString();

  @override
  dynamic get rawValue => value;

  @override
  double toDouble() => value;

  @override
  Int64? toIntegerRepresentation() {
    if (value.isNaN) {
      return null;
    } else if (value == value.toInt()) {
      return Int64(value.toInt());
    } else {
      return null;
    }
  }
}

final class LuaString extends LuaValue {
  LuaString(this.value);

  final String value;

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaString && other.value == value;
  }

  @override
  int get luaHashCode => value.hashCode;

  @override
  String toString() {
    return '#$value';
  }

  @override
  String get luaRepresentation {
    final buffer = StringBuffer('"');
    for (var i = 0; i < value.length; i++) {
      final c = value[i];
      switch (c) {
        case '\x07':
          buffer.write('\\\x07');
        case '\b':
          buffer.write('\\\b');
        case '\f':
          buffer.write('\\\f');
        case '\n':
          buffer.write('\\\n');
        case '\r':
          buffer.write('\\\r');
        case '\t':
          buffer.write('\\\t');
        case '\v':
          buffer.write('\\\v');
        case '"':
          buffer.write(r'\"');
        case r'\':
          buffer.write(r'\\');
        default:
          buffer.write(c);
      }
    }
    buffer.write('"');
    return buffer.toString();
  }

  @override
  String luaToString() => value;

  @override
  String luaToDisplayString() => value;

  @override
  LuaValueType get luaType => LuaValueType.string;

  @override
  dynamic get rawValue => value;

  int get length => value.length;
}

abstract class LuaFunction extends LuaValue {
  @override
  LuaValueType get luaType => LuaValueType.function;
}

final class LuaCustomValue<Value> extends LuaValue {
  LuaCustomValue(
    this.value, {
    LuaValueType? type,
    String Function(Value)? onLuaToString,
  }) {
    _type = type ?? LuaValueType.userdata;
    _onLuaToString = onLuaToString;
  }

  final Value value;

  late final LuaValueType _type;

  @override
  LuaValueType get luaType => _type;

  late final String Function(Value)? _onLuaToString;

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaCustomValue && rawValue == other.rawValue;
  }

  @override
  int get luaHashCode => value.hashCode;

  @override
  dynamic get rawValue => value;

  @override
  String toString() {
    return '#<${value.runtimeType} $hashCode>';
  }

  @override
  String get luaRepresentation => '${_type.name} $hashCode';

  @override
  String luaToString() {
    if (_onLuaToString != null) {
      return _onLuaToString!(value);
    } else {
      return luaRepresentation;
    }
  }
}
