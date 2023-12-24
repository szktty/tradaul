import 'dart:io';

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
        LuaBinding(
          onGet: () => Success(LuaBoolean.fromBool(Platform.isAndroid)),
        ),
      )
      ..bind(
        'isfuchsia',
        LuaBinding(
          onGet: () => Success(LuaBoolean.fromBool(Platform.isFuchsia)),
        ),
      )
      ..bind(
        'isios',
        LuaBinding(onGet: () => Success(LuaBoolean.fromBool(Platform.isIOS))),
      )
      ..bind(
        'islinux',
        LuaBinding(
          onGet: () => Success(LuaBoolean.fromBool(Platform.isLinux)),
        ),
      )
      ..bind(
        'ismac',
        LuaBinding(
          onGet: () => Success(LuaBoolean.fromBool(Platform.isMacOS)),
        ),
      )
      ..bind(
        'iswindows',
        LuaBinding(
          onGet: () => Success(LuaBoolean.fromBool(Platform.isWindows)),
        ),
      )
      ..bind(
        'os',
        LuaBinding(
          onGet: () {
            return Success(LuaString(Platform.operatingSystem));
          },
        ),
      )
      ..bind(
        'osversion',
        LuaBinding(
          onGet: () {
            return Success(LuaString(Platform.operatingSystemVersion));
          },
        ),
      )
      ..bind(
        'locale',
        LuaBinding(
          onGet: () {
            return Success(LuaString(Platform.localeName));
          },
        ),
      )
      ..bind(
        'host',
        LuaBinding(
          onGet: () {
            return Success(LuaString(Platform.localHostname));
          },
        ),
      )
      ..bind(
        'version',
        LuaBinding(
          onGet: () {
            return Success(LuaString(Platform.version));
          },
        ),
      )
      ..bind(
        'environment',
        LuaBinding(
          onGet: () {
            final table = LuaTable();
            Platform.environment.forEach((key, value) {
              table.stringKeySet(key, LuaString(value));
            });
            return Success(table);
          },
        ),
      );
    context.environment.variables.stringKeySet('platform', module);
    return Success(module);
  }
}
