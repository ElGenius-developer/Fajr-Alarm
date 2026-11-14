// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fajr_alarm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FajrAlarmConfig {

 double get latitude; double get longitude; String? get cityName; FajrCalculationMethod get calculationMethod; FajrMadhab get madhab; FajrAlarmMode get mode; FajrOffsetDirection get offsetDirection; int get offsetMinutes; int get manualHour; int get manualMinute; bool get isEnabled;
/// Create a copy of FajrAlarmConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FajrAlarmConfigCopyWith<FajrAlarmConfig> get copyWith => _$FajrAlarmConfigCopyWithImpl<FajrAlarmConfig>(this as FajrAlarmConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FajrAlarmConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FajrAlarmConfig&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.calculationMethod, _this.calculationMethod) || other.calculationMethod == _this.calculationMethod)&&(identical(other.madhab, _this.madhab) || other.madhab == _this.madhab)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.offsetDirection, _this.offsetDirection) || other.offsetDirection == _this.offsetDirection)&&(identical(other.offsetMinutes, _this.offsetMinutes) || other.offsetMinutes == _this.offsetMinutes)&&(identical(other.manualHour, _this.manualHour) || other.manualHour == _this.manualHour)&&(identical(other.manualMinute, _this.manualMinute) || other.manualMinute == _this.manualMinute)&&(identical(other.isEnabled, _this.isEnabled) || other.isEnabled == _this.isEnabled));
}


@override
int get hashCode {
  final _this = this as FajrAlarmConfig;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.cityName,_this.calculationMethod,_this.madhab,_this.mode,_this.offsetDirection,_this.offsetMinutes,_this.manualHour,_this.manualMinute,_this.isEnabled);
}

@override
String toString() {
  final _this = this as FajrAlarmConfig;
  return 'FajrAlarmConfig(latitude: ${_this.latitude}, longitude: ${_this.longitude}, cityName: ${_this.cityName}, calculationMethod: ${_this.calculationMethod}, madhab: ${_this.madhab}, mode: ${_this.mode}, offsetDirection: ${_this.offsetDirection}, offsetMinutes: ${_this.offsetMinutes}, manualHour: ${_this.manualHour}, manualMinute: ${_this.manualMinute}, isEnabled: ${_this.isEnabled})';
}


}

/// @nodoc
abstract mixin class $FajrAlarmConfigCopyWith<$Res>  {
  factory $FajrAlarmConfigCopyWith(FajrAlarmConfig value, $Res Function(FajrAlarmConfig) _then) = _$FajrAlarmConfigCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String? cityName, FajrCalculationMethod calculationMethod, FajrMadhab madhab, FajrAlarmMode mode, FajrOffsetDirection offsetDirection, int offsetMinutes, int manualHour, int manualMinute, bool isEnabled
});




}
/// @nodoc
class _$FajrAlarmConfigCopyWithImpl<$Res>
    implements $FajrAlarmConfigCopyWith<$Res> {
  _$FajrAlarmConfigCopyWithImpl(this._self, this._then);

  final FajrAlarmConfig _self;
  final $Res Function(FajrAlarmConfig) _then;

/// Create a copy of FajrAlarmConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? cityName = freezed,Object? calculationMethod = null,Object? madhab = null,Object? mode = null,Object? offsetDirection = null,Object? offsetMinutes = null,Object? manualHour = null,Object? manualMinute = null,Object? isEnabled = null,}) {
  return _then(FajrAlarmConfig(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as FajrCalculationMethod,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as FajrMadhab,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FajrAlarmMode,offsetDirection: null == offsetDirection ? _self.offsetDirection : offsetDirection // ignore: cast_nullable_to_non_nullable
as FajrOffsetDirection,offsetMinutes: null == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int,manualHour: null == manualHour ? _self.manualHour : manualHour // ignore: cast_nullable_to_non_nullable
as int,manualMinute: null == manualMinute ? _self.manualMinute : manualMinute // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FajrAlarmConfig].
extension FajrAlarmConfigPatterns on FajrAlarmConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FajrAlarmConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FajrAlarmConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FajrAlarmConfig value)  $default,){
final _that = this;
switch (_that) {
case _FajrAlarmConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FajrAlarmConfig value)?  $default,){
final _that = this;
switch (_that) {
case _FajrAlarmConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String? cityName,  FajrCalculationMethod calculationMethod,  FajrMadhab madhab,  FajrAlarmMode mode,  FajrOffsetDirection offsetDirection,  int offsetMinutes,  int manualHour,  int manualMinute,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FajrAlarmConfig() when $default != null:
return $default(_that.latitude,_that.longitude,_that.cityName,_that.calculationMethod,_that.madhab,_that.mode,_that.offsetDirection,_that.offsetMinutes,_that.manualHour,_that.manualMinute,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String? cityName,  FajrCalculationMethod calculationMethod,  FajrMadhab madhab,  FajrAlarmMode mode,  FajrOffsetDirection offsetDirection,  int offsetMinutes,  int manualHour,  int manualMinute,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _FajrAlarmConfig():
return $default(_that.latitude,_that.longitude,_that.cityName,_that.calculationMethod,_that.madhab,_that.mode,_that.offsetDirection,_that.offsetMinutes,_that.manualHour,_that.manualMinute,_that.isEnabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  String? cityName,  FajrCalculationMethod calculationMethod,  FajrMadhab madhab,  FajrAlarmMode mode,  FajrOffsetDirection offsetDirection,  int offsetMinutes,  int manualHour,  int manualMinute,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _FajrAlarmConfig() when $default != null:
return $default(_that.latitude,_that.longitude,_that.cityName,_that.calculationMethod,_that.madhab,_that.mode,_that.offsetDirection,_that.offsetMinutes,_that.manualHour,_that.manualMinute,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _FajrAlarmConfig implements FajrAlarmConfig {
  const _FajrAlarmConfig({required this.latitude, required this.longitude, this.cityName, this.calculationMethod = FajrCalculationMethod.egyptian, this.madhab = FajrMadhab.shafi, this.mode = FajrAlarmMode.relativeToAdhan, this.offsetDirection = FajrOffsetDirection.at, this.offsetMinutes = 0, this.manualHour = 4, this.manualMinute = 30, this.isEnabled = true});
  

@override final  double latitude;
@override final  double longitude;
@override final  String? cityName;
@override@JsonKey() final  FajrCalculationMethod calculationMethod;
@override@JsonKey() final  FajrMadhab madhab;
@override@JsonKey() final  FajrAlarmMode mode;
@override@JsonKey() final  FajrOffsetDirection offsetDirection;
@override@JsonKey() final  int offsetMinutes;
@override@JsonKey() final  int manualHour;
@override@JsonKey() final  int manualMinute;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of FajrAlarmConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FajrAlarmConfigCopyWith<_FajrAlarmConfig> get copyWith => __$FajrAlarmConfigCopyWithImpl<_FajrAlarmConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FajrAlarmConfig&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.calculationMethod, calculationMethod) || other.calculationMethod == calculationMethod)&&(identical(other.madhab, madhab) || other.madhab == madhab)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.offsetDirection, offsetDirection) || other.offsetDirection == offsetDirection)&&(identical(other.offsetMinutes, offsetMinutes) || other.offsetMinutes == offsetMinutes)&&(identical(other.manualHour, manualHour) || other.manualHour == manualHour)&&(identical(other.manualMinute, manualMinute) || other.manualMinute == manualMinute)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,cityName,calculationMethod,madhab,mode,offsetDirection,offsetMinutes,manualHour,manualMinute,isEnabled);
}

@override
String toString() {
    return 'FajrAlarmConfig(latitude: $latitude, longitude: $longitude, cityName: $cityName, calculationMethod: $calculationMethod, madhab: $madhab, mode: $mode, offsetDirection: $offsetDirection, offsetMinutes: $offsetMinutes, manualHour: $manualHour, manualMinute: $manualMinute, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$FajrAlarmConfigCopyWith<$Res> implements $FajrAlarmConfigCopyWith<$Res> {
  factory _$FajrAlarmConfigCopyWith(_FajrAlarmConfig value, $Res Function(_FajrAlarmConfig) _then) = __$FajrAlarmConfigCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, String? cityName, FajrCalculationMethod calculationMethod, FajrMadhab madhab, FajrAlarmMode mode, FajrOffsetDirection offsetDirection, int offsetMinutes, int manualHour, int manualMinute, bool isEnabled
});




}
/// @nodoc
class __$FajrAlarmConfigCopyWithImpl<$Res>
    implements _$FajrAlarmConfigCopyWith<$Res> {
  __$FajrAlarmConfigCopyWithImpl(this._self, this._then);

  final _FajrAlarmConfig _self;
  final $Res Function(_FajrAlarmConfig) _then;

/// Create a copy of FajrAlarmConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? cityName = freezed,Object? calculationMethod = null,Object? madhab = null,Object? mode = null,Object? offsetDirection = null,Object? offsetMinutes = null,Object? manualHour = null,Object? manualMinute = null,Object? isEnabled = null,}) {
  return _then(_FajrAlarmConfig(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as FajrCalculationMethod,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as FajrMadhab,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FajrAlarmMode,offsetDirection: null == offsetDirection ? _self.offsetDirection : offsetDirection // ignore: cast_nullable_to_non_nullable
as FajrOffsetDirection,offsetMinutes: null == offsetMinutes ? _self.offsetMinutes : offsetMinutes // ignore: cast_nullable_to_non_nullable
as int,manualHour: null == manualHour ? _self.manualHour : manualHour // ignore: cast_nullable_to_non_nullable
as int,manualMinute: null == manualMinute ? _self.manualMinute : manualMinute // ignore: cast_nullable_to_non_nullable
as int,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
