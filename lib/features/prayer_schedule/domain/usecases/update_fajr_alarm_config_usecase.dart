import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/is_within_pre_fajr_lock_window_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Updates [FajrAlarmConfig], recalculates the 30-day rolling schedule,
/// and enforces the Pre-Fajr Lock Window (FR-5.4).
class UpdateFajrAlarmConfigUseCase {
  const UpdateFajrAlarmConfigUseCase({
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
    required FajrAlarmConfig newConfig,
    DateTime? now,
    bool isChallengePending = false,
  }) async {
    final effectiveNow = now ?? DateTime.now();

    final currentAlarmResult = await _repository.getNextScheduledAlarm();
    final currentAlarm = currentAlarmResult.getOrElse((_) => null);

    final lockResult = _isWithinLockWindow(
      alarmTime: currentAlarm,
      now: effectiveNow,
      isChallengePending: isChallengePending,
    );

    final isLocked = lockResult.getOrElse((_) => false);
    if (isLocked) {
      return const Left(
        Failure.lockWindow(
          message: 'Cannot modify alarm during Pre-Fajr Lock Window (T - 30m).',
        ),
      );
    }

    final saveConfigResult = await _repository.saveAlarmConfig(newConfig);
    if (saveConfigResult.isLeft()) {
      return saveConfigResult.fold(
        Left.new,
        (_) => const Left(Failure.unexpected(message: 'Unexpected error')),
      );
    }

    final calcResult = await _calculate30DaySchedule(
      config: newConfig,
      startDate: effectiveNow,
    );

    return calcResult.fold(Left.new, (schedules) async {
      final nextAlarmResult = _getNextFajrAlarm(
        schedules: schedules,
        config: newConfig,
        now: effectiveNow,
      );
      return nextAlarmResult.fold(Left.new, (nextAlarm) async {
        await _repository.saveNextScheduledAlarm(nextAlarm);
        final updatedLock = _isWithinLockWindow(
          alarmTime: nextAlarm,
          now: effectiveNow,
          isChallengePending: isChallengePending,
        ).getOrElse((_) => false);

        return Right(
          PrayerScheduleOverview(
            config: newConfig,
            schedules: schedules,
            nextAlarmTime: nextAlarm,
            isWithinLockWindow: updatedLock,
          ),
        );
      });
    });
  }
}
