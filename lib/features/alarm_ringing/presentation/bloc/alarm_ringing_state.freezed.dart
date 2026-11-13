// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_ringing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlarmRingingState {

 AlarmStateEntity get entity; int get snoozeRemainingSeconds; int get emergencyHoldElapsedSeconds; bool get isEmergencyMuted; bool get emergencyReleasedEarly; Failure? get failure;
/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmRingingStateCopyWith<AlarmRingingState> get copyWith => _$AlarmRingingStateCopyWithImpl<AlarmRingingState>(this as AlarmRingingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlarmRingingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmRingingState&&(identical(other.entity, _this.entity) || other.entity == _this.entity)&&(identical(other.snoozeRemainingSeconds, _this.snoozeRemainingSeconds) || other.snoozeRemainingSeconds == _this.snoozeRemainingSeconds)&&(identical(other.emergencyHoldElapsedSeconds, _this.emergencyHoldElapsedSeconds) || other.emergencyHoldElapsedSeconds == _this.emergencyHoldElapsedSeconds)&&(identical(other.isEmergencyMuted, _this.isEmergencyMuted) || other.isEmergencyMuted == _this.isEmergencyMuted)&&(identical(other.emergencyReleasedEarly, _this.emergencyReleasedEarly) || other.emergencyReleasedEarly == _this.emergencyReleasedEarly)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as AlarmRingingState;
  return Object.hash(runtimeType,_this.entity,_this.snoozeRemainingSeconds,_this.emergencyHoldElapsedSeconds,_this.isEmergencyMuted,_this.emergencyReleasedEarly,_this.failure);
}

@override
String toString() {
  final _this = this as AlarmRingingState;
  return 'AlarmRingingState(entity: ${_this.entity}, snoozeRemainingSeconds: ${_this.snoozeRemainingSeconds}, emergencyHoldElapsedSeconds: ${_this.emergencyHoldElapsedSeconds}, isEmergencyMuted: ${_this.isEmergencyMuted}, emergencyReleasedEarly: ${_this.emergencyReleasedEarly}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $AlarmRingingStateCopyWith<$Res>  {
  factory $AlarmRingingStateCopyWith(AlarmRingingState value, $Res Function(AlarmRingingState) _then) = _$AlarmRingingStateCopyWithImpl;
@useResult
$Res call({
 AlarmStateEntity entity, int snoozeRemainingSeconds, int emergencyHoldElapsedSeconds, bool isEmergencyMuted, bool emergencyReleasedEarly, Failure? failure
});


$AlarmStateEntityCopyWith<$Res> get entity;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$AlarmRingingStateCopyWithImpl<$Res>
    implements $AlarmRingingStateCopyWith<$Res> {
  _$AlarmRingingStateCopyWithImpl(this._self, this._then);

  final AlarmRingingState _self;
  final $Res Function(AlarmRingingState) _then;

/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entity = null,Object? snoozeRemainingSeconds = null,Object? emergencyHoldElapsedSeconds = null,Object? isEmergencyMuted = null,Object? emergencyReleasedEarly = null,Object? failure = freezed,}) {
  return _then(AlarmRingingState(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as AlarmStateEntity,snoozeRemainingSeconds: null == snoozeRemainingSeconds ? _self.snoozeRemainingSeconds : snoozeRemainingSeconds // ignore: cast_nullable_to_non_nullable
as int,emergencyHoldElapsedSeconds: null == emergencyHoldElapsedSeconds ? _self.emergencyHoldElapsedSeconds : emergencyHoldElapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isEmergencyMuted: null == isEmergencyMuted ? _self.isEmergencyMuted : isEmergencyMuted // ignore: cast_nullable_to_non_nullable
as bool,emergencyReleasedEarly: null == emergencyReleasedEarly ? _self.emergencyReleasedEarly : emergencyReleasedEarly // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmStateEntityCopyWith<$Res> get entity {
  
  return $AlarmStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of AlarmRingingState
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


/// Adds pattern-matching-related methods to [AlarmRingingState].
extension AlarmRingingStatePatterns on AlarmRingingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmRingingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmRingingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmRingingState value)  $default,){
final _that = this;
switch (_that) {
case _AlarmRingingState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmRingingState value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmRingingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AlarmStateEntity entity,  int snoozeRemainingSeconds,  int emergencyHoldElapsedSeconds,  bool isEmergencyMuted,  bool emergencyReleasedEarly,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmRingingState() when $default != null:
return $default(_that.entity,_that.snoozeRemainingSeconds,_that.emergencyHoldElapsedSeconds,_that.isEmergencyMuted,_that.emergencyReleasedEarly,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AlarmStateEntity entity,  int snoozeRemainingSeconds,  int emergencyHoldElapsedSeconds,  bool isEmergencyMuted,  bool emergencyReleasedEarly,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AlarmRingingState():
return $default(_that.entity,_that.snoozeRemainingSeconds,_that.emergencyHoldElapsedSeconds,_that.isEmergencyMuted,_that.emergencyReleasedEarly,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AlarmStateEntity entity,  int snoozeRemainingSeconds,  int emergencyHoldElapsedSeconds,  bool isEmergencyMuted,  bool emergencyReleasedEarly,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AlarmRingingState() when $default != null:
return $default(_that.entity,_that.snoozeRemainingSeconds,_that.emergencyHoldElapsedSeconds,_that.isEmergencyMuted,_that.emergencyReleasedEarly,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AlarmRingingState implements AlarmRingingState {
  const _AlarmRingingState({required this.entity, this.snoozeRemainingSeconds = 0, this.emergencyHoldElapsedSeconds = 0, this.isEmergencyMuted = false, this.emergencyReleasedEarly = false, this.failure});
  

@override final  AlarmStateEntity entity;
@override@JsonKey() final  int snoozeRemainingSeconds;
@override@JsonKey() final  int emergencyHoldElapsedSeconds;
@override@JsonKey() final  bool isEmergencyMuted;
@override@JsonKey() final  bool emergencyReleasedEarly;
@override final  Failure? failure;

/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmRingingStateCopyWith<_AlarmRingingState> get copyWith => __$AlarmRingingStateCopyWithImpl<_AlarmRingingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmRingingState&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.snoozeRemainingSeconds, snoozeRemainingSeconds) || other.snoozeRemainingSeconds == snoozeRemainingSeconds)&&(identical(other.emergencyHoldElapsedSeconds, emergencyHoldElapsedSeconds) || other.emergencyHoldElapsedSeconds == emergencyHoldElapsedSeconds)&&(identical(other.isEmergencyMuted, isEmergencyMuted) || other.isEmergencyMuted == isEmergencyMuted)&&(identical(other.emergencyReleasedEarly, emergencyReleasedEarly) || other.emergencyReleasedEarly == emergencyReleasedEarly)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entity,snoozeRemainingSeconds,emergencyHoldElapsedSeconds,isEmergencyMuted,emergencyReleasedEarly,failure);
}

@override
String toString() {
    return 'AlarmRingingState(entity: $entity, snoozeRemainingSeconds: $snoozeRemainingSeconds, emergencyHoldElapsedSeconds: $emergencyHoldElapsedSeconds, isEmergencyMuted: $isEmergencyMuted, emergencyReleasedEarly: $emergencyReleasedEarly, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AlarmRingingStateCopyWith<$Res> implements $AlarmRingingStateCopyWith<$Res> {
  factory _$AlarmRingingStateCopyWith(_AlarmRingingState value, $Res Function(_AlarmRingingState) _then) = __$AlarmRingingStateCopyWithImpl;
@override @useResult
$Res call({
 AlarmStateEntity entity, int snoozeRemainingSeconds, int emergencyHoldElapsedSeconds, bool isEmergencyMuted, bool emergencyReleasedEarly, Failure? failure
});


@override $AlarmStateEntityCopyWith<$Res> get entity;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$AlarmRingingStateCopyWithImpl<$Res>
    implements _$AlarmRingingStateCopyWith<$Res> {
  __$AlarmRingingStateCopyWithImpl(this._self, this._then);

  final _AlarmRingingState _self;
  final $Res Function(_AlarmRingingState) _then;

/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,Object? snoozeRemainingSeconds = null,Object? emergencyHoldElapsedSeconds = null,Object? isEmergencyMuted = null,Object? emergencyReleasedEarly = null,Object? failure = freezed,}) {
  return _then(_AlarmRingingState(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as AlarmStateEntity,snoozeRemainingSeconds: null == snoozeRemainingSeconds ? _self.snoozeRemainingSeconds : snoozeRemainingSeconds // ignore: cast_nullable_to_non_nullable
as int,emergencyHoldElapsedSeconds: null == emergencyHoldElapsedSeconds ? _self.emergencyHoldElapsedSeconds : emergencyHoldElapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isEmergencyMuted: null == isEmergencyMuted ? _self.isEmergencyMuted : isEmergencyMuted // ignore: cast_nullable_to_non_nullable
as bool,emergencyReleasedEarly: null == emergencyReleasedEarly ? _self.emergencyReleasedEarly : emergencyReleasedEarly // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of AlarmRingingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmStateEntityCopyWith<$Res> get entity {
  
  return $AlarmStateEntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of AlarmRingingState
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
