import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';
import 'package:tradaul/src/runtime/lua_module.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system.dart';
import 'package:tradaul/src/runtime/lua_table.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class TestFailure extends Error {
  TestFailure(this.exception);

  final LuaException exception;
}

void Function(LuaContext)? _initContext;

void luaSetOnInitContext(void Function(LuaContext context) callback) {
  _initContext = callback;
}

Future<List<LuaValue>> luaExecute(
  String source, {
  LuaContextOptions? options,
  LuaSystem? system,
  void Function(LuaContext)? onInit,
}) async {
  final options1 = options ?? const LuaContextOptions(debug: true);
  final options2 = options1.copyWith(system: system);

  final context = await LuaContext.create(options: options2);
  _initContext?.call(context);
  onInit?.call(context);

  final result = await context.execute(source);
  if (result.isSuccess()) {
    return result.getOrThrow();
  } else {
    final excContext = result.exceptionOrNull()!;
    final exception = excContext.exception;
    throw exception;
    /*
    if (exception.type == LuaExceptionType.nonCallable ||
        exception.type == LuaExceptionType.invalidIndex) {
      throw TestFailure(exception);
    } else {
      throw exception;
    }
     */
  }
}

Matcher luaEquals(List<dynamic> expected) {
  final expected1 = expected.map(_toLuaValue).toList().cast<dynamic>();
  return _LuaEqualsMatcher(expected1);
}

dynamic _toLuaValue(dynamic e) {
  if (e == null) {
    return LuaNil();
  } else if (e is bool) {
    return e ? LuaTrue() : LuaFalse();
  } else if (e is int) {
    return LuaInteger.fromInt(e);
  } else if (e is Int64) {
    return LuaInteger(e);
  } else if (e is double) {
    return LuaFloat(e);
  } else if (e is String) {
    return LuaString(e);
  } else if (e is List) {
    return LuaTable.fromList(e.map(_toLuaValue).toList().cast());
  } else if (e is Map) {
    return LuaTable.fromMap(
      e.map((key, value) {
        return MapEntry(
          _toLuaValue(key) as LuaValue,
          _toLuaValue(value) as LuaValue,
        );
      }),
    );
  } else if (e is Set) {
    return LuaTable.fromSet(e.map(_toLuaValue).toSet().cast());
  } else {
    return e;
  }
}

Matcher luaIsA<T>() {
  return _LuaTypeMatcher<T>();
}

Matcher luaThrows(LuaExceptionType expectedType) {
  return throwsA(_LuaErrorMatcher(expectedType));
}

Matcher luaIsNaN() {
  return predicate((v) => (v! as LuaFloat).isNaN);
}

class _LuaEqualsMatcher extends Matcher {
  _LuaEqualsMatcher(this.expected) {
    for (final value in expected) {
      if (value == null) {
        throw ArgumentError(
          'expected must be a list of LuaValue or Matcher, but got null',
        );
      } else if (value is! LuaValue && value is! Matcher) {
        throw ArgumentError('expected must be a list of LuaValue or Matcher, '
            'but got ${value.runtimeType}');
      }
    }
  }

  late final List<dynamic> expected;

  @override
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    final actual1 = actual as List<LuaValue>;
    if (actual1.length != expected.length) {
      return false;
    }

    for (var i = 0; i < actual1.length; i++) {
      final v1 = actual1[i];
      final v2 = expected[i];
      if (v2 is Matcher) {
        return v2.matches(v1, matchState);
      } else if (v1 is LuaTable && v2 is LuaTable) {
        if (v1.simpleHashCode != v2.simpleHashCode) return false;
      } else if (!v1.luaEquals(v2 as LuaValue)) {
        return false;
      }
    }

    return true;
  }

  @override
  Description describe(Description description) {
    final s = expected.map((e) {
      if (e is Matcher) {
        return e.toString();
      } else {
        return (e as LuaValue).luaRepresentation;
      }
    }).join(', ');
    return description.add('[$s]');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    final s =
        (item as List<LuaValue>).map((e) => e.luaRepresentation).join(', ');
    return mismatchDescription.add('[$s]');
  }
}

class _LuaTypeMatcher<T> extends Matcher {
  @override
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    return actual is T;
  }

  @override
  Description describe(Description description) {
    return description.add('$T');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    final values = item as List<LuaValue>;
    return mismatchDescription.add('${values.firstOrNull?.runtimeType}');
  }
}

class _LuaErrorMatcher extends Matcher {
  _LuaErrorMatcher(this.expected);

  final LuaExceptionType expected;

  @override
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    if (actual is LuaException) {
      return actual.type == expected;
    } else {
      return false;
    }
  }

  @override
  Description describe(Description description) {
    return description.add('$expected');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return mismatchDescription.add('$item');
  }
}

String _toLua(dynamic v) {
  if (v == null) {
    return 'nil';
  } else if (v is String) {
    return '"$v"';
  } else if (v is List) {
    final elements = v.map(_toLua).join(', ');
    return '{${elements.isEmpty ? '' : elements}}';
  } else if (v is Map<dynamic, dynamic>) {
    final entries = v.entries
        .map((e) => '[${_toLua(e.key)}]=${_toLua(e.value)}')
        .join(', ');
    return '{${entries.isEmpty ? '' : entries}}';
  } else {
    return v.toString();
  }
}

void testUnaryOperator(
  String title,
  String operator,
  List<List<dynamic>> testCases,
) {
  group(title, () {
    for (final testCase in testCases) {
      final title = testCase[0];
      final a = _toLua(testCase[1]);
      final expected = testCase[2];

      test('$title: $operator $a', () async {
        expect(
          await luaExecute('return $operator $a'),
          luaEquals([expected]),
        );
      });
    }
  });
}

void testBinaryOperator(
  String title,
  String operator,
  List<List<dynamic>> testCases,
) {
  group(title, () {
    for (final testCase in testCases) {
      final title = testCase[0];
      final a = _toLua(testCase[1]);
      final b = _toLua(testCase[2]);
      final expected = testCase[3];

      test('$title: $a $operator $b', () async {
        expect(
          await luaExecute('return $a $operator $b'),
          luaEquals([expected]),
        );
      });
    }
  });
}

final testDir = path.join(
  Directory.current.path,
  'test',
  'execution',
);

final searchDir = path.join(
  testDir,
  'language',
  'lua_lib',
);

final searchPath = [
  path.join(searchDir, '?.lua'),
  path.join(searchDir, 'foo/?.lua'),
  path.join(searchDir, 'foo/bar/?.lua'),
  path.join(searchDir, 'foo/bar/baz/?.lua'),
];

final luaSearchPath = LuaSearchPath.fromList(searchPath);

final luaSearchPathString = luaSearchPath.luaToString;

const fooModuleValue = 'foo';
const fooBarModuleValue = 'bar';
const fooBarBazModuleValue = 'baz';

final tempDir = path.join(
  testDir,
  'temp',
);
