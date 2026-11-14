import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/settings_and_streak_repository.dart';
import 'pre_fajr_lock_window.dart';

/// Cancels any active Dry-Run Alarm outside the Pre-Fajr Lock Window.
class CancelDryRunAlarmUseCase {
  const CancelDryRunAlarmUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, Unit>> call({
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
          message: 'Dry-run alarm cannot be cancelled during the Pre-Fajr Lock Window.',
        ),
      );
    }

    return _repository.cancelDryRunAlarm();
  }
}
