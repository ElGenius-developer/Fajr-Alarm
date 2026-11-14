// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vacation_mode_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VacationModeConfig {

 DateTime get startDate; int get durationDays; DateTime get endDate;
/// Create a copy of VacationModeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VacationModeConfigCopyWith<VacationModeConfig> get copyWith => _$VacationModeConfigCopyWithImpl<VacationModeConfig>(this as VacationModeConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VacationModeConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VacationModeConfig&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.durationDays, _this.durationDays) || other.durationDays == _this.durationDays)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate));
}


@override
int get hashCode {
  final _this = this as VacationModeConfig;
  return Object.hash(runtimeType,_this.startDate,_this.durationDays,_this.endDate);
}

@override
String toString() {
  final _this = this as VacationModeConfig;
  return 'VacationModeConfig(startDate: ${_this.startDate}, durationDays: ${_this.durationDays}, endDate: ${_this.endDate})';
}


}

/// @nodoc
abstract mixin class $VacationModeConfigCopyWith<$Res>  {
  factory $VacationModeConfigCopyWith(VacationModeConfig value, $Res Function(VacationModeConfig) _then) = _$VacationModeConfigCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, int durationDays, DateTime endDate
});




}
/// @nodoc
class _$VacationModeConfigCopyWithImpl<$Res>
    implements $VacationModeConfigCopyWith<$Res> {
  _$VacationModeConfigCopyWithImpl(this._self, this._then);

  final VacationModeConfig _self;
  final $Res Function(VacationModeConfig) _then;

/// Create a copy of VacationModeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? durationDays = null,Object? endDate = null,}) {
  return _then(VacationModeConfig(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VacationModeConfig].
extension VacationModeConfigPatterns on VacationModeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VacationModeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VacationModeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VacationModeConfig value)  $default,){
final _that = this;
switch (_that) {
case _VacationModeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VacationModeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _VacationModeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startDate,  int durationDays,  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VacationModeConfig() when $default != null:
return $default(_that.startDate,_that.durationDays,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startDate,  int durationDays,  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _VacationModeConfig():
return $default(_that.startDate,_that.durationDays,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startDate,  int durationDays,  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _VacationModeConfig() when $default != null:
return $default(_that.startDate,_that.durationDays,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _VacationModeConfig extends VacationModeConfig {
  const _VacationModeConfig({required this.startDate, required this.durationDays, required this.endDate}): super._();
  

@override final  DateTime startDate;
@override final  int durationDays;
@override final  DateTime endDate;

/// Create a copy of VacationModeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VacationModeConfigCopyWith<_VacationModeConfig> get copyWith => __$VacationModeConfigCopyWithImpl<_VacationModeConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VacationModeConfig&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,startDate,durationDays,endDate);
}

@override
String toString() {
    return 'VacationModeConfig(startDate: $startDate, durationDays: $durationDays, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$VacationModeConfigCopyWith<$Res> implements $VacationModeConfigCopyWith<$Res> {
  factory _$VacationModeConfigCopyWith(_VacationModeConfig value, $Res Function(_VacationModeConfig) _then) = __$VacationModeConfigCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, int durationDays, DateTime endDate
});




}
/// @nodoc
class __$VacationModeConfigCopyWithImpl<$Res>
    implements _$VacationModeConfigCopyWith<$Res> {
  __$VacationModeConfigCopyWithImpl(this._self, this._then);

  final _VacationModeConfig _self;
  final $Res Function(_VacationModeConfig) _then;

/// Create a copy of VacationModeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? durationDays = null,Object? endDate = null,}) {
  return _then(_VacationModeConfig(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
