import 'package:logging/logging.dart';

enum LuaLogLevel implements Comparable<LuaLogLevel> {
  fatal,
  error,
  warn,
  info,
  verbose,
  debug;

  String get name {
    switch (this) {
      case LuaLogLevel.fatal:
        return 'FATAL';
      case LuaLogLevel.error:
        return 'ERROR';
      case LuaLogLevel.warn:
        return 'WARN';
      case LuaLogLevel.info:
        return 'INFO';
      case LuaLogLevel.verbose:
        return 'VERBOSE';
      case LuaLogLevel.debug:
        return 'DEBUG';
    }
  }

  int get _value {
    switch (this) {
      case LuaLogLevel.fatal:
        return Level.SHOUT.value;
      case LuaLogLevel.error:
        return Level.SEVERE.value;
      case LuaLogLevel.warn:
        return Level.WARNING.value;
      case LuaLogLevel.info:
        return Level.INFO.value;
      case LuaLogLevel.verbose:
        return Level.FINE.value;
      case LuaLogLevel.debug:
        return Level.FINER.value;
    }
  }

  @override
  int compareTo(LuaLogLevel other) => _value.compareTo(other._value);
}

abstract class Log {
  static final _logger = _initLogger();

  static Logger _initLogger() {
    final logger = Logger('Lua');
    logger.onRecord.listen((record) {
      if (record.level.value < level._value) {
        return;
      }
      final message = '${record.time} [${level.name}] ${record.message}';
      onListen(message);
    });
    return logger;
  }

  static LuaLogLevel level = LuaLogLevel.warn;

  static void Function(String) onListen = print;

  static void fatal(String message) => _logger.shout(message);

  static void error(String message) => _logger.severe(message);

  static void warn(String message) => _logger.warning(message);

  static void info(String message) => _logger.info(message);

  static void verbose(String message) => _logger.fine(message);

  static void debug(String message) => _logger.finest(message);
}
