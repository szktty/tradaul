import 'dart:io';

// TODO: replace IO operations with context.fileSystem

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/file.dart';

typedef LuaModuleSearcher = Result<LuaModuleLoader, String> Function(
  LuaContext context,
  String name,
);

final class LuaModuleLoader {
  LuaModuleLoader(this.module, this.argument);

  final LuaModule module;
  final LuaValue? argument;

  Future<LuaValueResult> load(LuaContext context) async {
    return module.load(context, argument);
  }
}

class LuaSearchPath {
  LuaSearchPath(this.paths);

  LuaSearchPath.of(LuaSearchPath path) : paths = List.of(path.paths);

  LuaSearchPath.fromString(String line) : paths = line.split(templateSeparator);

  LuaSearchPath.fromList(List<String> paths) : paths = List.of(paths);

  static String get directorySeparator => Platform.isWindows ? r'\' : '/';

  static const templateSeparator = ';';

  static const substitutionPoint = '?';

  static const executeDirectoryPlaceHolder = '!';

  static const luaopenIgnoreMark = '-';

  static const defaultNameSeparator = '.';

  final List<String> paths;

  String get luaToString => paths.join(templateSeparator);

  List<String> substitutePoint(
    String name, {
    String? separator,
    String? replacement,
  }) {
    final name1 = name.replaceAll(
      separator ?? defaultNameSeparator,
      replacement ?? directorySeparator,
    );
    return paths
        .map((path) => path.replaceAll(substitutionPoint, name1))
        .toList();
  }
}

abstract class LuaModule {
  String get name;

  Future<LuaValueResult> load(LuaContext context, LuaValue? argument);
}

final class LuaFileModule extends LuaModule {
  LuaFileModule({
    required this.name,
    required this.path,
  });

  @override
  final String name;

  final String path;

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    final file = File(path);
    if (!file.existsSync()) {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'file not found: $path',
        ),
      );
    }

    final source = file.readAsStringSync();
    final compilerResult = context.compile(source, path: path);
    if (compilerResult!.isError()) {
      final message = compilerResult.exceptionOrNull()!.toDisplayString();
      return Failure(LuaException(LuaExceptionType.runtimeError, message));
    }

    final code = compilerResult.getOrThrow();
    final closure = LuaClosure(code: code.chunk, upvalueStacks: []);
    final execResult = await context.executeClosure(closure, path: path);
    if (execResult.isSuccess()) {
      final value = execResult.getOrThrow().firstOrNull ?? LuaNil();
      return Success(value);
    } else {
      final error = execResult.exceptionOrNull()!.toDisplayString();
      return Failure(LuaException(LuaExceptionType.runtimeError, error));
    }
  }
}

class LuaNativeModule extends LuaModule {
  LuaNativeModule({
    required this.name,
  });

  @override
  final String name;

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    throw UnimplementedError('onLoad is not implemented');
  }
}

final class LuaCustomModule extends LuaModule {
  LuaCustomModule(this.name, this.loader);

  @override
  final String name;

  final LuaValue loader;

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    // TODO: use loader
    throw UnimplementedError('onLoad is not implemented');
  }
}

abstract class LuaModuleSearchers {
  static Result<LuaModuleLoader, String> _fileSearcher(
    String name,
    LuaSearchPath searchPath,
    LuaModuleLoader Function(String path) creator,
  ) {
    final candidates = searchPath.substitutePoint(name);
    final found = candidates.firstWhereOrNull(FileUtils.exists);
    if (found != null) {
      return Success(creator(found));
    } else {
      return Failure('module not found: $name');
    }
  }

  static Result<LuaModuleLoader, String> system(
    LuaContext context,
    String name,
  ) =>
      _fileSearcher(
        name,
        context.moduleManager.systemSearchPath,
        (path) => LuaModuleLoader(
          LuaFileModule(name: name, path: path),
          LuaString(path),
        ),
      );

  static Result<LuaModuleLoader, String> preload(
    LuaContext context,
    String name,
  ) {
    final loader = context.moduleManager.preloadLoaders.stringKeyGet(name);
    if (loader != null) {
      return Success(
        LuaModuleLoader(LuaCustomModule(name, loader), LuaString(name)),
      );
    } else {
      return Failure('module not found: $name');
    }
  }

  static Result<LuaModuleLoader, String> user(
    LuaContext context,
    String name,
  ) =>
      _fileSearcher(
        name,
        context.moduleManager.userSearchPath,
        (path) => LuaModuleLoader(
          LuaFileModule(name: name, path: path),
          LuaString(path),
        ),
      );
}

final class LuaModuleManager {
  @protected
  LuaModuleManager(this.context) {
    _systemSearchPath =
        LuaSearchPath.fromList(context.options.systemModuleSearchPath);
    userSearchPath =
        LuaSearchPath.fromList(context.options.userModuleSearchPath);
    _preloadLoaders =
        LuaTable.of(context.options.preloadModuleLoaders ?? LuaTable());
    _loaders = List.of(context.options.moduleLoaders);
  }

  final LuaContext context;

  final List<LuaModule> _modules = [];

  List<LuaModule> get modules => List.of(_modules);

  final Map<LuaModule, LuaValue> _loadedModules = {};

  Map<LuaModule, LuaValue> get loadedModules => Map.of(_loadedModules);

  late final LuaSearchPath _systemSearchPath;

  LuaSearchPath get systemSearchPath => LuaSearchPath.of(_systemSearchPath);

  late final LuaSearchPath userSearchPath;

  late final LuaTable _preloadLoaders;

  LuaTable get preloadLoaders {
    return LuaTable.of(_preloadLoaders)
      ..onSet = (key, value) => _preloadLoaders.set(key, value);
  }

  late final List<LuaModuleLoader> _loaders;

  List<LuaModuleLoader> get loaders => List.of(_loaders);

  void addLoader(LuaModuleLoader loader) {
    _loaders.add(loader);
  }

  void removeLoader(LuaModuleLoader loader) {
    _loaders.remove(loader);
  }

  void register(LuaModule module) {
    _modules.add(module);
  }

  bool isModuleLoaded(String name) {
    return _loadedModules.keys.any((module) => module.name == name);
  }

  final List<String> _importing = [];

  Future<LuaCallResult> import(String name) async {
    // check cyclic reference
    if (_importing.contains(name)) {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'cyclic reference: $name',
        ),
      );
    }
    _importing.add(name);

    // check cache
    final cache =
        _loadedModules.keys.firstWhereOrNull((module) => module.name == name);
    if (cache != null) {
      _importing.remove(name);
      return Success([_loadedModules[cache]!]);
    }

    // check registered (unloaded) modules
    final registered = _modules.firstWhereOrNull((e) => e.name == name);
    if (registered != null) {
      final loadResult = await registered.load(context, LuaString(name));
      _importing.remove(name);
      if (loadResult.isSuccess()) {
        _addLoaded(registered, loadResult.getOrThrow());
        return Success([loadResult.getOrThrow(), LuaString(name)]);
      } else {
        return Failure(loadResult.exceptionOrNull()!);
      }
    }

    // search and load
    const searchers = [
      LuaModuleSearchers.system,
      LuaModuleSearchers.preload,
      LuaModuleSearchers.user,
    ];
    LuaModuleLoader? loader;
    for (final searcher in searchers) {
      final result = searcher(context, name);
      if (result.isSuccess()) {
        loader = result.getOrThrow();
        break;
      }
    }

    if (loader != null) {
      final loadResult = await loader.load(context);
      _importing.remove(name);
      if (loadResult.isSuccess()) {
        final value = loadResult.getOrThrow();
        _addLoaded(loader.module, value);
        if (loader.argument != null) {
          return Success([value, loader.argument!]);
        } else {
          return Success([value]);
        }
      } else {
        return Failure(loadResult.exceptionOrNull()!);
      }
    } else {
      _importing.remove(name);
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'module not found: $name',
        ),
      );
    }
  }

  void _addLoaded(LuaModule module, LuaValue value) {
    _modules.remove(module);
    if (value.isNil && _loadedModules[module] == null) {
      _loadedModules[module] = LuaTrue();
    } else {
      _loadedModules[module] = value;
    }
  }
}
