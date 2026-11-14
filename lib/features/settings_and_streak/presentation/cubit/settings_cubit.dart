import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/activate_vacation_mode_usecase.dart';
import '../../domain/usecases/auto_resume_vacation_usecase.dart';
import '../../domain/usecases/cancel_dry_run_alarm_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/get_streak_stats_usecase.dart';
import '../../domain/usecases/pre_fajr_lock_window.dart';
import '../../domain/usecases/trigger_dry_run_alarm_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_state.dart';

/// Manages settings, language switching, Vacation Mode, emergency quota, and dry-run alarms.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this._getSettings,
    required this._getStreakStats,
    required this._updateSettings,
    required this._activateVacationMode,
    required this._autoResumeVacation,
    required this._triggerDryRunAlarm,
    this._cancelDryRunAlarm,
    this._nextAlarmProvider,
    DateTime Function()? nowProvider,
  }) : _nowProvider = nowProvider ?? DateTime.now,
       super(const SettingsState());

  final GetSettingsUseCase _getSettings;
  final GetStreakStatsUseCase _getStreakStats;
  final UpdateSettingsUseCase _updateSettings;
  final ActivateVacationModeUseCase _activateVacationMode;
  final AutoResumeVacationUseCase _autoResumeVacation;
  final TriggerDryRunAlarmUseCase _triggerDryRunAlarm;
  final CancelDryRunAlarmUseCase? _cancelDryRunAlarm;
  final Future<DateTime?> Function()? _nextAlarmProvider;
  final DateTime Function() _nowProvider;

  Future<DateTime?> _resolveNextAlarm(DateTime? explicit) async {
    if (explicit != null) {
      return explicit;
    }
    return _nextAlarmProvider?.call();
  }

  Future<void> load({
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (isClosed) return;
    final now = _nowProvider();
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final lockWindow = isWithinPreFajrLockWindow(
      now: now,
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );

    emit(
      state.copyWith(
        isLoading: true,
        isWithinLockWindow: lockWindow,
        failure: null,
      ),
    );

    await _autoResumeVacation(now: now);
    if (isClosed) return;
    final settingsResult = await _getSettings();
    if (isClosed) return;
    final statsResult = await _getStreakStats();
    if (isClosed) return;

    settingsResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (settings) => statsResult.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            settings: settings,
            failure: failure,
          ),
        ),
        (stats) => emit(
          state.copyWith(
            isLoading: false,
            settings: settings,
            streakStats: stats,
            failure: null,
          ),
        ),
      ),
    );
  }

  Future<void> switchLocale(
    String locale, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(locale: locale),
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updated) => emit(state.copyWith(settings: updated, failure: null)),
    );
  }

  Future<void> switchThemeMode(
    String themeMode, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(themeMode: themeMode),
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updated) => emit(state.copyWith(settings: updated, failure: null)),
    );
  }

  Future<void> switchDesignStyle(
    String designStyle, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(designStyle: designStyle),
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updated) => emit(state.copyWith(settings: updated, failure: null)),
    );
  }

  Future<void> updateMonthlyEmergencyQuota(
    int quota, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(monthlyEmergencyQuota: quota),
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updated) => emit(state.copyWith(settings: updated, failure: null)),
    );
  }

  Future<void> activateVacationMode(
    int durationDays, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _activateVacationMode(
      durationDays: durationDays,
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    await result.fold(
      (failure) async => _safeEmit(state.copyWith(failure: failure)),
      (updatedSettings) async {
        final statsResult = await _getStreakStats();
        if (isClosed) return;
        statsResult.fold(
          (failure) => _safeEmit(
            state.copyWith(settings: updatedSettings, failure: failure),
          ),
          (stats) => _safeEmit(
            state.copyWith(
              settings: updatedSettings,
              streakStats: stats,
              failure: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> triggerDryRunAlarm({
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final result = await _triggerDryRunAlarm(
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (scheduledAt) => emit(
        state.copyWith(
          dryRunScheduledAt: scheduledAt,
          dryRunJustScheduled: true,
          dryRunCancelled: false,
          failure: null,
        ),
      ),
    );
  }

  Future<void> cancelDryRunAlarm({
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return;
    final useCase = _cancelDryRunAlarm;
    if (useCase == null) {
      emit(
        state.copyWith(
          dryRunScheduledAt: null,
          dryRunJustScheduled: false,
          dryRunCancelled: true,
          failure: null,
        ),
      );
      return;
    }
    final result = await useCase(
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) => emit(
        state.copyWith(
          dryRunScheduledAt: null,
          dryRunJustScheduled: false,
          dryRunCancelled: true,
          failure: null,
        ),
      ),
    );
  }

  void clearActiveDryRun() {
    _safeEmit(
      state.copyWith(
        dryRunScheduledAt: null,
        dryRunJustScheduled: false,
        dryRunCancelled: false,
      ),
    );
  }

  void clearNotifications() {
    _safeEmit(
      state.copyWith(
        failure: null,
        dryRunJustScheduled: false,
        dryRunCancelled: false,
      ),
    );
  }

  void _safeEmit(SettingsState nextState) {
    if (!isClosed) {
      emit(nextState);
    }
  }
}
