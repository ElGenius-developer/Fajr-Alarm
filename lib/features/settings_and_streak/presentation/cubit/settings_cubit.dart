import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../onboarding/domain/entities/onboarding_state_entity.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../../../prayer_schedule/domain/entities/fajr_alarm_config.dart';
import '../../../prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import '../../../prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import '../../../prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import '../../domain/entities/user_settings.dart';
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
    this._onboardingRepository,
    this._prayerScheduleRepository,
    this._updateFajrAlarmConfig,
    this._rescheduleTomorrowFajr,
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
  final OnboardingRepository? _onboardingRepository;
  final PrayerScheduleRepository? _prayerScheduleRepository;
  final UpdateFajrAlarmConfigUseCase? _updateFajrAlarmConfig;
  final RescheduleTomorrowFajrUseCase? _rescheduleTomorrowFajr;

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

    await settingsResult.fold<Future<void>>(
      (failure) async =>
          _safeEmit(state.copyWith(isLoading: false, failure: failure)),
      (settings) async {
        final resolved = await _syncOnboardedBarcode(
          settings: settings,
          now: now,
          effectiveNextAlarm: effectiveNextAlarm,
          lockWindow: lockWindow,
          isAlarmRinging: isAlarmRinging,
        );
        if (isClosed) return;
        statsResult.fold(
          (failure) => _safeEmit(
            state.copyWith(
              isLoading: false,
              settings: resolved,
              failure: failure,
            ),
          ),
          (stats) => _safeEmit(
            state.copyWith(
              isLoading: false,
              settings: resolved,
              streakStats: stats,
              failure: null,
            ),
          ),
        );
      },
    );
  }

  Future<UserSettings> _syncOnboardedBarcode({
    required UserSettings settings,
    required DateTime now,
    required DateTime? effectiveNextAlarm,
    required bool lockWindow,
    required bool isAlarmRinging,
  }) async {
    if (settings.bathroomBarcode != null || _onboardingRepository == null) {
      return settings;
    }
    final onboardingResult = await _onboardingRepository.getOnboardingState();
    final onboardedBarcode = onboardingResult.fold(
      (_) => null,
      (entity) => entity.registeredBarcode?.trim(),
    );
    if (onboardedBarcode == null || onboardedBarcode.isEmpty) {
      return settings;
    }
    final synced = settings.copyWith(bathroomBarcode: onboardedBarcode);
    if (!lockWindow) {
      await _updateSettings(
        newSettings: synced,
        now: now,
        nextFajrAlarmAt: effectiveNextAlarm,
        isAlarmRinging: isAlarmRinging,
      );
    }
    return synced;
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

  Future<bool> _isLockedWithFailure({
    required DateTime? nextFajrAlarmAt,
    required bool isAlarmRinging,
    required String lockMessage,
  }) async {
    final now = _nowProvider();
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return true;
    if (isWithinPreFajrLockWindow(
      now: now,
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    )) {
      _safeEmit(
        state.copyWith(failure: Failure.lockWindow(message: lockMessage)),
      );
      return true;
    }
    return false;
  }

  Future<void> deactivateVacationMode({
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (await _isLockedWithFailure(
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
      lockMessage:
          'Vacation Mode cannot be ended during the Pre-Fajr Lock Window.',
    )) {
      return;
    }
    final currentVacation = state.settings.vacationMode;
    if (currentVacation == null) return;

    final resumedResult = await _autoResumeVacation(
      now: currentVacation.endDate.add(const Duration(seconds: 1)),
    );
    if (isClosed) return;
    await resumedResult.fold<Future<void>>(
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
        await _rescheduleTomorrowFajr?.call(completedAt: _nowProvider());
      },
    );
  }

  Future<bool> updateBathroomBarcode(
    String? barcode, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    final trimmed = barcode?.trim();
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    final effectiveNextAlarm = await _resolveNextAlarm(nextFajrAlarmAt);
    if (isClosed) return false;
    final result = await _updateSettings(
      newSettings: state.settings.copyWith(bathroomBarcode: normalized),
      now: _nowProvider(),
      nextFajrAlarmAt: effectiveNextAlarm,
      isAlarmRinging: isAlarmRinging,
    );
    if (isClosed) return false;
    return await result.fold<Future<bool>>(
      (failure) async {
        _safeEmit(state.copyWith(failure: failure));
        return false;
      },
      (updated) async {
        if (_onboardingRepository != null) {
          final onboardResult = await _onboardingRepository
              .registerBathroomBarcode(normalized);
          if (isClosed) return false;
          final onboardFailure = onboardResult.fold((f) => f, (_) => null);
          if (onboardFailure != null) {
            _safeEmit(
              state.copyWith(settings: updated, failure: onboardFailure),
            );
            return false;
          }
        }
        _safeEmit(state.copyWith(settings: updated, failure: null));
        return true;
      },
    );
  }

  Future<FajrAlarmConfig?> loadAlarmConfig() async {
    final repo = _prayerScheduleRepository;
    if (repo == null) return null;
    final result = await repo.getAlarmConfig();
    return result.fold((_) => null, (config) => config);
  }

  Future<bool> updateAlarmConfig(
    FajrAlarmConfig config, {
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (await _isLockedWithFailure(
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
      lockMessage: 'Cannot modify alarm during Pre-Fajr Lock Window (T - 30m).',
    )) {
      return false;
    }

    final Failure? saveFailure;
    if (_updateFajrAlarmConfig != null) {
      final result = await _updateFajrAlarmConfig(
        newConfig: config,
        now: _nowProvider(),
        isChallengePending: isAlarmRinging,
      );
      if (isClosed) return false;
      saveFailure = result.fold((f) => f, (overview) => overview.actionFailure);
    } else if (_prayerScheduleRepository != null) {
      final result = await _prayerScheduleRepository.saveAlarmConfig(config);
      if (isClosed) return false;
      saveFailure = result.fold((f) => f, (_) => null);
    } else {
      return false;
    }

    if (saveFailure != null) {
      _safeEmit(state.copyWith(failure: saveFailure));
      return false;
    }

    if (_onboardingRepository != null &&
        config.cityName != null &&
        config.cityName!.trim().isNotEmpty) {
      await _onboardingRepository.saveLocation(
        latitude: config.latitude,
        longitude: config.longitude,
        cityName: config.cityName!.trim(),
      );
      if (isClosed) return false;
    }
    _safeEmit(state.copyWith(failure: null));
    return true;
  }

  Future<OnboardingStateEntity?> loadOnboardingState() async {
    final repo = _onboardingRepository;
    if (repo == null) return null;
    final result = await repo.getOnboardingState();
    return result.fold((_) => null, (entity) => entity);
  }

  Future<PermissionsGateStatus?> checkPermissions() async {
    final repo = _onboardingRepository;
    if (repo == null) return null;
    final result = await repo.checkPermissions();
    return result.fold(
      (failure) {
        _safeEmit(state.copyWith(failure: failure));
        return null;
      },
      (status) {
        repo.savePermissionsGranted(status.allGranted);
        return status;
      },
    );
  }

  Future<PermissionsGateStatus?> requestPermissions() async {
    final repo = _onboardingRepository;
    if (repo == null) return null;
    final result = await repo.requestPermissions();
    return result.fold(
      (failure) {
        _safeEmit(state.copyWith(failure: failure));
        return null;
      },
      (status) {
        repo.savePermissionsGranted(status.allGranted);
        return status;
      },
    );
  }

  Future<bool> updateGeminiApiKey({
    required String apiKey,
    required bool consentAccepted,
    DateTime? nextFajrAlarmAt,
    bool isAlarmRinging = false,
  }) async {
    if (await _isLockedWithFailure(
      nextFajrAlarmAt: nextFajrAlarmAt,
      isAlarmRinging: isAlarmRinging,
      lockMessage:
          'API key changes are locked during the Pre-Fajr Lock Window.',
    )) {
      return false;
    }
    final repo = _onboardingRepository;
    if (repo == null) return false;
    if (!consentAccepted) {
      _safeEmit(
        state.copyWith(
          failure: const Failure.validation(
            message: 'Privacy disclosure consent is required.',
          ),
        ),
      );
      return false;
    }
    final trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) {
      _safeEmit(
        state.copyWith(
          failure: const Failure.validation(
            message: 'Gemini API key cannot be empty.',
          ),
        ),
      );
      return false;
    }

    await repo.setPrivacyConsentAccepted(true);
    final validateResult = await repo.validateGeminiKey(trimmedKey);
    if (isClosed) return false;

    return await validateResult.fold<Future<bool>>(
      (failure) async {
        _safeEmit(state.copyWith(failure: failure));
        return false;
      },
      (isValid) async {
        if (!isValid) {
          _safeEmit(
            state.copyWith(
              failure: const Failure.api(
                message: 'Gemini API key validation failed.',
              ),
            ),
          );
          return false;
        }
        final saveResult = await repo.saveGeminiKey(trimmedKey);
        if (isClosed) return false;
        return saveResult.fold(
          (failure) {
            _safeEmit(state.copyWith(failure: failure));
            return false;
          },
          (_) {
            _safeEmit(state.copyWith(failure: null));
            return true;
          },
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
