import 'package:fixnum/fixnum.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_context_options.dart';
import 'package:tradaul/src/runtime/lua_module_options.dart';

import '../language/test.dart';

void main() {
  group('os module', () {
    const mockClock = 123.456;
    const mockLocalDateTime = 1609459200;
    const mockLocalDateTimeFormat = '2023-01-01';
    const mockUtcDateTimeFormat = '2023-01-02';
    final mockLocalDateTimeDesc = LuaOsDateTime(year: 2023, month: 1, day: 1);
    final mockUtcDateTimeDesc = LuaOsDateTime(year: 2023, month: 1, day: 2);
    const mockEnvPath = '/usr/bin:/bin';
    const mockTemporaryName = 'tmpfile';
    final callbacks = LuaOsModuleOptions(
      clock: () async => const Success(mockClock),
      time: (LuaOsDateTime? localDateTime) async =>
          Success(Int64(mockLocalDateTime)),
      format: (
        String format,
        LuaOsDateTime dateTime, {
        required bool utc,
      }) async =>
          Success(
        utc
            ? (
                string: mockUtcDateTimeFormat,
                dateTime: mockUtcDateTimeDesc,
              )
            : (
                string: mockLocalDateTimeFormat,
                dateTime: mockLocalDateTimeDesc,
              ),
      ),
      timeDifference: (Int64 a, Int64 b) async => Success(a - b),
      getEnvironmentVariable: (String name) async => const Success(mockEnvPath),
      setLocale: (String locale, LuaLocaleCategory category) async =>
          Success(locale),
      exit: ({bool? status, int? code}) async => const Success(true),
      execute: (String command) async => const Success(
        LuaOsExecutionStatus(
          success: true,
          code: 0,
        ),
      ),
      temporaryFileName: () async => const Success(mockTemporaryName),
    );
    final options = LuaContextOptions(debug: true, osCallbacks: callbacks);

    test('os.clock', () async {
      const source = 'return os.clock()';
      expect(
        await luaExecute(source, options: options),
        luaEquals([mockClock]),
      );
    });

    group('os.date', () {
      test('local datetime', () async {
        const source = 'return os.date("%c")';
        expect(
          await luaExecute(source, options: options),
          luaEquals([mockLocalDateTimeFormat]),
        );
      });

      test('UTC datetime', () async {
        const source = 'return os.date("!%c")';
        expect(
          await luaExecute(source, options: options),
          luaEquals([mockUtcDateTimeFormat]),
        );
      });

      test('local datetime table', () async {
        const source = '''
          local t = os.date("*t")
          return t.day
          ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([mockLocalDateTimeDesc.day]),
        );
      });

      test('UTC datetime table', () async {
        const source = '''
          local t = os.date("!*t")
          return t.day
          ''';
        expect(
          await luaExecute(source, options: options),
          luaEquals([mockUtcDateTimeDesc.day]),
        );
      });

      test('invalid table specifier', () async {
        const source = 'return os.date("*table")';
        expect(
          await luaExecute(source, options: options),
          luaEquals(['*table']),
        );
      });
    });

    test('os.difftime', () async {
      const source = 'return os.difftime(1000, 500)';
      expect(await luaExecute(source), luaEquals([500]));
    });

    test('os.execute', () async {
      const source = 'return os.execute("echo hello")';
      expect(
        await luaExecute(source, options: options),
        luaEquals([true, 0, null]),
      );
    });

    test('os.getenv', () async {
      const source = 'return os.getenv("PATH")';
      expect(
        await luaExecute(source, options: options),
        luaEquals([mockEnvPath]),
      );
    });

    test('os.remove', () async {
      const source = 'return os.remove("file.txt")';
      expect(await luaExecute(source, options: options), luaEquals([true]));
    });

    test('os.rename', () async {
      const source = 'return os.rename("file.txt", "newfile.txt")';
      expect(await luaExecute(source, options: options), luaEquals([true]));
    });

    test('os.setlocale', () async {
      const expected = 'en_US.UTF-8';
      const source = 'return os.setlocale("$expected")';
      expect(await luaExecute(source, options: options), luaEquals([expected]));
    });

    test('os.time', () async {
      const source = 'return os.time()';
      expect(
        await luaExecute(source, options: options),
        luaEquals([mockLocalDateTime]),
      );
    });

    test('os.tmpname', () async {
      const source = 'return os.tmpname()';
      expect(
        await luaExecute(source, options: options),
        luaEquals([mockTemporaryName]),
      );
    });
  });
}
