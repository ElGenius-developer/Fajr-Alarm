import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/streak_stats.dart';
import '../repositories/settings_and_streak_repository.dart';

/// Updates Streak & Local-Only KPIs after an alarm finishes, skipping dry-runs.
class RecordAlarmCompletionUseCase {
  const RecordAlarmCompletionUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, StreakStats>> call({
    required int timeToWakeSeconds,
    required bool isDryRun,
    required bool completed,
    DateTime? completedAt,
  }) async {
    final statsResult = await _repository.getStreakStats();
    return statsResult.fold(Left.new, (stats) async {
      if (isDryRun) {
        return Right(stats);
      }

      final sanitizedSeconds = timeToWakeSeconds < 0 ? 0 : timeToWakeSeconds;
      final nextTotal = stats.totalAlarms + 1;

      if (!completed) {
        final nextStreak = stats.isFrozen ? stats.currentStreak : 0;
        return _repository.saveStreakStats(
          stats.copyWith(totalAlarms: nextTotal, currentStreak: nextStreak),
        );
      }

      final nextStreak = stats.currentStreak + 1;
      final nextLongest = nextStreak > stats.longestStreak
          ? nextStreak
          : stats.longestStreak;

      return _repository.saveStreakStats(
        stats.copyWith(
          currentStreak: nextStreak,
          longestStreak: nextLongest,
          totalAlarms: nextTotal,
          completedAlarms: stats.completedAlarms + 1,
          totalTimeToWakeSeconds:
              stats.totalTimeToWakeSeconds + sanitizedSeconds,
          lastCompletedDate: completedAt ?? stats.lastCompletedDate,
        ),
      );
    });
  }
}
