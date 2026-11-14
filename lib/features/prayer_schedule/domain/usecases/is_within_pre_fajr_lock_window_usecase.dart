import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fpdart/fpdart.dart';

/// Checks whether the current time falls inside the Pre-Fajr Lock Window (FR-5.4):
/// starting 30 minutes before [alarmTime] (`T - 30m`) until the challenge is completed.
class IsWithinPreFajrLockWindowUseCase {
  const IsWithinPreFajrLockWindowUseCase();

  /// Duration before the Fajr alarm when edits and Vacation Mode are locked.
  static const Duration lockWindowDuration = Duration(minutes: 30);

  /// Evaluates lock status using either an injected [now] timestamp or a
  /// tamper-resistant [clock] anchored at [referenceTime] / [referenceElapsed].
  Either<Failure, bool> call({
    required DateTime? alarmTime,
    DateTime? now,
    MonotonicClock? clock,
    DateTime? referenceTime,
    Duration referenceElapsed = Duration.zero,
    bool isChallengePending = false,
  }) {
    if (isChallengePending) {
      return const Right(true);
    }

    if (alarmTime == null) {
      return const Right(false);
    }

    final effectiveNow = _resolveEffectiveNow(
      now: now,
      clock: clock,
      referenceTime: referenceTime,
      referenceElapsed: referenceElapsed,
    );

    final lockStart = alarmTime.subtract(lockWindowDuration);
    final isWithinWindow =
        !effectiveNow.isBefore(lockStart) && effectiveNow.isBefore(alarmTime);
    return Right(isWithinWindow);
  }

  DateTime _resolveEffectiveNow({
    required DateTime? now,
    required MonotonicClock? clock,
    required DateTime? referenceTime,
    required Duration referenceElapsed,
  }) {
    if (now != null) {
      return now;
    }
    if (clock != null && referenceTime != null) {
      final delta = clock.elapsed - referenceElapsed;
      return referenceTime.add(delta.isNegative ? Duration.zero : delta);
    }
    return DateTime.now();
  }
}
