import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_state_entity.freezed.dart';

/// Immutable domain entity representing the current alarm state.
@freezed
abstract class AlarmStateEntity with _$AlarmStateEntity {
  const factory AlarmStateEntity({
    required AlarmStatus status,
    DateTime? scheduledAt,
    @Default(false) bool isDryRun,
    @Default(false) bool snoozeUsed,
    @Default(3) int remainingEmergencyOverrides,
    @Default(0) int relentlessCycleCount,
  }) = _AlarmStateEntity;
}
