import 'dart:async';
import 'dart:convert';

// ignore_for_file: ambiguous_import

import 'package:file/file.dart';
import 'package:tradaul/src/runtime/lua_system/lua_system_stub.dart'
    if (dart.library.io) 'package:tradaul/src/runtime/lua_system/lua_system_native.dart'
    if (dart.library.html) 'package:tradaul/src/runtime/lua_system/lua_system_web.dart';

final class LuaSystem {
  LuaSystem({
    Stream<List<int>>? stdin,
    StreamSink<List<int>>? stdout,
    StreamSink<List<int>>? stderr,
    String? lineTerminator,
  }) {
    this.stdin = stdin ?? getDefaultStdin();
    this.stdout = stdout ?? getDefaultStdout();
    this.stderr = stderr ?? getDefaultStderr();
    this.lineTerminator = lineTerminator ?? getLineTerminator();
  }

  static final LuaSystem shared = LuaSystem();

  late final Stream<List<int>> stdin;
  late final StreamSink<List<int>> stdout;
  late final StreamSink<List<int>> stderr;
  late final String lineTerminator;

  void write(String message) {
    stdout.add(utf8.encode(message));
  }

  void writeLine(String message) {
    write('$message$lineTerminator');
  }

  void error(String message) {
    stderr.add(utf8.encode(message));
  }

  void errorLine(String message) {
    error('$message$lineTerminator');
  }

  FileSystem createFileSystem() {
    return basicCreateFileSystem();
  }
}
