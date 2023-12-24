import 'package:tradaul/src/compiler/number_parser.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

enum LuaComparisonType {
  eq,
  neq,
  lt,
  le,
  gt,
  ge,
}

final class LuaComparator {
  LuaComparator(this.a, this.b);

  final LuaValue a;
  final LuaValue b;

  bool compare(LuaComparisonType type) {
    if ((a is LuaFloat && (a as LuaFloat).value.isNaN) ||
        (b is LuaFloat && (b as LuaFloat).value.isNaN)) {
      return false;
    }

    switch (type) {
      case LuaComparisonType.eq:
        return a.luaEquals(b);
      case LuaComparisonType.neq:
        return !a.luaEquals(b);
      case LuaComparisonType.lt:
        if (a is LuaInteger && b is LuaInteger) {
          return (a as LuaInteger).value < (b as LuaInteger).value;
        } else if (a is LuaInteger && b is LuaFloat) {
          return (a as LuaInteger).value.toDouble() < (b as LuaFloat).value;
        } else if (a is LuaFloat && b is LuaInteger) {
          return (a as LuaFloat).value < (b as LuaInteger).value.toDouble();
        } else if (a is LuaInteger && b is LuaString) {
          final bInt = NumberParser.parseInt64((b as LuaString).value);
          if (bInt != null) {
            return (a as LuaInteger).value < bInt;
          } else {
            throw LuaException.invalidComparison(a.luaType, b.luaType);
          }
        } else if (a is LuaString && b is LuaInteger) {
          final aInt = NumberParser.parseInt64((a as LuaString).value);
          if (aInt != null) {
            return (b as LuaInteger).value < aInt;
          } else {
            throw LuaException.invalidComparison(a.luaType, b.luaType);
          }
        } else if (a is LuaFloat && b is LuaFloat) {
          return (a as LuaFloat).value < (b as LuaFloat).value;
        } else if (a is LuaFloat && b is LuaString) {
          final bDouble = NumberParser.parseDouble((b as LuaString).value);
          if (bDouble != null) {
            return (a as LuaFloat).value < bDouble;
          } else {
            throw LuaException.invalidComparison(a.luaType, b.luaType);
          }
        } else if (a is LuaString && b is LuaFloat) {
          final aDouble = NumberParser.parseDouble((a as LuaString).value);
          if (aDouble != null) {
            return (b as LuaFloat).value < aDouble;
          } else {
            throw LuaException.invalidComparison(a.luaType, b.luaType);
          }
        } else if (a is LuaString && b is LuaString) {
          return (a as LuaString).value.compareTo((b as LuaString).value) < 0;
        } else {
          throw LuaException.invalidComparison(a.luaType, b.luaType);
        }
      case LuaComparisonType.le:
        return compare(LuaComparisonType.lt) || compare(LuaComparisonType.eq);
      case LuaComparisonType.gt:
        return !compare(LuaComparisonType.le);
      case LuaComparisonType.ge:
        return !compare(LuaComparisonType.lt);
    }
  }
}
