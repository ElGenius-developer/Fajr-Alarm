import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Platform channel abstraction for native Android & iOS 26+ alarm operations.
abstract interface class AlarmPlatformRepository {
  Future<Either<Failure, Unit>> scheduleAlarm({
    required DateTime scheduledAt,
    required bool isDryRun,
  });

  Future<Either<Failure, Unit>> cancelAllAlarms();

  Future<Either<Failure, Unit>> startRinging({required bool isDryRun});

  Future<Either<Failure, Unit>> stopRinging();

  Future<Either<Failure, Unit>> muteRingingAudio();

  Future<Either<Failure, Unit>> unmuteRingingAudio();

  Future<Either<Failure, Unit>> enableScreenPinning();

  Future<Either<Failure, Unit>> disableScreenPinning();

  Future<Either<Failure, bool>> canUseFullScreenIntent();

  Future<Either<Failure, Unit>> requestFullScreenIntentPermission();

  Future<Either<Failure, bool>> isIgnoringBatteryOptimizations();

  Future<Either<Failure, Unit>> requestIgnoreBatteryOptimizations();
}
