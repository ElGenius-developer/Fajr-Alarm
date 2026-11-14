// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_verification_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChallengeVerificationResult _$ChallengeVerificationResultFromJson(
  Map<String, dynamic> json,
) => _ChallengeVerificationResult(
  isPrayerRugPresent: json['is_prayer_rug_present'] as bool,
  areFeetOnRug: json['are_feet_on_rug'] as bool,
  isRealLivePhoto: json['is_real_live_photo'] as bool,
  verified: json['verified'] as bool,
  rejectionReason: json['rejection_reason'] as String,
);

Map<String, dynamic> _$ChallengeVerificationResultToJson(
  _ChallengeVerificationResult instance,
) => <String, dynamic>{
  'is_prayer_rug_present': instance.isPrayerRugPresent,
  'are_feet_on_rug': instance.areFeetOnRug,
  'is_real_live_photo': instance.isRealLivePhoto,
  'verified': instance.verified,
  'rejection_reason': instance.rejectionReason,
};
