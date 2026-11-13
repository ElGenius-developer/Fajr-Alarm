import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_and_streak_repository.dart';

/// Loads the persisted [UserSettings].
class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, UserSettings>> call() => _repository.getSettings();
}
