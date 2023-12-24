# Usage

## Basic Usage

To start using the Lua library, first create a `LuaContext`. This object represents the Lua execution environment. You
can create it using `LuaContext.create()`, which is an asynchronous operation, so ensure to use `await`:

```
LuaContext context = await LuaContext.create();
```

To execute Lua source code, use the `execute` method. Remember, this method is also asynchronous:

```
LuaExecutionResult result = await context.execute(source);
```

Note that `execute` can only run one source code at a time. Parallel execution of multiple sources is not possible.
The `execute` method returns a `LuaExecutionResult` object, which contains the execution results. This `Result` object
is part of the [`result_dart` package](https://pub.dev/packages/result_dart). It includes the returned values (if any)
from the last `return` statement in
the
form of
a `List<LuaValue>`. In case of errors, it contains an exception with a stack trace.

### Stopping Execution

WIP

## Runtime Options

Use `LuaContextOptions` to configure the execution environment. These options include setting security options, module
search paths, and redirecting standard input and output.

## Security Options

Security options are available through `LuaPermissions` and `LuaLibraryPermissions`. These options allow you to limit
functionalities that could potentially affect the application or platform. For instance, you can enable or disable
specific modules. The implementation of these options is ongoing.

## Lua Value Representation

Lua values are represented by `LuaValue` objects. These objects reflect different Lua data types:

- `LuaBoolean` (bool), `LuaNumber` (number), `LuaInteger` (integer), `LuaFloat` (float), `LuaString` (
  string), `LuaTable` (table), `LuaFunction` (function)
- `LuaFunction` can represent both Lua source-defined functions and Dart-implemented native functions.
- `LuaEnvironment` represents the Lua global environment, managing global variables and metatables.

## Runtime Errors and Stack Traces

During execution, if an error occurs, `execute` returns a `LuaExceptionContext`. This context contains information about
the error and its stack trace.

## Standard Input/Output and Error

Standard input, output, and error streams can be redirected using `Stream` and `StreamSink`. These can be modified
using `LuaSystem`.

## Native Modules and Functions

To create a module, add functions to a table and then add this table to the global environment (`LuaEnvironment`).
Native functions are implemented as follows:

- Implement a function with the signature `Future<LuaCallResult?> Function(LuaContext context, LuaArguments arguments)`.
- Return multiple `LuaValue` results. Returning `null` implies no return value (empty list).
- Use `LuaTable.addNativeCalls` to add native functions to a table.

Invoking Lua functions requires creating a `LuaInvocation` and executing it with `LuaContext.invoke`.
Be aware that `LuaContext.invoke` can only be executed during an `execute` call.

To handle Dart values within Lua, wrap them using `LuaCustomValue`. This enables the integration of Dart data types and
structures into the Lua scripting environment, allowing for seamless interaction between Dart and Lua.

```
// create custom value
LuaCustomValue<Userdata> customValue = LuaCustomValue(userdata);

// get custom value
Userdata userdata = (luaValue as LuaCustomValue<Userdata>).value;
```

## Tradaul-Specific Lua APIs

- `platform` module: platform information accessible through `dart.io`.
