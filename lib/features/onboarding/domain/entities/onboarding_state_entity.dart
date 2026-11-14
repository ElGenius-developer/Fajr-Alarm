import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state_entity.freezed.dart';

/// Pure domain representation of the 4-step onboarding progress and settings.
@freezed
sealed class OnboardingStateEntity with _$OnboardingStateEntity {
  const OnboardingStateEntity._();

  const factory OnboardingStateEntity({
    @Default(0) int step,
    double? latitude,
    double? longitude,
    String? cityName,
    @Default(false) bool permissionsGranted,
    @Default(false) bool privacyConsentAccepted,
    @Default(false) bool apiKeyValidated,
    String? registeredBarcode,
    @Default(false) bool isCompleted,
  }) = _OnboardingStateEntity;

  /// Whether a valid location and city have been saved.
  bool get hasLocation =>
      latitude != null &&
      longitude != null &&
      cityName != null &&
      cityName!.trim().isNotEmpty;

  /// Whether all mandatory steps (1..3) are satisfied for completion.
  bool get canComplete =>
      hasLocation &&
      permissionsGranted &&
      privacyConsentAccepted &&
      apiKeyValidated;
}

/// Pure domain status of mandatory OS permissions checked in Step 2.
@freezed
sealed class PermissionsGateStatus with _$PermissionsGateStatus {
  const PermissionsGateStatus._();

  const factory PermissionsGateStatus({
    @Default(false) bool fullScreenIntentGranted,
    @Default(false) bool batteryOptimizationIgnored,
    @Default(false) bool cameraGranted,
    @Default(false) bool alarmPermissionGranted,
  }) = _PermissionsGateStatus;

  /// True only when every mandatory permission is granted.
  bool get allGranted =>
      fullScreenIntentGranted &&
      batteryOptimizationIgnored &&
      cameraGranted &&
      alarmPermissionGranted;
}
