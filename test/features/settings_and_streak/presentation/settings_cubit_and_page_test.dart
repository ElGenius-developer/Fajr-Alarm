import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/widgets/barcode_scanner_input.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/streak_stats.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/user_settings.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/vacation_mode_config.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/repositories/settings_and_streak_repository.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/activate_vacation_mode_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/auto_resume_vacation_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/cancel_dry_run_alarm_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_settings_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_streak_stats_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/trigger_dry_run_alarm_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/update_settings_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_state.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsAndStreakRepository extends Mock
    implements SettingsAndStreakRepository {}

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockPrayerScheduleRepository extends Mock
    implements PrayerScheduleRepository {}

class MockUpdateFajrAlarmConfigUseCase extends Mock
    implements UpdateFajrAlarmConfigUseCase {}

class MockRescheduleTomorrowFajrUseCase extends Mock
    implements RescheduleTomorrowFajrUseCase {}

void main() {
  late MockSettingsAndStreakRepository repository;
  final fixedNow = DateTime(2026, 11, 13, 21, 0);

  setUpAll(() {
    registerFallbackValue(const UserSettings());
    registerFallbackValue(const StreakStats());
    registerFallbackValue(
      const FajrAlarmConfig(latitude: 30.0444, longitude: 31.2357),
    );
  });

  setUp(() {
    repository = MockSettingsAndStreakRepository();
  });

  SettingsCubit buildCubit({
    DateTime Function()? nowProvider,
    Future<DateTime?> Function()? nextAlarmProvider,
    OnboardingRepository? onboardingRepository,
    PrayerScheduleRepository? prayerScheduleRepository,
    UpdateFajrAlarmConfigUseCase? updateFajrAlarmConfig,
    RescheduleTomorrowFajrUseCase? rescheduleTomorrowFajr,
  }) {
    return SettingsCubit(
      getSettings: GetSettingsUseCase(repository),
      getStreakStats: GetStreakStatsUseCase(repository),
      updateSettings: UpdateSettingsUseCase(repository),
      activateVacationMode: ActivateVacationModeUseCase(repository),
      autoResumeVacation: AutoResumeVacationUseCase(repository),
      triggerDryRunAlarm: TriggerDryRunAlarmUseCase(repository),
      cancelDryRunAlarm: CancelDryRunAlarmUseCase(repository),
      nextAlarmProvider: nextAlarmProvider,
      nowProvider: nowProvider ?? () => fixedNow,
      onboardingRepository: onboardingRepository,
      prayerScheduleRepository: prayerScheduleRepository,
      updateFajrAlarmConfig: updateFajrAlarmConfig,
      rescheduleTomorrowFajr: rescheduleTomorrowFajr,
    );
  }

  group('SettingsCubit', () {
    const initialSettings = UserSettings(
      locale: 'ar',
      monthlyEmergencyQuota: 3,
    );
    const initialStats = StreakStats(
      currentStreak: 7,
      longestStreak: 14,
      totalAlarms: 10,
      completedAlarms: 9,
      totalTimeToWakeSeconds: 1620,
    );

    blocTest<SettingsCubit, SettingsState>(
      'load emits loading then loaded settings and streak stats',
      build: () {
        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(initialSettings));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(initialStats));
        return buildCubit();
      },
      act: (cubit) =>
          cubit.load(nextFajrAlarmAt: fixedNow.add(const Duration(hours: 8))),
      expect: () => [
        const SettingsState(isLoading: true),
        const SettingsState(
          isLoading: false,
          settings: initialSettings,
          streakStats: initialStats,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'switchLocale updates locale to en',
      build: () {
        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(initialSettings));
        when(() => repository.saveSettings(any()))
            .thenAnswer((_) async => const Right(UserSettings(locale: 'en')));
        return buildCubit();
      },
      act: (cubit) => cubit.switchLocale('en'),
      expect: () => [const SettingsState(settings: UserSettings(locale: 'en'))],
    );

    blocTest<SettingsCubit, SettingsState>(
      'activateVacationMode sets vacation and freezes streak',
      build: () {
        final expectedVacation = VacationModeConfig(
          startDate: fixedNow,
          durationDays: 5,
          endDate: fixedNow.add(const Duration(days: 5)),
        );
        final updatedSettings = initialSettings.copyWith(
          vacationMode: expectedVacation,
        );

        var currentStats = initialStats;
        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(initialSettings));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => Right(currentStats));
        when(() => repository.saveStreakStats(any())).thenAnswer((
          invocation,
        ) async {
          currentStats = invocation.positionalArguments.first as StreakStats;
          return Right(currentStats);
        });
        when(() => repository.saveSettings(any()))
            .thenAnswer((_) async => Right(updatedSettings));
        return buildCubit();
      },
      act: (cubit) => cubit.activateVacationMode(5),
      verify: (cubit) {
        expect(cubit.state.settings.vacationMode?.durationDays, 5);
        expect(cubit.state.streakStats.isFrozen, isTrue);
        expect(cubit.state.failure, isNull);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'triggerDryRunAlarm schedules 10s dry-run outside lock window',
      build: () {
        when(
          () => repository.scheduleDryRunAlarm(
            scheduledAt: any(named: 'scheduledAt'),
          ),
        ).thenAnswer((_) async => const Right(unit));
        return buildCubit();
      },
      act: (cubit) => cubit.triggerDryRunAlarm(
        nextFajrAlarmAt: fixedNow.add(const Duration(hours: 5)),
      ),
      expect: () => [
        SettingsState(
          dryRunScheduledAt: fixedNow.add(const Duration(seconds: 10)),
          dryRunJustScheduled: true,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'cancelDryRunAlarm clears active dryRunScheduledAt and sets dryRunCancelled',
      build: () {
        when(
          () => repository.scheduleDryRunAlarm(
            scheduledAt: any(named: 'scheduledAt'),
          ),
        ).thenAnswer((_) async => const Right(unit));
        when(() => repository.cancelDryRunAlarm())
            .thenAnswer((_) async => const Right(unit));
        return buildCubit(
          nextAlarmProvider: () async => fixedNow.add(const Duration(hours: 5)),
        );
      },
      act: (cubit) async {
        await cubit.triggerDryRunAlarm();
        await cubit.cancelDryRunAlarm();
      },
      verify: (cubit) {
        expect(cubit.state.dryRunScheduledAt, isNull);
        expect(cubit.state.dryRunCancelled, isTrue);
        verify(() => repository.cancelDryRunAlarm()).called(1);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'load uses nextAlarmProvider to detect active T-30m lock window',
      build: () {
        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(initialSettings));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(initialStats));
        return buildCubit(
          nextAlarmProvider: () async =>
              fixedNow.add(const Duration(minutes: 10)),
        );
      },
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.isWithinLockWindow, isTrue);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'triggerDryRunAlarm emits LockWindowFailure inside T - 30m',
      build: buildCubit,
      act: (cubit) => cubit.triggerDryRunAlarm(
        nextFajrAlarmAt: fixedNow.add(const Duration(minutes: 15)),
      ),
      verify: (cubit) {
        expect(cubit.state.failure, isA<LockWindowFailure>());
      },
    );
  });

  group('SettingsPage Widget', () {
    Widget buildTestApp(
      SettingsCubit cubit, {
      Locale locale = const Locale('en'),
    }) {
      return MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: const SettingsPage(),
        ),
      );
    }

    testWidgets(
      'renders KPIs, language switcher, vacation, quota, and dry-run in EN',
      (tester) async {
        const settings = UserSettings(
          locale: 'en',
          monthlyEmergencyQuota: 3,
          emergencyQuotaUsed: 1,
        );
        const stats = StreakStats(
          currentStreak: 5,
          longestStreak: 12,
          totalAlarms: 10,
          completedAlarms: 9,
          totalTimeToWakeSeconds: 1800,
          isFrozen: true,
        );

        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(settings));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(stats));
        when(
          () => repository.scheduleDryRunAlarm(
            scheduledAt: any(named: 'scheduledAt'),
          ),
        ).thenAnswer((_) async => const Right(unit));
        when(() => repository.cancelDryRunAlarm())
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildCubit();
        await cubit.load();

        await tester.pumpWidget(buildTestApp(cubit));
        await tester.pumpAndSettle();

        expect(find.text('5 days'), findsOneWidget);
        expect(find.text('12 days'), findsOneWidget);
        expect(find.text('90%'), findsOneWidget);
        expect(find.text('Streak Frozen (Vacation)'), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text('2 of 3 remaining this month'),
          200,
        );
        expect(find.text('2 of 3 remaining this month'), findsOneWidget);

        await tester.scrollUntilVisible(find.text('Test Alarm Now (10s)'), 200);
        await tester.ensureVisible(find.text('Test Alarm Now (10s)'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Test Alarm Now (10s)'));
        await tester.pumpAndSettle();

        expect(
          find.text('Dry-run alarm scheduled for 10 seconds from now.'),
          findsOneWidget,
        );
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        final cancelButton = find.byKey(
          const Key('settings_cancel_dry_run_button'),
        );
        expect(cancelButton, findsOneWidget);
        await tester.ensureVisible(cancelButton);
        await tester.pumpAndSettle();
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        expect(cancelButton, findsNothing);
        verify(() => repository.cancelDryRunAlarm()).called(1);
      },
    );

    testWidgets('renders Arabic RTL and lock window banner when locked', (
      tester,
    ) async {
      const settings = UserSettings(locale: 'ar');
      const stats = StreakStats(currentStreak: 3);

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(settings));
      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(stats));

      final cubit = buildCubit();
      await cubit.load(
        nextFajrAlarmAt: fixedNow.add(const Duration(minutes: 10)),
      );

      await tester.pumpWidget(buildTestApp(cubit, locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.byIcon(Icons.lock_clock), findsOneWidget);
    });

    test(
      'SettingsCubit does not throw when closed while load is in flight',
      () async {
        final settingsCompleter = Completer<Either<Failure, UserSettings>>();
        when(() => repository.getSettings())
            .thenAnswer((_) => settingsCompleter.future);
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(StreakStats()));

        final cubit = buildCubit();
        final future = cubit.load();
        await cubit.close();
        settingsCompleter.complete(const Right(UserSettings()));
        await future;
      },
    );

    test(
      'SettingsCubit does not throw when closed while load is in flight',
      () async {
        final settingsCompleter = Completer<Either<Failure, UserSettings>>();
        when(() => repository.getSettings())
            .thenAnswer((_) => settingsCompleter.future);
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(StreakStats()));

        final cubit = buildCubit();
        final future = cubit.load();
        await cubit.close();
        settingsCompleter.complete(const Right(UserSettings()));
        await future;
      },
    );
  });

  group('SettingsCubit extended settings', () {
    late MockOnboardingRepository onboardingRepo;
    late MockPrayerScheduleRepository prayerRepo;
    late MockUpdateFajrAlarmConfigUseCase updateConfigUseCase;
    late MockRescheduleTomorrowFajrUseCase rescheduleUseCase;

    setUp(() {
      onboardingRepo = MockOnboardingRepository();
      prayerRepo = MockPrayerScheduleRepository();
      updateConfigUseCase = MockUpdateFajrAlarmConfigUseCase();
      rescheduleUseCase = MockRescheduleTomorrowFajrUseCase();
    });

    SettingsCubit buildExtendedCubit({
      Future<DateTime?> Function()? nextAlarmProvider,
    }) {
      return buildCubit(
        nextAlarmProvider: nextAlarmProvider,
        onboardingRepository: onboardingRepo,
        prayerScheduleRepository: prayerRepo,
        updateFajrAlarmConfig: updateConfigUseCase,
        rescheduleTomorrowFajr: rescheduleUseCase,
      );
    }

    test(
      'updateBathroomBarcode saves and syncs barcode and allows clearing',
      () async {
        const saved = UserSettings(bathroomBarcode: 'BATH-123');
        const cleared = UserSettings(bathroomBarcode: null);
        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(UserSettings()));
        when(() => repository.saveSettings(any()))
            .thenAnswer((_) async => const Right(saved));
        when(() => onboardingRepo.registerBathroomBarcode(any()))
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildExtendedCubit();
        final saveOk = await cubit.updateBathroomBarcode('  BATH-123  ');
        expect(saveOk, isTrue);
        expect(cubit.state.settings.bathroomBarcode, 'BATH-123');
        verify(() => onboardingRepo.registerBathroomBarcode('BATH-123'))
            .called(1);

        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(saved));
        when(() => repository.saveSettings(any()))
            .thenAnswer((_) async => const Right(cleared));

        final clearOk = await cubit.updateBathroomBarcode('   ');
        expect(clearOk, isTrue);
        expect(cubit.state.settings.bathroomBarcode, isNull);
        verify(() => onboardingRepo.registerBathroomBarcode(null)).called(1);
      },
    );

    test(
      'updateBathroomBarcode emits LockWindowFailure inside T - 30m',
      () async {
        when(() => repository.getSettings()).thenAnswer(
          (_) async => const Right(UserSettings(bathroomBarcode: 'OLD-1')),
        );
        final cubit = buildExtendedCubit();
        final ok = await cubit.updateBathroomBarcode(
          'NEW-2',
          nextFajrAlarmAt: fixedNow.add(const Duration(minutes: 10)),
        );

        expect(ok, isFalse);
        expect(cubit.state.failure, isA<LockWindowFailure>());
        verifyNever(() => onboardingRepo.registerBathroomBarcode(any()));
      },
    );

    test(
      'deactivateVacationMode clears active vacation and reschedules Fajr',
      () async {
        final activeVacation = VacationModeConfig(
          startDate: fixedNow,
          durationDays: 3,
          endDate: fixedNow.add(const Duration(days: 3)),
        );
        final withVacation = UserSettings(vacationMode: activeVacation);
        const resumed = UserSettings(vacationMode: null);
        const stats = StreakStats(isFrozen: false, currentStreak: 4);

        when(() => repository.getSettings())
            .thenAnswer((_) async => Right(withVacation));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(stats));
        when(() => repository.saveStreakStats(any()))
            .thenAnswer((_) async => const Right(stats));
        when(() => repository.saveSettings(any()))
            .thenAnswer((_) async => const Right(resumed));
        when(() => onboardingRepo.getOnboardingState())
            .thenAnswer((_) async => const Right(OnboardingStateEntity()));
        when(
          () => rescheduleUseCase.call(completedAt: any(named: 'completedAt')),
        ).thenAnswer((_) async => Right(fixedNow.add(const Duration(days: 1))));

        final cubit = buildExtendedCubit();
        await cubit.load();
        await cubit.deactivateVacationMode();

        expect(cubit.state.settings.vacationMode, isNull);
        expect(cubit.state.streakStats.isFrozen, isFalse);
        verify(
          () => rescheduleUseCase.call(completedAt: any(named: 'completedAt')),
        ).called(1);
      },
    );

    test(
      'updateAlarmConfig updates config, syncs city, and respects lock window',
      () async {
        const config = FajrAlarmConfig(
          latitude: 21.4225,
          longitude: 39.8262,
          cityName: 'Makkah',
        );
        final overview = PrayerScheduleOverview(
          config: config,
          schedules: const [],
          nextAlarmTime: fixedNow.add(const Duration(hours: 6)),
          isWithinLockWindow: false,
        );
        when(
          () => updateConfigUseCase.call(
            newConfig: config,
            now: any(named: 'now'),
            isChallengePending: false,
          ),
        ).thenAnswer((_) async => Right(overview));
        when(
          () => onboardingRepo.saveLocation(
            latitude: 21.4225,
            longitude: 39.8262,
            cityName: 'Makkah',
          ),
        ).thenAnswer((_) async => const Right(OnboardingStateEntity()));

        final cubit = buildExtendedCubit();
        final ok = await cubit.updateAlarmConfig(config);
        expect(ok, isTrue);
        verify(
          () => onboardingRepo.saveLocation(
            latitude: 21.4225,
            longitude: 39.8262,
            cityName: 'Makkah',
          ),
        ).called(1);

        final lockedOk = await cubit.updateAlarmConfig(
          config,
          nextFajrAlarmAt: fixedNow.add(const Duration(minutes: 5)),
        );
        expect(lockedOk, isFalse);
        expect(cubit.state.failure, isA<LockWindowFailure>());
      },
    );

    test('updateGeminiApiKey validates consent, rejects invalid key, and saves valid key', () async {
      final cubit = buildExtendedCubit();

      final missingConsent = await cubit.updateGeminiApiKey(
        apiKey: 'AIzaTestKey',
        consentAccepted: false,
      );
      expect(missingConsent, isFalse);
      expect(cubit.state.failure, isA<ValidationFailure>());

      when(() => onboardingRepo.setPrivacyConsentAccepted(true))
          .thenAnswer((_) async => const Right(unit));
      when(() => onboardingRepo.validateGeminiKey('bad-key'))
          .thenAnswer((_) async => const Right(false));
      final invalidOk = await cubit.updateGeminiApiKey(
        apiKey: 'bad-key',
        consentAccepted: true,
      );
      expect(invalidOk, isFalse);
      expect(cubit.state.failure, isA<ApiFailure>());

      when(() => onboardingRepo.validateGeminiKey('AIzaValidKey'))
          .thenAnswer((_) async => const Right(true));
      when(() => onboardingRepo.saveGeminiKey('AIzaValidKey'))
          .thenAnswer((_) async => const Right(unit));
      final validOk = await cubit.updateGeminiApiKey(
        apiKey: '  AIzaValidKey ',
        consentAccepted: true,
      );
      expect(validOk, isTrue);
      expect(cubit.state.failure, isNull);
      verify(() => onboardingRepo.saveGeminiKey('AIzaValidKey')).called(1);
    });

    test(
      'checkPermissions and requestPermissions delegate to repository',
      () async {
        const missing = PermissionsGateStatus(cameraGranted: false);
        const granted = PermissionsGateStatus(
          fullScreenIntentGranted: true,
          batteryOptimizationIgnored: true,
          cameraGranted: true,
          alarmPermissionGranted: true,
        );
        when(() => onboardingRepo.checkPermissions())
            .thenAnswer((_) async => const Right(missing));
        when(() => onboardingRepo.requestPermissions())
            .thenAnswer((_) async => const Right(granted));
        when(() => onboardingRepo.savePermissionsGranted(any()))
            .thenAnswer((_) async => const Right(unit));

        final cubit = buildExtendedCubit();
        expect(await cubit.checkPermissions(), missing);
        expect(await cubit.requestPermissions(), granted);
        verify(() => onboardingRepo.savePermissionsGranted(false)).called(1);
        verify(() => onboardingRepo.savePermissionsGranted(true)).called(1);
      },
    );
  });

  group('SettingsPage Extended Controls', () {
    late MockOnboardingRepository onboardingRepo;
    late MockPrayerScheduleRepository prayerRepo;
    late MockUpdateFajrAlarmConfigUseCase updateConfigUseCase;
    late MockRescheduleTomorrowFajrUseCase rescheduleUseCase;

    setUp(() {
      onboardingRepo = MockOnboardingRepository();
      prayerRepo = MockPrayerScheduleRepository();
      updateConfigUseCase = MockUpdateFajrAlarmConfigUseCase();
      rescheduleUseCase = MockRescheduleTomorrowFajrUseCase();

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(UserSettings(locale: 'en')));
      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(StreakStats()));
      when(() => prayerRepo.getAlarmConfig()).thenAnswer(
        (_) async => const Right(
          FajrAlarmConfig(
            latitude: 30.0444,
            longitude: 31.2357,
            cityName: 'Cairo',
          ),
        ),
      );
      when(() => onboardingRepo.getOnboardingState()).thenAnswer(
        (_) async => const Right(
          OnboardingStateEntity(
            privacyConsentAccepted: true,
            apiKeyValidated: false,
          ),
        ),
      );
      when(() => onboardingRepo.checkPermissions()).thenAnswer(
        (_) async => const Right(PermissionsGateStatus(cameraGranted: true)),
      );
      when(() => onboardingRepo.savePermissionsGranted(any()))
          .thenAnswer((_) async => const Right(unit));
    });

    SettingsCubit buildExtendedCubit() {
      return buildCubit(
        onboardingRepository: onboardingRepo,
        prayerScheduleRepository: prayerRepo,
        updateFajrAlarmConfig: updateConfigUseCase,
        rescheduleTomorrowFajr: rescheduleUseCase,
      );
    }

    Widget buildExtendedApp(
      SettingsCubit cubit, {
      BarcodeScannerBuilder? scannerBuilder,
    }) {
      return MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SettingsCubit>.value(
          value: cubit,
          child: SettingsPage(barcodeScannerBuilder: scannerBuilder),
        ),
      );
    }

    Future<void> scrollToKey(WidgetTester tester, Key key) async {
      await tester.dragUntilVisible(
        find.byKey(key),
        find.descendant(
          of: find.byType(SettingsPage),
          matching: find.byType(Scrollable),
        ),
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'opens Bathroom Barcode sheet, scans & saves barcode, then clears it',
      (tester) async {
        var currentSettings = const UserSettings(locale: 'en');
        var currentOnboarding = const OnboardingStateEntity(
          privacyConsentAccepted: true,
        );
        when(() => repository.getSettings())
            .thenAnswer((_) async => Right(currentSettings));
        when(() => repository.saveStreakStats(any()))
            .thenAnswer((_) async => const Right(StreakStats()));
        when(() => repository.saveSettings(any())).thenAnswer((inv) async {
          currentSettings = inv.positionalArguments.first as UserSettings;
          return Right(currentSettings);
        });
        when(() => onboardingRepo.getOnboardingState())
            .thenAnswer((_) async => Right(currentOnboarding));
        when(() => onboardingRepo.registerBathroomBarcode(any()))
            .thenAnswer((inv) async {
              currentOnboarding = currentOnboarding.copyWith(
                registeredBarcode: inv.positionalArguments.first as String?,
              );
              return const Right(unit);
            });

        final cubit = buildExtendedCubit();
        await cubit.load();

        await tester.pumpWidget(
          buildExtendedApp(
            cubit,
            scannerBuilder: (context, onDetected) => TextButton(
              key: const Key('mock_detect_barcode_button'),
              onPressed: () => onDetected('BATH-SCAN-99'),
              child: const Text('Detect'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await scrollToKey(
          tester,
          const Key('settings_open_barcode_sheet_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_open_barcode_sheet_button')),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('settings_scan_barcode_button')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('mock_detect_barcode_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('settings_save_barcode_button')));
        await tester.pumpAndSettle();

        expect(cubit.state.settings.bathroomBarcode, 'BATH-SCAN-99');
        expect(find.textContaining('BATH-SCAN-99'), findsOneWidget);

        // Reopen sheet, enter manual barcode and save, then reopen and clear.
        await tester.tap(
          find.byKey(const Key('settings_open_barcode_sheet_button')),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('settings_barcode_input_field')),
          'MANUAL-42',
        );
        await tester.tap(find.byKey(const Key('settings_save_barcode_button')));
        await tester.pumpAndSettle();
        expect(cubit.state.settings.bathroomBarcode, 'MANUAL-42');

        await tester.tap(
          find.byKey(const Key('settings_open_barcode_sheet_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('settings_clear_barcode_button')),
        );
        await tester.pumpAndSettle();

        expect(cubit.state.settings.bathroomBarcode, isNull);
        verify(() => onboardingRepo.registerBathroomBarcode(null)).called(1);
      },
    );

    testWidgets(
      'updates location/method, Gemini API key, permissions, and deactivates vacation',
      (tester) async {
        final activeVacation = VacationModeConfig(
          startDate: fixedNow,
          durationDays: 2,
          endDate: fixedNow.add(const Duration(days: 2)),
        );
        var currentSettings = UserSettings(
          locale: 'en',
          vacationMode: activeVacation,
        );
        var currentOnboarding = const OnboardingStateEntity(
          privacyConsentAccepted: false,
          apiKeyValidated: false,
        );
        when(() => repository.getSettings())
            .thenAnswer((_) async => Right(currentSettings));
        when(() => repository.saveStreakStats(any()))
            .thenAnswer((_) async => const Right(StreakStats()));
        when(() => repository.saveSettings(any())).thenAnswer((inv) async {
          currentSettings = inv.positionalArguments.first as UserSettings;
          return Right(currentSettings);
        });
        when(() => onboardingRepo.getOnboardingState())
            .thenAnswer((_) async => Right(currentOnboarding));
        when(
          () => updateConfigUseCase.call(
            newConfig: any(named: 'newConfig'),
            now: any(named: 'now'),
            isChallengePending: false,
          ),
        ).thenAnswer((inv) async {
          final updated = inv.namedArguments[#newConfig] as FajrAlarmConfig;
          return Right(
            PrayerScheduleOverview(
              config: updated,
              schedules: const [],
              nextAlarmTime: fixedNow.add(const Duration(hours: 6)),
              isWithinLockWindow: false,
            ),
          );
        });
        when(
          () => onboardingRepo.saveLocation(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            cityName: any(named: 'cityName'),
          ),
        ).thenAnswer((_) async => Right(currentOnboarding));
        when(() => onboardingRepo.setPrivacyConsentAccepted(true))
            .thenAnswer((_) async => const Right(unit));
        when(() => onboardingRepo.validateGeminiKey('AIzaWidgetKey'))
            .thenAnswer((_) async => const Right(true));
        when(() => onboardingRepo.saveGeminiKey('AIzaWidgetKey'))
            .thenAnswer((_) async {
              currentOnboarding = currentOnboarding.copyWith(
                privacyConsentAccepted: true,
                apiKeyValidated: true,
              );
              return const Right(unit);
            });
        when(() => onboardingRepo.requestPermissions()).thenAnswer(
          (_) async => const Right(
            PermissionsGateStatus(
              fullScreenIntentGranted: true,
              batteryOptimizationIgnored: true,
              cameraGranted: true,
              alarmPermissionGranted: true,
            ),
          ),
        );
        when(
          () => rescheduleUseCase.call(completedAt: any(named: 'completedAt')),
        ).thenAnswer((_) async => Right(fixedNow.add(const Duration(days: 1))));

        final cubit = buildExtendedCubit();
        await cubit.load();
        await tester.pumpWidget(buildExtendedApp(cubit));
        await tester.pumpAndSettle();

        // Deactivate vacation mode early.
        await scrollToKey(
          tester,
          const Key('settings_deactivate_vacation_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_deactivate_vacation_button')),
        );
        await tester.pumpAndSettle();
        expect(cubit.state.settings.vacationMode, isNull);

        // Open Location & Method sheet, pick Makkah, and save.
        await scrollToKey(
          tester,
          const Key('settings_edit_location_method_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_edit_location_method_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Makkah'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('settings_save_location_method_button')),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('Makkah'), findsOneWidget);

        // Toggle Fajr alarm enabled switch directly on SettingsPage.
        await scrollToKey(tester, const Key('settings_alarm_enabled_switch'));
        await tester.tap(
          find.byKey(const Key('settings_alarm_enabled_switch')),
        );
        await tester.pumpAndSettle();

        // Open Gemini API Key sheet, accept consent, enter key, and verify.
        await scrollToKey(
          tester,
          const Key('settings_open_api_key_sheet_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_open_api_key_sheet_button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('settings_privacy_consent_checkbox')),
        );
        await tester.enterText(
          find.byKey(const Key('settings_api_key_field')),
          'AIzaWidgetKey',
        );
        await tester.tap(find.byKey(const Key('settings_save_api_key_button')));
        await tester.pumpAndSettle();
        verify(() => onboardingRepo.saveGeminiKey('AIzaWidgetKey')).called(1);

        // Grant and refresh permissions.
        await scrollToKey(
          tester,
          const Key('settings_grant_permissions_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_grant_permissions_button')),
        );
        await tester.pumpAndSettle();
        verify(() => onboardingRepo.requestPermissions()).called(1);

        await scrollToKey(
          tester,
          const Key('settings_refresh_permissions_button'),
        );
        await tester.tap(
          find.byKey(const Key('settings_refresh_permissions_button')),
        );
        await tester.pumpAndSettle();
        verify(() => onboardingRepo.checkPermissions())
            .called(greaterThanOrEqualTo(2));
      },
    );
  });
}
