import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_stats.freezed.dart';

/// Local-only KPIs and streak tracking for Fajr alarm completions.
@freezed
abstract class StreakStats with _$StreakStats {
  const StreakStats._();

  const factory StreakStats({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalAlarms,
    @Default(0) int completedAlarms,
    @Default(0) int totalTimeToWakeSeconds,
    @Default(false) bool isFrozen,
    DateTime? lastCompletedDate,
  }) = _StreakStats;

  /// Percentage (0.0 - 100.0) of real alarms completed with Proof-of-Action.
  double get completionRate =>
      totalAlarms == 0 ? 0.0 : (completedAlarms / totalAlarms) * 100.0;

  /// Average minutes from initial ring to `[COMPLETED]` across completed alarms.
  double get averageTimeToWakeMinutes => completedAlarms == 0
      ? 0.0
      : (totalTimeToWakeSeconds / completedAlarms) / 60.0;
}
