# Tradaul VM Performance Improvement Report

**Created**: June 8, 2025  
**Target Version**: Tradaul v0.7.0  
**Implementer**: Claude Code (claude.ai/code)

## Executive Summary

A Tradaul VM performance improvement project was conducted, achieving the following results:

**Final Performance Improvements:**
- **fibonacci.lua**: 44.0% faster (3.857s → 2.160s)
- **loop.lua**: 79.0% faster (1.027s → 0.216s)
- **table.lua**: 55.6% faster (0.153s → 0.068s)
- **string.lua**: 12.5% faster (0.008s → 0.007s)

Key optimizations included reducing async overhead (synchronizing 46 await operations) and implementing compile-time instruction decoding.

## Successful Optimizations

### 1. Synchronous Basic Arithmetic Implementation

**Implementation:**
- Added fast paths for ADD, SUB, MUL, DIV operations with number-only optimization
- Skip async processing (await) for direct calculation execution

**Technical Details:**
```dart
// Skip async processing for number-to-number operations
if (left is LuaNumber && right is LuaNumber) {
  final rawA = left.rawValue;
  final rawB = right.rawValue;
  if (ArithmeticOperatorDispatcher.add.validate(rawA, rawB) == null) {
    _stack.push(ArithmeticOperatorDispatcher.add.dispatch(rawA, rawB));
    break; // Complete await avoidance
  }
}
```

**Results:**
- loop.lua: 68.2% improvement (maximum effect)
- fibonacci.lua: 28.5% improvement

### 2. Comparison Operation Synchronization

**Implementation:**
- Synchronous processing for LT, LE, EQ, GT, GE operations when comparing numbers/strings
- Fast path bypassing metamethod processing

**Results:**
- fibonacci.lua: 18.3% improvement (comparison optimization in recursive processing)
- Particularly effective for processes with many function calls

### 3. Table Operation Optimization

**Implementation:**
- Added synchronous paths for GET_FIELD/SET_FIELD instructions
- Direct access bypassing metamethod checks

**Results:**
- table.lua: 20.5% improvement
- Notable effects in table-intensive processing

### 4. Compile-time Instruction Decoding

**Implementation:**
- Pre-complete bit operations with `DecodedInstruction` class
- Eliminate runtime `LuaOpcode.getFields()` calls

**Technical Details:**
```dart
class DecodedInstruction {
  final int op;
  final int a;
  final int b;
  final int c;
  
  factory DecodedInstruction.decode(int code) {
    return DecodedInstruction._(
      op: code & 0x3F,
      a: (code >> 6) & 0xFF,
      b: (code >> 14) & 0x1FF,
      c: (code >> 23) & 0x1FF,
    );
  }
}
```

**Results:**
- loop.lua: 9.6% improvement
- Reduced instruction dispatch overhead

### 5. Bitwise Operation Synchronization

**Implementation:**
- Implement BAND, BOR, BXOR, SHL, SHR operations with integer-only fast paths
- Synchronize unary operations (NEG, BNOT) as well

**Results:**
- 39% faster for arithmetic-heavy code (dedicated benchmark)

## Failed Optimizations

### 1. Opcode Analysis Cache

**Implementation:**
- Result caching with `static Map<int, OpFields> _opcodeFieldsCache`
- Reduce duplicate calculations in `LuaOpcode.getFields()`

**Results:**
- Performance degradation across all benchmarks (up to 37.5%)
- fibonacci: -7.9%, loop: -24.6%, table: -32.0%

**Failure Causes:**
- Map lookup overhead exceeds direct calculation cost
- Not optimized for Dart's small object access

### 2. LuaValue Object Pool

**Implementation:**
- Cache small integers (-5~50), floating-point numbers (0.0, 1.0, -1.0)
- Pool Lua keywords and short strings

**Results:**
- loop.lua: 25% performance degradation (0.216s → 0.270s)
- Minor degradation in other benchmarks

**Failure Causes:**
- `Map.putIfAbsent` overhead higher than new object creation
- Dart's GC already optimized for small short-lived objects

### 3. Stack Sharing Optimization

**Implementation:**
- Size-class based stack slot array pool with `SharedStackPool`
- Reduce stack copy overhead during upvalue processing

**Results:**
- fibonacci: +1.8% degradation (2.047s → 2.083s)
- table: +8.6% degradation (0.035s → 0.038s)

**Failure Causes:**
- Pool overhead (map lookups, size class calculations)
- Cannot compete with Dart's efficient memory management
- Complexity of upvalue safety management

### 4. Bytecode Optimization

**Implementation:**
- Remove duplicate MARK_RETURN instructions
- Dead code elimination and compile-time optimization

**Results:**
- Runtime error "no return mark"
- Bug with reversed order of multiple return values

**Failure Causes:**
- Underestimated complexity of Lua control flow
- Inappropriate optimization for functions with multiple return statements

### 5. Invoke Method Optimization

**Implementation:**
- Speed up metamethod search
- Function call inlining

**Results:**
- fibonacci: +3.5% degradation
- Only microscopic level changes

**Failure Causes:**
- Instruction cache misses due to increased code size
- Interference with Dart VM optimization

## Important Discoveries in Dart Environment

### 1. Small Objects and Memory Management
- **Dart GC Efficiency**: Processing of small short-lived objects already highly optimized
- **Object Pool Countereffect**: Long-lived objects worsen GC efficiency
- **Direct Creation Speed**: Direct creation of `LuaInteger()`, `LuaFloat()`, etc. faster than expected

### 2. Map Operation Costs
- **Lookup Overhead**: `Map.putIfAbsent` slower than simple constructors
- **Impact in Tight Loops**: Map access causes notable performance degradation in iterative processing
- **Cache Limitations**: No cache benefits for small objects

### 3. Async Processing Characteristics
- **Await Penalty**: `await` in simple operations has significant performance cost
- **Synchronization Benefits**: Processes that can execute synchronously should be aggressively synchronized
- **JIT Optimization**: Design that leverages Dart VM optimization is important

## Lessons and Future Guidelines

### 1. Language-Specific Optimization Strategies
- Common VM optimization techniques (object pools, memory pools) counterproductive in Dart
- "Common sense" optimizations without benchmark measurement are dangerous
- Need optimization with deep understanding of Dart runtime characteristics

### 2. Importance of Measurement-Driven Development
- All optimizations must be verified by measurement
- Flexibility to accept counter-intuitive results
- Ensure result stability through multiple measurements

### 3. Correctness First Priority
- Never sacrifice correctness for performance gains
- Strict maintenance of Lua semantics
- Importance of incremental implementation and testing

## Technical Details

### Test Environment
- **OS**: macOS (Darwin 23.6.0)
- **CPU**: Apple M2 Pro (ARM64)
- **RAM**: 32 GB
- **Dart**: 3.7.2 (stable)

### Benchmarks
- **fibonacci.lua**: Recursive Fibonacci sequence calculation (n=30)
- **loop.lua**: Simple numeric loop (1 billion iterations)
- **table.lua**: Comprehensive table operation test
- **string.lua**: String concatenation (10,000 characters)

### Eliminated Await Operations
- **Total**: 46 out of 57 synchronized (80% elimination rate)
- **Remaining**: Native functions, coroutines, metamethods, function calls (11)

## Conclusion

Through these optimizations, we significantly improved Tradaul VM performance. Particularly notable effects were achieved in arithmetic operations and table operations, with async overhead reduction being most effective.

On the other hand, many "common" optimization techniques proved ineffective in the Dart environment, highlighting the importance of optimization strategies that understand language-specific characteristics.

While the performance gap with standard Lua remains large (about 34x slower for fibonacci.lua), we achieved practical performance improvements and gained important insights for future improvements.