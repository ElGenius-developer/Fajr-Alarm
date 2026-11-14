import 'dart:math' as math;

import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Reads accelerometer data via `sensors_plus` and computes downward pitch
/// angle in degrees (`-15°` to `25°` indicates standing POV orientation).
class TiltSensorDataSource {
  TiltSensorDataSource({this._accelerometerStream});

  final Stream<AccelerometerEvent>? _accelerometerStream;

  Stream<AccelerometerEvent> get _stream =>
      _accelerometerStream ?? accelerometerEventStream();

  /// Computes pitch in degrees from accelerometer axes `(x, y, z)`.
  ///
  /// - Screen-up / shallow forward tilt (`y = 0, z = +9.8`): `0°` (within `-15°..25°`)
  /// - Steep tilt (`y = +6.93, z = +6.93`): `-45°` (outside standing range)
  /// - Vertical (`y = +9.8, z = 0`): `-90°` (outside standing range)
  static double calculatePitchDegrees(double x, double y, double z) {
    if (y == 0 && z == 0) {
      return 0.0;
    }
    return -math.atan2(y, z) * (180.0 / math.pi);
  }

  /// Streams live [TiltAngleReading] updates.
  Stream<TiltAngleReading> watchTiltAngle() {
    return _stream.map(
      (AccelerometerEvent event) => TiltAngleReading.fromPitch(
        calculatePitchDegrees(event.x, event.y, event.z),
      ),
    );
  }

  /// Returns the latest [TiltAngleReading] from the accelerometer stream.
  Future<TiltAngleReading> getCurrentTiltAngle() async {
    final AccelerometerEvent event = await _stream.first.timeout(
      const Duration(seconds: 2),
    );
    return TiltAngleReading.fromPitch(
      calculatePitchDegrees(event.x, event.y, event.z),
    );
  }
}
