import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_exception.dart';

import '../language/test.dart';

void main() {
  group('io and file module tests', () {
    const fs = LocalFileSystem();
    final testFile = path.join(tempDir, 'test.txt');
    const testFileContent = 'Hello, world!';
    final testWriteFile = path.join(tempDir, 'test_write.txt');

    setUpAll(() {
      fs.directory(tempDir).createSync(recursive: true);

      final f = fs.file(testFile)..createSync();
      f.openSync(mode: FileMode.write)
        ..writeStringSync(testFileContent)
        ..closeSync();
    });

    tearDown(() {
      fs.file(testWriteFile).deleteSync();
    });

    tearDownAll(() {
      fs.directory(tempDir).deleteSync(recursive: true);
    });

    group('standard input, output, error', () {
      test('existing stdin', () async {
        const source = '''
    return io.stdin ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('existing stdout', () async {
        const source = '''
    return io.stdout ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('existing stderr', () async {
        const source = '''
    return io.stderr ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });
    });

    group('io.open', () {
      test('existing file with read mode', () async {
        final source = '''
    return io.open("$testFile", "r") ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('existing file with write mode', () async {
        final source = '''
    return io.open("$testFile", "w") ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('existing file with append mode', () async {
        final source = '''
    return io.open("$testFile", "a") ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('non-existing file with read mode', () async {
        final source = '''
    return io.open("$testWriteFile", "r")
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('non-existing file with append mode', () async {
        final source = '''
    return io.open("$testWriteFile", "a") ~= nil
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });
    });

    group('io.close', () {
      test('io.close', () async {
        final source = '''
  local file = io.open("$testFile", "r")
  file:close(file)
  ''';
        expect(await luaExecute(source), luaEquals([]));
      });

      test('attempt to use file after closing', () async {
        final source = '''
        local file = io.open("$testFile", "r")
        file:close(file)
        file:write("Hello, world!")
      ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    group('io.type', () {
      test('opened file', () async {
        final source = '''
  local file = io.open("$testFile", "r")
  return io.type(file)
  ''';
        expect(await luaExecute(source), luaEquals(['file']));
      });

      test('closed file', () async {
        final source = '''
  local file = io.open("$testFile", "r")
  file:close(file)
  return io.type(file)
  ''';
        expect(await luaExecute(source), luaEquals(['closed file']));
      });
    });

    test('io.flush', () async {
      final source = '''
    local file = io.open("$testWriteFile", "w")
    file:write("Some data")
    file:flush()
    file:close()
    ''';
      expect(await luaExecute(source), luaEquals([]));
    });

    test('io.input and io.read', () async {
      final source = '''
    io.input("$testFile")
    return io.read("*a")
    ''';
      expect(await luaExecute(source), luaEquals([testFileContent]));
    });

    test('io.output and io.write', () async {
      final source = '''
    io.output("$testWriteFile")
    io.write("Some data")
    io.close()
    io.input("$testWriteFile")
    return io.read("*a")
    ''';
      expect(await luaExecute(source), luaEquals([testFileContent]));
    });

    group('io.seek', () {
      test('set to beginning', () async {
        final source = '''
        local file = io.open("$testFile", "r")
        file:seek("set")
        local result = file:read("*a")
        file:close()
        return result
      ''';
        expect(await luaExecute(source), luaEquals([testFileContent]));
      });

      test('set to specific position', () async {
        final source = '''
        local file = io.open("$testFile", "r")
        file:seek("set", 7)
        local result = file:read("*a")
        file:close()
        return result
      ''';
        expect(await luaExecute(source), luaEquals([testFileContent]));
      });

      test('set to end', () async {
        final source = '''
        local file = io.open("$testFile", "r")
        file:seek("end")
        local result = file:read("*a")
        file:close()
        return result
      ''';
        expect(await luaExecute(source), luaEquals([testFileContent]));
      });

      test('invalid mode', () async {
        final source = '''
        local file = io.open("$testFile", "r")
        file:seek("invalidMode")
      ''';
        expect(() async => luaExecute(source), throwsA(isA<LuaException>()));
      });
    });

    test('io.lines', () async {
      final testFile = path.join(tempDir, 'test_write.txt');
      final f = fs.file(testFile);
      f.openSync(mode: FileMode.write)
        ..writeStringSync('line1\nline2\nline3')
        ..closeSync();

      final source = '''
    local file = io.open("$testFile", "r")
    local lines = {}
    for line in file:lines() do
      table.insert(lines, line)
    end
    return lines[1], lines[2], lines[3]
    ''';
      expect(
        await luaExecute(source),
        luaEquals([
          ['line1', 'line2', 'line3'],
        ]),
      );
    });

    group('file:setvbuf', () {
      test('mode "no"', () async {
        const source = '''
    local file = io.open("test_file.txt", "w")
    local result = file:setvbuf("no")
    file:close()
    return result
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('mode "full"', () async {
        const source = '''
    local file = io.open("test_file.txt", "w")
    local result = file:setvbuf("full")
    file:close()
    return result
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('mode "line"', () async {
        const source = '''
    local file = io.open("test_file.txt", "w")
    local result = file:setvbuf("line")
    file:close()
    return result
    ''';
        expect(await luaExecute(source), luaEquals([true]));
      });

      test('invalid mode', () async {
        const source = '''
    local file = io.open("test_file.txt", "w")
    file:setvbuf("invalid_mode")
    ''';
        expect(() async => luaExecute(source), throwsA(isA<Exception>()));
      });
    });

    group('io.tmpfile', () {
      test('rreate and write', () async {
        const source = '''
        local file = io.tmpfile()
        file:write("Hello, world!")
        file:flush()
      ''';
        expect(await luaExecute(source), luaEquals([]));
      });

      test('read', () async {
        const source = '''
        local file = io.tmpfile()
        file:write("Hello, world!")
        file:flush()
        file:seek("set")
        return file:read("*a")
      ''';
        expect(await luaExecute(source), luaEquals(['Hello, world!']));
      });

      test('close', () async {
        const source = '''
        local file = io.tmpfile()
        file:close()
        return io.type(file)
      ''';
        expect(await luaExecute(source), luaEquals(['closed file']));
      });
    });

    test('file:read', () async {
      final source = '''
    local file = io.open("$testFile", "r")
    return file:read("*a")
    ''';
      expect(await luaExecute(source), luaEquals([testFileContent]));
    });

    test('file:write', () async {
      final source = '''
    local file = io.open("$testWriteFile", "w")
    file:write("Some data")
    file:close()
    local file_read = io.open("$testWriteFile", "r")
    local data = file_read:read("*a")
    file_read:close()
    return data
    ''';
      expect(await luaExecute(source), luaEquals(['Some data']));
    });
  });
}
