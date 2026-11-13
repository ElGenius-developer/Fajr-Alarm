import 'dart:async';

import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/emergency_override_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/start_relentless_ringing_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives the Fajr-Alarm state machine using a [MonotonicClock] (FR-02, FR-05, FR-6.2).
class AlarmRingingBloc extends Bloc<AlarmRingingEvent, AlarmRingingState> {
  AlarmRingingBloc({
    required this._clock,
    required this._platformRepository,
    required this._snoozeAlarmUseCase,
    required this._startRelentlessRingingUseCase,
    required this._emergencyOverrideUseCase,
    required this._completeAlarmUseCase,
    AlarmStateEntity initialEntity = const AlarmStateEntity(
      status: AlarmStatus.idle,
    ),
  }) : super(AlarmRingingState(entity: initialEntity)) {
    on<PreFajrLockEntered>(_onPreFajrLockEntered);
    on<AlarmTriggered>(_onAlarmTriggered);
    on<SnoozeRequested>(_onSnoozeRequested);
    on<SnoozeTicked>(_onSnoozeTicked);
    on<RelentlessTicked>(_onRelentlessTicked);
    on<ChallengeStarted>(_onChallengeStarted);
    on<ChallengeRejected>(_onChallengeRejected);
    on<ChallengeSucceeded>(_onChallengeSucceeded);
    on<EmergencyHoldStarted>(_onEmergencyHoldStarted);
    on<EmergencyHoldTicked>(_onEmergencyHoldTicked);
    on<EmergencyHoldReleased>(_onEmergencyHoldReleased);
    on<VacationFrozen>(_onVacationFrozen);
    on<VacationEnded>(_onVacationEnded);
  }

  static const Duration snoozeDuration = Duration(minutes: 5);
  static const Duration relentlessInterval = Duration(minutes: 1);
  static const Duration emergencyHoldDuration = Duration(seconds: 60);
  static const Duration initialIgnoreEscalationDuration = Duration(seconds: 60);

  final MonotonicClock _clock;
  final AlarmPlatformRepository _platformRepository;
  final SnoozeAlarmUseCase _snoozeAlarmUseCase;
  final StartRelentlessRingingUseCase _startRelentlessRingingUseCase;
  final EmergencyOverrideUseCase _emergencyOverrideUseCase;
  final CompleteAlarmUseCase _completeAlarmUseCase;

  Timer? _initialIgnoreTimer;
  Timer? _snoozeTimer;
  Timer? _relentlessTimer;
  Timer? _emergencyTimer;

  Duration _initialRingStartElapsed = Duration.zero;
  Duration _snoozeStartElapsed = Duration.zero;
  Duration _relentlessLastRingElapsed = Duration.zero;
  Duration _emergencyStartElapsed = Duration.zero;

  void _onPreFajrLockEntered(
    PreFajrLockEntered event,
    Emitter<AlarmRingingState> emit,
  ) {
    _cancelAllTimers();
    emit(
      state.copyWith(
        entity: state.entity.copyWith(
          status: AlarmStatus.lockedPreFajr,
          scheduledAt: event.scheduledAt,
          isDryRun: event.isDryRun,
          remainingEmergencyOverrides: event.remainingEmergencyOverrides,
        ),
        failure: null,
      ),
    );
  }

  Future<void> _onAlarmTriggered(
    AlarmTriggered event,
    Emitter<AlarmRingingState> emit,
  ) async {
    _cancelAllTimers();
    final startResult = await _platformRepository.startRinging(
      isDryRun: event.isDryRun,
    );

    if (startResult.isLeft()) {
      startResult.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (_) {},
      );
      return;
    }

    await _platformRepository.enableScreenPinning();

    _initialRingStartElapsed = _clock.elapsed;
    emit(
      state.copyWith(
        entity: state.entity.copyWith(
          status: AlarmStatus.ringingInitial,
          scheduledAt: event.scheduledAt ?? state.entity.scheduledAt,
          isDryRun: event.isDryRun,
          snoozeUsed: false,
          remainingEmergencyOverrides: event.remainingEmergencyOverrides,
          relentlessCycleCount: 0,
        ),
        snoozeRemainingSeconds: 0,
        emergencyHoldElapsedSeconds: 0,
        isEmergencyMuted: false,
        emergencyReleasedEarly: false,
        failure: null,
      ),
    );

    _initialIgnoreTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.entity.status != AlarmStatus.ringingInitial ||
          state.isEmergencyMuted) {
        return;
      }
      if (_clock.elapsed - _initialRingStartElapsed >=
          initialIgnoreEscalationDuration) {
        _initialIgnoreTimer?.cancel();
        add(const AlarmRingingEvent.relentlessTicked());
      }
    });
  }

  Future<void> _onSnoozeRequested(
    SnoozeRequested event,
    Emitter<AlarmRingingState> emit,
  ) async {
    _initialIgnoreTimer?.cancel();
    final result = await _snoozeAlarmUseCase(state.entity);
    result.fold((failure) => emit(state.copyWith(failure: failure)), (
      updatedEntity,
    ) {
      _snoozeStartElapsed = _clock.elapsed;
      emit(
        state.copyWith(
          entity: updatedEntity,
          snoozeRemainingSeconds: snoozeDuration.inSeconds,
          emergencyReleasedEarly: false,
          failure: null,
        ),
      );
      _snoozeTimer?.cancel();
      _snoozeTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => add(const AlarmRingingEvent.snoozeTicked()),
      );
    });
  }

  Future<void> _onSnoozeTicked(
    SnoozeTicked event,
    Emitter<AlarmRingingState> emit,
  ) async {
    if (state.entity.status != AlarmStatus.snoozed5Min) {
      _snoozeTimer?.cancel();
      return;
    }

    final elapsed = _clock.elapsed - _snoozeStartElapsed;
    if (elapsed >= snoozeDuration) {
      _snoozeTimer?.cancel();
      emit(state.copyWith(snoozeRemainingSeconds: 0));
      await _escalateToRelentless(emit);
      return;
    }

    final remaining = (snoozeDuration - elapsed).inSeconds;
    emit(state.copyWith(snoozeRemainingSeconds: remaining));
  }

  Future<void> _onRelentlessTicked(
    RelentlessTicked event,
    Emitter<AlarmRingingState> emit,
  ) async {
    if (state.isEmergencyMuted) {
      return;
    }

    if (state.entity.status == AlarmStatus.ringingInitial) {
      await _escalateToRelentless(emit);
      return;
    }

    if (state.entity.status != AlarmStatus.ringingRelentless) {
      _relentlessTimer?.cancel();
      return;
    }

    if (_clock.elapsed - _relentlessLastRingElapsed >= relentlessInterval) {
      _relentlessLastRingElapsed = _clock.elapsed;
      final result = await _startRelentlessRingingUseCase(state.entity);
      result.fold(
        (failure) => emit(state.copyWith(failure: failure)),
        (updatedEntity) =>
            emit(state.copyWith(entity: updatedEntity, failure: null)),
      );
    }
  }

  Future<void> _escalateToRelentless(Emitter<AlarmRingingState> emit) async {
    final result = await _startRelentlessRingingUseCase(state.entity);
    result.fold((failure) => emit(state.copyWith(failure: failure)), (
      updatedEntity,
    ) {
      _relentlessLastRingElapsed = _clock.elapsed;
      emit(
        state.copyWith(
          entity: updatedEntity,
          snoozeRemainingSeconds: 0,
          failure: null,
        ),
      );
      _relentlessTimer?.cancel();
      _relentlessTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => add(const AlarmRingingEvent.relentlessTicked()),
      );
    });
  }

  void _onChallengeStarted(
    ChallengeStarted event,
    Emitter<AlarmRingingState> emit,
  ) {
    _cancelAllTimers();
    emit(
      state.copyWith(
        entity: state.entity.copyWith(status: AlarmStatus.challengeActive),
        isEmergencyMuted: false,
        emergencyHoldElapsedSeconds: 0,
        emergencyReleasedEarly: false,
        failure: null,
      ),
    );
  }

  Future<void> _onChallengeRejected(
    ChallengeRejected event,
    Emitter<AlarmRingingState> emit,
  ) async {
    await _escalateToRelentless(emit);
  }

  Future<void> _onChallengeSucceeded(
    ChallengeSucceeded event,
    Emitter<AlarmRingingState> emit,
  ) async {
    _cancelAllTimers();
    final result = await _completeAlarmUseCase(state.entity);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updatedEntity) => emit(
        state.copyWith(
          entity: updatedEntity,
          snoozeRemainingSeconds: 0,
          emergencyHoldElapsedSeconds: 0,
          isEmergencyMuted: false,
          emergencyReleasedEarly: false,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onEmergencyHoldStarted(
    EmergencyHoldStarted event,
    Emitter<AlarmRingingState> emit,
  ) async {
    if (state.isEmergencyMuted) {
      return;
    }

    final result = await _emergencyOverrideUseCase.beginTouchMute(
      remainingEmergencyOverrides: state.entity.remainingEmergencyOverrides,
    );

    result.fold((failure) => emit(state.copyWith(failure: failure)), (_) {
      _emergencyStartElapsed = _clock.elapsed;
      emit(
        state.copyWith(
          isEmergencyMuted: true,
          emergencyHoldElapsedSeconds: 0,
          emergencyReleasedEarly: false,
          failure: null,
        ),
      );
      _emergencyTimer?.cancel();
      _emergencyTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => add(const AlarmRingingEvent.emergencyHoldTicked()),
      );
    });
  }

  Future<void> _onEmergencyHoldTicked(
    EmergencyHoldTicked event,
    Emitter<AlarmRingingState> emit,
  ) async {
    if (!state.isEmergencyMuted) {
      _emergencyTimer?.cancel();
      return;
    }

    final elapsed = _clock.elapsed - _emergencyStartElapsed;
    if (elapsed >= emergencyHoldDuration) {
      _cancelAllTimers();
      final result = await _emergencyOverrideUseCase.completeOverride(
        state.entity,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            isEmergencyMuted: false,
            emergencyHoldElapsedSeconds: 0,
            failure: failure,
          ),
        ),
        (updatedEntity) => emit(
          state.copyWith(
            entity: updatedEntity,
            snoozeRemainingSeconds: 0,
            emergencyHoldElapsedSeconds: emergencyHoldDuration.inSeconds,
            isEmergencyMuted: false,
            emergencyReleasedEarly: false,
            failure: null,
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(emergencyHoldElapsedSeconds: elapsed.inSeconds));
  }

  Future<void> _onEmergencyHoldReleased(
    EmergencyHoldReleased event,
    Emitter<AlarmRingingState> emit,
  ) async {
    if (!state.isEmergencyMuted) {
      return;
    }
    _emergencyTimer?.cancel();
    final result = await _emergencyOverrideUseCase.cancelEarlyRelease();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isEmergencyMuted: false,
          emergencyHoldElapsedSeconds: 0,
          emergencyReleasedEarly: true,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isEmergencyMuted: false,
          emergencyHoldElapsedSeconds: 0,
          emergencyReleasedEarly: true,
          failure: null,
        ),
      ),
    );
  }

  void _onVacationFrozen(
    VacationFrozen event,
    Emitter<AlarmRingingState> emit,
  ) {
    if (state.entity.status != AlarmStatus.idle) {
      return;
    }
    emit(
      state.copyWith(
        entity: state.entity.copyWith(status: AlarmStatus.vacationFrozen),
        failure: null,
      ),
    );
  }

  void _onVacationEnded(VacationEnded event, Emitter<AlarmRingingState> emit) {
    if (state.entity.status != AlarmStatus.vacationFrozen) {
      return;
    }
    emit(
      state.copyWith(
        entity: state.entity.copyWith(status: AlarmStatus.idle),
        failure: null,
      ),
    );
  }

  void _cancelAllTimers() {
    _initialIgnoreTimer?.cancel();
    _snoozeTimer?.cancel();
    _relentlessTimer?.cancel();
    _emergencyTimer?.cancel();
  }

  @override
  Future<void> close() {
    _cancelAllTimers();
    return super.close();
  }
}
