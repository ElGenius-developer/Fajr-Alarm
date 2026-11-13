import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../entities/vacation_mode_config.dart';
import '../repositories/settings_and_streak_repository.dart';
import 'pre_fajr_lock_window.dart';

/// Activates Vacation Mode for an explicit duration in days and applies Streak Freeze.
class ActivateVacationModeUseCase {
  const ActivateVacationModeUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, UserSettings>> call({
    required int durationDays,
    required DateTime now,
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (durationDays <= 0) {
      return const Left(
        Failure.validation(
          message: 'Vacation duration must be greater than 0 days.',
        ),
      );
    }

    if (isWithinPreFajrLockWindow(
      now: now,
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    )) {
      return const Left(
        Failure.lockWindow(
          message: 'Vacation Mode cannot be activated during the Pre-Fajr Lock Window.',
        ),
      );
    }

    final settingsResult = await _repository.getSettings();
    return settingsResult.fold(Left.new, (settings) async {
      final statsResult = await _repository.getStreakStats();
      return statsResult.fold(Left.new, (stats) async {
        final frozenResult = await _repository.saveStreakStats(
          stats.copyWith(isFrozen: true),
        );
        return frozenResult.fold(Left.new, (_) {
          final vacation = VacationModeConfig(
            startDate: now,
            durationDays: durationDays,
            endDate: now.add(Duration(days: durationDays)),
          );
          return _repository.saveSettings(
            settings.copyWith(vacationMode: vacation),
          );
        });
      });
    });
  }
}
