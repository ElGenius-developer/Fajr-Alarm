import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_ringing_state.freezed.dart';

/// Immutable UI state for the Alarm Ringing flow.
@freezed
abstract class AlarmRingingState with _$AlarmRingingState {
  const factory AlarmRingingState({
    required AlarmStateEntity entity,
    @Default(0) int snoozeRemainingSeconds,
    @Default(0) int emergencyHoldElapsedSeconds,
    @Default(false) bool isEmergencyMuted,
    @Default(false) bool emergencyReleasedEarly,
    Failure? failure,
  }) = _AlarmRingingState;
}
