// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlarmStateEntity {

 AlarmStatus get status; DateTime? get scheduledAt; bool get isDryRun; bool get snoozeUsed; int get remainingEmergencyOverrides; int get relentlessCycleCount;
/// Create a copy of AlarmStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmStateEntityCopyWith<AlarmStateEntity> get copyWith => _$AlarmStateEntityCopyWithImpl<AlarmStateEntity>(this as AlarmStateEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlarmStateEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmStateEntity&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.scheduledAt, _this.scheduledAt) || other.scheduledAt == _this.scheduledAt)&&(identical(other.isDryRun, _this.isDryRun) || other.isDryRun == _this.isDryRun)&&(identical(other.snoozeUsed, _this.snoozeUsed) || other.snoozeUsed == _this.snoozeUsed)&&(identical(other.remainingEmergencyOverrides, _this.remainingEmergencyOverrides) || other.remainingEmergencyOverrides == _this.remainingEmergencyOverrides)&&(identical(other.relentlessCycleCount, _this.relentlessCycleCount) || other.relentlessCycleCount == _this.relentlessCycleCount));
}


@override
int get hashCode {
  final _this = this as AlarmStateEntity;
  return Object.hash(runtimeType,_this.status,_this.scheduledAt,_this.isDryRun,_this.snoozeUsed,_this.remainingEmergencyOverrides,_this.relentlessCycleCount);
}

@override
String toString() {
  final _this = this as AlarmStateEntity;
  return 'AlarmStateEntity(status: ${_this.status}, scheduledAt: ${_this.scheduledAt}, isDryRun: ${_this.isDryRun}, snoozeUsed: ${_this.snoozeUsed}, remainingEmergencyOverrides: ${_this.remainingEmergencyOverrides}, relentlessCycleCount: ${_this.relentlessCycleCount})';
}


}

/// @nodoc
abstract mixin class $AlarmStateEntityCopyWith<$Res>  {
  factory $AlarmStateEntityCopyWith(AlarmStateEntity value, $Res Function(AlarmStateEntity) _then) = _$AlarmStateEntityCopyWithImpl;
@useResult
$Res call({
 AlarmStatus status, DateTime? scheduledAt, bool isDryRun, bool snoozeUsed, int remainingEmergencyOverrides, int relentlessCycleCount
});




}
/// @nodoc
class _$AlarmStateEntityCopyWithImpl<$Res>
    implements $AlarmStateEntityCopyWith<$Res> {
  _$AlarmStateEntityCopyWithImpl(this._self, this._then);

  final AlarmStateEntity _self;
  final $Res Function(AlarmStateEntity) _then;

/// Create a copy of AlarmStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? scheduledAt = freezed,Object? isDryRun = null,Object? snoozeUsed = null,Object? remainingEmergencyOverrides = null,Object? relentlessCycleCount = null,}) {
  return _then(AlarmStateEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlarmStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDryRun: null == isDryRun ? _self.isDryRun : isDryRun // ignore: cast_nullable_to_non_nullable
as bool,snoozeUsed: null == snoozeUsed ? _self.snoozeUsed : snoozeUsed // ignore: cast_nullable_to_non_nullable
as bool,remainingEmergencyOverrides: null == remainingEmergencyOverrides ? _self.remainingEmergencyOverrides : remainingEmergencyOverrides // ignore: cast_nullable_to_non_nullable
as int,relentlessCycleCount: null == relentlessCycleCount ? _self.relentlessCycleCount : relentlessCycleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmStateEntity].
extension AlarmStateEntityPatterns on AlarmStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _AlarmStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AlarmStatus status,  DateTime? scheduledAt,  bool isDryRun,  bool snoozeUsed,  int remainingEmergencyOverrides,  int relentlessCycleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmStateEntity() when $default != null:
return $default(_that.status,_that.scheduledAt,_that.isDryRun,_that.snoozeUsed,_that.remainingEmergencyOverrides,_that.relentlessCycleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AlarmStatus status,  DateTime? scheduledAt,  bool isDryRun,  bool snoozeUsed,  int remainingEmergencyOverrides,  int relentlessCycleCount)  $default,) {final _that = this;
switch (_that) {
case _AlarmStateEntity():
return $default(_that.status,_that.scheduledAt,_that.isDryRun,_that.snoozeUsed,_that.remainingEmergencyOverrides,_that.relentlessCycleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AlarmStatus status,  DateTime? scheduledAt,  bool isDryRun,  bool snoozeUsed,  int remainingEmergencyOverrides,  int relentlessCycleCount)?  $default,) {final _that = this;
switch (_that) {
case _AlarmStateEntity() when $default != null:
return $default(_that.status,_that.scheduledAt,_that.isDryRun,_that.snoozeUsed,_that.remainingEmergencyOverrides,_that.relentlessCycleCount);case _:
  return null;

}
}

}

/// @nodoc


class _AlarmStateEntity implements AlarmStateEntity {
  const _AlarmStateEntity({required this.status, this.scheduledAt, this.isDryRun = false, this.snoozeUsed = false, this.remainingEmergencyOverrides = 3, this.relentlessCycleCount = 0});
  

@override final  AlarmStatus status;
@override final  DateTime? scheduledAt;
@override@JsonKey() final  bool isDryRun;
@override@JsonKey() final  bool snoozeUsed;
@override@JsonKey() final  int remainingEmergencyOverrides;
@override@JsonKey() final  int relentlessCycleCount;

/// Create a copy of AlarmStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmStateEntityCopyWith<_AlarmStateEntity> get copyWith => __$AlarmStateEntityCopyWithImpl<_AlarmStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmStateEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.isDryRun, isDryRun) || other.isDryRun == isDryRun)&&(identical(other.snoozeUsed, snoozeUsed) || other.snoozeUsed == snoozeUsed)&&(identical(other.remainingEmergencyOverrides, remainingEmergencyOverrides) || other.remainingEmergencyOverrides == remainingEmergencyOverrides)&&(identical(other.relentlessCycleCount, relentlessCycleCount) || other.relentlessCycleCount == relentlessCycleCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,scheduledAt,isDryRun,snoozeUsed,remainingEmergencyOverrides,relentlessCycleCount);
}

@override
String toString() {
    return 'AlarmStateEntity(status: $status, scheduledAt: $scheduledAt, isDryRun: $isDryRun, snoozeUsed: $snoozeUsed, remainingEmergencyOverrides: $remainingEmergencyOverrides, relentlessCycleCount: $relentlessCycleCount)';
}


}

/// @nodoc
abstract mixin class _$AlarmStateEntityCopyWith<$Res> implements $AlarmStateEntityCopyWith<$Res> {
  factory _$AlarmStateEntityCopyWith(_AlarmStateEntity value, $Res Function(_AlarmStateEntity) _then) = __$AlarmStateEntityCopyWithImpl;
@override @useResult
$Res call({
 AlarmStatus status, DateTime? scheduledAt, bool isDryRun, bool snoozeUsed, int remainingEmergencyOverrides, int relentlessCycleCount
});




}
/// @nodoc
class __$AlarmStateEntityCopyWithImpl<$Res>
    implements _$AlarmStateEntityCopyWith<$Res> {
  __$AlarmStateEntityCopyWithImpl(this._self, this._then);

  final _AlarmStateEntity _self;
  final $Res Function(_AlarmStateEntity) _then;

/// Create a copy of AlarmStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? scheduledAt = freezed,Object? isDryRun = null,Object? snoozeUsed = null,Object? remainingEmergencyOverrides = null,Object? relentlessCycleCount = null,}) {
  return _then(_AlarmStateEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlarmStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDryRun: null == isDryRun ? _self.isDryRun : isDryRun // ignore: cast_nullable_to_non_nullable
as bool,snoozeUsed: null == snoozeUsed ? _self.snoozeUsed : snoozeUsed // ignore: cast_nullable_to_non_nullable
as bool,remainingEmergencyOverrides: null == remainingEmergencyOverrides ? _self.remainingEmergencyOverrides : remainingEmergencyOverrides // ignore: cast_nullable_to_non_nullable
as int,relentlessCycleCount: null == relentlessCycleCount ? _self.relentlessCycleCount : relentlessCycleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
