import 'dart:typed_data';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Verifies a live prayer-rug POV photo after confirming standing tilt angle,
/// and guarantees immediate in-memory byte-buffer zeroing after verification.
class VerifyPrayerRugPhotoUseCase {
  const VerifyPrayerRugPhotoUseCase(this._repository);

  final ChallengeVerificationRepository _repository;

  /// Executes the verification and zeroes [imageBytes] in a `finally` block.
  Future<Either<Failure, ChallengeVerificationResult>> call({
    required Uint8List imageBytes,
    required String localeCode,
  }) async {
    try {
      if (imageBytes.isEmpty) {
        return const Left(
          Failure.validation(message: 'Captured photo buffer is empty.'),
        );
      }

      final Either<Failure, TiltAngleReading> tiltResult = await _repository
          .getCurrentTiltAngle();

      return await tiltResult.fold((Failure failure) async => Left(failure), (
        TiltAngleReading reading,
      ) async {
        if (!reading.isWithinStandingRange) {
          return Left(
            Failure.sensor(
              message:
                  'Standing tilt out of range (${reading.pitchDegrees.toStringAsFixed(1)}°).',
            ),
          );
        }

        return _repository.verifyPrayerRugPhoto(
          imageBytes: imageBytes,
          localeCode: localeCode,
        );
      });
    } finally {
      if (imageBytes.isNotEmpty) {
        imageBytes.fillRange(0, imageBytes.length, 0);
      }
    }
  }
}
