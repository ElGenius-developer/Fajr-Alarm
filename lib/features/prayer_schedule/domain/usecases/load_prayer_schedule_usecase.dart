import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/is_within_pre_fajr_lock_window_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Snapshot returned by [LoadPrayerScheduleUseCase].
class PrayerScheduleOverview {
  const PrayerScheduleOverview({
    required this.config,
    required this.schedules,
    required this.nextAlarmTime,
    required this.isWithinLockWindow,
  });

  final FajrAlarmConfig config;
  final List<PrayerSchedule> schedules;
  final DateTime? nextAlarmTime;
  final bool isWithinLockWindow;
}

/// Loads the persisted config and 30-day rolling schedule (calculating offline
/// if the cache is empty or expired) along with lock window status.
class LoadPrayerScheduleUseCase {
  const LoadPrayerScheduleUseCase({
    required this._repository,
    required this._calculate30DaySchedule,
    required this._getNextFajrAlarm,
    required this._isWithinLockWindow,
  });

  final PrayerScheduleRepository _repository;
  final Calculate30DayFajrScheduleUseCase _calculate30DaySchedule;
  final GetNextFajrAlarmUseCase _getNextFajrAlarm;
  final IsWithinPreFajrLockWindowUseCase _isWithinLockWindow;

  Future<Either<Failure, PrayerScheduleOverview>> call({
    DateTime? now,
    MonotonicClock? clock,
    bool isChallengePending = false,
  }) async {
    final effectiveNow = now ?? DateTime.now();

    final configResult = await _repository.getAlarmConfig();
    return configResult.fold(Left.new, (config) async {
      final cachedResult = await _repository.getCached30DaySchedule();
      var schedules = cachedResult.getOrElse((_) => const []);

      final hasUpcomingDay = schedules.any(
        (day) => day.fajrTime.isAfter(effectiveNow),
      );

      if (cachedResult.isLeft() || schedules.isEmpty || !hasUpcomingDay) {
        final calcResult = await _calculate30DaySchedule(
          config: config,
          startDate: effectiveNow,
        );
        if (calcResult.isLeft()) {
          return calcResult.fold(
            Left.new,
            (_) => const Left(Failure.unexpected(message: 'Unexpected error')),
          );
        }
        schedules = calcResult.getOrElse((_) => const []);
      }

      final nextAlarmResult = _getNextFajrAlarm(
        schedules: schedules,
        config: config,
        now: effectiveNow,
      );

      return nextAlarmResult.fold(Left.new, (nextAlarm) async {
        await _repository.saveNextScheduledAlarm(nextAlarm);
        final lockResult = _isWithinLockWindow(
          alarmTime: nextAlarm,
          now: effectiveNow,
          clock: clock,
          isChallengePending: isChallengePending,
        );
        return lockResult.map(
          (isLocked) => PrayerScheduleOverview(
            config: config,
            schedules: schedules,
            nextAlarmTime: nextAlarm,
            isWithinLockWindow: isLocked,
          ),
        );
      });
    });
  }
}
