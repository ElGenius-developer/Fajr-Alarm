// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerSchedule {

 DateTime get date; DateTime get fajrTime; DateTime get sunriseTime; double get latitude; double get longitude; String get calculationMethod; String get madhab;
/// Create a copy of PrayerSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerScheduleCopyWith<PrayerSchedule> get copyWith => _$PrayerScheduleCopyWithImpl<PrayerSchedule>(this as PrayerSchedule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrayerSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerSchedule&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.fajrTime, _this.fajrTime) || other.fajrTime == _this.fajrTime)&&(identical(other.sunriseTime, _this.sunriseTime) || other.sunriseTime == _this.sunriseTime)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.calculationMethod, _this.calculationMethod) || other.calculationMethod == _this.calculationMethod)&&(identical(other.madhab, _this.madhab) || other.madhab == _this.madhab));
}


@override
int get hashCode {
  final _this = this as PrayerSchedule;
  return Object.hash(runtimeType,_this.date,_this.fajrTime,_this.sunriseTime,_this.latitude,_this.longitude,_this.calculationMethod,_this.madhab);
}

@override
String toString() {
  final _this = this as PrayerSchedule;
  return 'PrayerSchedule(date: ${_this.date}, fajrTime: ${_this.fajrTime}, sunriseTime: ${_this.sunriseTime}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, calculationMethod: ${_this.calculationMethod}, madhab: ${_this.madhab})';
}


}

/// @nodoc
abstract mixin class $PrayerScheduleCopyWith<$Res>  {
  factory $PrayerScheduleCopyWith(PrayerSchedule value, $Res Function(PrayerSchedule) _then) = _$PrayerScheduleCopyWithImpl;
@useResult
$Res call({
 DateTime date, DateTime fajrTime, DateTime sunriseTime, double latitude, double longitude, String calculationMethod, String madhab
});




}
/// @nodoc
class _$PrayerScheduleCopyWithImpl<$Res>
    implements $PrayerScheduleCopyWith<$Res> {
  _$PrayerScheduleCopyWithImpl(this._self, this._then);

  final PrayerSchedule _self;
  final $Res Function(PrayerSchedule) _then;

/// Create a copy of PrayerSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? fajrTime = null,Object? sunriseTime = null,Object? latitude = null,Object? longitude = null,Object? calculationMethod = null,Object? madhab = null,}) {
  return _then(PrayerSchedule(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fajrTime: null == fajrTime ? _self.fajrTime : fajrTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunriseTime: null == sunriseTime ? _self.sunriseTime : sunriseTime // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as String,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PrayerSchedule].
extension PrayerSchedulePatterns on PrayerSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrayerSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrayerSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrayerSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PrayerSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrayerSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PrayerSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  DateTime fajrTime,  DateTime sunriseTime,  double latitude,  double longitude,  String calculationMethod,  String madhab)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrayerSchedule() when $default != null:
return $default(_that.date,_that.fajrTime,_that.sunriseTime,_that.latitude,_that.longitude,_that.calculationMethod,_that.madhab);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  DateTime fajrTime,  DateTime sunriseTime,  double latitude,  double longitude,  String calculationMethod,  String madhab)  $default,) {final _that = this;
switch (_that) {
case _PrayerSchedule():
return $default(_that.date,_that.fajrTime,_that.sunriseTime,_that.latitude,_that.longitude,_that.calculationMethod,_that.madhab);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  DateTime fajrTime,  DateTime sunriseTime,  double latitude,  double longitude,  String calculationMethod,  String madhab)?  $default,) {final _that = this;
switch (_that) {
case _PrayerSchedule() when $default != null:
return $default(_that.date,_that.fajrTime,_that.sunriseTime,_that.latitude,_that.longitude,_that.calculationMethod,_that.madhab);case _:
  return null;

}
}

}

/// @nodoc


class _PrayerSchedule implements PrayerSchedule {
  const _PrayerSchedule({required this.date, required this.fajrTime, required this.sunriseTime, required this.latitude, required this.longitude, required this.calculationMethod, required this.madhab});
  

@override final  DateTime date;
@override final  DateTime fajrTime;
@override final  DateTime sunriseTime;
@override final  double latitude;
@override final  double longitude;
@override final  String calculationMethod;
@override final  String madhab;

/// Create a copy of PrayerSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrayerScheduleCopyWith<_PrayerSchedule> get copyWith => __$PrayerScheduleCopyWithImpl<_PrayerSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrayerSchedule&&(identical(other.date, date) || other.date == date)&&(identical(other.fajrTime, fajrTime) || other.fajrTime == fajrTime)&&(identical(other.sunriseTime, sunriseTime) || other.sunriseTime == sunriseTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.calculationMethod, calculationMethod) || other.calculationMethod == calculationMethod)&&(identical(other.madhab, madhab) || other.madhab == madhab));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,fajrTime,sunriseTime,latitude,longitude,calculationMethod,madhab);
}

@override
String toString() {
    return 'PrayerSchedule(date: $date, fajrTime: $fajrTime, sunriseTime: $sunriseTime, latitude: $latitude, longitude: $longitude, calculationMethod: $calculationMethod, madhab: $madhab)';
}


}

/// @nodoc
abstract mixin class _$PrayerScheduleCopyWith<$Res> implements $PrayerScheduleCopyWith<$Res> {
  factory _$PrayerScheduleCopyWith(_PrayerSchedule value, $Res Function(_PrayerSchedule) _then) = __$PrayerScheduleCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DateTime fajrTime, DateTime sunriseTime, double latitude, double longitude, String calculationMethod, String madhab
});




}
/// @nodoc
class __$PrayerScheduleCopyWithImpl<$Res>
    implements _$PrayerScheduleCopyWith<$Res> {
  __$PrayerScheduleCopyWithImpl(this._self, this._then);

  final _PrayerSchedule _self;
  final $Res Function(_PrayerSchedule) _then;

/// Create a copy of PrayerSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? fajrTime = null,Object? sunriseTime = null,Object? latitude = null,Object? longitude = null,Object? calculationMethod = null,Object? madhab = null,}) {
  return _then(_PrayerSchedule(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fajrTime: null == fajrTime ? _self.fajrTime : fajrTime // ignore: cast_nullable_to_non_nullable
as DateTime,sunriseTime: null == sunriseTime ? _self.sunriseTime : sunriseTime // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as String,madhab: null == madhab ? _self.madhab : madhab // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
