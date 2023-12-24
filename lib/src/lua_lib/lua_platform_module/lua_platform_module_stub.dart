import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LuaPlatformModule extends LuaNativeModule {
  LuaPlatformModule() : super(name: 'platform');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    return Success(LuaNil());
  }
}
