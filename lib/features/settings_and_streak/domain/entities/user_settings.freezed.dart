// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettings {

 String get locale; int get monthlyEmergencyQuota; int get emergencyQuotaUsed; int get emergencyQuotaResetMonth; String? get bathroomBarcode; int get alarmOffsetMinutes; int? get manualAlarmHour; int? get manualAlarmMinute; VacationModeConfig? get vacationMode;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.monthlyEmergencyQuota, _this.monthlyEmergencyQuota) || other.monthlyEmergencyQuota == _this.monthlyEmergencyQuota)&&(identical(other.emergencyQuotaUsed, _this.emergencyQuotaUsed) || other.emergencyQuotaUsed == _this.emergencyQuotaUsed)&&(identical(other.emergencyQuotaResetMonth, _this.emergencyQuotaResetMonth) || other.emergencyQuotaResetMonth == _this.emergencyQuotaResetMonth)&&(identical(other.bathroomBarcode, _this.bathroomBarcode) || other.bathroomBarcode == _this.bathroomBarcode)&&(identical(other.alarmOffsetMinutes, _this.alarmOffsetMinutes) || other.alarmOffsetMinutes == _this.alarmOffsetMinutes)&&(identical(other.manualAlarmHour, _this.manualAlarmHour) || other.manualAlarmHour == _this.manualAlarmHour)&&(identical(other.manualAlarmMinute, _this.manualAlarmMinute) || other.manualAlarmMinute == _this.manualAlarmMinute)&&(identical(other.vacationMode, _this.vacationMode) || other.vacationMode == _this.vacationMode));
}


@override
int get hashCode {
  final _this = this as UserSettings;
  return Object.hash(runtimeType,_this.locale,_this.monthlyEmergencyQuota,_this.emergencyQuotaUsed,_this.emergencyQuotaResetMonth,_this.bathroomBarcode,_this.alarmOffsetMinutes,_this.manualAlarmHour,_this.manualAlarmMinute,_this.vacationMode);
}

@override
String toString() {
  final _this = this as UserSettings;
  return 'UserSettings(locale: ${_this.locale}, monthlyEmergencyQuota: ${_this.monthlyEmergencyQuota}, emergencyQuotaUsed: ${_this.emergencyQuotaUsed}, emergencyQuotaResetMonth: ${_this.emergencyQuotaResetMonth}, bathroomBarcode: ${_this.bathroomBarcode}, alarmOffsetMinutes: ${_this.alarmOffsetMinutes}, manualAlarmHour: ${_this.manualAlarmHour}, manualAlarmMinute: ${_this.manualAlarmMinute}, vacationMode: ${_this.vacationMode})';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 String locale, int monthlyEmergencyQuota, int emergencyQuotaUsed, int emergencyQuotaResetMonth, String? bathroomBarcode, int alarmOffsetMinutes, int? manualAlarmHour, int? manualAlarmMinute, VacationModeConfig? vacationMode
});


$VacationModeConfigCopyWith<$Res>? get vacationMode;

}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? monthlyEmergencyQuota = null,Object? emergencyQuotaUsed = null,Object? emergencyQuotaResetMonth = null,Object? bathroomBarcode = freezed,Object? alarmOffsetMinutes = null,Object? manualAlarmHour = freezed,Object? manualAlarmMinute = freezed,Object? vacationMode = freezed,}) {
  return _then(UserSettings(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,monthlyEmergencyQuota: null == monthlyEmergencyQuota ? _self.monthlyEmergencyQuota : monthlyEmergencyQuota // ignore: cast_nullable_to_non_nullable
as int,emergencyQuotaUsed: null == emergencyQuotaUsed ? _self.emergencyQuotaUsed : emergencyQuotaUsed // ignore: cast_nullable_to_non_nullable
as int,emergencyQuotaResetMonth: null == emergencyQuotaResetMonth ? _self.emergencyQuotaResetMonth : emergencyQuotaResetMonth // ignore: cast_nullable_to_non_nullable
as int,bathroomBarcode: freezed == bathroomBarcode ? _self.bathroomBarcode : bathroomBarcode // ignore: cast_nullable_to_non_nullable
as String?,alarmOffsetMinutes: null == alarmOffsetMinutes ? _self.alarmOffsetMinutes : alarmOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,manualAlarmHour: freezed == manualAlarmHour ? _self.manualAlarmHour : manualAlarmHour // ignore: cast_nullable_to_non_nullable
as int?,manualAlarmMinute: freezed == manualAlarmMinute ? _self.manualAlarmMinute : manualAlarmMinute // ignore: cast_nullable_to_non_nullable
as int?,vacationMode: freezed == vacationMode ? _self.vacationMode : vacationMode // ignore: cast_nullable_to_non_nullable
as VacationModeConfig?,
  ));
}
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationModeConfigCopyWith<$Res>? get vacationMode {
    if (_self.vacationMode == null) {
    return null;
  }

  return $VacationModeConfigCopyWith<$Res>(_self.vacationMode!, (value) {
    return _then(_self.copyWith(vacationMode: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locale,  int monthlyEmergencyQuota,  int emergencyQuotaUsed,  int emergencyQuotaResetMonth,  String? bathroomBarcode,  int alarmOffsetMinutes,  int? manualAlarmHour,  int? manualAlarmMinute,  VacationModeConfig? vacationMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.locale,_that.monthlyEmergencyQuota,_that.emergencyQuotaUsed,_that.emergencyQuotaResetMonth,_that.bathroomBarcode,_that.alarmOffsetMinutes,_that.manualAlarmHour,_that.manualAlarmMinute,_that.vacationMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locale,  int monthlyEmergencyQuota,  int emergencyQuotaUsed,  int emergencyQuotaResetMonth,  String? bathroomBarcode,  int alarmOffsetMinutes,  int? manualAlarmHour,  int? manualAlarmMinute,  VacationModeConfig? vacationMode)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.locale,_that.monthlyEmergencyQuota,_that.emergencyQuotaUsed,_that.emergencyQuotaResetMonth,_that.bathroomBarcode,_that.alarmOffsetMinutes,_that.manualAlarmHour,_that.manualAlarmMinute,_that.vacationMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locale,  int monthlyEmergencyQuota,  int emergencyQuotaUsed,  int emergencyQuotaResetMonth,  String? bathroomBarcode,  int alarmOffsetMinutes,  int? manualAlarmHour,  int? manualAlarmMinute,  VacationModeConfig? vacationMode)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.locale,_that.monthlyEmergencyQuota,_that.emergencyQuotaUsed,_that.emergencyQuotaResetMonth,_that.bathroomBarcode,_that.alarmOffsetMinutes,_that.manualAlarmHour,_that.manualAlarmMinute,_that.vacationMode);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettings extends UserSettings {
  const _UserSettings({this.locale = 'ar', this.monthlyEmergencyQuota = 3, this.emergencyQuotaUsed = 0, this.emergencyQuotaResetMonth = 0, this.bathroomBarcode, this.alarmOffsetMinutes = 0, this.manualAlarmHour, this.manualAlarmMinute, this.vacationMode}): super._();
  

@override@JsonKey() final  String locale;
@override@JsonKey() final  int monthlyEmergencyQuota;
@override@JsonKey() final  int emergencyQuotaUsed;
@override@JsonKey() final  int emergencyQuotaResetMonth;
@override final  String? bathroomBarcode;
@override@JsonKey() final  int alarmOffsetMinutes;
@override final  int? manualAlarmHour;
@override final  int? manualAlarmMinute;
@override final  VacationModeConfig? vacationMode;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.monthlyEmergencyQuota, monthlyEmergencyQuota) || other.monthlyEmergencyQuota == monthlyEmergencyQuota)&&(identical(other.emergencyQuotaUsed, emergencyQuotaUsed) || other.emergencyQuotaUsed == emergencyQuotaUsed)&&(identical(other.emergencyQuotaResetMonth, emergencyQuotaResetMonth) || other.emergencyQuotaResetMonth == emergencyQuotaResetMonth)&&(identical(other.bathroomBarcode, bathroomBarcode) || other.bathroomBarcode == bathroomBarcode)&&(identical(other.alarmOffsetMinutes, alarmOffsetMinutes) || other.alarmOffsetMinutes == alarmOffsetMinutes)&&(identical(other.manualAlarmHour, manualAlarmHour) || other.manualAlarmHour == manualAlarmHour)&&(identical(other.manualAlarmMinute, manualAlarmMinute) || other.manualAlarmMinute == manualAlarmMinute)&&(identical(other.vacationMode, vacationMode) || other.vacationMode == vacationMode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,locale,monthlyEmergencyQuota,emergencyQuotaUsed,emergencyQuotaResetMonth,bathroomBarcode,alarmOffsetMinutes,manualAlarmHour,manualAlarmMinute,vacationMode);
}

@override
String toString() {
    return 'UserSettings(locale: $locale, monthlyEmergencyQuota: $monthlyEmergencyQuota, emergencyQuotaUsed: $emergencyQuotaUsed, emergencyQuotaResetMonth: $emergencyQuotaResetMonth, bathroomBarcode: $bathroomBarcode, alarmOffsetMinutes: $alarmOffsetMinutes, manualAlarmHour: $manualAlarmHour, manualAlarmMinute: $manualAlarmMinute, vacationMode: $vacationMode)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String locale, int monthlyEmergencyQuota, int emergencyQuotaUsed, int emergencyQuotaResetMonth, String? bathroomBarcode, int alarmOffsetMinutes, int? manualAlarmHour, int? manualAlarmMinute, VacationModeConfig? vacationMode
});


@override $VacationModeConfigCopyWith<$Res>? get vacationMode;

}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? monthlyEmergencyQuota = null,Object? emergencyQuotaUsed = null,Object? emergencyQuotaResetMonth = null,Object? bathroomBarcode = freezed,Object? alarmOffsetMinutes = null,Object? manualAlarmHour = freezed,Object? manualAlarmMinute = freezed,Object? vacationMode = freezed,}) {
  return _then(_UserSettings(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,monthlyEmergencyQuota: null == monthlyEmergencyQuota ? _self.monthlyEmergencyQuota : monthlyEmergencyQuota // ignore: cast_nullable_to_non_nullable
as int,emergencyQuotaUsed: null == emergencyQuotaUsed ? _self.emergencyQuotaUsed : emergencyQuotaUsed // ignore: cast_nullable_to_non_nullable
as int,emergencyQuotaResetMonth: null == emergencyQuotaResetMonth ? _self.emergencyQuotaResetMonth : emergencyQuotaResetMonth // ignore: cast_nullable_to_non_nullable
as int,bathroomBarcode: freezed == bathroomBarcode ? _self.bathroomBarcode : bathroomBarcode // ignore: cast_nullable_to_non_nullable
as String?,alarmOffsetMinutes: null == alarmOffsetMinutes ? _self.alarmOffsetMinutes : alarmOffsetMinutes // ignore: cast_nullable_to_non_nullable
as int,manualAlarmHour: freezed == manualAlarmHour ? _self.manualAlarmHour : manualAlarmHour // ignore: cast_nullable_to_non_nullable
as int?,manualAlarmMinute: freezed == manualAlarmMinute ? _self.manualAlarmMinute : manualAlarmMinute // ignore: cast_nullable_to_non_nullable
as int?,vacationMode: freezed == vacationMode ? _self.vacationMode : vacationMode // ignore: cast_nullable_to_non_nullable
as VacationModeConfig?,
  ));
}

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VacationModeConfigCopyWith<$Res>? get vacationMode {
    if (_self.vacationMode == null) {
    return null;
  }

  return $VacationModeConfigCopyWith<$Res>(_self.vacationMode!, (value) {
    return _then(_self.copyWith(vacationMode: value));
  });
}
}

// dart format on
