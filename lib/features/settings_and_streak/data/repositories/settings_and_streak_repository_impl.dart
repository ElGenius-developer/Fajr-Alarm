import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/streak_stats.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_and_streak_repository.dart';
import '../datasources/settings_local_data_source.dart';

/// Callback type for scheduling a 10-second dry-run alarm on the platform layer.
typedef DryRunAlarmScheduler = Future<Either<Failure, Unit>> Function(
  DateTime scheduledAt,
);

/// Callback type for cancelling an active dry-run alarm on the platform layer.
typedef DryRunAlarmCanceller = Future<Either<Failure, Unit>> Function();

/// Repository implementation backed by [SettingsLocalDataSource].
class SettingsAndStreakRepositoryImpl implements SettingsAndStreakRepository {
  SettingsAndStreakRepositoryImpl({
    required this._localDataSource,
    this._onScheduleDryRunAlarm,
    this._onCancelDryRunAlarm,
  });

  final SettingsLocalDataSource _localDataSource;
  final DryRunAlarmScheduler? _onScheduleDryRunAlarm;
  final DryRunAlarmCanceller? _onCancelDryRunAlarm;

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final settings = await _localDataSource.getSettings();
      return Right(settings);
    } on Exception catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSettings>> saveSettings(
    UserSettings settings,
  ) async {
    try {
      final saved = await _localDataSource.saveSettings(settings);
      return Right(saved);
    } on Exception catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StreakStats>> getStreakStats() async {
    try {
      final stats = await _localDataSource.getStreakStats();
      return Right(stats);
    } on Exception catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, StreakStats>> saveStreakStats(
    StreakStats stats,
  ) async {
    try {
      final saved = await _localDataSource.saveStreakStats(stats);
      return Right(saved);
    } on Exception catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> scheduleDryRunAlarm({
    required DateTime scheduledAt,
  }) async {
    final scheduler = _onScheduleDryRunAlarm;
    if (scheduler == null) {
      return const Right(unit);
    }
    return scheduler(scheduledAt);
  }

  @override
  Future<Either<Failure, Unit>> cancelDryRunAlarm() async {
    final canceller = _onCancelDryRunAlarm;
    if (canceller == null) {
      return const Right(unit);
    }
    return canceller();
  }
}
