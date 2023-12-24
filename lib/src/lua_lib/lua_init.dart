import 'package:tradaul/src/lua_lib/lua_coroutine_module.dart';
import 'package:tradaul/src/lua_lib/lua_globals.dart';
import 'package:tradaul/src/lua_lib/lua_math_module.dart';
import 'package:tradaul/src/lua_lib/lua_package_module.dart';
import 'package:tradaul/src/lua_lib/lua_platform_module/lua_platform_module_stub.dart'
    if (dart.library.io) 'package:tradaul/src/lua_lib/lua_platform_module/lua_platform_module_native.dart'
    if (dart.library.html) 'package:tradaul/src/lua_lib/lua_platform_module/lua_platform_module_web.dart';
import 'package:tradaul/src/lua_lib/lua_string_module.dart';
import 'package:tradaul/src/lua_lib/lua_table_module.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_module.dart';

// ignore_for_file: one_member_abstracts

class LuaLibraryInstaller {
  static Future<void> run(LuaContext context) async {
    final modules = <LuaModule>[
      LuaGlobals(),
      LuaCoroutineModule(),
      LuaMathModule(),
      LuaPackageModule(),
      LuaStringModule(),
      LuaTableModule(),

      // library-specific modules
      LuaPlatformModule(),
    ];
    for (final module in modules) {
      context.moduleManager.register(module);
      await context.moduleManager.import(module.name);
    }
  }
}
