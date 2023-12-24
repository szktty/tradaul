import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

void main() {
  group('LuaStackTraceEntry', () {
    test('should convert to a map with both path and line', () {
      final entry = LuaStackTraceEntry(
        path: 'script.lua',
        line: 5,
      );
      final expectedMap = {
        'path': 'script.lua',
        'line': 5,
      };

      expect(entry.toMap(), expectedMap);
    });

    test('should convert to a map with only path', () {
      final entry = LuaStackTraceEntry(path: 'script.lua');
      final expectedMap = {'path': 'script.lua', 'line': null};

      expect(entry.toMap(), expectedMap);
    });

    test('should convert to a map with only line', () {
      final entry = LuaStackTraceEntry(line: 5);
      final expectedMap = {
        'path': null,
        'line': 5,
      };

      expect(entry.toMap(), expectedMap);
    });
  });

  group('LuaStackTrace', () {
    test('should convert to a map with multiple entries', () {
      final entries = [
        LuaStackTraceEntry(
          path: 'script1.lua',
          line: 3,
        ),
        LuaStackTraceEntry(
          path: 'script2.lua',
          line: 8,
        ),
      ];
      final stackTrace = LuaStackTrace(entries);
      final expectedMap = {
        'entries': [
          {
            'path': 'script1.lua',
            'line': 3,
          },
          {
            'path': 'script2.lua',
            'line': 8,
          }
        ],
      };

      expect(stackTrace.toMap(), expectedMap);
    });

    test('should convert to a map with no entries', () {
      final stackTrace = LuaStackTrace([]);
      final expectedMap = {'entries': []};

      expect(stackTrace.toMap(), expectedMap);
    });
  });
}
