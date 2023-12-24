import 'dart:async';

import 'package:file/file.dart';
import 'package:file/memory.dart';

// TODO

Stream<List<int>> getDefaultStdin() {
  throw UnimplementedError();
}

StreamSink<List<int>> getDefaultStdout() {
  throw UnimplementedError();
}

StreamSink<List<int>> getDefaultStderr() {
  throw UnimplementedError();
}

String getLineTerminator() {
  throw UnimplementedError();
}

FileSystem basicCreateFileSystem() {
  return MemoryFileSystem();
}
