# Lua API Support and Implementation Status

## Coverage

- Total API 145
- Implemented 73 (50%)
- Unimplemented 64 (44%)
- Not supported 8 (6%)

## Table

- **✅**: Implemented and should work as expected
- **(Blank)**: Not yet implemented
- **❌**: Not supported and there are no plans to implement it
- **⚠**: Implemented but with certain limitations, or if the implementation deviates from the standard Lua
  specification

| API                     | Status | Note                                                         |
|-------------------------|--------|--------------------------------------------------------------|
| `_G`                    | ✅      |                                                              |
| `_VERSION`              | ✅      |                                                              |
| `assert`                | ✅      |                                                              |
| `collectgarbage`        | ⚠      | Prepared but does nothing as GC operations are not supported |
| `dofile`                | ✅      |                                                              |
| `error`                 | ✅      |                                                              |
| `getmetatable`          | ✅      |                                                              |
| `ipairs`                | ✅      |                                                              |
| `load`                  | ✅      |                                                              |
| `loadfile`              | ✅      |                                                              |
| `next`                  | ✅      |                                                              |
| `pairs`                 | ✅      |                                                              |
| `pcall`                 | ✅      |                                                              |
| `print`                 | ✅      |                                                              |
| `rawequal`              | ✅      |                                                              |
| `rawget`                | ✅      |                                                              |
| `rawlen`                | ✅      |                                                              |
| `rawset`                | ✅      |                                                              |
| `require`               | ✅      |                                                              |
| `select`                | ✅      |                                                              |
| `setmetatable`          | ✅      |                                                              |
| `tonumber`              | ✅      |                                                              |
| `tostring`              | ✅      |                                                              |
| `type`                  | ✅      |                                                              |
| `xpcall`                | ✅      |                                                              |
| `coroutine.create`      | ✅      |                                                              |
| `coroutine.isyieldable` | ✅      |                                                              |
| `coroutine.resume`      | ✅      |                                                              |
| `coroutine.running`     | ✅      |                                                              |
| `coroutine.status`      | ✅      |                                                              |
| `coroutine.wrap`        | ✅      |                                                              |
| `coroutine.yield`       | ✅      |                                                              |
| `debug.debug`           | ❌      |                                                              |
| `debug.gethook`         |        |                                                              |
| `debug.getinfo`         |        |                                                              |
| `debug.getlocal`        | ❌      |                                                              |
| `debug.getmetatable`    |        |                                                              |
| `debug.getregistry`     | ❌      |                                                              |
| `debug.getupvalue`      | ❌      |                                                              |
| `debug.getuservalue`    |        |                                                              |
| `debug.sethook`         | ❌      |                                                              |
| `debug.setlocal`        |        |                                                              |
| `debug.setmetatable`    |        |                                                              |
| `debug.setupvalue`      | ❌      |                                                              |
| `debug.setuservalue`    |        |                                                              |
| `debug.traceback`       |        |                                                              |
| `debug.upvalueid`       | ❌      |                                                              |
| `debug.upvaluejoin`     | ❌      |                                                              |
| `io.close`              |        |                                                              |
| `io.flush`              |        |                                                              |
| `io.input`              |        |                                                              |
| `io.lines`              |        |                                                              |
| `io.open`               |        |                                                              |
| `io.output`             |        |                                                              |
| `io.popen`              |        |                                                              |
| `io.read`               |        |                                                              |
| `io.stderr`             |        |                                                              |
| `io.stdin`              |        |                                                              |
| `io.stdout`             |        |                                                              |
| `io.tmpfile`            |        |                                                              |
| `io.type`               |        |                                                              |
| `io.write`              |        |                                                              |
| `file:close`            |        |                                                              |
| `file:flush`            |        |                                                              |
| `file:lines`            |        |                                                              |
| `file:read`             |        |                                                              |
| `file:seek`             |        |                                                              |
| `file:setvbuf`          |        |                                                              |
| `file:write`            |        |                                                              |
| `math.abs`              | ✅      |                                                              |
| `math.acos`             | ✅      |                                                              |
| `math.asin`             | ✅      |                                                              |
| `math.atan`             | ✅      |                                                              |
| `math.ceil`             | ✅      |                                                              |
| `math.cos`              | ✅      |                                                              |
| `math.deg`              | ✅      |                                                              |
| `math.exp`              | ✅      |                                                              |
| `math.floor`            | ✅      |                                                              |
| `math.fmod`             | ✅      |                                                              |
| `math.huge`             | ✅      |                                                              |
| `math.log`              | ✅      |                                                              |
| `math.max`              | ✅      |                                                              |
| `math.maxinteger`       | ✅      |                                                              |
| `math.min`              | ✅      |                                                              |
| `math.mininteger`       | ✅      |                                                              |
| `math.modf`             | ✅      |                                                              |
| `math.pi`               | ✅      |                                                              |
| `math.rad`              | ✅      |                                                              |
| `math.random`           | ⚠      | 128 bit seed is not supported                                |
| `math.randomseed`       | ⚠      | 128 bit seed is not supported                                |
| `math.sin`              | ✅      |                                                              |
| `math.sqrt`             | ✅      |                                                              |
| `math.tan`              | ✅      |                                                              |
| `math.tointeger`        | ✅      |                                                              |
| `math.type`             | ✅      |                                                              |
| `math.ult`              | ✅      |                                                              |
| `os.clock`              |        |                                                              |
| `os.date`               |        |                                                              |
| `os.difftime`           |        |                                                              |
| `os.execute`            |        |                                                              |
| `os.exit`               |        |                                                              |
| `os.getenv`             |        |                                                              |
| `os.remove`             |        |                                                              |
| `os.rename`             |        |                                                              |
| `os.setlocale`          |        |                                                              |
| `os.time`               |        |                                                              |
| `os.tmpname`            |        |                                                              |
| `package.config`        | ✅      |                                                              |
| `package.cpath`         | ⚠      | Not used                                                     |
| `package.loaded`        | ✅      |                                                              |
| `package.loadlib`       | ✅      |                                                              |
| `package.path`          | ✅      |                                                              |
| `package.preload`       | ✅      |                                                              |
| `package.searchers`     | ✅      |                                                              |
| `package.searchpath`    | ✅      |                                                              |
| `string.byte`           |        |                                                              |
| `string.char`           |        |                                                              |
| `string.dump`           |        |                                                              |
| `string.find`           | ⚠      | partial match is not yet implemented                         |
| `string.format`         | ✅      |                                                              |
| `string.gmatch`         |        |                                                              |
| `string.gsub`           | ✅      |                                                              |
| `string.len`            |        |                                                              |
| `string.lower`          |        |                                                              |
| `string.match`          |        |                                                              |
| `string.pack`           |        |                                                              |
| `string.packsize`       |        |                                                              |
| `string.rep`            |        |                                                              |
| `string.reverse`        |        |                                                              |
| `string.sub`            |        |                                                              |
| `string.unpack`         |        |                                                              |
| `string.upper`          |        |                                                              |
| `table.concat`          |        |                                                              |
| `table.insert`          | ✅      |                                                              |
| `table.move`            |        |                                                              |
| `table.pack`            |        |                                                              |
| `table.remove`          | ✅      |                                                              |
| `table.sort`            |        |                                                              |
| `table.unpack`          | ✅      |                                                              |
| `utf8.char`             |        |                                                              |
| `utf8.charpattern`      |        |                                                              |
| `utf8.codepoint`        |        |                                                              |
| `utf8.codes`            |        |                                                              |
| `utf8.len`              |        |                                                              |
| `utf8.offset`           |        |                                                              |
