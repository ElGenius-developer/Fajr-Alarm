/// Abstract monotonic clock immune to manual wall-clock changes.
abstract interface class MonotonicClock {
  /// Monotonically increasing elapsed duration since clock initialization.
  Duration get elapsed;

  /// Monotonically increasing elapsed milliseconds.
  int get elapsedMilliseconds;
}

/// System implementation backed by Dart's monotonic [Stopwatch].
class SystemMonotonicClock implements MonotonicClock {
  SystemMonotonicClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  Duration get elapsed => _stopwatch.elapsed;

  @override
  int get elapsedMilliseconds => _stopwatch.elapsedMilliseconds;
}
