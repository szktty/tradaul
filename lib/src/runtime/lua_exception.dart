import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tradaul/src/parser/ast.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

enum LuaExceptionType {
  parserError,
  compilerError,
  runtimeError,
  permissionError,
  fatalError,
  badArgument,
  notEnoughArguments,
  invalidIndex,
  nonCallable,
  userError,
  wrappedError,
}

extension LuaExceptionTypeExtension on LuaExceptionType {
  String get displayString {
    switch (this) {
      case LuaExceptionType.parserError:
        return 'parser error';
      case LuaExceptionType.compilerError:
        return 'compiler error';
      case LuaExceptionType.runtimeError:
        return 'runtime error';
      case LuaExceptionType.permissionError:
        return 'security error';
      case LuaExceptionType.fatalError:
        return 'fatal error';
      case LuaExceptionType.badArgument:
        return 'bad argument';
      case LuaExceptionType.notEnoughArguments:
        return 'not enough arguments';
      case LuaExceptionType.invalidIndex:
        return 'invalid index';
      case LuaExceptionType.nonCallable:
        return 'non callable';
      case LuaExceptionType.userError:
        return 'user error';
      case LuaExceptionType.wrappedError:
        return 'wrapped error';
    }
  }
}

final class LuaExceptionContext {
  @protected
  LuaExceptionContext(this.exception, [this.stackTrace]);

  final LuaException exception;
  final LuaStackTrace? stackTrace;

  LuaStackTraceEntry? get lastEntry => stackTrace?.entries.last;

  String toDisplayString() {
    String locationString(String? path, int? line) {
      final buffer = StringBuffer();
      if (path != null) {
        buffer.write(path);
      } else {
        buffer.write('<string>');
      }
      if (line != null) {
        buffer.write(': line $line');
      }
      return buffer.toString();
    }

    final buffer = StringBuffer();
    if (stackTrace != null && stackTrace!.entries.isNotEmpty) {
      final entries = stackTrace!.entries.reversed.toList();
      final first = entries.removeAt(0);
      final type = exception.type != LuaExceptionType.userError
          ? '${exception.type.displayString}: '
          : '';
      buffer.writeln(
        '${locationString(first.path, first.line)}: $type${exception.message}',
      );
      if (entries.isNotEmpty) {
        buffer.writeln('stack traceback:');
        for (final entry in entries) {
          buffer.writeln('  at ${locationString(entry.path, entry.line)}');
        }
      }
    } else {
      buffer.writeln('${exception.type.displayString}: ${exception.message}');
    }
    return buffer.toString();
  }
}

final class LuaException implements Exception {
  LuaException(
    this.type,
    this.message, {
    this.wrapped,
  });

  LuaException.wrap(Exception other)
      : this(
          LuaExceptionType.wrappedError,
          other.toString(),
          wrapped: other,
        );

  LuaException.parserError({
    required String message,
    LuaLocation? location,
  }) : this(
          LuaExceptionType.parserError,
          _messageWithLocation(message, location),
        );

  LuaException.compilerError({
    required String message,
    LuaLocation? location,
  }) : this(
          LuaExceptionType.compilerError,
          _messageWithLocation(message, location),
        );

  LuaException.badArgumentTypeError({
    required String function,
    required int order,
    required String expected,
    String? actual,
  }) : this(
            LuaExceptionType.badArgument,
            "bad argument #$order to '$function' "
            "($expected expected, got ${actual ?? 'no value'})");

  LuaException.badArgumentError({
    required String function,
    required int order,
    required String message,
  }) : this(
          LuaExceptionType.badArgument,
          "bad argument #$order to '$function' ($message)",
        );

  LuaException.wrongNumberOfArguments({
    required String function,
    required String expected,
  }) : this(
          LuaExceptionType.badArgument,
          "wrong number of arguments to '$function' ($expected expected)",
        );

  LuaException.noIntegerRepresentation({
    required String function,
    required int order,
  }) : this(
          LuaExceptionType.badArgument,
          "bad argument #$order to '$function' (number has no integer representation)",
        );

  LuaException.notEnoughArguments({
    required String function,
    required int expected,
    required int actual,
  }) : this(
          LuaExceptionType.notEnoughArguments,
          "not enough arguments '$function' ($expected expected, got $actual)",
        );

  LuaException.invalidComparison(LuaValueType a, LuaValueType b)
      : this(
          LuaExceptionType.badArgument,
          'attempt to compare ${a.name} with ${b.name}',
        );

  LuaException.invalidIndex({String? actual})
      : this(
          LuaExceptionType.invalidIndex,
          'attempt to call a ${actual ?? 'nil'} value',
        );

  LuaException.nonCallable({String? actual})
      : this(
          LuaExceptionType.nonCallable,
          'attempt to call a ${actual ?? 'nil'} value',
        );

  static String _messageWithLocation(String message, LuaLocation? location) {
    if (location != null) {
      return '$message at ${location.toDisplayString()}';
    } else {
      return message;
    }
  }

  final LuaExceptionType type;
  late final String message;
  final Exception? wrapped;

  @override
  String toString() {
    if (wrapped != null) {
      return '$type: $message ($wrapped{';
    } else {
      return '$type: $message';
    }
  }
}

final class LuaStackTrace {
  @protected
  LuaStackTrace(this.entries);

  final List<LuaStackTraceEntry> entries;

  Map<String, dynamic> toMap() {
    return {
      'entries': entries.map((entry) => entry.toMap()).toList(),
    };
  }
}

final class LuaStackTraceEntry {
  @protected
  LuaStackTraceEntry({
    this.path,
    this.line,
  });

  final String? path;
  final int? line;

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'line': line,
    };
  }
}
