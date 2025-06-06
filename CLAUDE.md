# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tradaul is a Lua 5.4 interpreter implementation written in Dart, designed as a library for embedding in Dart/Flutter applications. The project is currently at version 0.7.0 and is work-in-progress with 73/145 Lua APIs implemented (50% coverage).

## Development Commands

### Build and Generation
- `make generate` - Run code generation for Freezed models (required after modifying AST classes)
- `make cli` - Compile standalone CLI executable to `bin/tradaul`
- `make format` - Format and fix code using dart fix and dart format
- `dart run build_runner build` - Alternative to make generate

### Testing
- `dart test` - Run all tests
- `dart test test/specific_test.dart` - Run specific test file
- `dart test test/language/` - Run tests in specific directory

#### Two Testing Methods
1. **Internal test suite**: Run tests in the `test/` directory using `dart test`
2. **Official Lua test suite**: Run lua-5.4.6-tests using the `tradaul` CLI command
   - Build the CLI with `make cli`
   - Not all tests will pass as some APIs are unsupported
   - If an API passes `dart test` but fails the official test suite, the internal test is likely incorrect
   - Refer to official Lua documentation and test suite code for corrections

### Linting
- `dart analyze` - Run static analysis (uses very_good_analysis)
- Code must pass strict linting rules; unawaited_futures are treated as errors

### CLI Usage
The `tradaul` CLI executable is built with `make cli` and outputs to `bin/tradaul`.

#### Command Line Usage
```bash
bin/tradaul [OPTIONS] [SCRIPT [ARGS]]
```

#### Options
- `-h, --help` - Display help message
- `--version` - Display the version of Tradaul
- `--verbose` - Enable verbose output
- `--debug` - Enable debug mode
- `-c, --syntax` - Check syntax only
- `-e, --execute <code>` - Pass string as source code
- `-i, --stdin` - Read source code from stdin

#### Examples
```bash
# Execute a Lua script file
bin/tradaul script.lua

# Execute Lua code directly
bin/tradaul -e "print('Hello, World!')"

# Read Lua code from stdin
echo "print('Hello from stdin')" | bin/tradaul -i

# Check syntax only
bin/tradaul -c script.lua

# Enable debug mode
bin/tradaul --debug script.lua
```

## Architecture

The codebase follows a clean 3-stage pipeline:

```
Lua Source → Parser → Compiler → Runtime
```

### Core Components

**Parser** (`lib/src/parser/`):
- Uses PetitParser grammar to convert Lua source to AST
- AST nodes are immutable using Freezed annotations
- Run `make generate` after modifying ast.dart

**Compiler** (`lib/src/compiler/`):
- Transforms AST into custom bytecode
- Handles Lua number/string literal parsing
- Outputs `CompiledCode` with instruction sequences

**Runtime** (`lib/src/runtime/`):
- `LuaContext` - Main API entry point and execution environment
- `LuaValues` - Complete Lua type system (nil, boolean, number, string, table, function, thread, userdata)
- `execution.dart` - Bytecode interpreter and virtual machine
- `LuaTable` - Lua table implementation with metamethods
- `thread.dart` - Coroutine support

**Lua Standard Library** (`lib/src/lua_lib/`):
- Modular implementation of Lua standard modules
- Each module can be selectively included via permissions

## Key Design Patterns

- **Result-based error handling**: Uses `result_dart` package instead of exceptions
- **Immutable data structures**: AST and core data types use Freezed
- **Asynchronous execution**: All execution methods return Futures
- **Security-first**: Built-in permissions system to restrict functionality
- **Platform abstraction**: Clean separation between platform-specific and generic code

## Testing Approach

- **Language compliance tests**: Verify Lua 5.4 compatibility in `test/language/`
- **Module tests**: Test each standard library module in `test/modules/`
- **Compiler tests**: Parser and compilation testing in `test/compiler/`
- Tests include Lua source files for integration testing

## API Usage Patterns

### Basic Execution
```dart
LuaContext context = await LuaContext.create();
LuaExecutionResult result = await context.execute(luaSource);
if (result.isSuccess()) {
  List<LuaValue> values = result.getOrThrow();
}
```

### Native Functions
```dart
Future<LuaCallResult?> nativeFunction(LuaContext context, LuaArguments arguments) async {
  // Implementation
  return LuaCallResult([LuaString('result')]);
}
```

## Important Constraints

- Only one `execute()` call can run at a time per context
- `LuaContext.invoke()` can only be called during an `execute()` call
- Bytecode is not compatible with standard Lua
- Garbage collection operations are not supported
- Weak reference tables are not supported

## Current Status (v0.7.0)

**Implemented**: Core language features, math module, partial string module, coroutines
**Not Implemented**: I/O module, debug module, garbage collection metamethods
**Partial**: String module (format/gsub complete, find has limitations)

The project prioritizes core language compliance over standard library completeness.