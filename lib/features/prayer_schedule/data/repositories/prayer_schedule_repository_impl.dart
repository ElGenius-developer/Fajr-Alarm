import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/datasources/prayer_schedule_local_data_source.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/fajr_alarm_config_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/prayer_schedule_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Repository implementation backed by [PrayerScheduleLocalDataSource] and
/// optional [AlarmPlatformRepository] for OS alarm scheduling.
class PrayerScheduleRepositoryImpl implements PrayerScheduleRepository {
  const PrayerScheduleRepositoryImpl(
    this._localDataSource, {
    this._alarmPlatformRepository,
  });

  final PrayerScheduleLocalDataSource _localDataSource;
  final AlarmPlatformRepository? _alarmPlatformRepository;

  /// Default Cairo coordinates when no user config has been persisted yet.
  static const FajrAlarmConfig defaultConfig = FajrAlarmConfig(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'Cairo',
    calculationMethod: FajrCalculationMethod.egyptian,
  );

  @override
  Future<Either<Failure, List<PrayerSchedule>>> getCached30DaySchedule() async {
    try {
      final models = await _localDataSource.get30DaySchedule();
      return Right(
        models.map((model) => model.toDomain()).toList(growable: false),
      );
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to read 30-day schedule: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> save30DaySchedule(
    List<PrayerSchedule> schedules,
  ) async {
    try {
      final models = schedules
          .map(PrayerScheduleHiveModel.fromDomain)
          .toList(growable: false);
      await _localDataSource.save30DaySchedule(models);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to save 30-day schedule: $e'));
    }
  }

  @override
  Future<Either<Failure, FajrAlarmConfig>> getAlarmConfig() async {
    try {
      final model = await _localDataSource.getAlarmConfig();
      if (model == null) {
        return const Right(defaultConfig);
      }
      return Right(model.toDomain());
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to read alarm config: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAlarmConfig(FajrAlarmConfig config) async {
    try {
      await _localDataSource.saveAlarmConfig(
        FajrAlarmConfigHiveModel.fromDomain(config),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to save alarm config: $e'));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getNextScheduledAlarm() async {
    try {
      final alarm = await _localDataSource.getNextScheduledAlarm();
      return Right(alarm);
    } catch (e) {
      return Left(
        Failure.cache(message: 'Failed to read next scheduled alarm: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNextScheduledAlarm(
    DateTime? alarmTime,
  ) async {
    try {
      await _localDataSource.saveNextScheduledAlarm(alarmTime);
    } catch (e) {
      return Left(
        Failure.cache(message: 'Failed to save next scheduled alarm: $e'),
      );
    }

    final AlarmPlatformRepository? platformRepository =
        _alarmPlatformRepository;
    if (platformRepository == null) {
      return const Right(unit);
    }

    if (alarmTime != null) {
      return platformRepository.scheduleAlarm(
        scheduledAt: alarmTime,
        isDryRun: false,
      );
    }
    return platformRepository.cancelAllAlarms();
  }
}
