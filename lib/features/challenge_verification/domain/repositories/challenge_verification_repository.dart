import 'dart:typed_data';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for verifying Proof-of-Action challenges (online & offline).
abstract interface class ChallengeVerificationRepository {
  /// Sends in-memory [imageBytes] to Gemini Vision for prayer-rug POV check.
  Future<Either<Failure, ChallengeVerificationResult>> verifyPrayerRugPhoto({
    required Uint8List imageBytes,
    required String localeCode,
  });

  /// Streams live accelerometer pitch readings.
  Stream<Either<Failure, TiltAngleReading>> watchTiltAngle();

  /// Reads the current accelerometer pitch angle.
  Future<Either<Failure, TiltAngleReading>> getCurrentTiltAngle();

  /// Checks whether [scannedBarcode] matches the registered bathroom barcode.
  Future<Either<Failure, bool>> verifyBathroomBarcode({
    required String scannedBarcode,
  });

  /// Verifies that [typedText] is an exact 120-character match for [expectedText].
  Future<Either<Failure, bool>> verifyStandingTyping({
    required String typedText,
    required String expectedText,
  });

  /// Returns `true` if the user has a registered bathroom barcode on record.
  Future<Either<Failure, bool>> hasRegisteredBathroomBarcode();
}
