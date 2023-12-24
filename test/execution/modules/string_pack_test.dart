import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../language/test.dart';

void main() {
  group('string.pack and string.unpack functions', () {
    group('endian formats', () {
      test('big endian format', () async {
        const source = '''
      local packed = string.pack(">i4", 12345678)
      return string.unpack(">i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([12345678]));
      });

      test('little endian format', () async {
        const source = '''
      local packed = string.pack("<i4", 12345678)
      return string.unpack("<i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([12345678]));
      });

      test('native endian format', () async {
        const source = '''
      local packed = string.pack("=i4", 12345678)
      return string.unpack("=i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([12345678]));
      });
    });

    group('integer types', () {
      test('signed byte', () async {
        const source = '''
      local packed = string.pack("b", -128)
      return string.unpack("b", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-128]));
      });

      test('unsigned byte', () async {
        const source = '''
      local packed = string.pack("B", 255)
      return string.unpack("B", packed)
    ''';
        expect(await luaExecute(source), luaEquals([255]));
      });

      test('signed short', () async {
        const source = '''
      local packed = string.pack("h", -32768)
      return string.unpack("h", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-32768]));
      });

      test('unsigned short', () async {
        const source = '''
      local packed = string.pack("H", 65535)
      return string.unpack("H", packed)
    ''';
        expect(await luaExecute(source), luaEquals([65535]));
      });

      test('signed long', () async {
        const source = '''
      local packed = string.pack("l", -2147483648)
      return string.unpack("l", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-2147483648]));
      });

      test('unsigned long', () async {
        const source = '''
      local packed = string.pack("L", 4294967295)
      return string.unpack("L", packed)
    ''';
        expect(await luaExecute(source), luaEquals([4294967295]));
      });

      test('signed int with custom size', () async {
        const source = '''
      local packed = string.pack("i2", -32768)
      return string.unpack("i2", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-32768]));
      });

      test('unsigned int with custom size', () async {
        const source = '''
      local packed = string.pack("I2", 65535)
      return string.unpack("I2", packed)
    ''';
        expect(await luaExecute(source), luaEquals([65535]));
      });

      test('lua_Integer', () async {
        const source = '''
      local packed = string.pack("j", -9223372036854775808)
      return string.unpack("j", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-9223372036854775808]));
      });

      test('lua_Unsigned', () async {
        const source = '''
      local packed = string.pack("J", 18446744073709551615)
      return string.unpack("J", packed)
    ''';
        expect(
          await luaExecute(source),
          luaEquals([Int64.parseInt('18446744073709551615')]),
        );
      });

      test('size_t', () async {
        const source = '''
      local packed = string.pack("T", 4294967295)
      return string.unpack("T", packed)
    ''';
        expect(await luaExecute(source), luaEquals([4294967295]));
      });
    });

    group('floating point types', () {
      test('float', () async {
        const source = '''
      local packed = string.pack("f", 123.456)
      return string.unpack("f", packed)
    ''';
        expect(await luaExecute(source), luaEquals([123.456]));
      });

      test('double', () async {
        const source = '''
      local packed = string.pack("d", 123.456789)
      return string.unpack("d", packed)
    ''';
        expect(await luaExecute(source), luaEquals([123.456789]));
      });
    });

    group('fixed-length strings', () {
      test('fixed-length string of 5 bytes', () async {
        const source = '''
      local packed = string.pack("c5", "hello")
      return string.unpack("c5", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello']));
      });

      test('fixed-length string with padding', () async {
        const source = '''
      local packed = string.pack("c10", "hello")
      return string.unpack("c10", packed)
    ''';
        expect(
          await luaExecute(source),
          luaEquals(['hello\x00\x00\x00\x00\x00']),
        );
      });
    });

    group('zero-terminated strings', () {
      test('zero-terminated string', () async {
        const source = '''
      local packed = string.pack("z", "hello")
      return string.unpack("z", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello']));
      });
    });

    group('length-prefixed strings', () {
      test('length-prefixed string with 1-byte length', () async {
        const source = '''
      local packed = string.pack("s1", "hello")
      return string.unpack("s1", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello']));
      });

      test('length-prefixed string with 2-byte length', () async {
        const source = '''
      local packed = string.pack("s2", "hello")
      return string.unpack("s2", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello']));
      });
    });

    group('padding and alignment', () {
      test('padding byte', () async {
        const source = '''
      local packed = string.pack("xi4", 1234)
      return string.unpack("xi4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234]));
      });

      test('alignment - aligned int', () async {
        const source = '''
      local packed = string.pack("!4i4", 1234)
      return string.unpack("!4i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234]));
      });

      test('alignment - unaligned int', () async {
        const source = '''
      local packed = string.pack("i4", 1234)
      return string.unpack("i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234]));
      });
    });

    group('arrays', () {
      test('array of integers', () async {
        const source = '''
      local packed = string.pack("i4i4i4", 1, 2, 3)
      return {string.unpack("i4i4i4", packed)}
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [1, 2, 3],
          ]),
        );
      });

      test('array with mixed types', () async {
        const source = '''
      local packed = string.pack("i4bf", 1234, -128, 3.14)
      return {string.unpack("i4bf", packed)}
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [1234, -128, 3.14],
          ]),
        );
      });
    });

    group('complex formats and captures', () {
      test('nested structures', () async {
        const source = '''
      local packed = string.pack("i4(i4zf)", 1234, 5678, "hello", 3.14)
      return {string.unpack("i4(i4zf)", packed)}
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [
              1234,
              [5678, 'hello', 3.14],
            ]
          ]),
        );
      });

      test('optional elements', () async {
        const source = '''
      local packed = string.pack("i4z?i4", 1234, "hello", 5678)
      return {string.unpack("i4z?i4", packed)}
    ''';
        expect(
          await luaExecute(source),
          luaEquals([
            [1234, 'hello', 5678],
          ]),
        );
      });
    });
  });
}
