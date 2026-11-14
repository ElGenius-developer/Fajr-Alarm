import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/router/app_router.dart';
import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/emergency_override_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/start_relentless_ringing_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/streak_stats.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/user_settings.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/repositories/settings_and_streak_repository.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/consume_emergency_quota_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/record_alarm_completion_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAlarmPlatformRepository extends Mock
    implements AlarmPlatformRepository {}

class _MockSettingsRepository extends Mock
    implements SettingsAndStreakRepository {}

class _MockPrayerScheduleRepository extends Mock
    implements PrayerScheduleRepository {}

void main() {
  late _MockAlarmPlatformRepository alarmRepo;
  late _MockSettingsRepository settingsRepo;
  late _MockPrayerScheduleRepository scheduleRepo;

  setUpAll(() {
    registerFallbackValue(const StreakStats());
    registerFallbackValue(const UserSettings());
  });

  setUp(() async {
    await sl.reset();
    alarmRepo = _MockAlarmPlatformRepository();
    settingsRepo = _MockSettingsRepository();
    scheduleRepo = _MockPrayerScheduleRepository();

    when(() => alarmRepo.stopRinging())
        .thenAnswer((_) async => const Right(unit));
    when(() => alarmRepo.disableScreenPinning())
        .thenAnswer((_) async => const Right(unit));
    when(() => alarmRepo.cancelAllAlarms())
        .thenAnswer((_) async => const Right(unit));
    when(() => alarmRepo.startRinging(isDryRun: any(named: 'isDryRun')))
        .thenAnswer((_) async => const Right(unit));
    when(() => alarmRepo.enableScreenPinning())
        .thenAnswer((_) async => const Right(unit));

    when(() => settingsRepo.getStreakStats())
        .thenAnswer((_) async => const Right(StreakStats()));
    when(() => settingsRepo.saveStreakStats(any())).thenAnswer((inv) async {
      return Right(inv.positionalArguments.first as StreakStats);
    });
    when(() => settingsRepo.getSettings())
        .thenAnswer((_) async => const Right(UserSettings()));
    when(() => settingsRepo.saveSettings(any())).thenAnswer((inv) async {
      return Right(inv.positionalArguments.first as UserSettings);
    });

    when(() => scheduleRepo.getAlarmConfig()).thenAnswer(
      (_) async =>
          const Right(FajrAlarmConfig(latitude: 30.0444, longitude: 31.2357)),
    );
    when(() => scheduleRepo.getCached30DaySchedule())
        .thenAnswer((_) async => const Right([]));
    when(() => scheduleRepo.save30DaySchedule(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => scheduleRepo.saveNextScheduledAlarm(any()))
        .thenAnswer((_) async => const Right(unit));

    sl
      ..registerLazySingleton<AlarmPlatformRepository>(() => alarmRepo)
      ..registerLazySingleton<CompleteAlarmUseCase>(
        () => CompleteAlarmUseCase(alarmRepo),
      )
      ..registerLazySingleton<RecordAlarmCompletionUseCase>(
        () => RecordAlarmCompletionUseCase(settingsRepo),
      )
      ..registerLazySingleton<ConsumeEmergencyQuotaUseCase>(
        () => ConsumeEmergencyQuotaUseCase(settingsRepo),
      )
      ..registerLazySingleton<RescheduleTomorrowFajrUseCase>(
        () => RescheduleTomorrowFajrUseCase(
          repository: scheduleRepo,
          calculate30DaySchedule: Calculate30DayFajrScheduleUseCase(
            scheduleRepo,
          ),
          getNextFajrAlarm: const GetNextFajrAlarmUseCase(),
        ),
      )
      ..registerFactory<AlarmRingingBloc>(
        () => AlarmRingingBloc(
          clock: SystemMonotonicClock(),
          platformRepository: alarmRepo,
          snoozeAlarmUseCase: SnoozeAlarmUseCase(alarmRepo),
          startRelentlessRingingUseCase: StartRelentlessRingingUseCase(
            alarmRepo,
          ),
          emergencyOverrideUseCase: EmergencyOverrideUseCase(alarmRepo),
          completeAlarmUseCase: sl<CompleteAlarmUseCase>(),
        ),
      );
  });

  tearDown(() async {
    await sl.reset();
  });

  test(
    'finalizeChallengeCompletion stops alarm, records streak, and reschedules',
    () async {
      await finalizeChallengeCompletion(
        isDryRun: false,
        startedAt: DateTime.now().subtract(const Duration(seconds: 30)),
      );

      verify(() => alarmRepo.stopRinging()).called(1);
      verify(() => alarmRepo.disableScreenPinning()).called(1);
      verify(() => alarmRepo.cancelAllAlarms()).called(1);
      verify(() => settingsRepo.saveStreakStats(any())).called(1);
      verify(() => scheduleRepo.saveNextScheduledAlarm(any())).called(1);
    },
  );

  test(
    'finalizeEmergencyOverride consumes quota and reschedules for real alarm',
    () async {
      await finalizeEmergencyOverride(isDryRun: false);

      verify(() => settingsRepo.saveSettings(any())).called(1);
      verify(() => settingsRepo.saveStreakStats(any())).called(1);
      verify(() => scheduleRepo.saveNextScheduledAlarm(any())).called(1);
    },
  );

  testWidgets(
    '/alarm-ringing with autoTrigger dispatches AlarmTriggered and shows ringing UI',
    (tester) async {
      final router = createAppRouter(
        initialLocation:
            '${AppRoutes.alarmRinging}?autoTrigger=true&dryRun=true',
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      verify(() => alarmRepo.startRinging(isDryRun: true)).called(1);
      expect(find.text('Dry-Run Test Alarm'), findsOneWidget);
      expect(find.text('Time for Fajr!'), findsOneWidget);
    },
  );
}
