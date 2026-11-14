import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Completes onboarding only when location, permissions gate, consent, and API key are satisfied.
final class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Verifies mandatory prerequisites before marking onboarding complete.
  Future<Either<Failure, OnboardingStateEntity>> call() async {
    final Either<Failure, OnboardingStateEntity> stateResult = await _repository
        .getOnboardingState();

    return stateResult.fold(Left.new, (OnboardingStateEntity state) async {
      if (!state.canComplete) {
        return const Left(
          Failure.validation(
            message: 'Location, mandatory permissions, privacy consent, and validated API key are required.',
          ),
        );
      }
      return _repository.completeOnboarding();
    });
  }
}
