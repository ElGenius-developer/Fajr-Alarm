import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter/services.dart';

/// Contract for checking and requesting mandatory OS permissions in Step 2.
abstract interface class OnboardingPermissionsDataSource {
  Future<PermissionsGateStatus> checkPermissions();
  Future<PermissionsGateStatus> requestPermissions();
}

/// MethodChannel-backed permissions data source.
final class MethodChannelOnboardingPermissionsDataSource
    implements OnboardingPermissionsDataSource {
  MethodChannelOnboardingPermissionsDataSource({MethodChannel? channel})
    : _channel =
          channel ??
          const MethodChannel('com.elgenius.fajralarm/onboarding_permissions');

  final MethodChannel _channel;

  @override
  Future<PermissionsGateStatus> checkPermissions() async {
    final Map<Object?, Object?>? raw = await _channel
        .invokeMapMethod<Object?, Object?>('checkPermissions');
    return _parseStatus(raw);
  }

  @override
  Future<PermissionsGateStatus> requestPermissions() async {
    final Map<Object?, Object?>? raw = await _channel
        .invokeMapMethod<Object?, Object?>('requestPermissions');
    return _parseStatus(raw);
  }

  PermissionsGateStatus _parseStatus(Map<Object?, Object?>? raw) {
    if (raw == null) {
      return const PermissionsGateStatus();
    }
    return PermissionsGateStatus(
      fullScreenIntentGranted: raw['fullScreenIntentGranted'] == true,
      batteryOptimizationIgnored: raw['batteryOptimizationIgnored'] == true,
      cameraGranted: raw['cameraGranted'] == true,
      alarmPermissionGranted: raw['alarmPermissionGranted'] == true,
    );
  }
}
