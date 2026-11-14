import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fpdart/fpdart.dart';

/// Resolves the next Fajr alarm timestamp using either an Adhan-relative offset
/// (`before` / `at` / `after`) or a fixed manual time.
class GetNextFajrAlarmUseCase {
  const GetNextFajrAlarmUseCase();

  static const int _manualSearchHorizonDays = 30;

  /// Returns the next [DateTime] strictly after [now] (defaults to `DateTime.now()`),
  /// or `Right(null)` if the alarm is disabled.
  Either<Failure, DateTime?> call({
    required List<PrayerSchedule> schedules,
    required FajrAlarmConfig config,
    DateTime? now,
  }) {
    if (config.offsetMinutes < 0) {
      return const Left(
        Failure.validation(message: 'Offset minutes cannot be negative.'),
      );
    }
    if (config.manualHour < 0 || config.manualHour > 23) {
      return const Left(
        Failure.validation(message: 'Manual hour must be between 0 and 23.'),
      );
    }
    if (config.manualMinute < 0 || config.manualMinute > 59) {
      return const Left(
        Failure.validation(message: 'Manual minute must be between 0 and 59.'),
      );
    }

    if (!config.isEnabled) {
      return const Right(null);
    }

    final effectiveNow = now ?? DateTime.now();

    if (config.mode == FajrAlarmMode.manualTime) {
      for (var i = 0; i <= _manualSearchHorizonDays; i++) {
        final candidate = DateTime(
          effectiveNow.year,
          effectiveNow.month,
          effectiveNow.day + i,
          config.manualHour,
          config.manualMinute,
        );
        if (candidate.isAfter(effectiveNow)) {
          return Right(candidate);
        }
      }
      return const Left(
        Failure.unexpected(message: 'Could not determine next manual alarm.'),
      );
    }

    if (schedules.isEmpty) {
      return const Left(
        Failure.cache(message: 'No cached prayer schedule available.'),
      );
    }

    final sorted = List<PrayerSchedule>.of(schedules)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final day in sorted) {
      final candidate = _applyOffset(
        day.fajrTime,
        config.offsetDirection,
        config.offsetMinutes,
      );
      if (candidate.isAfter(effectiveNow)) {
        return Right(candidate);
      }
    }

    return const Left(
      Failure.cache(message: 'Cached prayer schedule has no upcoming Fajr.'),
    );
  }

  DateTime _applyOffset(
    DateTime fajrTime,
    FajrOffsetDirection direction,
    int minutes,
  ) {
    final offset = Duration(minutes: minutes);
    return switch (direction) {
      FajrOffsetDirection.before => fajrTime.subtract(offset),
      FajrOffsetDirection.at => fajrTime,
      FajrOffsetDirection.after => fajrTime.add(offset),
    };
  }
}
