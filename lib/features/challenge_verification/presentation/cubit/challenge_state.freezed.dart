// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChallengeState {

 ChallengeMode get mode; ChallengeStatus get status; TiltAngleReading? get tiltReading; bool get isTorchOn; bool get isCameraAvailable; ChallengeVerificationResult? get verificationResult; String? get rejectionMessage; Failure? get failure; String get typingPrompt; String get typedText;
/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeStateCopyWith<ChallengeState> get copyWith => _$ChallengeStateCopyWithImpl<ChallengeState>(this as ChallengeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChallengeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.tiltReading, _this.tiltReading) || other.tiltReading == _this.tiltReading)&&(identical(other.isTorchOn, _this.isTorchOn) || other.isTorchOn == _this.isTorchOn)&&(identical(other.isCameraAvailable, _this.isCameraAvailable) || other.isCameraAvailable == _this.isCameraAvailable)&&(identical(other.verificationResult, _this.verificationResult) || other.verificationResult == _this.verificationResult)&&(identical(other.rejectionMessage, _this.rejectionMessage) || other.rejectionMessage == _this.rejectionMessage)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.typingPrompt, _this.typingPrompt) || other.typingPrompt == _this.typingPrompt)&&(identical(other.typedText, _this.typedText) || other.typedText == _this.typedText));
}


@override
int get hashCode {
  final _this = this as ChallengeState;
  return Object.hash(runtimeType,_this.mode,_this.status,_this.tiltReading,_this.isTorchOn,_this.isCameraAvailable,_this.verificationResult,_this.rejectionMessage,_this.failure,_this.typingPrompt,_this.typedText);
}

@override
String toString() {
  final _this = this as ChallengeState;
  return 'ChallengeState(mode: ${_this.mode}, status: ${_this.status}, tiltReading: ${_this.tiltReading}, isTorchOn: ${_this.isTorchOn}, isCameraAvailable: ${_this.isCameraAvailable}, verificationResult: ${_this.verificationResult}, rejectionMessage: ${_this.rejectionMessage}, failure: ${_this.failure}, typingPrompt: ${_this.typingPrompt}, typedText: ${_this.typedText})';
}


}

/// @nodoc
abstract mixin class $ChallengeStateCopyWith<$Res>  {
  factory $ChallengeStateCopyWith(ChallengeState value, $Res Function(ChallengeState) _then) = _$ChallengeStateCopyWithImpl;
@useResult
$Res call({
 ChallengeMode mode, ChallengeStatus status, TiltAngleReading? tiltReading, bool isTorchOn, bool isCameraAvailable, ChallengeVerificationResult? verificationResult, String? rejectionMessage, Failure? failure, String typingPrompt, String typedText
});


$TiltAngleReadingCopyWith<$Res>? get tiltReading;$ChallengeVerificationResultCopyWith<$Res>? get verificationResult;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$ChallengeStateCopyWithImpl<$Res>
    implements $ChallengeStateCopyWith<$Res> {
  _$ChallengeStateCopyWithImpl(this._self, this._then);

  final ChallengeState _self;
  final $Res Function(ChallengeState) _then;

/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? status = null,Object? tiltReading = freezed,Object? isTorchOn = null,Object? isCameraAvailable = null,Object? verificationResult = freezed,Object? rejectionMessage = freezed,Object? failure = freezed,Object? typingPrompt = null,Object? typedText = null,}) {
  return _then(ChallengeState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChallengeMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChallengeStatus,tiltReading: freezed == tiltReading ? _self.tiltReading : tiltReading // ignore: cast_nullable_to_non_nullable
as TiltAngleReading?,isTorchOn: null == isTorchOn ? _self.isTorchOn : isTorchOn // ignore: cast_nullable_to_non_nullable
as bool,isCameraAvailable: null == isCameraAvailable ? _self.isCameraAvailable : isCameraAvailable // ignore: cast_nullable_to_non_nullable
as bool,verificationResult: freezed == verificationResult ? _self.verificationResult : verificationResult // ignore: cast_nullable_to_non_nullable
as ChallengeVerificationResult?,rejectionMessage: freezed == rejectionMessage ? _self.rejectionMessage : rejectionMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,typingPrompt: null == typingPrompt ? _self.typingPrompt : typingPrompt // ignore: cast_nullable_to_non_nullable
as String,typedText: null == typedText ? _self.typedText : typedText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiltAngleReadingCopyWith<$Res>? get tiltReading {
    if (_self.tiltReading == null) {
    return null;
  }

  return $TiltAngleReadingCopyWith<$Res>(_self.tiltReading!, (value) {
    return _then(_self.copyWith(tiltReading: value));
  });
}/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeVerificationResultCopyWith<$Res>? get verificationResult {
    if (_self.verificationResult == null) {
    return null;
  }

  return $ChallengeVerificationResultCopyWith<$Res>(_self.verificationResult!, (value) {
    return _then(_self.copyWith(verificationResult: value));
  });
}/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChallengeState].
extension ChallengeStatePatterns on ChallengeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeState value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeState value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChallengeMode mode,  ChallengeStatus status,  TiltAngleReading? tiltReading,  bool isTorchOn,  bool isCameraAvailable,  ChallengeVerificationResult? verificationResult,  String? rejectionMessage,  Failure? failure,  String typingPrompt,  String typedText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeState() when $default != null:
return $default(_that.mode,_that.status,_that.tiltReading,_that.isTorchOn,_that.isCameraAvailable,_that.verificationResult,_that.rejectionMessage,_that.failure,_that.typingPrompt,_that.typedText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChallengeMode mode,  ChallengeStatus status,  TiltAngleReading? tiltReading,  bool isTorchOn,  bool isCameraAvailable,  ChallengeVerificationResult? verificationResult,  String? rejectionMessage,  Failure? failure,  String typingPrompt,  String typedText)  $default,) {final _that = this;
switch (_that) {
case _ChallengeState():
return $default(_that.mode,_that.status,_that.tiltReading,_that.isTorchOn,_that.isCameraAvailable,_that.verificationResult,_that.rejectionMessage,_that.failure,_that.typingPrompt,_that.typedText);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChallengeMode mode,  ChallengeStatus status,  TiltAngleReading? tiltReading,  bool isTorchOn,  bool isCameraAvailable,  ChallengeVerificationResult? verificationResult,  String? rejectionMessage,  Failure? failure,  String typingPrompt,  String typedText)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeState() when $default != null:
return $default(_that.mode,_that.status,_that.tiltReading,_that.isTorchOn,_that.isCameraAvailable,_that.verificationResult,_that.rejectionMessage,_that.failure,_that.typingPrompt,_that.typedText);case _:
  return null;

}
}

}

/// @nodoc


class _ChallengeState implements ChallengeState {
  const _ChallengeState({this.mode = ChallengeMode.photoVision, this.status = ChallengeStatus.initial, this.tiltReading, this.isTorchOn = false, this.isCameraAvailable = true, this.verificationResult, this.rejectionMessage, this.failure, this.typingPrompt = '', this.typedText = ''});
  

@override@JsonKey() final  ChallengeMode mode;
@override@JsonKey() final  ChallengeStatus status;
@override final  TiltAngleReading? tiltReading;
@override@JsonKey() final  bool isTorchOn;
@override@JsonKey() final  bool isCameraAvailable;
@override final  ChallengeVerificationResult? verificationResult;
@override final  String? rejectionMessage;
@override final  Failure? failure;
@override@JsonKey() final  String typingPrompt;
@override@JsonKey() final  String typedText;

/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeStateCopyWith<_ChallengeState> get copyWith => __$ChallengeStateCopyWithImpl<_ChallengeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&(identical(other.tiltReading, tiltReading) || other.tiltReading == tiltReading)&&(identical(other.isTorchOn, isTorchOn) || other.isTorchOn == isTorchOn)&&(identical(other.isCameraAvailable, isCameraAvailable) || other.isCameraAvailable == isCameraAvailable)&&(identical(other.verificationResult, verificationResult) || other.verificationResult == verificationResult)&&(identical(other.rejectionMessage, rejectionMessage) || other.rejectionMessage == rejectionMessage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.typingPrompt, typingPrompt) || other.typingPrompt == typingPrompt)&&(identical(other.typedText, typedText) || other.typedText == typedText));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,status,tiltReading,isTorchOn,isCameraAvailable,verificationResult,rejectionMessage,failure,typingPrompt,typedText);
}

@override
String toString() {
    return 'ChallengeState(mode: $mode, status: $status, tiltReading: $tiltReading, isTorchOn: $isTorchOn, isCameraAvailable: $isCameraAvailable, verificationResult: $verificationResult, rejectionMessage: $rejectionMessage, failure: $failure, typingPrompt: $typingPrompt, typedText: $typedText)';
}


}

/// @nodoc
abstract mixin class _$ChallengeStateCopyWith<$Res> implements $ChallengeStateCopyWith<$Res> {
  factory _$ChallengeStateCopyWith(_ChallengeState value, $Res Function(_ChallengeState) _then) = __$ChallengeStateCopyWithImpl;
@override @useResult
$Res call({
 ChallengeMode mode, ChallengeStatus status, TiltAngleReading? tiltReading, bool isTorchOn, bool isCameraAvailable, ChallengeVerificationResult? verificationResult, String? rejectionMessage, Failure? failure, String typingPrompt, String typedText
});


@override $TiltAngleReadingCopyWith<$Res>? get tiltReading;@override $ChallengeVerificationResultCopyWith<$Res>? get verificationResult;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$ChallengeStateCopyWithImpl<$Res>
    implements _$ChallengeStateCopyWith<$Res> {
  __$ChallengeStateCopyWithImpl(this._self, this._then);

  final _ChallengeState _self;
  final $Res Function(_ChallengeState) _then;

/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? status = null,Object? tiltReading = freezed,Object? isTorchOn = null,Object? isCameraAvailable = null,Object? verificationResult = freezed,Object? rejectionMessage = freezed,Object? failure = freezed,Object? typingPrompt = null,Object? typedText = null,}) {
  return _then(_ChallengeState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChallengeMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChallengeStatus,tiltReading: freezed == tiltReading ? _self.tiltReading : tiltReading // ignore: cast_nullable_to_non_nullable
as TiltAngleReading?,isTorchOn: null == isTorchOn ? _self.isTorchOn : isTorchOn // ignore: cast_nullable_to_non_nullable
as bool,isCameraAvailable: null == isCameraAvailable ? _self.isCameraAvailable : isCameraAvailable // ignore: cast_nullable_to_non_nullable
as bool,verificationResult: freezed == verificationResult ? _self.verificationResult : verificationResult // ignore: cast_nullable_to_non_nullable
as ChallengeVerificationResult?,rejectionMessage: freezed == rejectionMessage ? _self.rejectionMessage : rejectionMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,typingPrompt: null == typingPrompt ? _self.typingPrompt : typingPrompt // ignore: cast_nullable_to_non_nullable
as String,typedText: null == typedText ? _self.typedText : typedText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TiltAngleReadingCopyWith<$Res>? get tiltReading {
    if (_self.tiltReading == null) {
    return null;
  }

  return $TiltAngleReadingCopyWith<$Res>(_self.tiltReading!, (value) {
    return _then(_self.copyWith(tiltReading: value));
  });
}/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChallengeVerificationResultCopyWith<$Res>? get verificationResult {
    if (_self.verificationResult == null) {
    return null;
  }

  return $ChallengeVerificationResultCopyWith<$Res>(_self.verificationResult!, (value) {
    return _then(_self.copyWith(verificationResult: value));
  });
}/// Create a copy of ChallengeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
