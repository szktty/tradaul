# Known Issues and Future Work

This document outlines known issues in the Tradaul Lua interpreter implementation that require future work.

## 1. UTF-8 Encoding Issues

### Problem Description
UTF-8 strings are being corrupted when processed by the Lua interpreter, causing multi-byte characters to be incorrectly represented.

### Observed Behavior
```lua
local str = "こんにちは"  -- Japanese text
print(str)  -- Output: "S�kao" (corrupted)
```

### Impact
- UTF-8 module tests fail due to corrupted input strings
- `utf8.charpattern` cannot match corrupted characters
- General Unicode string handling is broken
- Affects international text processing

### Root Cause
The issue appears to be in the core string handling system, likely in:
- String literal parsing in the compiler
- String representation in LuaString values
- Character encoding conversion between Dart and Lua

### Required Fixes
1. **String Parsing**: Review how UTF-8 string literals are parsed in `string_parser.dart`
2. **String Storage**: Ensure LuaString properly handles UTF-8 byte sequences
3. **Character Operations**: Fix string operations to work with UTF-8 code units vs characters
4. **Testing**: Add comprehensive UTF-8 test coverage

### Test Cases Affected
- `utf8_test.dart`: Most UTF-8 module tests
- Any tests involving non-ASCII characters

## 2. Large Integer Handling Issues

### Problem Description
Large positive integers are being incorrectly converted to negative values during parsing or storage.

### Observed Behavior
```lua
local num = 12345678
print(num)  -- Output: -4431538 (incorrect)
```

### Technical Details
- Input: `12345678` (positive integer)
- Expected: `12345678`
- Actual: `-4431538`
- Suggests 32-bit signed integer overflow or sign bit issues

### Impact
- `string.pack` tests fail with large integers
- Numeric operations may produce incorrect results
- Data integrity issues in applications using large numbers

### Root Cause Analysis
The issue likely occurs in:
1. **Number Parsing**: `number_parser.dart` may have overflow handling issues
2. **Int64 Conversion**: Incorrect conversion between Dart int and Int64
3. **Bit Operations**: Sign extension or bit manipulation errors

### Required Fixes
1. **Parser Review**: Check `LuaInteger.fromInt()` and related parsing code
2. **Range Validation**: Ensure proper handling of 32-bit vs 64-bit integers
3. **Overflow Handling**: Implement proper overflow detection and handling
4. **Testing**: Add tests for edge cases and large integer values

### Test Cases Affected
- `string_pack_test.dart`: Tests with large integer values
- Any numeric operations with large numbers

## 3. Minor Test Framework Issues

### 3.1 table.unpack Nil Handling

#### Problem Description
`table.unpack` with nil-only tables returns different results in tests vs manual execution.

#### Observed Behavior
- Manual execution: `table.unpack({nil, nil, nil})` returns empty result (correct)
- Test framework: Same code returns `[nil, nil, nil]` (incorrect)

#### Impact
- Single failing test case
- No impact on core functionality

#### Root Cause
Likely a test framework issue with how multiple return values are captured.

### 3.2 Test Expectation Inconsistencies

#### Problem Description
Some tests had inconsistent expectation formats (nested arrays vs flat arrays).

#### Status
**RESOLVED** - Fixed table.sort test expectations to match other similar tests.

## 4. Binary Format Parsing (string.pack/unpack)

### Current Status
Basic implementation is working but incomplete. **Most string.pack/unpack tests are failing.**

### Specific Issues Found
1. **Endianness Problems**: Big endian format `>i4` produces wrong values
   - Expected: `12345678`, Actual: `-4431538`
   - All endian formats (big, little, native) affected

2. **Return Value Issues**: `string.unpack` returns extra position value
   - Expected: `[value]`, Actual: `[value, position]`
   - This breaks many test expectations

### Missing Features
1. **Complex Format Strings**: 
   - Nested structures `()`
   - Optional elements `?`
   - Alignment specifiers `!n`
   - Proper padding handling

2. **IEEE 754 Compliance**:
   - Current float/double packing is simplified
   - Real IEEE 754 binary representation needed

3. **Endianness Edge Cases**:
   - More thorough testing of endianness handling
   - Platform-specific endian detection

### Required Work
1. **URGENT**: Fix endianness handling in integer packing/unpacking
2. Review string.unpack return value format (some tests expect position, others don't)
3. Implement full Lua 5.4 pack/unpack format specification
4. Add IEEE 754 compliant float/double handling
5. Comprehensive format string parser
6. Extended test coverage for all format combinations

## 5. Performance and Memory Issues

### Potential Issues
These haven't been thoroughly investigated but should be monitored:

1. **String Operations**: UTF-8 handling may be inefficient
2. **Table Operations**: Large table sorting performance
3. **Memory Leaks**: Ensure proper cleanup of native objects
4. **Garbage Collection**: Integration with Dart's GC

### Recommended Actions
1. Performance profiling with large datasets
2. Memory usage analysis
3. Benchmark against standard Lua performance

## 6. Platform Compatibility

### Current Status
Code is primarily developed and tested on macOS.

### Potential Issues
1. **Endianness**: Native endian handling on different platforms
2. **Integer Size**: Platform-specific integer size assumptions
3. **File I/O**: Platform-specific file handling in IO module
4. **Character Encoding**: Platform-specific UTF-8 handling

### Required Testing
1. Comprehensive testing on Windows and Linux
2. Mobile platform testing (iOS/Android)
3. Web platform compatibility testing

## Priority Assessment

### High Priority
1. **UTF-8 Encoding Issues** - Affects international users
2. **Large Integer Handling** - Data integrity critical

### Medium Priority  
3. **Binary Format Completion** - Feature completeness
4. **Performance Issues** - User experience

### Low Priority
5. **Minor Test Issues** - Quality of life
6. **Platform Compatibility** - Broader adoption

## Investigation Notes

### UTF-8 Issue Debugging Steps
1. Check string literal tokenization in lexer
2. Verify UTF-8 byte preservation in string storage
3. Test character boundary detection
4. Review string operation implementations

### Integer Issue Debugging Steps  
1. Add debug output to `LuaInteger.fromInt()`
2. Check Int64 construction and conversion
3. Test edge cases around 32-bit boundaries
4. Review bit operation implementations

## Related Files

### UTF-8 Issues
- `lib/src/compiler/string_parser.dart`
- `lib/src/runtime/lua_values.dart` (LuaString)
- `lib/src/lua_lib/lua_utf8_module.dart`
- `test/execution/modules/utf8_test.dart`

### Integer Issues
- `lib/src/compiler/number_parser.dart`
- `lib/src/runtime/lua_values.dart` (LuaInteger)
- `test/execution/modules/string_pack_test.dart`

### Binary Format
- `lib/src/lua_lib/lua_string_module.dart` (_packBinaryData, _unpackBinaryData)
- `test/execution/modules/string_pack_test.dart`