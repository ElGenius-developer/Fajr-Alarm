import 'package:adhan/adhan.dart' as adhan;
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Calculates a 30-day rolling Fajr schedule offline using `adhan` and caches it.
class Calculate30DayFajrScheduleUseCase {
  const Calculate30DayFajrScheduleUseCase(this._repository);

  static const int defaultRollingDays = 30;

  final PrayerScheduleRepository _repository;

  /// Calculates [days] days of Fajr times starting from [startDate] (defaults to today)
  /// and persists the rolling cache unless [persist] is false.
  Future<Either<Failure, List<PrayerSchedule>>> call({
    required FajrAlarmConfig config,
    DateTime? startDate,
    int days = defaultRollingDays,
    bool persist = true,
  }) async {
    if (!config.latitude.isFinite ||
        config.latitude < -90 ||
        config.latitude > 90) {
      return const Left(
        Failure.validation(message: 'Latitude must be between -90 and 90.'),
      );
    }
    if (!config.longitude.isFinite ||
        config.longitude < -180 ||
        config.longitude > 180) {
      return const Left(
        Failure.validation(message: 'Longitude must be between -180 and 180.'),
      );
    }
    if (days <= 0) {
      return const Left(
        Failure.validation(message: 'Days count must be greater than zero.'),
      );
    }

    final base = startDate ?? DateTime.now();
    final normalizedStart = DateTime(base.year, base.month, base.day);
    final coordinates = adhan.Coordinates(config.latitude, config.longitude);
    final params = _mapMethod(config.calculationMethod).getParameters()
      ..madhab = _mapMadhab(config.madhab);

    final schedules = <PrayerSchedule>[];
    for (var i = 0; i < days; i++) {
      final targetDate = DateTime(
        normalizedStart.year,
        normalizedStart.month,
        normalizedStart.day + i,
      );
      final dateComponents = adhan.DateComponents(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final prayerTimes = adhan.PrayerTimes(
        coordinates,
        dateComponents,
        params,
      );

      schedules.add(
        PrayerSchedule(
          date: targetDate,
          fajrTime: prayerTimes.fajr,
          sunriseTime: prayerTimes.sunrise,
          latitude: config.latitude,
          longitude: config.longitude,
          calculationMethod: config.calculationMethod.name,
          madhab: config.madhab.name,
        ),
      );
    }

    if (persist) {
      final saveResult = await _repository.save30DaySchedule(schedules);
      return saveResult.map((_) => schedules);
    }

    return Right(schedules);
  }

  adhan.CalculationMethod _mapMethod(FajrCalculationMethod method) {
    return switch (method) {
      FajrCalculationMethod.muslimWorldLeague =>
        adhan.CalculationMethod.muslim_world_league,
      FajrCalculationMethod.egyptian => adhan.CalculationMethod.egyptian,
      FajrCalculationMethod.karachi => adhan.CalculationMethod.karachi,
      FajrCalculationMethod.ummAlQura => adhan.CalculationMethod.umm_al_qura,
      FajrCalculationMethod.dubai => adhan.CalculationMethod.dubai,
      FajrCalculationMethod.moonSightingCommittee =>
        adhan.CalculationMethod.moon_sighting_committee,
      FajrCalculationMethod.northAmerica =>
        adhan.CalculationMethod.north_america,
      FajrCalculationMethod.kuwait => adhan.CalculationMethod.kuwait,
      FajrCalculationMethod.qatar => adhan.CalculationMethod.qatar,
      FajrCalculationMethod.singapore => adhan.CalculationMethod.singapore,
      FajrCalculationMethod.tehran => adhan.CalculationMethod.tehran,
      FajrCalculationMethod.turkey => adhan.CalculationMethod.turkey,
    };
  }

  adhan.Madhab _mapMadhab(FajrMadhab madhab) {
    return switch (madhab) {
      FajrMadhab.shafi => adhan.Madhab.shafi,
      FajrMadhab.hanafi => adhan.Madhab.hanafi,
    };
  }
}
