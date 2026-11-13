// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 OnboardingStateEntity get entity; PermissionsGateStatus get permissionsStatus; bool get isLoading; bool get isValidatingKey; bool get isSubmitting; Failure? get error;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.entity, _this.entity) || other.entity == _this.entity)&&(identical(other.permissionsStatus, _this.permissionsStatus) || other.permissionsStatus == _this.permissionsStatus)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isValidatingKey, _this.isValidatingKey) || other.isValidatingKey == _this.isValidatingKey)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as OnboardingState;
  return Object.hash(runtimeType,_this.entity,_this.permissionsStatus,_this.isLoading,_this.isValidatingKey,_this.isSubmitting,_this.error);
}

@override
String toString() {
  final _this = this as OnboardingState;
  return 'OnboardingState(entity: ${_this.entity}, permissionsStatus: ${_this.permissionsStatus}, isLoading: ${_this.isLoading}, isValidatingKey: ${_this.isValidatingKey}, isSubmitting: ${_this.isSubmitting}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStateEntity entity, PermissionsGateStatus permissionsStatus, bool isLoading, bool isValidatingKey, bool isSubmitting, Failure? error
});


$OnboardingStateEntityCopyWith<$Res> get entity;$PermissionsGateStatusCopyWith<$Res> get permissionsStatus;$FailureCopyWith<$Res>? get error;

}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entity = null,Object? permissionsStatus = null,Object? isLoading = null,Object? isValidatingKey = null,Object? isSubmitting = null,Object? error = freezed,}) {
  return _then(OnboardingState(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as OnboardingStateEntity,permissionsStatus: null == permissionsStatus ? _self.permissionsStatus : permissionsStatus // ignore: cast_nullable_to_non_nullable
as PermissionsGateStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isValidatingKey: null == isValidatingKey ? _self.isValidatingKey : isValidatingKey // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStateEntityCopyWith<$Res> get entity {
  
  return $OnboardingStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsGateStatusCopyWith<$Res> get permissionsStatus {
  
  return $PermissionsGateStatusCopyWith<$Res>(_self.permissionsStatus, (value) {
    return _then(_self.copyWith(permissionsStatus: value));
  });
}/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStateEntity entity,  PermissionsGateStatus permissionsStatus,  bool isLoading,  bool isValidatingKey,  bool isSubmitting,  Failure? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.entity,_that.permissionsStatus,_that.isLoading,_that.isValidatingKey,_that.isSubmitting,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStateEntity entity,  PermissionsGateStatus permissionsStatus,  bool isLoading,  bool isValidatingKey,  bool isSubmitting,  Failure? error)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.entity,_that.permissionsStatus,_that.isLoading,_that.isValidatingKey,_that.isSubmitting,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStateEntity entity,  PermissionsGateStatus permissionsStatus,  bool isLoading,  bool isValidatingKey,  bool isSubmitting,  Failure? error)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.entity,_that.permissionsStatus,_that.isLoading,_that.isValidatingKey,_that.isSubmitting,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.entity = const OnboardingStateEntity(), this.permissionsStatus = const PermissionsGateStatus(), this.isLoading = false, this.isValidatingKey = false, this.isSubmitting = false, this.error});
  

@override@JsonKey() final  OnboardingStateEntity entity;
@override@JsonKey() final  PermissionsGateStatus permissionsStatus;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isValidatingKey;
@override@JsonKey() final  bool isSubmitting;
@override final  Failure? error;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.permissionsStatus, permissionsStatus) || other.permissionsStatus == permissionsStatus)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isValidatingKey, isValidatingKey) || other.isValidatingKey == isValidatingKey)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entity,permissionsStatus,isLoading,isValidatingKey,isSubmitting,error);
}

@override
String toString() {
    return 'OnboardingState(entity: $entity, permissionsStatus: $permissionsStatus, isLoading: $isLoading, isValidatingKey: $isValidatingKey, isSubmitting: $isSubmitting, error: $error)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStateEntity entity, PermissionsGateStatus permissionsStatus, bool isLoading, bool isValidatingKey, bool isSubmitting, Failure? error
});


@override $OnboardingStateEntityCopyWith<$Res> get entity;@override $PermissionsGateStatusCopyWith<$Res> get permissionsStatus;@override $FailureCopyWith<$Res>? get error;

}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,Object? permissionsStatus = null,Object? isLoading = null,Object? isValidatingKey = null,Object? isSubmitting = null,Object? error = freezed,}) {
  return _then(_OnboardingState(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as OnboardingStateEntity,permissionsStatus: null == permissionsStatus ? _self.permissionsStatus : permissionsStatus // ignore: cast_nullable_to_non_nullable
as PermissionsGateStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isValidatingKey: null == isValidatingKey ? _self.isValidatingKey : isValidatingKey // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStateEntityCopyWith<$Res> get entity {
  
  return $OnboardingStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsGateStatusCopyWith<$Res> get permissionsStatus {
  
  return $PermissionsGateStatusCopyWith<$Res>(_self.permissionsStatus, (value) {
    return _then(_self.copyWith(permissionsStatus: value));
  });
}/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
