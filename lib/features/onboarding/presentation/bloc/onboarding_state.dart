import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

/// Immutable UI state for the 4-step [OnboardingCubit].
@freezed
sealed class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStateEntity()) OnboardingStateEntity entity,
    @Default(PermissionsGateStatus()) PermissionsGateStatus permissionsStatus,
    @Default(false) bool isLoading,
    @Default(false) bool isValidatingKey,
    @Default(false) bool isSubmitting,
    Failure? error,
  }) = _OnboardingState;
}
