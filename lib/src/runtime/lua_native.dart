import 'package:fixnum/fixnum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

typedef LuaNativeCall = Future<LuaCallResult?> Function(
  LuaContext context,
  LuaArguments arguments,
);

final class LuaArguments {
  @protected
  LuaArguments(this.arguments);

  final List<LuaValue> arguments;

  int get length => arguments.length;

  LuaValue? get receiver => arguments.firstOrNull;

  List<LuaValue> get methodArguments => arguments.skip(1).toList();

  LuaValueType? getType(int index) {
    if (index < 0 || index >= arguments.length) {
      return null;
    }
    return arguments[index].luaType;
  }

  String? getTypeName(int index) {
    return getType(index)?.name;
  }

  T? get<T extends LuaValue>(int index) {
    if (index < 0 || index >= arguments.length) {
      return null;
    }
    final value = arguments[index];
    if (value is T) {
      return value;
    } else {
      return null;
    }
  }

  Result<T, LuaValue>? getRawValue<T extends Object>(int index) {
    final value = get(index);
    if (value == null) {
      return null;
    } else if (T == bool && value is LuaBoolean) {
      return Success(value.rawValue as T);
    } else if (T == num && value is LuaNumber) {
      return Success(getNumber(index) as T);
    } else if (T == int && value is LuaInteger) {
      return Success(getInt(index)! as T);
    } else if (T == double && value is LuaFloat) {
      return Success(value.rawValue as T);
    } else if (T == String && value is LuaString) {
      return Success(value.rawValue as T);
    } else {
      return Failure(value);
    }
  }

  LuaValue getOrNil(int index) => get(index) ?? LuaNil();

  int? getInt(int index) {
    return get<LuaInteger>(index)?.value.toInt();
  }

  Result<Int64, LuaValue>? getIntegerRepresentation(int index) {
    final value = get(index);
    if (value == null) {
      return null;
    } else if (value is LuaNumber) {
      final integer = value.toIntegerRepresentation();
      return integer == null ? Failure(value) : Success(integer);
    } else if (value is LuaString) {
      final integer = NumberParser.parseInt64(value.value);
      return integer == null ? Failure(value) : Success(integer);
    } else {
      return Failure(value);
    }
  }

  dynamic getNumber(int index) {
    final value = get(index);
    if (value is LuaInteger) {
      return value.value;
    } else if (value is LuaFloat) {
      return value.value;
    } else if (value is LuaString) {
      return NumberParser.parseInt64(value.value) ??
          NumberParser.parseDouble(value.value);
    } else {
      return null;
    }
  }

  String? getString(int index) {
    return get<LuaString>(index)?.value;
  }

  Result<LuaTable, LuaValue>? getTable(int index) {
    final value = get(index);
    if (value == null) {
      return null;
    } else if (value is LuaTable) {
      return Success(value);
    } else {
      return Failure(value);
    }
  }
}

final class LuaNativeFunction extends LuaFunction {
  LuaNativeFunction(this.name, this.callback);

  final String? name;
  final LuaNativeCall callback;

  @override
  String toString() => 'LuaNativeFunction($name)';

  @override
  String get luaRepresentation => 'function: $name';

  @override
  bool luaEquals(LuaValue other) {
    return other is LuaNativeFunction && other.callback == callback;
  }

  @override
  int get luaHashCode => callback.hashCode;

  @override
  dynamic get rawValue => callback;

  Future<LuaCallResult> call(
    LuaContext context,
    List<LuaValue> arguments,
  ) async {
    return await callback(context, LuaArguments(arguments)) ??
        const Success([]);
  }
}
