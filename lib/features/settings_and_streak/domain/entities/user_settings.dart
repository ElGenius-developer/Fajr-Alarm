import 'package:freezed_annotation/freezed_annotation.dart';

import 'vacation_mode_config.dart';

part 'user_settings.freezed.dart';

/// Persisted user preferences and alarm configuration.
@freezed
abstract class UserSettings with _$UserSettings {
  const UserSettings._();

  const factory UserSettings({
    @Default('ar') String locale,
    @Default(3) int monthlyEmergencyQuota,
    @Default(0) int emergencyQuotaUsed,
    @Default(0) int emergencyQuotaResetMonth,
    String? bathroomBarcode,
    @Default(0) int alarmOffsetMinutes,
    int? manualAlarmHour,
    int? manualAlarmMinute,
    VacationModeConfig? vacationMode,
  }) = _UserSettings;

  /// Remaining emergency overrides for the current month.
  int get remainingEmergencyQuota {
    final remaining = monthlyEmergencyQuota - emergencyQuotaUsed;
    return remaining < 0 ? 0 : remaining;
  }

  /// Whether a manual fixed alarm time is configured instead of Adhan offset.
  bool get hasManualAlarmTime =>
      manualAlarmHour != null && manualAlarmMinute != null;
}
