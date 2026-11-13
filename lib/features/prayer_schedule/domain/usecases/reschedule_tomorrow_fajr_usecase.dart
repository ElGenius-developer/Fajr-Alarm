import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Automatically reschedules tomorrow's Fajr alarm once the current alarm
/// transitions to `[COMPLETED]` (FR-1.3), refreshing the 30-day rolling cache if needed.
class RescheduleTomorrowFajrUseCase {
  const RescheduleTomorrowFajrUseCase({
    required this._repository,
    required this._calculate30DaySchedule,
    required this._getNextFajrAlarm,
  });

  final PrayerScheduleRepository _repository;
  final Calculate30DayFajrScheduleUseCase _calculate30DaySchedule;
  final GetNextFajrAlarmUseCase _getNextFajrAlarm;

  /// Computes and persists the next Fajr alarm after [completedAt].
  Future<Either<Failure, DateTime?>> call({DateTime? completedAt}) async {
    final effectiveCompletedAt = completedAt ?? DateTime.now();

    final configResult = await _repository.getAlarmConfig();
    return configResult.fold(Left.new, (config) async {
      final schedulesResult = await _repository.getCached30DaySchedule();
      var schedules = schedulesResult.getOrElse((_) => const []);

      final hasUpcoming = schedules.any(
        (s) => s.fajrTime.isAfter(effectiveCompletedAt),
      );

      if (schedulesResult.isLeft() || schedules.length < 2 || !hasUpcoming) {
        final recalcResult = await _calculate30DaySchedule(
          config: config,
          startDate: effectiveCompletedAt,
        );
        if (recalcResult.isLeft()) {
          return recalcResult.fold(
            Left.new,
            (_) => const Left(Failure.unexpected(message: 'Unexpected error')),
          );
        }
        schedules = recalcResult.getOrElse((_) => const []);
      }

      final nextAlarmResult = _getNextFajrAlarm(
        schedules: schedules,
        config: config,
        now: effectiveCompletedAt,
      );

      return nextAlarmResult.fold(Left.new, (nextAlarm) async {
        final saveResult = await _repository.saveNextScheduledAlarm(nextAlarm);
        return saveResult.map((_) => nextAlarm);
      });
    });
  }
}
