import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/streak_stats.dart';
import '../entities/user_settings.dart';

/// Abstract contract for persisting settings, streak KPIs, and triggering dry-run alarms.
abstract interface class SettingsAndStreakRepository {
  Future<Either<Failure, UserSettings>> getSettings();

  Future<Either<Failure, UserSettings>> saveSettings(UserSettings settings);

  Future<Either<Failure, StreakStats>> getStreakStats();

  Future<Either<Failure, StreakStats>> saveStreakStats(StreakStats stats);

  Future<Either<Failure, Unit>> scheduleDryRunAlarm({
    required DateTime scheduledAt,
  });

  Future<Either<Failure, Unit>> cancelDryRunAlarm();
}
