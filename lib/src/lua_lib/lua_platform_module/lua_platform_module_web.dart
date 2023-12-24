import 'dart:html';

import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LuaPlatformModule extends LuaNativeModule {
  LuaPlatformModule() : super(name: 'platform');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.platform) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..bind(
        'isandroid',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'isfuchsia',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'isios',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'islinux',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'ismac',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'iswindows',
        LuaBinding(onGet: () => Success(LuaFalse())),
      )
      ..bind(
        'isweb',
        LuaBinding(onGet: () => Success(LuaTrue())),
      )
      ..bind(
        'useragent',
        LuaBinding(onGet: () => Success(LuaString(window.navigator.userAgent))),
      )
      ..bind(
        'os',
        LuaBinding(onGet: () => Success(LuaNil())),
      )
      ..bind(
        'osversion',
        LuaBinding(onGet: () => Success(LuaNil())),
      )
      ..bind(
        'locale',
        LuaBinding(onGet: () => Success(LuaNil())),
      )
      ..bind(
        'host',
        LuaBinding(onGet: () => Success(LuaNil())),
      )
      ..bind(
        'version',
        LuaBinding(onGet: () => Success(LuaNil())),
      )
      ..bind(
        'environment',
        LuaBinding(onGet: () => Success(LuaNil())),
      );
    context.environment.variables.stringKeySet('platform', module);
    return Success(module);
  }
}
