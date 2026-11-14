import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Abstract repository contract for the 4-step onboarding workflow.
abstract interface class OnboardingRepository {
  /// Loads the persisted onboarding state.
  Future<Either<Failure, OnboardingStateEntity>> getOnboardingState();

  /// Persists the selected location and city name.
  Future<Either<Failure, OnboardingStateEntity>> saveLocation({
    required double latitude,
    required double longitude,
    required String cityName,
  });

  /// Checks current OS permission statuses without prompting the user.
  Future<Either<Failure, PermissionsGateStatus>> checkPermissions();

  /// Requests missing OS permissions and returns the updated statuses.
  Future<Either<Failure, PermissionsGateStatus>> requestPermissions();

  /// Persists whether the mandatory permissions gate has been satisfied.
  Future<Either<Failure, Unit>> savePermissionsGranted(bool granted);

  /// Persists explicit user acceptance of Google Free Tier privacy terms.
  Future<Either<Failure, Unit>> setPrivacyConsentAccepted(bool accepted);

  /// Validates a Gemini API key live against the Gemini REST API.
  Future<Either<Failure, bool>> validateGeminiKey(String apiKey);

  /// Saves the Gemini API key in secure OS storage (`FlutterSecureStorage`).
  Future<Either<Failure, Unit>> saveGeminiKey(String apiKey);

  /// Reads the stored Gemini API key from secure OS storage, if present.
  Future<Either<Failure, String?>> getGeminiKey();

  /// Registers or clears the offline Bathroom Barcode Challenge fallback.
  Future<Either<Failure, Unit>> registerBathroomBarcode(String? barcode);

  /// Marks onboarding as completed.
  Future<Either<Failure, OnboardingStateEntity>> completeOnboarding();

  /// Persists the current step index (0..3).
  Future<Either<Failure, Unit>> updateStep(int step);
}
