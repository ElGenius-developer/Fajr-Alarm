import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Verifies a scanned bathroom product barcode against the registered barcode.
class VerifyBathroomBarcodeUseCase {
  const VerifyBathroomBarcodeUseCase(this._repository);

  final ChallengeVerificationRepository _repository;

  Future<Either<Failure, bool>> call({required String scannedBarcode}) async {
    final String normalized = scannedBarcode.trim();
    if (normalized.isEmpty) {
      return const Left(
        Failure.validation(message: 'Scanned barcode cannot be empty.'),
      );
    }

    return _repository.verifyBathroomBarcode(scannedBarcode: normalized);
  }
}
