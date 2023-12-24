import 'dart:async';
import 'dart:io';

import 'package:file/file.dart';
import 'package:file/local.dart';

Stream<List<int>> getDefaultStdin() {
  return stdin;
}

StreamSink<List<int>> getDefaultStdout() {
  return stdout;
}

StreamSink<List<int>> getDefaultStderr() {
  return stderr;
}

String getLineTerminator() {
  return Platform.lineTerminator;
}

FileSystem basicCreateFileSystem() {
  return const LocalFileSystem();
}
