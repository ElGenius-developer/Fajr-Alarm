import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Verifies the 120-character Standing Typing Challenge with 0 errors and
/// an active standing tilt angle (-15° to 25°).
class VerifyStandingTypingUseCase {
  const VerifyStandingTypingUseCase(this._repository);

  static const int requiredLength = 120;

  final ChallengeVerificationRepository _repository;

  Future<Either<Failure, bool>> call({
    required String typedText,
    required String expectedText,
  }) async {
    if (expectedText.length != requiredLength) {
      return const Left(
        Failure.validation(
          message: 'Expected Adhkar prompt must be exactly 120 characters.',
        ),
      );
    }

    final Either<Failure, TiltAngleReading> tiltResult = await _repository
        .getCurrentTiltAngle();

    return tiltResult.fold((Failure failure) async => Left(failure), (
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

      if (typedText.length != requiredLength || typedText != expectedText) {
        return const Right(false);
      }

      return _repository.verifyStandingTyping(
        typedText: typedText,
        expectedText: expectedText,
      );
    });
  }
}
