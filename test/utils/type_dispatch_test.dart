import 'package:test/test.dart';
import 'package:tradaul/src/utils/type_dispatch.dart';

void main() {
  group('TypeDispatch2 tests', () {
    late TypeDispatch2<int, double, String> dispatcher;

    setUp(() {
      dispatcher = TypeDispatch2<int, double, String>(
        t1T1: (a, b) => 'int-int',
        t1T2: (a, b) => 'int-double',
        t2T1: (a, b) => 'double-int', // t2T1 callback setup
        t2T2: (a, b) => 'double-double',
      );
    });

    test('Dispatch int-int', () {
      expect(dispatcher.dispatch(1, 2), equals('int-int'));
    });

    test('Dispatch int-double', () {
      expect(dispatcher.dispatch(1, 2.0), equals('int-double'));
    });

    test('Dispatch double-int', () {
      // New test for t2T1
      expect(dispatcher.dispatch(2.0, 3), equals('double-int'));
    });

    test('Dispatch double-double', () {
      expect(dispatcher.dispatch(2.0, 3.0), equals('double-double'));
    });

    test('Validate with invalid types', () {
      expect(dispatcher.validate(1, 'string'), equals(String));
      expect(dispatcher.validate('string', 2.0), equals(String));
    });

    test('Dispatch with invalid types throws exception', () {
      expect(
        () => dispatcher.dispatch(1, 'string'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => dispatcher.dispatch('string', 2.0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('TypeDispatch3 tests', () {
    late TypeDispatch3<int, double, String, String> dispatcher;

    setUp(() {
      dispatcher = TypeDispatch3<int, double, String, String>(
        t1T1: (a, b) => 'int-int',
        t1T2: (a, b) => 'int-double',
        t1T3: (a, b) => 'int-string',
        t2T1: (a, b) => 'double-int',
        t2T2: (a, b) => 'double-double',
        t2T3: (a, b) => 'double-string',
        t3T1: (a, b) => 'string-int',
        t3T2: (a, b) => 'string-double',
        t3T3: (a, b) => 'string-string',
      );
    });

    test('Dispatch int-int', () {
      expect(dispatcher.dispatch(1, 2), equals('int-int'));
    });

    test('Dispatch int-double', () {
      expect(dispatcher.dispatch(1, 2.0), equals('int-double'));
    });

    test('Dispatch int-string', () {
      expect(dispatcher.dispatch(1, 'hello'), equals('int-string'));
    });

    test('Dispatch double-double', () {
      expect(dispatcher.dispatch(2.0, 3.0), equals('double-double'));
    });

    test('Dispatch double-string', () {
      expect(dispatcher.dispatch(2.0, 'world'), equals('double-string'));
    });

    test('Dispatch string-string', () {
      expect(dispatcher.dispatch('hello', 'world'), equals('string-string'));
    });

    test('Dispatch double-int', () {
      expect(dispatcher.dispatch(2.0, 1), equals('double-int'));
    });

    test('Dispatch string-int', () {
      expect(dispatcher.dispatch('hello', 1), equals('string-int'));
    });

    test('Dispatch string-double', () {
      expect(dispatcher.dispatch('world', 2.0), equals('string-double'));
    });

    test('Validate with invalid types', () {
      expect(dispatcher.validate(1, true), equals(bool));
      expect(dispatcher.validate(true, 2.0), equals(bool));
    });

    test('Dispatch with invalid types throws exception', () {
      expect(() => dispatcher.dispatch(1, true), throwsA(isA<ArgumentError>()));
      expect(
        () => dispatcher.dispatch(true, 2.0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
