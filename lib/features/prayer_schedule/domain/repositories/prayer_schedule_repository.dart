import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fpdart/fpdart.dart';

/// Abstract contract for persisting and retrieving 30-day Fajr schedules and alarm config.
abstract interface class PrayerScheduleRepository {
  /// Returns the cached 30-day rolling Fajr schedule.
  Future<Either<Failure, List<PrayerSchedule>>> getCached30DaySchedule();

  /// Persists the 30-day rolling Fajr schedule to local storage.
  Future<Either<Failure, Unit>> save30DaySchedule(
    List<PrayerSchedule> schedules,
  );

  /// Returns the persisted [FajrAlarmConfig], or a default config if none saved.
  Future<Either<Failure, FajrAlarmConfig>> getAlarmConfig();

  /// Persists [FajrAlarmConfig] to local storage.
  Future<Either<Failure, Unit>> saveAlarmConfig(FajrAlarmConfig config);

  /// Returns the next scheduled Fajr alarm timestamp, if any.
  Future<Either<Failure, DateTime?>> getNextScheduledAlarm();

  /// Persists the next scheduled Fajr alarm timestamp.
  Future<Either<Failure, Unit>> saveNextScheduledAlarm(DateTime? alarmTime);
}
