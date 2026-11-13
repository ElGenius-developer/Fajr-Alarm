import 'dart:io';

import 'package:fajr_alarm/features/prayer_schedule/data/datasources/prayer_schedule_local_data_source.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/fajr_alarm_config_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/prayer_schedule_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;
  late PrayerScheduleLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('fajr_schedule_hive_test_');
    Hive.init(tempDir.path);
    dataSource = PrayerScheduleLocalDataSourceImpl(Hive);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('PrayerScheduleLocalDataSourceImpl', () {
    test(
      'persists and retrieves 30-day schedule via explicit TypeAdapter',
      () async {
        final schedules = List.generate(
          30,
          (i) => PrayerScheduleHiveModel.fromDomain(
            PrayerSchedule(
              date: DateTime(2026, 5, 1 + i),
              fajrTime: DateTime(2026, 5, 1 + i, 4, 15),
              sunriseTime: DateTime(2026, 5, 1 + i, 5, 45),
              latitude: 30.0444,
              longitude: 31.2357,
              calculationMethod: 'egyptian',
              madhab: 'shafi',
            ),
          ),
        );

        await dataSource.save30DaySchedule(schedules);
        final loaded = await dataSource.get30DaySchedule();

        expect(loaded, hasLength(30));
        expect(loaded.first.toDomain().date, DateTime(2026, 5, 1));
        expect(loaded.last.toDomain().date, DateTime(2026, 5, 30));
        expect(loaded.first.toDomain().fajrTime, DateTime(2026, 5, 1, 4, 15));
      },
    );

    test(
      'persists and retrieves FajrAlarmConfig via explicit TypeAdapter',
      () async {
        const config = FajrAlarmConfig(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
          calculationMethod: FajrCalculationMethod.egyptian,
          madhab: FajrMadhab.hanafi,
          mode: FajrAlarmMode.relativeToAdhan,
          offsetDirection: FajrOffsetDirection.before,
          offsetMinutes: 15,
          manualHour: 4,
          manualMinute: 20,
          isEnabled: true,
        );

        await dataSource.saveAlarmConfig(
          FajrAlarmConfigHiveModel.fromDomain(config),
        );
        final loaded = await dataSource.getAlarmConfig();

        expect(loaded, isNotNull);
        expect(loaded!.toDomain(), config);
      },
    );

    test('persists and clears nextScheduledAlarm timestamp', () async {
      final alarmTime = DateTime(2026, 5, 2, 4, 10);

      await dataSource.saveNextScheduledAlarm(alarmTime);
      expect(await dataSource.getNextScheduledAlarm(), alarmTime);

      await dataSource.saveNextScheduledAlarm(null);
      expect(await dataSource.getNextScheduledAlarm(), isNull);
    });
  });
}
