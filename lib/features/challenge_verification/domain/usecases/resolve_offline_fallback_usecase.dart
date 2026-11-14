import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Resolves the mandatory offline fallback hierarchy:
/// 1. [ChallengeMode.bathroomBarcode] if a barcode is registered and camera works.
/// 2. [ChallengeMode.standingTyping] otherwise.
class ResolveOfflineFallbackUseCase {
  const ResolveOfflineFallbackUseCase(this._repository);

  final ChallengeVerificationRepository _repository;

  Future<Either<Failure, ChallengeMode>> call({
    required bool isCameraAvailable,
  }) async {
    if (!isCameraAvailable) {
      return const Right(ChallengeMode.standingTyping);
    }

    final Either<Failure, bool> hasBarcodeResult = await _repository
        .hasRegisteredBathroomBarcode();

    return hasBarcodeResult.fold(
      (_) => const Right(ChallengeMode.standingTyping),
      (bool hasBarcode) => Right(
        hasBarcode
            ? ChallengeMode.bathroomBarcode
            : ChallengeMode.standingTyping,
      ),
    );
  }
}
