import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/activate_vacation_mode_usecase.dart';
import '../../domain/usecases/auto_resume_vacation_usecase.dart';
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
    DateTime Function()? nowProvider,
  }) : _nowProvider = nowProvider ?? DateTime.now,
       super(const SettingsState());

  final GetSettingsUseCase _getSettings;
  final GetStreakStatsUseCase _getStreakStats;
  final UpdateSettingsUseCase _updateSettings;
  final ActivateVacationModeUseCase _activateVacationMode;
  final AutoResumeVacationUseCase _autoResumeVacation;
  final TriggerDryRunAlarmUseCase _triggerDryRunAlarm;
  final DateTime Function() _nowProvider;

  Future<void> load({
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final now = _nowProvider();
    final lockWindow = isWithinPreFajrLockWindow(
      now: now,
      nextFajrAlarmAt: nextFajrAlarmAt,
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
    final settingsResult = await _getSettings();
    final statsResult = await _getStreakStats();

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
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(locale: locale),
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
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
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(themeMode: themeMode),
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
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
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(designStyle: designStyle),
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
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
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(monthlyEmergencyQuota: quota),
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
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
    final result = await _activateVacationMode(
      durationDays: durationDays,
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
    await result.fold(
      (failure) async => emit(state.copyWith(failure: failure)),
      (updatedSettings) async {
        final statsResult = await _getStreakStats();
        statsResult.fold(
          (failure) =>
              emit(state.copyWith(settings: updatedSettings, failure: failure)),
          (stats) => emit(
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
    final result = await _triggerDryRunAlarm(
      now: _nowProvider(),
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
    );
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (scheduledAt) =>
          emit(state.copyWith(dryRunScheduledAt: scheduledAt, failure: null)),
    );
  }

  void clearNotifications() {
    emit(state.copyWith(failure: null, dryRunScheduledAt: null));
  }
}
