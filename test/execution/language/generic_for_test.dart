import 'package:test/test.dart';

import 'test.dart';

void testGenericForLoop() {
  group('generic for loop', () {
    test('sequence table', () async {
      const source = '''
    local t = {"a", "b", "c"}
    local result = ""
    for _, v in pairs(t) do
      result = result .. v
    end
    return result
    ''';
      expect(await luaExecute(source), luaEquals(['abc']));
    });

    test('key-value table', () async {
      const source = '''
local t = {a = 1, b = 2, c = 3}
local count = 0
local sum = 0
for k, v in pairs(t) do
  count = count + 1
  sum = sum + v
end
return count, sum
    ''';
      expect(await luaExecute(source), luaEquals([3, 6]));
    });

    test('nested generic for', () async {
      const source = '''
    local t1 = {1, 2}
    local t2 = {"a", "b"}
    local result = ""
    for _, x in pairs(t1) do
      for _, y in pairs(t2) do
        result = result .. x .. y
      end
    end
    return result
    ''';
      expect(await luaExecute(source), luaEquals(['1a1b2a2b']));
    });

    group('terminates the execution of loop', () {
      test('goto', () async {
        const source = '''
local t = {1, 2, 3, 4, 5}
local sum = 0
for _, v in ipairs(t) do
  if v == 4 then
    goto exit_loop
  end
  sum = sum + v
end
::exit_loop::
return sum
''';
        expect(await luaExecute(source), luaEquals([6]));
      });

      test('break', () async {
        const source = '''
local result = 0
for idx, value in ipairs({1, 2, 3}) do
  result = value
  if value == 2 then
    break
  end
end
return result
''';
        expect(await luaExecute(source), luaEquals([2]));
      });

      test('nested loops', () async {
        const source = '''
local sum = 0
for _, outerValue in ipairs({1, 2}) do
  for _, innerValue in ipairs({10, 20, 30}) do
    sum = sum + (outerValue * innerValue)
    if outerValue == 1 and innerValue == 20 then
      break
    end
  end
end
return sum
''';
        expect(await luaExecute(source), luaEquals([150]));
      });
    });

    group('variable scope', () {
      test('loop variable not accessible outside', () async {
        const source = '''
    for key, _ in pairs({a=1}) do
    end
    return key
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('local variable inside loop', () async {
        const source = '''
    for key, _ in pairs({a=1}) do
      local innerVar = "test"
    end
    return innerVar
    ''';
        expect(await luaExecute(source), luaEquals([null]));
      });

      test('variable name shadowing', () async {
        const source = '''
    local key = "initial"
    for key, _ in pairs({a=1}) do
    end
    return key
    ''';
        expect(await luaExecute(source), luaEquals(['initial']));
      });
    });
  });
}
