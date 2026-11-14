import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/streak_stats.dart';
import '../repositories/settings_and_streak_repository.dart';

/// Loads the persisted [StreakStats] and Local-Only KPIs.
class GetStreakStatsUseCase {
  const GetStreakStatsUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, StreakStats>> call() => _repository.getStreakStats();
}
