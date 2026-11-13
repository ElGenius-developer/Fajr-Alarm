import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_state.freezed.dart';

/// Lifecycle status of the active Proof-of-Action challenge.
enum ChallengeStatus {
  initial,
  verifying,
  verified,
  rejected,
  fallbackTriggered,
}

/// Immutable state for [ChallengeCubit].
@freezed
sealed class ChallengeState with _$ChallengeState {
  const factory ChallengeState({
    @Default(ChallengeMode.photoVision) ChallengeMode mode,
    @Default(ChallengeStatus.initial) ChallengeStatus status,
    TiltAngleReading? tiltReading,
    @Default(false) bool isTorchOn,
    @Default(true) bool isCameraAvailable,
    ChallengeVerificationResult? verificationResult,
    String? rejectionMessage,
    Failure? failure,
    @Default('') String typingPrompt,
    @Default('') String typedText,
  }) = _ChallengeState;
}
