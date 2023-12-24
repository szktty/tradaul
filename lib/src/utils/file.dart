import 'dart:convert';
import 'dart:io';

import 'package:result_dart/result_dart.dart';

abstract class FileUtils {
  static bool exists(String path) => File(path).existsSync();

  static const List<Encoding> defaultEncodings = [utf8, ascii, latin1];

  static Result<String, String> read(
    String path, {
    List<Encoding>? encodings,
  }) {
    final encodings1 = encodings ?? defaultEncodings;
    final file = File(path);
    try {
      if (!file.existsSync()) {
        return Failure('No such file or directory: $path');
      }
    } on Exception catch (e) {
      return Failure(e.toString());
    }

    for (final encoding in encodings1) {
      try {
        final contents = file.readAsStringSync(encoding: encoding);
        return Success(contents);
      } on Exception {
        continue;
      }
    }

    return Failure('Failed to load file: $path');
  }
}
