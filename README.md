# [WIP] Tradaul

Tradaul is an implementation of Lua as library in Dart.

## Features

- Based on Lua 5.4
- Define Lua Functions and Modules in Dart: Offers the flexibility to define custom Lua functions and modules directly
  in Dart
- Customizable Standard Input/Output: Allows customization of standard input and output sources, providing flexibility
  for various use cases
- Security Options: Implement security options to restrict the functionality of the processing system and prevent
  operations that could unintentionally affect the behavior of the application

## Compatibility

This implementation is based on Lua 5.4 with the following compatibility details:

- Integer Size: 64-bit
- Floating-Point Numbers: 64-bit; rounding depends on Dart's handling
- Maximum Depth for Long Comments and Strings: Limited to 10
- Garbage Collection Operations: Not supported
    - `collectgarbage` has no effect
    - The `__gc` metamethod is not supported
- C API: Not supported
- Weak Reference Tables: Not supported
    - The `__mode` metamethod is not supported
- Bytecode Compatibility: Not compatible with standard Lua

## API Implementation Status

See [API_STATUS.md](API_STATUS.md)

## Installation

To install the Tradaul library, add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  tradaul:
    git:
      url: https://github.com/szktty/tradaul
```

## Running as a Standalone

For the purpose of testing and verification, the library can be run in a standalone mode.
It's important to note that this mode is not intended for actual production use.

To build the standalone version, use the following command:

```bash
make cli
```

This will compile the library and output the binary to `bin/tradaul`. You can then execute this binary to run the
library in a standalone mode for testing and development purposes.

### Command Line Usage

```bash
tradaul [OPTIONS] [SCRIPT [ARGS]]
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

Execute a Lua script file:
```bash
tradaul script.lua
```

Execute Lua code directly:
```bash
tradaul -e "print('Hello, World!')"
```

Read Lua code from stdin:
```bash
echo "print('Hello from stdin')" | tradaul -i
```

Check syntax only:
```bash
tradaul -c script.lua
```

Enable debug mode:
```bash
tradaul --debug script.lua
```

## Usage

See [USAGE.md](USAGE.md)

## Examples

See [examples](examples). `playground` requires Flutter.

## License

Apache 2.0

## Author

SUZUKI Tetsuya <tetsuya.suzuki@gmail.com>