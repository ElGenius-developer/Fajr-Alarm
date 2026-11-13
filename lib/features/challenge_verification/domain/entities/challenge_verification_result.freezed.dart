// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_verification_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChallengeVerificationResult {

@JsonKey(name: 'is_prayer_rug_present') bool get isPrayerRugPresent;@JsonKey(name: 'are_feet_on_rug') bool get areFeetOnRug;@JsonKey(name: 'is_real_live_photo') bool get isRealLivePhoto; bool get verified;@JsonKey(name: 'rejection_reason') String get rejectionReason;
/// Create a copy of ChallengeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeVerificationResultCopyWith<ChallengeVerificationResult> get copyWith => _$ChallengeVerificationResultCopyWithImpl<ChallengeVerificationResult>(this as ChallengeVerificationResult, _$identity);

  /// Serializes this ChallengeVerificationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChallengeVerificationResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeVerificationResult&&(identical(other.isPrayerRugPresent, _this.isPrayerRugPresent) || other.isPrayerRugPresent == _this.isPrayerRugPresent)&&(identical(other.areFeetOnRug, _this.areFeetOnRug) || other.areFeetOnRug == _this.areFeetOnRug)&&(identical(other.isRealLivePhoto, _this.isRealLivePhoto) || other.isRealLivePhoto == _this.isRealLivePhoto)&&(identical(other.verified, _this.verified) || other.verified == _this.verified)&&(identical(other.rejectionReason, _this.rejectionReason) || other.rejectionReason == _this.rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChallengeVerificationResult;
  return Object.hash(runtimeType,_this.isPrayerRugPresent,_this.areFeetOnRug,_this.isRealLivePhoto,_this.verified,_this.rejectionReason);
}

@override
String toString() {
  final _this = this as ChallengeVerificationResult;
  return 'ChallengeVerificationResult(isPrayerRugPresent: ${_this.isPrayerRugPresent}, areFeetOnRug: ${_this.areFeetOnRug}, isRealLivePhoto: ${_this.isRealLivePhoto}, verified: ${_this.verified}, rejectionReason: ${_this.rejectionReason})';
}


}

/// @nodoc
abstract mixin class $ChallengeVerificationResultCopyWith<$Res>  {
  factory $ChallengeVerificationResultCopyWith(ChallengeVerificationResult value, $Res Function(ChallengeVerificationResult) _then) = _$ChallengeVerificationResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_prayer_rug_present') bool isPrayerRugPresent,@JsonKey(name: 'are_feet_on_rug') bool areFeetOnRug,@JsonKey(name: 'is_real_live_photo') bool isRealLivePhoto, bool verified,@JsonKey(name: 'rejection_reason') String rejectionReason
});




}
/// @nodoc
class _$ChallengeVerificationResultCopyWithImpl<$Res>
    implements $ChallengeVerificationResultCopyWith<$Res> {
  _$ChallengeVerificationResultCopyWithImpl(this._self, this._then);

  final ChallengeVerificationResult _self;
  final $Res Function(ChallengeVerificationResult) _then;

/// Create a copy of ChallengeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPrayerRugPresent = null,Object? areFeetOnRug = null,Object? isRealLivePhoto = null,Object? verified = null,Object? rejectionReason = null,}) {
  return _then(ChallengeVerificationResult(
isPrayerRugPresent: null == isPrayerRugPresent ? _self.isPrayerRugPresent : isPrayerRugPresent // ignore: cast_nullable_to_non_nullable
as bool,areFeetOnRug: null == areFeetOnRug ? _self.areFeetOnRug : areFeetOnRug // ignore: cast_nullable_to_non_nullable
as bool,isRealLivePhoto: null == isRealLivePhoto ? _self.isRealLivePhoto : isRealLivePhoto // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: null == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeVerificationResult].
extension ChallengeVerificationResultPatterns on ChallengeVerificationResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeVerificationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeVerificationResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeVerificationResult value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeVerificationResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeVerificationResult value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeVerificationResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_prayer_rug_present')  bool isPrayerRugPresent, @JsonKey(name: 'are_feet_on_rug')  bool areFeetOnRug, @JsonKey(name: 'is_real_live_photo')  bool isRealLivePhoto,  bool verified, @JsonKey(name: 'rejection_reason')  String rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeVerificationResult() when $default != null:
return $default(_that.isPrayerRugPresent,_that.areFeetOnRug,_that.isRealLivePhoto,_that.verified,_that.rejectionReason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_prayer_rug_present')  bool isPrayerRugPresent, @JsonKey(name: 'are_feet_on_rug')  bool areFeetOnRug, @JsonKey(name: 'is_real_live_photo')  bool isRealLivePhoto,  bool verified, @JsonKey(name: 'rejection_reason')  String rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _ChallengeVerificationResult():
return $default(_that.isPrayerRugPresent,_that.areFeetOnRug,_that.isRealLivePhoto,_that.verified,_that.rejectionReason);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_prayer_rug_present')  bool isPrayerRugPresent, @JsonKey(name: 'are_feet_on_rug')  bool areFeetOnRug, @JsonKey(name: 'is_real_live_photo')  bool isRealLivePhoto,  bool verified, @JsonKey(name: 'rejection_reason')  String rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeVerificationResult() when $default != null:
return $default(_that.isPrayerRugPresent,_that.areFeetOnRug,_that.isRealLivePhoto,_that.verified,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeVerificationResult implements ChallengeVerificationResult {
  const _ChallengeVerificationResult({@JsonKey(name: 'is_prayer_rug_present') required this.isPrayerRugPresent, @JsonKey(name: 'are_feet_on_rug') required this.areFeetOnRug, @JsonKey(name: 'is_real_live_photo') required this.isRealLivePhoto, required this.verified, @JsonKey(name: 'rejection_reason') required this.rejectionReason});
  factory _ChallengeVerificationResult.fromJson(Map<String, dynamic> json) => _$ChallengeVerificationResultFromJson(json);

@override@JsonKey(name: 'is_prayer_rug_present') final  bool isPrayerRugPresent;
@override@JsonKey(name: 'are_feet_on_rug') final  bool areFeetOnRug;
@override@JsonKey(name: 'is_real_live_photo') final  bool isRealLivePhoto;
@override final  bool verified;
@override@JsonKey(name: 'rejection_reason') final  String rejectionReason;

/// Create a copy of ChallengeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeVerificationResultCopyWith<_ChallengeVerificationResult> get copyWith => __$ChallengeVerificationResultCopyWithImpl<_ChallengeVerificationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeVerificationResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeVerificationResult&&(identical(other.isPrayerRugPresent, isPrayerRugPresent) || other.isPrayerRugPresent == isPrayerRugPresent)&&(identical(other.areFeetOnRug, areFeetOnRug) || other.areFeetOnRug == areFeetOnRug)&&(identical(other.isRealLivePhoto, isRealLivePhoto) || other.isRealLivePhoto == isRealLivePhoto)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isPrayerRugPresent,areFeetOnRug,isRealLivePhoto,verified,rejectionReason);
}

@override
String toString() {
    return 'ChallengeVerificationResult(isPrayerRugPresent: $isPrayerRugPresent, areFeetOnRug: $areFeetOnRug, isRealLivePhoto: $isRealLivePhoto, verified: $verified, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$ChallengeVerificationResultCopyWith<$Res> implements $ChallengeVerificationResultCopyWith<$Res> {
  factory _$ChallengeVerificationResultCopyWith(_ChallengeVerificationResult value, $Res Function(_ChallengeVerificationResult) _then) = __$ChallengeVerificationResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_prayer_rug_present') bool isPrayerRugPresent,@JsonKey(name: 'are_feet_on_rug') bool areFeetOnRug,@JsonKey(name: 'is_real_live_photo') bool isRealLivePhoto, bool verified,@JsonKey(name: 'rejection_reason') String rejectionReason
});




}
/// @nodoc
class __$ChallengeVerificationResultCopyWithImpl<$Res>
    implements _$ChallengeVerificationResultCopyWith<$Res> {
  __$ChallengeVerificationResultCopyWithImpl(this._self, this._then);

  final _ChallengeVerificationResult _self;
  final $Res Function(_ChallengeVerificationResult) _then;

/// Create a copy of ChallengeVerificationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPrayerRugPresent = null,Object? areFeetOnRug = null,Object? isRealLivePhoto = null,Object? verified = null,Object? rejectionReason = null,}) {
  return _then(_ChallengeVerificationResult(
isPrayerRugPresent: null == isPrayerRugPresent ? _self.isPrayerRugPresent : isPrayerRugPresent // ignore: cast_nullable_to_non_nullable
as bool,areFeetOnRug: null == areFeetOnRug ? _self.areFeetOnRug : areFeetOnRug // ignore: cast_nullable_to_non_nullable
as bool,isRealLivePhoto: null == isRealLivePhoto ? _self.isRealLivePhoto : isRealLivePhoto // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: null == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
