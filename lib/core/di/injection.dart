import 'package:dio/dio.dart';
import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/alarm_ringing/data/datasources/alarm_platform_data_source.dart';
import 'package:fajr_alarm/features/alarm_ringing/data/repositories/alarm_platform_repository_impl.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/emergency_override_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/start_relentless_ringing_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/tilt_sensor_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/data/repositories/challenge_verification_repository_impl.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/resolve_offline_fallback_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_standing_typing_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/gemini_key_validator_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_permissions_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/models/onboarding_state_model.dart';
import 'package:fajr_alarm/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/datasources/prayer_schedule_local_data_source.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/fajr_alarm_config_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/prayer_schedule_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/is_within_pre_fajr_lock_window_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/data/datasources/settings_local_data_source.dart';
import 'package:fajr_alarm/features/settings_and_streak/data/repositories/settings_and_streak_repository_impl.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/streak_stats.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/user_settings.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/repositories/settings_and_streak_repository.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/activate_vacation_mode_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/auto_resume_vacation_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/cancel_dry_run_alarm_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/consume_emergency_quota_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_settings_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_streak_stats_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/record_alarm_completion_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/trigger_dry_run_alarm_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/update_settings_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initializes core and feature dependencies.
///
/// Pass [hivePath] in headless unit/widget tests to bypass `path_provider`.
Future<void> initDependencies({String? hivePath}) async {
  // Core
  if (!sl.isRegistered<MonotonicClock>()) {
    sl.registerLazySingleton<MonotonicClock>(SystemMonotonicClock.new);
  }
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  }
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  // Hive initialization & explicit TypeAdapters
  if (hivePath != null) {
    Hive.init(hivePath);
  } else {
    await Hive.initFlutter();
  }
  registerSettingsAdapters(Hive);
  if (!Hive.isAdapterRegistered(PrayerScheduleHiveAdapter.adapterTypeId)) {
    Hive.registerAdapter<PrayerScheduleHiveModel>(
      const PrayerScheduleHiveAdapter(),
    );
  }
  if (!Hive.isAdapterRegistered(FajrAlarmConfigHiveAdapter.adapterTypeId)) {
    Hive.registerAdapter<FajrAlarmConfigHiveModel>(
      const FajrAlarmConfigHiveAdapter(),
    );
  }
  if (!Hive.isAdapterRegistered(30)) {
    Hive.registerAdapter<OnboardingStateModel>(OnboardingStateModelAdapter());
  }

  final Box<UserSettings> settingsBox =
      Hive.isBoxOpen(HiveSettingsLocalDataSource.settingsBoxName)
      ? Hive.box<UserSettings>(HiveSettingsLocalDataSource.settingsBoxName)
      : await Hive.openBox<UserSettings>(
          HiveSettingsLocalDataSource.settingsBoxName,
        );
  final Box<StreakStats> streakBox =
      Hive.isBoxOpen(HiveSettingsLocalDataSource.streakBoxName)
      ? Hive.box<StreakStats>(HiveSettingsLocalDataSource.streakBoxName)
      : await Hive.openBox<StreakStats>(
          HiveSettingsLocalDataSource.streakBoxName,
        );
  const String onboardingBoxName = 'onboarding_state_box';
  final Box<OnboardingStateModel> onboardingBox =
      Hive.isBoxOpen(onboardingBoxName)
      ? Hive.box<OnboardingStateModel>(onboardingBoxName)
      : await Hive.openBox<OnboardingStateModel>(onboardingBoxName);

  // Feature 2: Native Alarm Platform Channels
  sl
    ..registerLazySingleton<AlarmPlatformDataSource>(
      AlarmPlatformDataSource.new,
    )
    ..registerLazySingleton<AlarmPlatformRepository>(
      () => AlarmPlatformRepositoryImpl(dataSource: sl()),
    );

  // Feature 1: Prayer Schedule
  sl
    ..registerLazySingleton<PrayerScheduleLocalDataSource>(
      () => PrayerScheduleLocalDataSourceImpl(Hive),
    )
    ..registerLazySingleton<PrayerScheduleRepository>(
      () => PrayerScheduleRepositoryImpl(sl(), alarmPlatformRepository: sl()),
    )
    ..registerLazySingleton<Calculate30DayFajrScheduleUseCase>(
      () => Calculate30DayFajrScheduleUseCase(sl()),
    )
    ..registerLazySingleton<GetNextFajrAlarmUseCase>(
      GetNextFajrAlarmUseCase.new,
    )
    ..registerLazySingleton<IsWithinPreFajrLockWindowUseCase>(
      IsWithinPreFajrLockWindowUseCase.new,
    )
    ..registerLazySingleton<LoadPrayerScheduleUseCase>(
      () => LoadPrayerScheduleUseCase(
        repository: sl(),
        calculate30DaySchedule: sl(),
        getNextFajrAlarm: sl(),
        isWithinLockWindow: sl(),
      ),
    )
    ..registerLazySingleton<UpdateFajrAlarmConfigUseCase>(
      () => UpdateFajrAlarmConfigUseCase(
        repository: sl(),
        calculate30DaySchedule: sl(),
        getNextFajrAlarm: sl(),
        isWithinLockWindow: sl(),
      ),
    )
    ..registerLazySingleton<RescheduleTomorrowFajrUseCase>(
      () => RescheduleTomorrowFajrUseCase(
        repository: sl(),
        calculate30DaySchedule: sl(),
        getNextFajrAlarm: sl(),
      ),
    )
    ..registerFactory<PrayerScheduleCubit>(
      () => PrayerScheduleCubit(
        loadSchedule: sl(),
        updateConfig: sl(),
        rescheduleTomorrow: sl(),
      ),
    );

  // Feature 3: Settings & Streak
  sl
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => HiveSettingsLocalDataSource(
        settingsBox: settingsBox,
        streakBox: streakBox,
      ),
    )
    ..registerLazySingleton<SettingsAndStreakRepository>(
      () => SettingsAndStreakRepositoryImpl(
        localDataSource: sl(),
        onScheduleDryRunAlarm: (DateTime scheduledAt) {
          return sl<AlarmPlatformRepository>().scheduleAlarm(
            scheduledAt: scheduledAt,
            isDryRun: true,
          );
        },
        onCancelDryRunAlarm: () async {
          final cancelResult = await sl<AlarmPlatformRepository>()
              .cancelAllAlarms();
          if (cancelResult.isLeft()) {
            return cancelResult;
          }
          await sl<RescheduleTomorrowFajrUseCase>()(
            completedAt: DateTime.now(),
          );
          return cancelResult;
        },
      ),
    )
    ..registerLazySingleton<GetSettingsUseCase>(() => GetSettingsUseCase(sl()))
    ..registerLazySingleton<GetStreakStatsUseCase>(
      () => GetStreakStatsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSettingsUseCase>(
      () => UpdateSettingsUseCase(sl()),
    )
    ..registerLazySingleton<ActivateVacationModeUseCase>(
      () => ActivateVacationModeUseCase(sl()),
    )
    ..registerLazySingleton<AutoResumeVacationUseCase>(
      () => AutoResumeVacationUseCase(sl()),
    )
    ..registerLazySingleton<RecordAlarmCompletionUseCase>(
      () => RecordAlarmCompletionUseCase(sl()),
    )
    ..registerLazySingleton<ConsumeEmergencyQuotaUseCase>(
      () => ConsumeEmergencyQuotaUseCase(sl()),
    )
    ..registerLazySingleton<TriggerDryRunAlarmUseCase>(
      () => TriggerDryRunAlarmUseCase(sl()),
    )
    ..registerLazySingleton<CancelDryRunAlarmUseCase>(
      () => CancelDryRunAlarmUseCase(sl()),
    )
    ..registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(
        getSettings: sl(),
        getStreakStats: sl(),
        updateSettings: sl(),
        activateVacationMode: sl(),
        autoResumeVacation: sl(),
        triggerDryRunAlarm: sl(),
        cancelDryRunAlarm: sl(),
        nextAlarmProvider: () async {
          final result = await sl<PrayerScheduleRepository>()
              .getNextScheduledAlarm();
          return result.getOrElse((_) => null);
        },
      ),
    );

  // Feature 4: Alarm Ringing
  sl
    ..registerLazySingleton<SnoozeAlarmUseCase>(() => SnoozeAlarmUseCase(sl()))
    ..registerLazySingleton<StartRelentlessRingingUseCase>(
      () => StartRelentlessRingingUseCase(sl()),
    )
    ..registerLazySingleton<EmergencyOverrideUseCase>(
      () => EmergencyOverrideUseCase(sl()),
    )
    ..registerLazySingleton<CompleteAlarmUseCase>(
      () => CompleteAlarmUseCase(sl()),
    )
    ..registerFactory<AlarmRingingBloc>(
      () => AlarmRingingBloc(
        clock: sl(),
        platformRepository: sl(),
        snoozeAlarmUseCase: sl(),
        startRelentlessRingingUseCase: sl(),
        emergencyOverrideUseCase: sl(),
        completeAlarmUseCase: sl(),
      ),
    );

  // Feature 5: Challenge Verification
  sl
    ..registerLazySingleton<GeminiVisionRemoteDataSource>(
      () => GeminiVisionRemoteDataSource(
        dio: sl(),
        secureStorage: sl(),
        apiKeyStorageKey: OnboardingLocalDataSourceImpl.geminiApiKeyStorageKey,
      ),
    )
    ..registerLazySingleton<TiltSensorDataSource>(TiltSensorDataSource.new)
    ..registerLazySingleton<ChallengeVerificationRepository>(
      () => ChallengeVerificationRepositoryImpl(
        remoteDataSource: sl(),
        tiltSensorDataSource: sl(),
        secureStorage: sl(),
        barcodeStorageKey:
            OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey,
      ),
    )
    ..registerLazySingleton<VerifyPrayerRugPhotoUseCase>(
      () => VerifyPrayerRugPhotoUseCase(sl()),
    )
    ..registerLazySingleton<VerifyBathroomBarcodeUseCase>(
      () => VerifyBathroomBarcodeUseCase(sl()),
    )
    ..registerLazySingleton<VerifyStandingTypingUseCase>(
      () => VerifyStandingTypingUseCase(sl()),
    )
    ..registerLazySingleton<ResolveOfflineFallbackUseCase>(
      () => ResolveOfflineFallbackUseCase(sl()),
    )
    ..registerFactory<ChallengeCubit>(
      () => ChallengeCubit(
        verifyPrayerRugPhoto: sl(),
        verifyBathroomBarcode: sl(),
        verifyStandingTyping: sl(),
        resolveOfflineFallback: sl(),
        repository: sl(),
      ),
    );

  // Feature 6: Onboarding
  sl
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(
        stateBox: onboardingBox,
        secureStorage: sl(),
      ),
    )
    ..registerLazySingleton<GeminiKeyValidatorDataSource>(
      () => GeminiKeyValidatorDataSourceImpl(sl()),
    )
    ..registerLazySingleton<OnboardingPermissionsDataSource>(
      MethodChannelOnboardingPermissionsDataSource.new,
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(
        localDataSource: sl(),
        geminiKeyValidatorDataSource: sl(),
        permissionsDataSource: sl(),
        prayerScheduleRepository: sl(),
      ),
    )
    ..registerLazySingleton<SaveLocationUseCase>(
      () => SaveLocationUseCase(sl()),
    )
    ..registerLazySingleton<CheckPermissionsGateUseCase>(
      () => CheckPermissionsGateUseCase(sl()),
    )
    ..registerLazySingleton<ValidateAndSaveGeminiKeyUseCase>(
      () => ValidateAndSaveGeminiKeyUseCase(sl()),
    )
    ..registerLazySingleton<RegisterBathroomBarcodeUseCase>(
      () => RegisterBathroomBarcodeUseCase(sl()),
    )
    ..registerLazySingleton<CompleteOnboardingUseCase>(
      () => CompleteOnboardingUseCase(sl()),
    )
    ..registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        repository: sl(),
        saveLocationUseCase: sl(),
        checkPermissionsGateUseCase: sl(),
        validateAndSaveGeminiKeyUseCase: sl(),
        registerBathroomBarcodeUseCase: sl(),
        completeOnboardingUseCase: sl(),
      ),
    );
}
