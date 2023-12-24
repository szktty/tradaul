import 'dart:io';

import 'package:collection/collection.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/utils/file.dart';

// TODO: replace IO operations with context.fileSystem
class LuaPackageModule extends LuaNativeModule {
  LuaPackageModule() : super(name: 'package');

  @override
  Future<LuaValueResult> load(LuaContext context, LuaValue? argument) async {
    if (!context.options.permissions.library.package) {
      return Success(LuaNil());
    }

    final module = LuaTable()
      ..bind('cpath', LuaBinding(onGet: () => Success(LuaString(''))))
      ..bind('config', LuaBinding(onGet: _luaConfigGet))
      ..bind(
        'path',
        LuaBinding(onGet: _luaPathGet(context), onSet: _luaPathSet(context)),
      )
      ..bind(
        'preload',
        LuaBinding(
          onGet: () => Success(context.moduleManager.preloadLoaders),
        ),
      )
      ..bind(
        'loaded',
        LuaBinding(
          onGet: () => Success(
            LuaTable.fromMap(
              context.moduleManager.loadedModules.map(
                (module, value) => MapEntry(LuaString(module.name), value),
              ),
            ),
          ),
        ),
      )
      ..bind(
        'searchers',
        LuaBinding(onGet: () => Success(_luaSearchers(context))),
      )
      ..addNativeCalls({
        'loadlib': _luaLoadlib,
        'searchpath': _luaSearchPath,
      });
    context.environment.variables.stringKeySet('package', module);
    return Success(module);
  }
}

Result<LuaValue, LuaException> _luaConfigGet() {
  return Success(
    LuaString(
      [
            LuaSearchPath.directorySeparator,
            LuaSearchPath.templateSeparator,
            LuaSearchPath.substitutionPoint,
            LuaSearchPath.executeDirectoryPlaceHolder,
            LuaSearchPath.luaopenIgnoreMark,
          ].join(Platform.lineTerminator) +
          Platform.lineTerminator,
    ),
  );
}

Result<LuaValue, LuaException> Function() _luaPathGet(LuaContext context) =>
    () => Success(LuaString(context.moduleManager.userSearchPath.luaToString));

LuaException? Function(LuaValue) _luaPathSet(LuaContext context) => (value) {
      if (value is! LuaString) {
        return null;
      }

      context.moduleManager.userSearchPath =
          LuaSearchPath.fromString(value.value);
      return null;
    };

Future<LuaCallResult> _luaLoadlib(
  LuaContext context,
  LuaArguments arguments,
) async {
  return Success([LuaNil()]);
}

LuaTable _luaSearchers(LuaContext context) {
  final table = LuaTable()
    ..add(_luaModuleSearcher('preload', LuaModuleSearchers.preload))
    ..add(_luaModuleSearcher('path', LuaModuleSearchers.user))
    ..add(LuaNativeFunction('cpath', _luaNoSearcher))
    ..add(LuaNativeFunction('allinone', _luaNoSearcher));
  return table;
}

Future<LuaCallResult> _luaNoSearcher(
  LuaContext context,
  LuaArguments arguments,
) async {
  return Success([LuaString('module not found')]);
}

LuaNativeFunction _luaModuleSearcher(String name, LuaModuleSearcher searcher) {
  Future<LuaCallResult> nativeCall(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    final name = arguments.getString(0);
    if (name == null) {
      return Success([LuaNil()]);
    }

    final result = searcher(context, name);
    if (result.isSuccess()) {
      final loader = result.getOrThrow();
      return Success([
        _luaModuleLoader('package.loader.$name', loader),
        loader.argument ?? LuaNil(),
      ]);
    } else {
      return Success([LuaString(result.exceptionOrNull()!)]);
    }
  }

  return LuaNativeFunction('package.searcher.$name', nativeCall);
}

LuaNativeFunction _luaModuleLoader(String name, LuaModuleLoader loader) {
  Future<LuaCallResult> nativeCall(
    LuaContext context,
    LuaArguments arguments,
  ) async {
    final result = await loader.load(context);
    if (result.isSuccess()) {
      return Success([result.getOrThrow()]);
    } else {
      return Success(
        [LuaNil(), LuaString(result.exceptionOrNull()!.toString())],
      );
    }
  }

  return LuaNativeFunction(name, nativeCall);
}

Future<LuaCallResult> _luaSearchPath(
  LuaContext context,
  LuaArguments arguments,
) async {
  final name = arguments.getString(0);
  if (name == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'searchpath',
        order: 1,
        expected: 'string',
        actual: arguments.getTypeName(0),
      ),
    );
  }

  final path = arguments.getString(1);
  if (path == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'searchpath',
        order: 2,
        expected: 'string',
        actual: arguments.getTypeName(1),
      ),
    );
  }

  final separator = arguments.getString(2);
  if (arguments.length >= 3 && separator == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'searchpath',
        order: 3,
        expected: 'string',
        actual: arguments.getTypeName(2),
      ),
    );
  }

  final replacement = arguments.getString(3);
  if (arguments.length >= 4 && replacement == null) {
    return Failure(
      LuaException.badArgumentTypeError(
        function: 'searchpath',
        order: 4,
        expected: 'string',
        actual: arguments.getTypeName(3),
      ),
    );
  }

  final searchPath = LuaSearchPath.fromString(path);
  final paths = searchPath.substitutePoint(
    name,
    separator: separator,
    replacement: replacement,
  );

  final buffer = StringBuffer();
  final found = paths.firstWhereOrNull((path) {
    if (FileUtils.exists(path)) {
      return true;
    } else {
      buffer.write('no file $path');
      return false;
    }
  });
  if (found != null) {
    return Success([LuaString(found)]);
  } else {
    return Success([LuaNil(), LuaString(buffer.toString())]);
  }
}
