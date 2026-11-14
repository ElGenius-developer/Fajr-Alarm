import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Checks or requests mandatory OS permissions (FullScreenIntent, Battery, Camera, AlarmKit).
final class CheckPermissionsGateUseCase {
  const CheckPermissionsGateUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Checks current permissions and persists [PermissionsGateStatus.allGranted].
  Future<Either<Failure, PermissionsGateStatus>> call({
    bool request = false,
  }) async {
    final Either<Failure, PermissionsGateStatus> result = request
        ? await _repository.requestPermissions()
        : await _repository.checkPermissions();

    return result.fold(Left.new, (PermissionsGateStatus status) async {
      final Either<Failure, Unit> saveResult = await _repository
          .savePermissionsGranted(status.allGranted);
      return saveResult.fold(Left.new, (_) => Right(status));
    });
  }
}
