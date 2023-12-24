import 'package:test/test.dart';

import 'test.dart';

void testUnaryOperators() {
  group('unary operators', () {
    testUnaryOperator('logical NOT (not)', 'not', [
      ['true', true, false],
      ['false', false, true],
      ['nil', null, true],
      ['non-nil value', 5, false],
    ]);

    testUnaryOperator('minus (-)', '-', [
      ['positive integer', 5, -5],
      ['negative integer', -5, 5],
      ['zero', 0, 0],
    ]);

    testUnaryOperator('length (#)', '#', [
      ['string', 'hello', 5],
      ['empty string', '', 0],
      ['table with 0 border (empty)', <dynamic, dynamic>{}, 0],
      [
        'table with 0 border (not sequence)',
        {'a': 1, 'b': 2},
        0,
      ],
      [
        'table with 1 border (sequence)',
        [10, 20, 30, 40, 50],
        5,
      ],
      [
        'table with 2 borders (not sequence)',
        [10, 20, 30, null, 50],
        5,
      ],
      [
        'table with 3 borders (not sequence)',
        [null, 20, 30, null, null, 60, null],
        6,
      ],
    ]);

    testUnaryOperator('bitwise NOT (~)', '~', [
      ['positive integer', 5, -6],
      ['negative integer', -5, 4],
      ['zero', 0, -1],
    ]);
  });
}
