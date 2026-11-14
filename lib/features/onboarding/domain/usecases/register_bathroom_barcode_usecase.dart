import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Registers (or skips with `null`) the offline Bathroom Barcode Challenge fallback.
final class RegisterBathroomBarcodeUseCase {
  const RegisterBathroomBarcodeUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Saves [barcode] (trimmed) or skips registration when `null`.
  Future<Either<Failure, Unit>> call({String? barcode}) async {
    if (barcode == null) {
      return _repository.registerBathroomBarcode(null);
    }

    final String trimmed = barcode.trim();
    if (trimmed.isEmpty) {
      return const Left(
        Failure.validation(message: 'Barcode value must not be empty.'),
      );
    }

    return _repository.registerBathroomBarcode(trimmed);
  }
}
