import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Validates a BYOK Gemini API key live and stores it securely ONLY after explicit consent.
final class ValidateAndSaveGeminiKeyUseCase {
  const ValidateAndSaveGeminiKeyUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Rejects saving or validating if [privacyConsentAccepted] is not `true`.
  Future<Either<Failure, bool>> call({
    required String apiKey,
    required bool privacyConsentAccepted,
  }) async {
    if (!privacyConsentAccepted) {
      return const Left(
        Failure.validation(
          message: 'Explicit privacy consent is required before saving Gemini API key.',
        ),
      );
    }

    final String trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) {
      return const Left(
        Failure.validation(message: 'Gemini API key must not be empty.'),
      );
    }

    final Either<Failure, bool> validationResult = await _repository
        .validateGeminiKey(trimmedKey);

    return validationResult.fold(Left.new, (bool isValid) async {
      if (!isValid) {
        return const Left(
          Failure.validation(message: 'Gemini API key is invalid.'),
        );
      }

      final Either<Failure, Unit> consentSave = await _repository
          .setPrivacyConsentAccepted(true);
      if (consentSave.isLeft()) {
        return consentSave.fold(Left.new, (_) => const Right(false));
      }

      final Either<Failure, Unit> keySave = await _repository.saveGeminiKey(
        trimmedKey,
      );
      return keySave.fold(Left.new, (_) => const Right(true));
    });
  }
}
