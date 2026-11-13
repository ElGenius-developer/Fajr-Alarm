import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_ringing_event.freezed.dart';

/// Events driving the [AlarmRingingBloc] state machine.
@freezed
sealed class AlarmRingingEvent with _$AlarmRingingEvent {
  const factory AlarmRingingEvent.preFajrLockEntered({
    required DateTime scheduledAt,
    @Default(false) bool isDryRun,
    @Default(3) int remainingEmergencyOverrides,
  }) = PreFajrLockEntered;

  const factory AlarmRingingEvent.alarmTriggered({
    DateTime? scheduledAt,
    @Default(false) bool isDryRun,
    @Default(3) int remainingEmergencyOverrides,
  }) = AlarmTriggered;

  const factory AlarmRingingEvent.snoozeRequested() = SnoozeRequested;

  const factory AlarmRingingEvent.snoozeTicked() = SnoozeTicked;

  const factory AlarmRingingEvent.relentlessTicked() = RelentlessTicked;

  const factory AlarmRingingEvent.challengeStarted() = ChallengeStarted;

  const factory AlarmRingingEvent.challengeRejected() = ChallengeRejected;

  const factory AlarmRingingEvent.challengeSucceeded() = ChallengeSucceeded;

  const factory AlarmRingingEvent.emergencyHoldStarted() = EmergencyHoldStarted;

  const factory AlarmRingingEvent.emergencyHoldTicked() = EmergencyHoldTicked;

  const factory AlarmRingingEvent.emergencyHoldReleased() =
      EmergencyHoldReleased;

  const factory AlarmRingingEvent.vacationFrozen() = VacationFrozen;

  const factory AlarmRingingEvent.vacationEnded() = VacationEnded;
}
