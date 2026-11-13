import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Validates and saves the user's location and city name for offline Fajr calculation.
final class SaveLocationUseCase {
  const SaveLocationUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Validates coordinates and non-empty [cityName] before persisting.
  Future<Either<Failure, OnboardingStateEntity>> call({
    required double latitude,
    required double longitude,
    required String cityName,
  }) async {
    final String trimmedCity = cityName.trim();
    if (trimmedCity.isEmpty) {
      return const Left(
        Failure.validation(message: 'City name must not be empty.'),
      );
    }
    if (latitude.isNaN || latitude < -90.0 || latitude > 90.0) {
      return const Left(
        Failure.validation(message: 'Latitude must be between -90 and 90.'),
      );
    }
    if (longitude.isNaN || longitude < -180.0 || longitude > 180.0) {
      return const Left(
        Failure.validation(message: 'Longitude must be between -180 and 180.'),
      );
    }
    return _repository.saveLocation(
      latitude: latitude,
      longitude: longitude,
      cityName: trimmedCity,
    );
  }
}
