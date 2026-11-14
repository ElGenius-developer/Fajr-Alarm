import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/streak_stats.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/user_settings.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/vacation_mode_config.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/repositories/settings_and_streak_repository.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/activate_vacation_mode_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/auto_resume_vacation_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/consume_emergency_quota_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_settings_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/get_streak_stats_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/record_alarm_completion_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/trigger_dry_run_alarm_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/update_settings_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsAndStreakRepository extends Mock
    implements SettingsAndStreakRepository {}

void main() {
  late MockSettingsAndStreakRepository repository;

  setUpAll(() {
    registerFallbackValue(const UserSettings());
    registerFallbackValue(const StreakStats());
  });

  setUp(() {
    repository = MockSettingsAndStreakRepository();
  });

  group('GetSettingsUseCase & GetStreakStatsUseCase', () {
    test('returns settings from repository', () async {
      const settings = UserSettings(locale: 'en', monthlyEmergencyQuota: 2);
      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(settings));

      final useCase = GetSettingsUseCase(repository);
      final result = await useCase();

      expect(result, const Right<Failure, UserSettings>(settings));
    });

    test('returns streak stats from repository', () async {
      const stats = StreakStats(currentStreak: 5, longestStreak: 10);
      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(stats));

      final useCase = GetStreakStatsUseCase(repository);
      final result = await useCase();

      expect(result, const Right<Failure, StreakStats>(stats));
    });
  });

  group('UpdateSettingsUseCase', () {
    late UpdateSettingsUseCase useCase;
    final fajrAt = DateTime(2026, 11, 14, 5, 0);

    setUp(() {
      useCase = UpdateSettingsUseCase(repository);
    });

    test('saves valid settings outside T - 30m lock window', () async {
      const current = UserSettings(locale: 'ar', monthlyEmergencyQuota: 3);
      const updated = UserSettings(locale: 'en', monthlyEmergencyQuota: 2);
      final now = fajrAt.subtract(const Duration(minutes: 31));

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(current));
      when(() => repository.saveSettings(updated))
          .thenAnswer((_) async => const Right(updated));

      final result = await useCase(
        newSettings: updated,
        now: now,
        nextFajrAlarmAt: fajrAt,
      );

      expect(result, const Right<Failure, UserSettings>(updated));
      verify(() => repository.saveSettings(updated)).called(1);
    });

    test(
      'returns LockWindowFailure when modifying quota inside T - 30m',
      () async {
        const current = UserSettings(monthlyEmergencyQuota: 3);
        const updated = UserSettings(monthlyEmergencyQuota: 5);
        final now = fajrAt.subtract(const Duration(minutes: 30));

        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(current));

        final result = await useCase(
          newSettings: updated,
          now: now,
          nextFajrAlarmAt: fajrAt,
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<LockWindowFailure>()),
          (_) => fail('Expected LockWindowFailure'),
        );
        verifyNever(() => repository.saveSettings(any()));
      },
    );

    test(
      'returns LockWindowFailure when modifying alarm offset while ringing',
      () async {
        const current = UserSettings(alarmOffsetMinutes: 0);
        const updated = UserSettings(alarmOffsetMinutes: 15);

        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(current));

        final result = await useCase(
          newSettings: updated,
          now: fajrAt,
          nextFajrAlarmAt: fajrAt,
          isAlarmRinging: true,
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<LockWindowFailure>()),
          (_) => fail('Expected LockWindowFailure'),
        );
      },
    );

    test('allows switching locale even inside T - 30m lock window', () async {
      const current = UserSettings(locale: 'ar');
      const updated = UserSettings(locale: 'en');
      final now = fajrAt.subtract(const Duration(minutes: 10));

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(current));
      when(() => repository.saveSettings(updated))
          .thenAnswer((_) async => const Right(updated));

      final result = await useCase(
        newSettings: updated,
        now: now,
        nextFajrAlarmAt: fajrAt,
      );

      expect(result, const Right<Failure, UserSettings>(updated));
    });

    test(
      'returns ValidationFailure for invalid locale or negative quota',
      () async {
        final result = await useCase(
          newSettings: const UserSettings(
            locale: 'fr',
            monthlyEmergencyQuota: -1,
          ),
          now: fajrAt.subtract(const Duration(hours: 2)),
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Expected ValidationFailure'),
        );
      },
    );
  });

  group('ActivateVacationModeUseCase', () {
    late ActivateVacationModeUseCase useCase;
    final fajrAt = DateTime(2026, 11, 14, 5, 0);

    setUp(() {
      useCase = ActivateVacationModeUseCase(repository);
    });

    test('rejects durationDays <= 0 with ValidationFailure', () async {
      final result = await useCase(
        durationDays: 0,
        now: fajrAt.subtract(const Duration(hours: 3)),
        nextFajrAlarmAt: fajrAt,
      );

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected ValidationFailure'),
      );
    });

    test('rejects activation inside T - 30m Pre-Fajr Lock Window', () async {
      final result = await useCase(
        durationDays: 3,
        now: fajrAt.subtract(const Duration(minutes: 15)),
        nextFajrAlarmAt: fajrAt,
      );

      result.fold(
        (failure) => expect(failure, isA<LockWindowFailure>()),
        (_) => fail('Expected LockWindowFailure'),
      );
    });

    test(
      'activates vacation mode and applies Streak Freeze outside lock window',
      () async {
        final now = DateTime(2026, 11, 13, 20, 0);
        const currentSettings = UserSettings();
        const currentStats = StreakStats(currentStreak: 7, isFrozen: false);

        final expectedVacation = VacationModeConfig(
          startDate: now,
          durationDays: 4,
          endDate: now.add(const Duration(days: 4)),
        );
        final expectedSettings = currentSettings.copyWith(
          vacationMode: expectedVacation,
        );
        final expectedStats = currentStats.copyWith(isFrozen: true);

        when(() => repository.getSettings())
            .thenAnswer((_) async => const Right(currentSettings));
        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(currentStats));
        when(() => repository.saveStreakStats(expectedStats))
            .thenAnswer((_) async => Right(expectedStats));
        when(() => repository.saveSettings(expectedSettings))
            .thenAnswer((_) async => Right(expectedSettings));

        final result = await useCase(
          durationDays: 4,
          now: now,
          nextFajrAlarmAt: fajrAt,
        );

        expect(result, Right<Failure, UserSettings>(expectedSettings));
        verify(() => repository.saveStreakStats(expectedStats)).called(1);
        verify(() => repository.saveSettings(expectedSettings)).called(1);
      },
    );
  });

  group('AutoResumeVacationUseCase', () {
    late AutoResumeVacationUseCase useCase;

    setUp(() {
      useCase = AutoResumeVacationUseCase(repository);
    });

    test('clears expired vacation mode and unfreezes streak', () async {
      final start = DateTime(2026, 11, 10, 12, 0);
      final end = DateTime(2026, 11, 13, 12, 0);
      final now = DateTime(2026, 11, 13, 12, 1);

      final settings = UserSettings(
        vacationMode: VacationModeConfig(
          startDate: start,
          durationDays: 3,
          endDate: end,
        ),
      );
      const stats = StreakStats(currentStreak: 12, isFrozen: true);

      when(() => repository.getSettings())
          .thenAnswer((_) async => Right(settings));
      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(stats));
      when(() => repository.saveStreakStats(stats.copyWith(isFrozen: false)))
          .thenAnswer((_) async => Right(stats.copyWith(isFrozen: false)));
      when(
        () => repository.saveSettings(settings.copyWith(vacationMode: null)),
      ).thenAnswer((_) async => Right(settings.copyWith(vacationMode: null)));

      final result = await useCase(now: now);

      expect(
        result,
        Right<Failure, UserSettings>(settings.copyWith(vacationMode: null)),
      );
      verify(() => repository.saveStreakStats(stats.copyWith(isFrozen: false)))
          .called(1);
    });

    test('keeps active vacation mode when now is before endDate', () async {
      final start = DateTime(2026, 11, 10, 12, 0);
      final end = DateTime(2026, 11, 15, 12, 0);
      final now = DateTime(2026, 11, 13, 12, 0);

      final settings = UserSettings(
        vacationMode: VacationModeConfig(
          startDate: start,
          durationDays: 5,
          endDate: end,
        ),
      );

      when(() => repository.getSettings())
          .thenAnswer((_) async => Right(settings));

      final result = await useCase(now: now);

      expect(result, Right<Failure, UserSettings>(settings));
      verifyNever(() => repository.saveSettings(any()));
      verifyNever(() => repository.saveStreakStats(any()));
    });
  });

  group('RecordAlarmCompletionUseCase', () {
    late RecordAlarmCompletionUseCase useCase;

    setUp(() {
      useCase = RecordAlarmCompletionUseCase(repository);
    });

    test('skips streak and KPI updates when isDryRun is true', () async {
      const stats = StreakStats(currentStreak: 4, totalAlarms: 10);
      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(stats));

      final result = await useCase(
        timeToWakeSeconds: 90,
        isDryRun: true,
        completed: true,
      );

      expect(result, const Right<Failure, StreakStats>(stats));
      verifyNever(() => repository.saveStreakStats(any()));
    });

    test('updates streak and KPIs on real alarm completion', () async {
      const stats = StreakStats(
        currentStreak: 4,
        longestStreak: 4,
        totalAlarms: 9,
        completedAlarms: 8,
        totalTimeToWakeSeconds: 1440,
      );
      final completedAt = DateTime(2026, 11, 14, 5, 3);
      final expected = StreakStats(
        currentStreak: 5,
        longestStreak: 5,
        totalAlarms: 10,
        completedAlarms: 9,
        totalTimeToWakeSeconds: 1620,
        lastCompletedDate: completedAt,
      );

      when(() => repository.getStreakStats())
          .thenAnswer((_) async => const Right(stats));
      when(() => repository.saveStreakStats(expected))
          .thenAnswer((_) async => Right(expected));

      final result = await useCase(
        timeToWakeSeconds: 180,
        isDryRun: false,
        completed: true,
        completedAt: completedAt,
      );

      expect(result, Right<Failure, StreakStats>(expected));
      expect(expected.completionRate, 90.0);
      expect(expected.averageTimeToWakeMinutes, 3.0);
    });

    test(
      'preserves currentStreak when isFrozen is true on missed alarm',
      () async {
        const stats = StreakStats(
          currentStreak: 6,
          longestStreak: 6,
          totalAlarms: 6,
          completedAlarms: 6,
          isFrozen: true,
        );
        final expected = stats.copyWith(totalAlarms: 7);

        when(() => repository.getStreakStats())
            .thenAnswer((_) async => const Right(stats));
        when(() => repository.saveStreakStats(expected))
            .thenAnswer((_) async => Right(expected));

        final result = await useCase(
          timeToWakeSeconds: 0,
          isDryRun: false,
          completed: false,
        );

        expect(result, Right<Failure, StreakStats>(expected));
      },
    );
  });

  group('ConsumeEmergencyQuotaUseCase', () {
    late ConsumeEmergencyQuotaUseCase useCase;

    setUp(() {
      useCase = ConsumeEmergencyQuotaUseCase(repository);
    });

    test('consumes 1 quota unit in same month', () async {
      final now = DateTime(2026, 11, 14, 5, 5);
      const settings = UserSettings(
        monthlyEmergencyQuota: 3,
        emergencyQuotaUsed: 1,
        emergencyQuotaResetMonth: 202611,
      );
      final expected = settings.copyWith(emergencyQuotaUsed: 2);

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(settings));
      when(() => repository.saveSettings(expected))
          .thenAnswer((_) async => Right(expected));

      final result = await useCase(now: now);

      expect(result, Right<Failure, UserSettings>(expected));
    });

    test('resets used count on new month before consuming', () async {
      final now = DateTime(2026, 12, 1, 5, 5);
      const settings = UserSettings(
        monthlyEmergencyQuota: 2,
        emergencyQuotaUsed: 2,
        emergencyQuotaResetMonth: 202611,
      );
      final expected = settings.copyWith(
        emergencyQuotaUsed: 1,
        emergencyQuotaResetMonth: 202612,
      );

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(settings));
      when(() => repository.saveSettings(expected))
          .thenAnswer((_) async => Right(expected));

      final result = await useCase(now: now);

      expect(result, Right<Failure, UserSettings>(expected));
    });

    test('returns QuotaExceededFailure when remaining quota is 0', () async {
      final now = DateTime(2026, 11, 14, 5, 5);
      const settings = UserSettings(
        monthlyEmergencyQuota: 2,
        emergencyQuotaUsed: 2,
        emergencyQuotaResetMonth: 202611,
      );

      when(() => repository.getSettings())
          .thenAnswer((_) async => const Right(settings));

      final result = await useCase(now: now);

      result.fold(
        (failure) => expect(failure, isA<QuotaExceededFailure>()),
        (_) => fail('Expected QuotaExceededFailure'),
      );
      verifyNever(() => repository.saveSettings(any()));
    });
  });

  group('TriggerDryRunAlarmUseCase', () {
    late TriggerDryRunAlarmUseCase useCase;
    final fajrAt = DateTime(2026, 11, 14, 5, 0);

    setUp(() {
      useCase = TriggerDryRunAlarmUseCase(repository);
    });

    test(
      'schedules dry-run alarm 10 seconds from now outside lock window',
      () async {
        final now = DateTime(2026, 11, 13, 21, 0);
        final scheduledAt = now.add(const Duration(seconds: 10));

        when(() => repository.scheduleDryRunAlarm(scheduledAt: scheduledAt))
            .thenAnswer((_) async => const Right(unit));

        final result = await useCase(now: now, nextFajrAlarmAt: fajrAt);

        expect(result, Right<Failure, DateTime>(scheduledAt));
        verify(() => repository.scheduleDryRunAlarm(scheduledAt: scheduledAt))
            .called(1);
      },
    );

    test('returns LockWindowFailure inside T - 30m lock window', () async {
      final now = fajrAt.subtract(const Duration(minutes: 20));

      final result = await useCase(now: now, nextFajrAlarmAt: fajrAt);

      result.fold(
        (failure) => expect(failure, isA<LockWindowFailure>()),
        (_) => fail('Expected LockWindowFailure'),
      );
      verifyNever(
        () => repository.scheduleDryRunAlarm(
          scheduledAt: any(named: 'scheduledAt'),
        ),
      );
    });
  });
}
