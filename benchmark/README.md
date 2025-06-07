# Tradaul Performance Benchmarks

This directory contains benchmark files for measuring the performance of the Tradaul Lua interpreter.

## Benchmark Types

### Individual Benchmarks

- `fibonacci.lua` - Recursive function call performance (function call overhead)
- `loop.lua` - Loop and basic arithmetic operation performance
- `table.lua` - Table read/write performance
- `string.lua` - String concatenation operation performance

### Combined Benchmark

- `all.lua` - Run all benchmarks at once

## How to Run

### Prerequisites

Build the CLI:

```bash
# From project root
make cli
```

### Running Individual Benchmarks

```bash
# Fibonacci benchmark
bin/tradaul benchmark/fibonacci.lua

# Loop benchmark
bin/tradaul benchmark/loop.lua

# Table benchmark
bin/tradaul benchmark/table.lua

# String benchmark
bin/tradaul benchmark/string.lua
```

### Running All Benchmarks

```bash
bin/tradaul benchmark/all.lua
```

## Comparison with Standard Lua

You can run the same benchmarks with standard Lua for performance comparison:

```bash
# Tradaul
bin/tradaul benchmark/all.lua

# Standard Lua (for comparison)
lua benchmark/all.lua
```

## Example Benchmark Results

### Tradaul (v0.7.0)
```
=== Fibonacci Test ===
fib(30) = 832040 in 3.8930001258850098 seconds

=== Loop Test ===
Loop sum = 1000000000000 in 1.0829999446868896 seconds

=== Table Test ===
Table operations in 0.1510000228881836 seconds

=== String Test ===
String concat (10000 chars) in 0.0070002079010009766 seconds
```

### Standard Lua (Reference)
```
=== Fibonacci Test ===
fib(30) = 832040 in 0.048284 seconds

=== Loop Test ===
Loop sum = 1000000000000 in 0.010749 seconds

=== Table Test ===
Table operations in 0.002191 seconds

=== String Test ===
String concat (10000 chars) in 0.001916 seconds
```

## Tracking Performance Improvements

When optimizing the VM, run these benchmarks to quantitatively measure improvement effects.

Key performance aspects measured by each benchmark:

- **fibonacci.lua**: Function call and stack operation overhead
- **loop.lua**: Basic arithmetic operations and loop control efficiency
- **table.lua**: Table access and hash operation performance
- **string.lua**: String operations and memory management efficiency