import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_settings.dart';
import '../repositories/settings_and_streak_repository.dart';

/// Consumes one unit of the monthly Emergency Override quota, resetting on new months.
class ConsumeEmergencyQuotaUseCase {
  const ConsumeEmergencyQuotaUseCase(this._repository);

  final SettingsAndStreakRepository _repository;

  Future<Either<Failure, UserSettings>> call({required DateTime now}) async {
    final settingsResult = await _repository.getSettings();
    return settingsResult.fold(Left.new, (settings) async {
      final currentMonthKey = now.year * 100 + now.month;
      final isNewMonth = settings.emergencyQuotaResetMonth != currentMonthKey;
      final usedThisMonth = isNewMonth ? 0 : settings.emergencyQuotaUsed;

      if (settings.monthlyEmergencyQuota - usedThisMonth <= 0) {
        return const Left(
          Failure.quotaExceeded(
            message: 'Monthly Emergency Override quota has been exhausted.',
          ),
        );
      }

      return _repository.saveSettings(
        settings.copyWith(
          emergencyQuotaUsed: usedThisMonth + 1,
          emergencyQuotaResetMonth: currentMonthKey,
        ),
      );
    });
  }
}
