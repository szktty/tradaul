import 'package:meta/meta.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/compiled_code.dart';
import 'package:tradaul/src/runtime/execution.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_environment.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_native.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class Thread {
  Thread({required this.luaContext, String? name, this.parent}) {
    this.name = name ?? 'thread: $hashCode';
  }

  final Thread? parent;
  final LuaContext luaContext;
  late final String name;

  bool get isMain => luaContext.mainThread == this;

  LuaException? beginExecute(Coroutine coroutine) {
    return luaContext.beginExecute(coroutine);
  }

  void endExecute() {
    luaContext.endExecute();
  }

  void finish() {
    luaContext.removeThread(this);
  }
}

enum LuaCoroutineState {
  running,
  suspended,
  normal,
  dead;

  String get luaName {
    switch (this) {
      case LuaCoroutineState.running:
        return 'running';
      case LuaCoroutineState.suspended:
        return 'suspended';
      case LuaCoroutineState.normal:
        return 'normal';
      case LuaCoroutineState.dead:
        return 'dead';
    }
  }
}

abstract class Coroutine {
  Thread get thread;

  LuaCoroutineState get state;

  Future<LuaCallResult> resume(List<LuaValue> values);
}

final class CompiledCoroutine extends Coroutine {
  CompiledCoroutine(this.thread, this.function, {this.environment});

  @override
  final Thread thread;

  final LuaCompiledFunction function;

  final LuaEnvironment? environment;

  CompiledExecutionContext? _context;

  CompiledExecutionContext? get context => _context;

  @override
  LuaCoroutineState get state {
    switch (_context?.state ?? ExecutionContextState.suspended) {
      case ExecutionContextState.completed:
        return LuaCoroutineState.dead;
      case ExecutionContextState.running:
        return LuaCoroutineState.running;
      case ExecutionContextState.suspended:
        return LuaCoroutineState.suspended;
    }
  }

  @override
  Future<LuaCallResult> resume(List<LuaValue> values) async {
    final error = thread.beginExecute(this);
    if (error != null) {
      return Failure(error);
    }

    LuaCallResult? result;
    if (_context == null) {
      _context = CompiledExecutionContext(
        coroutine: this,
        code: function,
        arguments: values,
        environment: environment ?? thread.luaContext.environment,
      );
      result = await _context!.resume(const []);
    } else {
      result = await _context!.resume(values);
    }
    thread.endExecute();
    return result;
  }

  Future<void> luaYield(List<LuaValue> values) async {
    if (_context == null) {
      throw LuaException(
        LuaExceptionType.runtimeError,
        'attempt to yield from outside a coroutine',
      );
    }
    await _context!.luaYield(values);
  }
}

final class CustomCoroutine extends Coroutine {
  CustomCoroutine(this.thread, this.callback);

  @override
  final Thread thread;

  LuaCustomCoroutineCallback? callback;

  @override
  LuaCoroutineState state = LuaCoroutineState.suspended;

  @override
  Future<LuaCallResult> resume(List<LuaValue> values) async {
    if (callback == null) {
      return Failure(
        LuaException(
          LuaExceptionType.runtimeError,
          'attempt to resume dead native coroutine',
        ),
      );
    }

    thread.luaContext.runningCoroutines.add(this);
    state = LuaCoroutineState.running;

    final result = await callback!(thread.luaContext, LuaArguments(values));
    var isDead = false;
    if (result.result.isError()) {
      state = LuaCoroutineState.dead;
      callback = null;
      isDead = true;
    } else if (result.isYielded) {
      state = LuaCoroutineState.suspended;
      callback = result.callback;
    } else {
      state = LuaCoroutineState.dead;
      callback = null;
      isDead = true;
    }

    if (isDead) {
      final last = thread.luaContext.runningCoroutines.removeLast();
      if (last != this) {
        return Failure(
          LuaException(
            LuaExceptionType.runtimeError,
            'invalid running coroutine is completed',
          ),
        );
      }
    }

    return result.result;
  }
}

abstract class LuaCoroutine extends LuaValue {
  LuaCoroutine();

  factory LuaCoroutine.custom(
    LuaContext context,
    LuaCustomCoroutineCallback callback,
  ) {
    return LuaCustomCoroutine(context, callback);
  }

  @override
  bool get isThread => true;

  @override
  bool luaEquals(LuaValue other) => this == other;

  @override
  int get luaHashCode => hashCode;

  @override
  String get luaRepresentation => 'thread: $hashCode';

  @override
  LuaValueType get luaType => LuaValueType.thread;

  Coroutine get _coroutine;

  Thread get _thread => _coroutine.thread;

  bool get inMainThread => _thread.isMain;

  LuaCoroutineState get state;

  Future<LuaCallResult> resume(List<LuaValue> values);
}

final class LuaCompiledCoroutine extends LuaCoroutine {
  LuaCompiledCoroutine(this._compiledCoroutine);

  final CompiledCoroutine _compiledCoroutine;

  @override
  Coroutine get _coroutine => _compiledCoroutine;

  @override
  LuaCoroutineState get state => _coroutine.state;

  @override
  Future<LuaCallResult> resume(List<LuaValue> values) async {
    return _coroutine.resume(values);
  }

  Future<void> luaYield(List<LuaValue> values) async {
    switch (state) {
      case LuaCoroutineState.suspended:
        throw LuaException(
          LuaExceptionType.runtimeError,
          'attempt to yield from suspended coroutine',
        );
      case LuaCoroutineState.normal:
        throw LuaException(
          LuaExceptionType.runtimeError,
          'attempt to yield from outside other running coroutine',
        );
      case LuaCoroutineState.dead:
        throw LuaException(
          LuaExceptionType.runtimeError,
          'attempt to yield from dead coroutine',
        );
      case LuaCoroutineState.running:
        await _compiledCoroutine.luaYield(values);
    }
  }

  @override
  dynamic get rawValue => this;
}

final class LuaCustomCoroutine extends LuaCoroutine {
  LuaCustomCoroutine(LuaContext context, LuaCustomCoroutineCallback callback) {
    _customCoroutine = CustomCoroutine(Thread(luaContext: context), callback);
  }

  late final CustomCoroutine _customCoroutine;

  @override
  Coroutine get _coroutine => _customCoroutine;

  @override
  LuaCoroutineState get state => _coroutine.state;

  @override
  Future<LuaCallResult> resume(List<LuaValue> values) async {
    return _coroutine.resume(values);
  }

  @override
  dynamic get rawValue => this;
}

typedef LuaCustomCoroutineCallback = Future<LuaCustomCoroutineResult> Function(
  LuaContext context,
  LuaArguments arguments,
);

final class LuaCustomCoroutineResult {
  @protected
  LuaCustomCoroutineResult(
    this.result, {
    required this.isYielded,
    this.callback,
  });

  LuaCustomCoroutineResult.success(List<LuaValue> values)
      : this(Success(values), isYielded: false);

  LuaCustomCoroutineResult.failure(LuaException exception)
      : this(Failure(exception), isYielded: false);

  LuaCustomCoroutineResult.luaYield(
    List<LuaValue> values,
    LuaCustomCoroutineCallback callback,
  ) : this(Success(values), isYielded: true, callback: callback);

  @protected
  final LuaCallResult result;

  @protected
  final bool isYielded;

  @protected
  final LuaCustomCoroutineCallback? callback;
}
