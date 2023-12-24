import 'dart:async';
import 'dart:math';

import 'package:file/file.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/compiler/compiler.dart';
import 'package:tradaul/src/lua_lib/lua_init.dart';
import 'package:tradaul/src/parser/parser.dart';
import 'package:tradaul/src/runtime/compiled_code.dart';
import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_environment.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_invocation.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_stats.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';
import 'package:tradaul/src/runtime/thread.dart';
import 'package:tradaul/src/utils/log.dart';

typedef LuaExecutionResult = Result<List<LuaValue>, LuaExceptionContext>;
typedef LuaCallResult = Result<List<LuaValue>, LuaException>;
typedef LuaValueResult = Result<LuaValue, LuaException>;

extension ResultLuaValueExtension on Result<List<LuaValue>, LuaException> {
  LuaValueResult toLuaValueResult() {
    if (isSuccess()) {
      return Success(getOrThrow().first);
    } else {
      return Failure(exceptionOrNull()!);
    }
  }
}

extension ResultLuaCallExtension on Result<LuaValue, LuaException> {
  LuaCallResult toLuaCallResult() {
    if (isSuccess()) {
      return Success([getOrThrow()]);
    } else {
      return Failure(exceptionOrNull()!);
    }
  }
}

/// Lua execution environment
final class LuaContext {
  LuaContext._({
    String? name,
    LuaContextOptions? options,
  }) {
    this.name = name ?? Random().nextInt(1000000).toString();
    this.options = options?.copyWith() ?? const LuaContextOptions();
    system = options?.system ?? LuaSystem.shared;
    fileSystem = options?.fileSystem ?? system.createFileSystem();
    moduleManager = LuaModuleManager(this);
  }

  static Future<LuaContext> create({
    String? name,
    LuaContextOptions? options,
  }) async {
    final context = LuaContext._(name: name, options: options);
    await context._install();
    return context;
  }

  Future<void> _install() async {
    await LuaLibraryInstaller.run(this);
  }

  static const thisVersion = '2023.1.0';
  static const luaVersion = '5.4';

  late String name;

  late final LuaContextOptions options;

  late final LuaSystem system;

  late final FileSystem fileSystem;

  final LuaStatistics statistics = LuaStatistics();

  final List<Thread> _threads = [];

  final LuaEnvironment environment = LuaEnvironment();

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  late final List<Coroutine> _runningCoroutines = [];

  Future<LuaExecutionResult> execute(
    String source, {
    String? path,
    (List<String>, List<String>)? arguments,
  }) async {
    if (_isRunning) {
      return Failure(
        LuaExceptionContext(
          LuaException(
            LuaExceptionType.runtimeError,
            'LuaContext is already running',
          ),
        ),
      );
    }

    _isRunning = true;

    final path1 = path ?? '<chunk>';
    final compilerResult = compile(source, path: path1);
    if (compilerResult == null) {
      return const Success([]);
    } else if (compilerResult.isError()) {
      return Failure(compilerResult.exceptionOrNull()!);
    }

    final code = compilerResult.getOrThrow();
    final closure = LuaClosure(code: code.chunk, upvalueStacks: []);
    final execResult =
        await executeClosure(closure, path: path1, arguments: arguments);
    _isRunning = false;
    return execResult;
  }

  void _setArguments(List<String> before, List<String> after) {
    final argTable = LuaTable();
    for (var i = 0; i < before.length; i++) {
      argTable.set(LuaInteger.fromInt(i - before.length), LuaString(before[i]));
    }
    for (var i = 0; i < after.length; i++) {
      argTable.set(LuaInteger.fromInt(i), LuaString(after[i]));
    }
    environment.variables.stringKeySet('arg', argTable);
  }

  // TODO: implement
  Future<void> stop() async {
    throw UnimplementedError();
  }

  LuaException? _validateExecutable() {
    if (!_isRunning || mainCoroutine == null) {
      return LuaException(
        LuaExceptionType.runtimeError,
        'LuaContext is not running',
      );
    } else if (mainCoroutine is! CompiledCoroutine) {
      return LuaException(
        LuaExceptionType.runtimeError,
        'attempt to invoke on out of main coroutine',
      );
    } else {
      return null;
    }
  }

  Future<LuaCallResult> invoke(LuaInvocation invocation) async {
    final exec = _validateExecutable();
    if (exec != null) {
      return Failure(exec);
    }

    final coroutine = mainCoroutine! as CompiledCoroutine;
    return coroutine.context!.invokeWithInvocation(invocation);
  }

  // returns null if the metamethod does not exist
  Future<LuaCallResult?> invokeMetamethod({
    required LuaTable target,
    required String name,
    required List<LuaValue> arguments,
  }) async {
    final exec = _validateExecutable();
    if (exec != null) {
      return Failure(exec);
    }

    final coroutine = mainCoroutine! as CompiledCoroutine;
    return coroutine.context!.invokeMetamethod(
      target: target,
      name: name,
      arguments: arguments,
    );
  }

  late final LuaModuleManager moduleManager;

  LuaException denyPermission(String message) {
    switch (options.permissionWarning) {
      case LuaPermissionWarning.error:
        throw LuaException(
          LuaExceptionType.permissionError,
          message,
        );
      case LuaPermissionWarning.warn:
      // TODO: implement
      // print('permission denied: $message');
      case LuaPermissionWarning.ignore:
        // do nothing
        break;
    }

    return LuaException(LuaExceptionType.permissionError, message);
  }
}

extension LuaContextInternal on LuaContext {
  Thread? get mainThread => _threads.firstOrNull;

  List<Thread> get threads => _threads;

  List<Coroutine> get runningCoroutines => _runningCoroutines;

  Coroutine? get runningCoroutine => _runningCoroutines.lastOrNull;

  Coroutine? get mainCoroutine => _runningCoroutines.firstOrNull;

  Thread createThread({String? name, Thread? parent}) {
    final thread = Thread(luaContext: this, name: name, parent: parent);
    _threads.add(thread);
    return thread;
  }

  void removeThread(Thread thread) {
    _threads.remove(thread);
  }

  Result<LuaCompiledCode, LuaExceptionContext>? compile(
    String source, {
    required String path,
  }) {
    final parser = LuaParser(path: path, input: source);
    final parserResult =
        parser.parse(debug: options.logLevel == LuaLogLevel.debug);
    if (!parserResult.isSuccess()) {
      final parserError = parserResult.exceptionOrNull()!;
      return Failure(
        LuaExceptionContext(
          LuaException.parserError(
            message: parserError.message,
          ),
        ),
      );
    }

    if (options.checkSyntaxOnly) {
      return null;
    }

    final chunk = parserResult.getOrThrow();
    final compiler = LuaCompiler(path: path);
    final compilerResult = compiler.compileChunk(chunk);
    if (compilerResult.isError()) {
      final compilerError = compilerResult.exceptionOrNull()!;
      return Failure(
        LuaExceptionContext(
          LuaException.compilerError(
            message: compilerError.message,
          ),
        ),
      );
    }

    return Success(compilerResult.getOrThrow());
  }

  LuaException? beginExecute(Coroutine coroutine) {
    if (_runningCoroutines.contains(coroutine)) {
      return LuaException(
        LuaExceptionType.runtimeError,
        'coroutine is already running',
      );
    }
    _runningCoroutines.add(coroutine);
    return null;
  }

  void endExecute() {
    _runningCoroutines.removeLast();
  }

  Future<LuaExecutionResult> executeClosure(
    LuaClosure closure, {
    required String path,
    (List<String>, List<String>)? arguments,
  }) async {
    final thread = createThread(name: name);
    final coroutine = CompiledCoroutine(
      thread,
      closure.code,
      environment: closure.environment ?? environment,
    );
    if (arguments != null) {
      _setArguments(arguments.$1, arguments.$2);
    }
    final result = await coroutine.resume(const []);
    if (result.isSuccess()) {
      return Success(result.getOrThrow());
    } else {
      final error = result.exceptionOrNull();
      final trace = coroutine.context?.trace();
      return Failure(LuaExceptionContext(error!, trace));
    }
  }
}
