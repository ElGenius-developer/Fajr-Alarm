import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_and_streak_repository.dart';
import 'pre_fajr_lock_window.dart';

/// Validates and persists [UserSettings], enforcing the `T - 30m` Pre-Fajr Lock Window.
class UpdateSettingsUseCase {
  const UpdateSettingsUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, UserSettings>> call({
    required UserSettings newSettings,
    required DateTime now,
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final validationError = _validate(newSettings);
    if (validationError != null) {
      return Left(Failure.validation(message: validationError));
    }

    final currentResult = await _repository.getSettings();
    return currentResult.fold(Left.new, (current) async {
      final locked = isWithinPreFajrLockWindow(
        now: now,
        nextFajrAlarmAt: nextFajrAlarmAt,
        isAlarmRinging: isAlarmRinging,
      );
      if (locked && _modifiesLockedField(current, newSettings)) {
        return const Left(
          Failure.lockWindow(
            message: 'Alarm time, emergency quota, and vacation mode are locked within 30 minutes before Fajr.',
          ),
        );
      }
      return _repository.saveSettings(newSettings);
    });
  }

  String? _validate(UserSettings settings) {
    if (settings.locale != 'ar' && settings.locale != 'en') {
      return 'Unsupported locale: ${settings.locale}';
    }
    if (settings.monthlyEmergencyQuota < 0) {
      return 'Monthly emergency quota cannot be negative.';
    }
    if (settings.manualAlarmHour != null &&
        (settings.manualAlarmHour! < 0 || settings.manualAlarmHour! > 23)) {
      return 'Manual alarm hour must be between 0 and 23.';
    }
    if (settings.manualAlarmMinute != null &&
        (settings.manualAlarmMinute! < 0 || settings.manualAlarmMinute! > 59)) {
      return 'Manual alarm minute must be between 0 and 59.';
    }
    return null;
  }

  bool _modifiesLockedField(UserSettings current, UserSettings next) {
    return current.alarmOffsetMinutes != next.alarmOffsetMinutes ||
        current.manualAlarmHour != next.manualAlarmHour ||
        current.manualAlarmMinute != next.manualAlarmMinute ||
        current.monthlyEmergencyQuota != next.monthlyEmergencyQuota ||
        current.vacationMode != next.vacationMode ||
        current.bathroomBarcode != next.bathroomBarcode;
  }
}
