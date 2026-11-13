import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/settings_and_streak_repository.dart';
import 'pre_fajr_lock_window.dart';

/// Schedules a 10-second Dry-Run Alarm outside the Pre-Fajr Lock Window.
class TriggerDryRunAlarmUseCase {
  const TriggerDryRunAlarmUseCase(this._repository);

  static const Duration dryRunDelay = Duration(seconds: 10);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, DateTime>> call({
    required DateTime now,
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (isWithinPreFajrLockWindow(
      now: now,
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    )) {
      return const Left(
        Failure.lockWindow(
          message: 'Dry-run alarm cannot be triggered during the Pre-Fajr Lock Window.',
        ),
      );
    }

    final scheduledAt = now.add(dryRunDelay);
    final result = await _repository.scheduleDryRunAlarm(
      scheduledAt: scheduledAt,
    );
    return result.map((_) => scheduledAt);
  }
}
