import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/is_within_pre_fajr_lock_window_usecase.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeMonotonicClock implements MonotonicClock {
  Duration currentElapsed = Duration.zero;

  @override
  Duration get elapsed => currentElapsed;

  @override
  int get elapsedMilliseconds => currentElapsed.inMilliseconds;
}

void main() {
  late IsWithinPreFajrLockWindowUseCase useCase;

  setUp(() {
    useCase = const IsWithinPreFajrLockWindowUseCase();
  });

  group('IsWithinPreFajrLockWindowUseCase', () {
    final alarmTime = DateTime(2026, 5, 1, 4, 30);

    test('returns false 31 minutes before alarmTime', () {
      final result = useCase(
        alarmTime: alarmTime,
        now: DateTime(2026, 5, 1, 3, 59),
      );

      expect(result.getOrElse((_) => true), isFalse);
    });

    test('returns true exactly at T - 30m boundary', () {
      final result = useCase(
        alarmTime: alarmTime,
        now: DateTime(2026, 5, 1, 4, 0),
      );

      expect(result.getOrElse((_) => false), isTrue);
    });

    test('returns true 1 minute before alarmTime', () {
      final result = useCase(
        alarmTime: alarmTime,
        now: DateTime(2026, 5, 1, 4, 29),
      );

      expect(result.getOrElse((_) => false), isTrue);
    });

    test('returns true while challenge is pending even after alarmTime', () {
      final result = useCase(
        alarmTime: alarmTime,
        now: DateTime(2026, 5, 1, 4, 35),
        isChallengePending: true,
      );

      expect(result.getOrElse((_) => false), isTrue);
    });

    test(
      'returns false when alarmTime is null and no challenge is pending',
      () {
        final result = useCase(alarmTime: null);

        expect(result.getOrElse((_) => true), isFalse);
      },
    );

    test('uses MonotonicClock to resist wall-clock manipulation', () {
      final clock = FakeMonotonicClock();
      final referenceTime = DateTime(2026, 5, 1, 3, 50); // T - 40m

      expect(
        useCase(
          alarmTime: alarmTime,
          clock: clock,
          referenceTime: referenceTime,
        ).getOrElse((_) => true),
        isFalse,
      );

      // 15 monotonic minutes elapse -> effective time is 4:05 (within T - 30m)
      clock.currentElapsed = const Duration(minutes: 15);
      expect(
        useCase(
          alarmTime: alarmTime,
          clock: clock,
          referenceTime: referenceTime,
        ).getOrElse((_) => false),
        isTrue,
      );
    });

    test('tracks elapsed time accurately with fake_async', () {
      fakeAsync((async) {
        final referenceTime = DateTime(2026, 5, 1, 3, 55); // T - 35m
        final fakeClock = FakeMonotonicClock();

        expect(
          useCase(
            alarmTime: alarmTime,
            clock: fakeClock,
            referenceTime: referenceTime,
          ).getOrElse((_) => true),
          isFalse,
        );

        Future<void>.delayed(const Duration(minutes: 6), () {
          fakeClock.currentElapsed = const Duration(minutes: 6);
        });
        async.elapse(const Duration(minutes: 6));

        expect(
          useCase(
            alarmTime: alarmTime,
            clock: fakeClock,
            referenceTime: referenceTime,
          ).getOrElse((_) => false),
          isTrue,
        );
      });
    });
  });
}
