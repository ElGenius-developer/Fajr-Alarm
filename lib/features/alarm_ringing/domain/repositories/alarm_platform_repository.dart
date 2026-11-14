import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

/// Platform-level alarm scheduling, ringing, audio-lock, and screen-pinning contract.
///
/// Pure Dart domain interface; platform implementations live in `data/`.
abstract class AlarmPlatformRepository {
  /// Schedules the exact alarm (Android `setAlarmClock` / iOS 26+ AlarmKit cascade).
  Future<Either<Failure, Unit>> scheduleAlarm({
    required DateTime scheduledAt,
    required bool isDryRun,
  });

  /// Cancels all scheduled alarms and any active iOS AlarmKit cascade.
  Future<Either<Failure, Unit>> cancelAllAlarms();

  /// Starts the native foreground ringing service / alarm audio engine.
  Future<Either<Failure, Unit>> startRinging({required bool isDryRun});

  /// Stops the native ringing service / alarm audio engine.
  Future<Either<Failure, Unit>> stopRinging();

  /// Temporarily mutes ringing audio (e.g., while emergency override is held).
  Future<Either<Failure, Unit>> muteRingingAudio();

  /// Restores ringing audio to full `STREAM_ALARM = 100%` volume.
  Future<Either<Failure, Unit>> unmuteRingingAudio();

  /// Enables screen pinning (`startLockTask` on Android; no-op on iOS).
  Future<Either<Failure, Unit>> enableScreenPinning();

  /// Disables screen pinning (`stopLockTask` on Android; no-op on iOS).
  Future<Either<Failure, Unit>> disableScreenPinning();

  /// Returns whether `USE_FULL_SCREEN_INTENT` is granted (Android 14+; `true` on older/iOS).
  Future<Either<Failure, bool>> canUseFullScreenIntent();

  /// Opens the system settings screen to grant Full-Screen Intent permission.
  Future<Either<Failure, Unit>> requestFullScreenIntentPermission();

  /// Returns whether battery optimizations are ignored for this app.
  Future<Either<Failure, bool>> isIgnoringBatteryOptimizations();

  /// Requests the system to ignore battery optimizations for this app.
  Future<Either<Failure, Unit>> requestIgnoreBatteryOptimizations();

  /// Returns and clears any pending native alarm-ringing trigger payload.
  Future<Either<Failure, Map<String, dynamic>?>> consumePendingAlarmTrigger();

  /// Registers or clears a live callback when native alarms start ringing.
  void listenForAlarmTriggers(
    void Function({required bool isDryRun})? onTriggered,
  );
}
