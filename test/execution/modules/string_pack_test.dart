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
        expect(await luaExecute(source), luaEquals([12345678, 5]));
      });

      test('little endian format', () async {
        const source = '''
      local packed = string.pack("<i4", 12345678)
      return string.unpack("<i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([12345678, 5]));
      });

      test('native endian format', () async {
        const source = '''
      local packed = string.pack("=i4", 12345678)
      return string.unpack("=i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([12345678, 5]));
      });
    });

    group('integer types', () {
      test('signed byte', () async {
        const source = '''
      local packed = string.pack("b", -128)
      return string.unpack("b", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-128, 2]));
      });

      test('unsigned byte', () async {
        const source = '''
      local packed = string.pack("B", 255)
      return string.unpack("B", packed)
    ''';
        expect(await luaExecute(source), luaEquals([255, 2]));
      });

      test('signed short', () async {
        const source = '''
      local packed = string.pack("h", -32768)
      return string.unpack("h", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-32768, 3]));
      });

      test('unsigned short', () async {
        const source = '''
      local packed = string.pack("H", 65535)
      return string.unpack("H", packed)
    ''';
        expect(await luaExecute(source), luaEquals([65535, 3]));
      });

      test('signed long', () async {
        const source = '''
      local packed = string.pack("l", -2147483648)
      return string.unpack("l", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-2147483648, 5]));
      });

      test('unsigned long', () async {
        const source = '''
      local packed = string.pack("L", 4294967295)
      return string.unpack("L", packed)
    ''';
        expect(await luaExecute(source), luaEquals([4294967295, 5]));
      });

      test('signed int with custom size', () async {
        const source = '''
      local packed = string.pack("i2", -32768)
      return string.unpack("i2", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-32768, 3]));
      });

      test('unsigned int with custom size', () async {
        const source = '''
      local packed = string.pack("I2", 65535)
      return string.unpack("I2", packed)
    ''';
        expect(await luaExecute(source), luaEquals([65535, 3]));
      });

      test('lua_Integer', () async {
        const source = '''
      local packed = string.pack("j", -9223372036854775808)
      return string.unpack("j", packed)
    ''';
        expect(await luaExecute(source), luaEquals([-9223372036854775808, 9]));
      });

      test('lua_Unsigned', () async {
        const source = '''
      local packed = string.pack("J", 18446744073709551615)
      return string.unpack("J", packed)
    ''';
        expect(
          await luaExecute(source),
          luaEquals([Int64.parseInt('18446744073709551615'), 9]),
        );
      });

      test('size_t', () async {
        const source = '''
      local packed = string.pack("T", 4294967295)
      return string.unpack("T", packed)
    ''';
        expect(await luaExecute(source), luaEquals([4294967295, 5]));
      });
    });

    group('floating point types', () {
      test('float', () async {
        const source = '''
      local packed = string.pack("f", 123.456)
      return string.unpack("f", packed)
    ''';
        expect(await luaExecute(source), luaEquals([123.456, 5]));
      });

      test('double', () async {
        const source = '''
      local packed = string.pack("d", 123.456789)
      return string.unpack("d", packed)
    ''';
        expect(await luaExecute(source), luaEquals([123.456789, 9]));
      });
    });

    group('fixed-length strings', () {
      test('fixed-length string of 5 bytes', () async {
        const source = '''
      local packed = string.pack("c5", "hello")
      return string.unpack("c5", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello', 6]));
      });

      test('fixed-length string with padding', () async {
        const source = '''
      local packed = string.pack("c10", "hello")
      return string.unpack("c10", packed)
    ''';
        expect(
          await luaExecute(source),
          luaEquals(['hello\x00\x00\x00\x00\x00', 11]),
        );
      });
    });

    group('zero-terminated strings', () {
      test('zero-terminated string', () async {
        const source = '''
      local packed = string.pack("z", "hello")
      return string.unpack("z", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello', 7]));
      });
    });

    group('length-prefixed strings', () {
      test('length-prefixed string with 1-byte length', () async {
        const source = '''
      local packed = string.pack("s1", "hello")
      return string.unpack("s1", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello', 7]));
      });

      test('length-prefixed string with 2-byte length', () async {
        const source = '''
      local packed = string.pack("s2", "hello")
      return string.unpack("s2", packed)
    ''';
        expect(await luaExecute(source), luaEquals(['hello', 8]));
      });
    });

    group('padding and alignment', () {
      test('padding byte', () async {
        const source = '''
      local packed = string.pack("xi4", 1234)
      return string.unpack("xi4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234, 6]));
      });

      test('alignment - aligned int', () async {
        const source = '''
      local packed = string.pack("!4i4", 1234)
      return string.unpack("!4i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234, 5]));
      });

      test('alignment - unaligned int', () async {
        const source = '''
      local packed = string.pack("i4", 1234)
      return string.unpack("i4", packed)
    ''';
        expect(await luaExecute(source), luaEquals([1234, 5]));
      });
    });

    group('arrays', () {
      test('array of integers', () async {
        const source = '''
      local packed = string.pack("i4i4i4", 1, 2, 3)
      local a, b, c, pos = string.unpack("i4i4i4", packed)
      return a, b, c, pos
    ''';
        expect(await luaExecute(source), luaEquals([1, 2, 3, 13]));
      });

      test('array with mixed types', () async {
        const source = '''
      local packed = string.pack("i4bf", 1234, -128, 3.14)
      local a, b, c, pos = string.unpack("i4bf", packed)
      return a, b, c, pos
    ''';
        expect(await luaExecute(source), luaEquals([1234, -128, 3.14, 10]));
      });
    });

    group('string.packsize', () {
      test('calculate size for integer', () async {
        const source = '''
      return string.packsize("i4")
    ''';
        expect(await luaExecute(source), luaEquals([4]));
      });

      test('calculate size for multiple types', () async {
        const source = '''
      return string.packsize("i4bf")
    ''';
        expect(await luaExecute(source), luaEquals([9]));
      });
    });
  });
}
