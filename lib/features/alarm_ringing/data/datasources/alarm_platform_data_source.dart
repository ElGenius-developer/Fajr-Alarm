import 'package:flutter/services.dart';

/// Platform channel data source for native Android & iOS alarm operations.
class AlarmPlatformDataSource {
  AlarmPlatformDataSource({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  /// Canonical MethodChannel name shared with Android Kotlin & iOS Swift.
  static const String channelName = 'com.elgenius.fajralarm/alarm_platform';

  final MethodChannel _channel;

  Future<void> scheduleAlarm({
    required DateTime scheduledAt,
    required bool isDryRun,
  }) async {
    await _channel.invokeMethod<void>('scheduleAlarm', <String, Object?>{
      'scheduledAtEpochMillis': scheduledAt.millisecondsSinceEpoch,
      'isDryRun': isDryRun,
    });
  }

  Future<void> cancelAllAlarms() async {
    await _channel.invokeMethod<void>('cancelAllAlarms');
  }

  Future<void> startRinging({required bool isDryRun}) async {
    await _channel.invokeMethod<void>('startRinging', <String, Object?>{
      'isDryRun': isDryRun,
    });
  }

  Future<void> stopRinging() async {
    await _channel.invokeMethod<void>('stopRinging');
  }

  Future<void> muteRingingAudio() async {
    await _channel.invokeMethod<void>('muteRingingAudio');
  }

  Future<void> unmuteRingingAudio() async {
    await _channel.invokeMethod<void>('unmuteRingingAudio');
  }

  Future<void> enableScreenPinning() async {
    await _channel.invokeMethod<void>('enableScreenPinning');
  }

  Future<void> disableScreenPinning() async {
    await _channel.invokeMethod<void>('disableScreenPinning');
  }

  Future<bool> canUseFullScreenIntent() async {
    final result = await _channel.invokeMethod<bool>('canUseFullScreenIntent');
    return result ?? false;
  }

  Future<void> requestFullScreenIntentPermission() async {
    await _channel.invokeMethod<void>('requestFullScreenIntentPermission');
  }

  Future<bool> isIgnoringBatteryOptimizations() async {
    final result = await _channel.invokeMethod<bool>(
      'isIgnoringBatteryOptimizations',
    );
    return result ?? false;
  }

  Future<void> requestIgnoreBatteryOptimizations() async {
    await _channel.invokeMethod<void>('requestIgnoreBatteryOptimizations');
  }
}
