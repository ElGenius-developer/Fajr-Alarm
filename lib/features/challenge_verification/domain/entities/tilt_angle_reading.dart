import 'package:freezed_annotation/freezed_annotation.dart';

part 'tilt_angle_reading.freezed.dart';

/// Accelerometer pitch reading used to verify the user is standing and
/// pointing the phone toward the floor (-15° to 25°).
@freezed
sealed class TiltAngleReading with _$TiltAngleReading {
  const TiltAngleReading._();

  /// Minimum valid standing pitch angle in degrees.
  static const double minValidPitchDegrees = -15.0;

  /// Maximum valid standing pitch angle in degrees.
  static const double maxValidPitchDegrees = 25.0;

  const factory TiltAngleReading({
    required double pitchDegrees,
    required bool isWithinStandingRange,
  }) = _TiltAngleReading;

  /// Creates a [TiltAngleReading] and evaluates whether [pitchDegrees] falls
  /// within the required standing range (`-15°` to `25°` inclusive).
  factory TiltAngleReading.fromPitch(double pitchDegrees) {
    final bool valid =
        pitchDegrees >= minValidPitchDegrees &&
        pitchDegrees <= maxValidPitchDegrees;
    return TiltAngleReading(
      pitchDegrees: pitchDegrees,
      isWithinStandingRange: valid,
    );
  }
}
