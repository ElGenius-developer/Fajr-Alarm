import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
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

void main() {
  late MockSettingsAndStreakRepository repository;
  final fixedNow = DateTime(2026, 11, 13, 21, 0);

  setUpAll(() {
    registerFallbackValue(const UserSettings());
    registerFallbackValue(const StreakStats());
  });

  setUp(() {
    repository = MockSettingsAndStreakRepository();
  });

  SettingsCubit buildCubit({
    DateTime Function()? nowProvider,
    Future<DateTime?> Function()? nextAlarmProvider,
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
}
