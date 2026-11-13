import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_verification_result.freezed.dart';
part 'challenge_verification_result.g.dart';

/// Result returned by Gemini Vision for the live prayer-rug POV challenge.
@freezed
sealed class ChallengeVerificationResult with _$ChallengeVerificationResult {
  const factory ChallengeVerificationResult({
    @JsonKey(name: 'is_prayer_rug_present') required bool isPrayerRugPresent,
    @JsonKey(name: 'are_feet_on_rug') required bool areFeetOnRug,
    @JsonKey(name: 'is_real_live_photo') required bool isRealLivePhoto,
    required bool verified,
    @JsonKey(name: 'rejection_reason') required String rejectionReason,
  }) = _ChallengeVerificationResult;

  factory ChallengeVerificationResult.fromJson(Map<String, dynamic> json) =>
      _$ChallengeVerificationResultFromJson(json);
}
