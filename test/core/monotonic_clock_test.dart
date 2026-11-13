import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SystemMonotonicClock', () {
    test('elapsed and elapsedMilliseconds are non-negative and monotonic', () {
      final clock = SystemMonotonicClock();
      final first = clock.elapsedMilliseconds;
      final second = clock.elapsedMilliseconds;

      expect(first, greaterThanOrEqualTo(0));
      expect(second, greaterThanOrEqualTo(first));
      expect(clock.elapsed.inMilliseconds, greaterThanOrEqualTo(first));
    });
  });
}
