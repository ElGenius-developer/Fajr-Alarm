import 'dart:io';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/settings_and_streak/data/datasources/settings_local_data_source.dart';
import 'package:fajr_alarm/features/settings_and_streak/data/repositories/settings_and_streak_repository_impl.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/streak_stats.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/user_settings.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/entities/vacation_mode_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

void main() {
  group('HiveSettingsLocalDataSource (explicit TypeAdapters)', () {
    late Directory tempDir;
    late Box<UserSettings> settingsBox;
    late Box<StreakStats> streakBox;
    late HiveSettingsLocalDataSource dataSource;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_settings_test_');
      Hive.init(tempDir.path);
      registerSettingsAdapters(Hive);
      settingsBox = await Hive.openBox<UserSettings>('test_settings_box');
      streakBox = await Hive.openBox<StreakStats>('test_streak_box');
      dataSource = HiveSettingsLocalDataSource(
        settingsBox: settingsBox,
        streakBox: streakBox,
      );
    });

    tearDown(() async {
      await settingsBox.close();
      await streakBox.close();
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('returns default UserSettings and StreakStats when empty', () async {
      expect(await dataSource.getSettings(), const UserSettings());
      expect(await dataSource.getStreakStats(), const StreakStats());
    });

    test('round-trips UserSettings including VacationModeConfig', () async {
      final start = DateTime(2026, 11, 14, 12, 0);
      final end = DateTime(2026, 11, 17, 12, 0);
      final settings = UserSettings(
        locale: 'en',
        monthlyEmergencyQuota: 5,
        emergencyQuotaUsed: 2,
        emergencyQuotaResetMonth: 202611,
        bathroomBarcode: '6221000012345',
        alarmOffsetMinutes: -10,
        manualAlarmHour: 4,
        manualAlarmMinute: 45,
        vacationMode: VacationModeConfig(
          startDate: start,
          durationDays: 3,
          endDate: end,
        ),
      );

      await dataSource.saveSettings(settings);
      final loaded = await dataSource.getSettings();
      expect(loaded, settings);
    });

    test('round-trips StreakStats including lastCompletedDate', () async {
      final completedAt = DateTime(2026, 11, 14, 5, 2);
      final stats = StreakStats(
        currentStreak: 12,
        longestStreak: 20,
        totalAlarms: 30,
        completedAlarms: 28,
        totalTimeToWakeSeconds: 3600,
        isFrozen: true,
        lastCompletedDate: completedAt,
      );

      await dataSource.saveStreakStats(stats);
      final loaded = await dataSource.getStreakStats();
      expect(loaded, stats);
    });
  });

  group('SettingsAndStreakRepositoryImpl', () {
    late MockSettingsLocalDataSource localDataSource;
    late SettingsAndStreakRepositoryImpl repository;

    setUp(() {
      localDataSource = MockSettingsLocalDataSource();
      repository = SettingsAndStreakRepositoryImpl(
        localDataSource: localDataSource,
      );
    });

    test('returns Right on successful getSettings and saveSettings', () async {
      const settings = UserSettings(locale: 'en');
      when(() => localDataSource.getSettings())
          .thenAnswer((_) async => settings);
      when(() => localDataSource.saveSettings(settings))
          .thenAnswer((_) async => settings);

      expect(
        await repository.getSettings(),
        const Right<Failure, UserSettings>(settings),
      );
      expect(
        await repository.saveSettings(settings),
        const Right<Failure, UserSettings>(settings),
      );
    });

    test('returns CacheFailure when localDataSource throws', () async {
      when(() => localDataSource.getSettings()).thenThrow(Exception('disk io'));
      when(() => localDataSource.getStreakStats())
          .thenThrow(Exception('disk io'));

      final settingsResult = await repository.getSettings();
      final streakResult = await repository.getStreakStats();

      settingsResult.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected CacheFailure'),
      );
      streakResult.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected CacheFailure'),
      );
    });

    test('delegates scheduleDryRunAlarm to injected scheduler', () async {
      DateTime? captured;
      final repo = SettingsAndStreakRepositoryImpl(
        localDataSource: localDataSource,
        onScheduleDryRunAlarm: (scheduledAt) async {
          captured = scheduledAt;
          return const Right(unit);
        },
      );
      final target = DateTime(2026, 11, 14, 10, 0, 10);

      final result = await repo.scheduleDryRunAlarm(scheduledAt: target);

      expect(result, const Right<Failure, Unit>(unit));
      expect(captured, target);
    });
  });
}
