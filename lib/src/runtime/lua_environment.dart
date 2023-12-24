import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LuaEnvironment {
  @protected
  LuaEnvironment({LuaTable? variables}) {
    this.variables = variables ?? LuaTable();
  }

  late final LuaTable variables;

  final Map<dynamic, Map<String, dynamic>> _userDatas = {};

  LuaTable? _stringMetatable;

  LuaValue? getMetatable(LuaValue value, {bool isRaw = false}) {
    LuaTable? meta;

    if (value is LuaTable) {
      meta = value.metatable;
    } else if (value is LuaString) {
      meta = _stringMetatable;
    }

    if (meta != null) {
      if (isRaw) {
        return meta;
      } else {
        return meta.stringKeyGet(LuaMetamethodNames.metatable) ?? meta;
      }
    } else {
      return null;
    }
  }

  bool setMetatable(LuaValue value, LuaTable? metatable) {
    if (value is LuaTable) {
      if (value.metatable?.stringKeyGet(LuaMetamethodNames.metatable) != null) {
        return false;
      }
      value.metatable = metatable;
    }

    return true;
  }

  void removeMetatable(LuaValue value) {
    if (value is LuaTable) {
      value.metatable = null;
    }
  }

  LuaValue? getMetafield(LuaTable table, String name) {
    final meta = getMetatable(table);
    if (meta == null) {
      return null;
    } else if (meta is LuaTable) {
      return meta.stringKeyGet(name);
    } else {
      return null;
    }
  }

  dynamic getUserData(dynamic userKey, String key) => _userDatas[userKey]?[key];

  void setUserData(dynamic userKey, String key, dynamic value) =>
      _userDatas.putIfAbsent(userKey, () => {})[key] = value;
}
