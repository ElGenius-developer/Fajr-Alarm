import 'package:freezed_annotation/freezed_annotation.dart';

part 'tilt_angle_reading.freezed.dart';

/// Accelerometer pitch reading used to verify the user is standing and
/// pointing the phone downward toward the floor (-45° to -90°).
@freezed
sealed class TiltAngleReading with _$TiltAngleReading {
  const TiltAngleReading._();

  /// Minimum (steepest) valid standing pitch angle in degrees.
  static const double minValidPitchDegrees = -90.0;

  /// Maximum (shallowest) valid standing pitch angle in degrees.
  static const double maxValidPitchDegrees = -45.0;

  const factory TiltAngleReading({
    required double pitchDegrees,
    required bool isWithinStandingRange,
  }) = _TiltAngleReading;

  /// Creates a [TiltAngleReading] and evaluates whether [pitchDegrees] falls
  /// within the required standing range (`-90°` to `-45°` inclusive).
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
