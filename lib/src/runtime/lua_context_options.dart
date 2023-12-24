import 'package:file/file.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradaul/src/runtime/lua_environment.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_module_options.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/utils/log.dart';

part 'lua_context_options.freezed.dart';

@freezed
class LuaContextOptions with _$LuaContextOptions {
  const factory LuaContextOptions({
    @Default(false) bool debug,
    @Default(LuaLogLevel.error) LuaLogLevel logLevel,
    @Default(false) bool checkSyntaxOnly,
    @Default(LuaPermissions()) LuaPermissions permissions,
    @Default(LuaPermissionWarning.warn) LuaPermissionWarning permissionWarning,
    LuaEnvironment? environment,
    @Default([]) List<String> systemModuleSearchPath,
    LuaTable? preloadModuleLoaders,
    @Default([]) List<String> userModuleSearchPath,
    @Default([]) List<LuaModuleLoader> moduleLoaders,
    LuaSystem? system,
    FileSystem? fileSystem,
    LuaOsModuleOptions? osCallbacks,
    LuaIoModuleOptions? ioOptions,
  }) = _LuaContextOptions;

  const LuaContextOptions._();
}

enum LuaPermissionWarning {
  ignore,
  warn,
  error,
}

@freezed
class LuaPermissions with _$LuaPermissions {
  const factory LuaPermissions({
    @Default(true) bool module,
    @Default(true) bool environment,
    @Default(true) bool assertion,
    @Default(true) bool error,
    @Default(true) bool metatable,
    @Default(true) bool raw,
    @Default(true) bool process,
    @Default(true) bool platform,
    @Default(true) bool debug,
    @Default(true) bool print,
    @Default(true) bool io,
    @Default(true) bool os,
    @Default(true) bool stdio,
    @Default(true) bool overwrite,
    @Default(true) bool global,
    @Default(LuaLibraryPermissions()) LuaLibraryPermissions library,
  }) = _LuaPermissions;
}

@freezed
class LuaLibraryPermissions with _$LuaLibraryPermissions {
  const factory LuaLibraryPermissions({
    @Default(true) bool file,
    @Default(true) bool io,
    @Default(true) bool coroutine,
    @Default(true) bool os,
    @Default(true) bool package,
    @Default(true) bool math,
    @Default(true) bool table,
    @Default(true) bool string,
    @Default(true) bool utf8,
  }) = _LuaLibraryPermissions;
}
