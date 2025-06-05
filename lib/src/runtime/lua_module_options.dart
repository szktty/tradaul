import 'package:fixnum/fixnum.dart';
import 'package:result_dart/result_dart.dart';
import 'package:tradaul/src/runtime/lua_values.dart';

final class LuaOsModuleOptions {
  LuaOsModuleOptions({
    this.clock,
    this.setLocale,
    this.getEnvironmentVariable,
    this.time,
    this.format,
    this.utcDateTime,
    this.timeDifference,
    this.removeFile,
    this.renameFileOrDirectory,
    this.temporaryFileName,
    this.exit,
    this.execute,
    this.shellIsAvailable,
  });

  final Future<Result<double>> Function()? clock;

  // os.setlocale
  final Future<Result<String>> Function(
    String locale,
    LuaLocaleCategory category,
  )? setLocale;

  // os.getenv
  final Future<Result<String>>? Function(String name)?
      getEnvironmentVariable;

  // os.time
  final Future<Result<Int64>> Function(LuaOsDateTime? localDateTime)?
      time;

  // os.date
  final Future<
          Result<
              ({
                String string,
                LuaOsDateTime dateTime,
              })>>
      Function(
    String format,
    LuaOsDateTime dateTime, {
    required bool utc,
  })? format;

  final Future<Result<LuaOsDateTime>> Function(
    LuaOsDateTime? localDateTime,
  )? utcDateTime;

  // os.difftime
  final Future<Result<Int64>> Function(Int64 t2, Int64 t1)?
      timeDifference;

  // os.remove
  final Future<ResultDart<void, LuaOsError>> Function(String name)? removeFile;

  // os.rename
  final Future<ResultDart<void, LuaOsError>> Function(
    String oldName,
    String newName,
  )? renameFileOrDirectory;

  // os.tmpname
  final Future<Result<String>> Function()? temporaryFileName;

  // os.exit
  final Future<Result<bool>> Function({bool? status, int? code})?
      exit;

  // os.execute(command)
  final Future<Result<LuaOsExecutionStatus>> Function(
    String command,
  )? execute;

  // os.execute()
  final Future<Result<LuaOsExecutionStatus>> Function(
    String command,
  )? shellIsAvailable;
}

final class LuaOsError {
  const LuaOsError(this.message, this.code);

  final String message;
  final int code;
}

final class LuaOsExecutionStatus {
  const LuaOsExecutionStatus({required this.success, this.code, this.signal});

  final bool success;
  final int? code;
  final int? signal;
}

final class LuaOsDateTime {
  LuaOsDateTime({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 12,
    this.minute = 0,
    this.second = 0,
    this.dst,
    this.utc = false,
  });

  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final bool? dst;
  final bool utc;
}

enum LuaLocaleCategory {
  all,
  collate,
  ctype,
  monetary,
  numeric,
  time,
}

final class LuaIoModuleOptions {
  LuaIoModuleOptions({
    this.open,
    this.close,
    this.popen,
    this.read,
    this.write,
    this.flush,
    this.seek,
    this.setBufferingMode,
  });

  Future<Result<Object>> Function(String path, String? mode)? open;
  Future<Result<Object>> Function(Object file)? close;
  Future<Result<Object>> Function(String program, String? mode)?
      popen;
  Future<Result<List<LuaValue>>> Function(
    Object file,
    List<String> formats,
  )? read;
  Future<Result<void>> Function(Object file, Object data)? write;
  Future<Result<void>> Function(Object file)? flush;
  Future<Result<List<int>>> Function(
    Object file,
    String whence,
    int offset,
  )? seek;

  Future<Result<List<int>>> Function(
    Object file,
    String mode,
    int size,
  )? setBufferingMode;
}
