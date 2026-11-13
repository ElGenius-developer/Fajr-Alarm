import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_and_streak_repository.dart';

/// Automatically ends expired Vacation Mode and lifts Streak Freeze.
class AutoResumeVacationUseCase {
  const AutoResumeVacationUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, UserSettings>> call({required DateTime now}) async {
    final settingsResult = await _repository.getSettings();
    return settingsResult.fold(Left.new, (settings) async {
      final vacation = settings.vacationMode;
      if (vacation == null || now.isBefore(vacation.endDate)) {
        return Right(settings);
      }

      final statsResult = await _repository.getStreakStats();
      return statsResult.fold(Left.new, (stats) async {
        final unfrozenResult = await _repository.saveStreakStats(
          stats.copyWith(isFrozen: false),
        );
        return unfrozenResult.fold(
          Left.new,
          (_) =>
              _repository.saveSettings(settings.copyWith(vacationMode: null)),
        );
      });
    });
  }
}
