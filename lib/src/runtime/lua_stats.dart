final class LuaStatistics {
  LuaStatistics() {
    startTime = DateTime.now();
  }

  late final DateTime startTime;

  int get elapsedTime {
    final now = DateTime.now();
    return now.difference(startTime).inMilliseconds;
  }
}
