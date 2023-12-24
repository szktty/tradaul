import 'package:test/test.dart';
import 'package:tradaul/src/compiler/number_parser.dart';

void main() {
  group('NumberParser.parseDouble tests', () {
    group('standard float numbers', () {
      test('basic float', () {
        expect(NumberParser.parseDouble('3.0'), 3.0);
      });

      test('fractional float', () {
        expect(NumberParser.parseDouble('3.1416'), 3.1416);
      });

      test('float with negative exponent', () {
        expect(NumberParser.parseDouble('314.16e-2'), 3.1416);
      });

      test('float with positive exponent', () {
        expect(NumberParser.parseDouble('0.31416E1'), 3.1416);
      });

      test('float with large positive exponent', () {
        expect(NumberParser.parseDouble('34e1'), 340.0);
      });

      test('integer part only', () {
        expect(NumberParser.parseDouble('0.'), 0);
      });

      test('fractional part only', () {
        expect(NumberParser.parseDouble('.0'), 0);
      });

      test('fraction with positive exponent', () {
        expect(NumberParser.parseDouble('.2e2'), 20.0);
      });
    });

    group('hex float numbers', () {
      test('integer part only', () {
        expect(NumberParser.parseDouble('0x0.'), 0.0);
      });

      test('fractional part only', () {
        expect(NumberParser.parseDouble('0x.0'), 0.0);
      });

      test('hexadecimal with positive exponent', () {
        expect(NumberParser.parseDouble('0x0.1E'), closeTo(0.1171875, 1e-10));
      });

      test('hexadecimal with negative power-of-two exponent', () {
        expect(NumberParser.parseDouble('0xA23p-4'), closeTo(162.1875, 1e-10));
      });

      test('hexadecimal fractional with negative power-of-two exponent', () {
        expect(NumberParser.parseDouble('0x.0p-3'), 0);
      });

      test('hexadecimal fractional with large positive power-of-two exponent',
          () {
        expect(NumberParser.parseDouble('0x.0p12'), 0);
      });

      test('hexadecimal large fractional', () {
        expect(
          NumberParser.parseDouble('0x.FfffFFFF'),
          closeTo(0.99999999976717, 1e-10),
        );
      });

      test('hexadecimal mixed format with large power-of-two exponent', () {
        expect(
          NumberParser.parseDouble('0x.ABCDEFp+24'),
          closeTo(11259375.0, 1e-10),
        );
      });

      test('long hexadecimal representation', () {
        expect(
          NumberParser.parseDouble('0X1.921FB54442D18P+1'),
          closeTo(3.1415926535898, 1e-10),
        );
      });
    });
  });
}
