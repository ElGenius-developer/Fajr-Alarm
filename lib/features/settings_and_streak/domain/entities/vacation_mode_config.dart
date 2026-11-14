import 'package:freezed_annotation/freezed_annotation.dart';

part 'vacation_mode_config.freezed.dart';

/// Configuration for a scheduled Vacation Mode period with Streak Freeze.
@freezed
abstract class VacationModeConfig with _$VacationModeConfig {
  const VacationModeConfig._();

  const factory VacationModeConfig({
    required DateTime startDate,
    required int durationDays,
    required DateTime endDate,
  }) = _VacationModeConfig;

  /// Whether [now] falls within the active vacation window `[startDate, endDate)`.
  bool isActiveAt(DateTime now) =>
      !now.isBefore(startDate) && now.isBefore(endDate);
}
