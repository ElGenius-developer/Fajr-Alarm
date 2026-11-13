// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingStateEntity {

 int get step; double? get latitude; double? get longitude; String? get cityName; bool get permissionsGranted; bool get privacyConsentAccepted; bool get apiKeyValidated; String? get registeredBarcode; bool get isCompleted;
/// Create a copy of OnboardingStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateEntityCopyWith<OnboardingStateEntity> get copyWith => _$OnboardingStateEntityCopyWithImpl<OnboardingStateEntity>(this as OnboardingStateEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingStateEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStateEntity&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.permissionsGranted, _this.permissionsGranted) || other.permissionsGranted == _this.permissionsGranted)&&(identical(other.privacyConsentAccepted, _this.privacyConsentAccepted) || other.privacyConsentAccepted == _this.privacyConsentAccepted)&&(identical(other.apiKeyValidated, _this.apiKeyValidated) || other.apiKeyValidated == _this.apiKeyValidated)&&(identical(other.registeredBarcode, _this.registeredBarcode) || other.registeredBarcode == _this.registeredBarcode)&&(identical(other.isCompleted, _this.isCompleted) || other.isCompleted == _this.isCompleted));
}


@override
int get hashCode {
  final _this = this as OnboardingStateEntity;
  return Object.hash(runtimeType,_this.step,_this.latitude,_this.longitude,_this.cityName,_this.permissionsGranted,_this.privacyConsentAccepted,_this.apiKeyValidated,_this.registeredBarcode,_this.isCompleted);
}

@override
String toString() {
  final _this = this as OnboardingStateEntity;
  return 'OnboardingStateEntity(step: ${_this.step}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, cityName: ${_this.cityName}, permissionsGranted: ${_this.permissionsGranted}, privacyConsentAccepted: ${_this.privacyConsentAccepted}, apiKeyValidated: ${_this.apiKeyValidated}, registeredBarcode: ${_this.registeredBarcode}, isCompleted: ${_this.isCompleted})';
}


}

/// @nodoc
abstract mixin class $OnboardingStateEntityCopyWith<$Res>  {
  factory $OnboardingStateEntityCopyWith(OnboardingStateEntity value, $Res Function(OnboardingStateEntity) _then) = _$OnboardingStateEntityCopyWithImpl;
@useResult
$Res call({
 int step, double? latitude, double? longitude, String? cityName, bool permissionsGranted, bool privacyConsentAccepted, bool apiKeyValidated, String? registeredBarcode, bool isCompleted
});




}
/// @nodoc
class _$OnboardingStateEntityCopyWithImpl<$Res>
    implements $OnboardingStateEntityCopyWith<$Res> {
  _$OnboardingStateEntityCopyWithImpl(this._self, this._then);

  final OnboardingStateEntity _self;
  final $Res Function(OnboardingStateEntity) _then;

/// Create a copy of OnboardingStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,Object? permissionsGranted = null,Object? privacyConsentAccepted = null,Object? apiKeyValidated = null,Object? registeredBarcode = freezed,Object? isCompleted = null,}) {
  return _then(OnboardingStateEntity(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,permissionsGranted: null == permissionsGranted ? _self.permissionsGranted : permissionsGranted // ignore: cast_nullable_to_non_nullable
as bool,privacyConsentAccepted: null == privacyConsentAccepted ? _self.privacyConsentAccepted : privacyConsentAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiKeyValidated: null == apiKeyValidated ? _self.apiKeyValidated : apiKeyValidated // ignore: cast_nullable_to_non_nullable
as bool,registeredBarcode: freezed == registeredBarcode ? _self.registeredBarcode : registeredBarcode // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStateEntity].
extension OnboardingStateEntityPatterns on OnboardingStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int step,  double? latitude,  double? longitude,  String? cityName,  bool permissionsGranted,  bool privacyConsentAccepted,  bool apiKeyValidated,  String? registeredBarcode,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStateEntity() when $default != null:
return $default(_that.step,_that.latitude,_that.longitude,_that.cityName,_that.permissionsGranted,_that.privacyConsentAccepted,_that.apiKeyValidated,_that.registeredBarcode,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int step,  double? latitude,  double? longitude,  String? cityName,  bool permissionsGranted,  bool privacyConsentAccepted,  bool apiKeyValidated,  String? registeredBarcode,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStateEntity():
return $default(_that.step,_that.latitude,_that.longitude,_that.cityName,_that.permissionsGranted,_that.privacyConsentAccepted,_that.apiKeyValidated,_that.registeredBarcode,_that.isCompleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int step,  double? latitude,  double? longitude,  String? cityName,  bool permissionsGranted,  bool privacyConsentAccepted,  bool apiKeyValidated,  String? registeredBarcode,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStateEntity() when $default != null:
return $default(_that.step,_that.latitude,_that.longitude,_that.cityName,_that.permissionsGranted,_that.privacyConsentAccepted,_that.apiKeyValidated,_that.registeredBarcode,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingStateEntity extends OnboardingStateEntity {
  const _OnboardingStateEntity({this.step = 0, this.latitude, this.longitude, this.cityName, this.permissionsGranted = false, this.privacyConsentAccepted = false, this.apiKeyValidated = false, this.registeredBarcode, this.isCompleted = false}): super._();
  

@override@JsonKey() final  int step;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? cityName;
@override@JsonKey() final  bool permissionsGranted;
@override@JsonKey() final  bool privacyConsentAccepted;
@override@JsonKey() final  bool apiKeyValidated;
@override final  String? registeredBarcode;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of OnboardingStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateEntityCopyWith<_OnboardingStateEntity> get copyWith => __$OnboardingStateEntityCopyWithImpl<_OnboardingStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStateEntity&&(identical(other.step, step) || other.step == step)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.permissionsGranted, permissionsGranted) || other.permissionsGranted == permissionsGranted)&&(identical(other.privacyConsentAccepted, privacyConsentAccepted) || other.privacyConsentAccepted == privacyConsentAccepted)&&(identical(other.apiKeyValidated, apiKeyValidated) || other.apiKeyValidated == apiKeyValidated)&&(identical(other.registeredBarcode, registeredBarcode) || other.registeredBarcode == registeredBarcode)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,latitude,longitude,cityName,permissionsGranted,privacyConsentAccepted,apiKeyValidated,registeredBarcode,isCompleted);
}

@override
String toString() {
    return 'OnboardingStateEntity(step: $step, latitude: $latitude, longitude: $longitude, cityName: $cityName, permissionsGranted: $permissionsGranted, privacyConsentAccepted: $privacyConsentAccepted, apiKeyValidated: $apiKeyValidated, registeredBarcode: $registeredBarcode, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateEntityCopyWith<$Res> implements $OnboardingStateEntityCopyWith<$Res> {
  factory _$OnboardingStateEntityCopyWith(_OnboardingStateEntity value, $Res Function(_OnboardingStateEntity) _then) = __$OnboardingStateEntityCopyWithImpl;
@override @useResult
$Res call({
 int step, double? latitude, double? longitude, String? cityName, bool permissionsGranted, bool privacyConsentAccepted, bool apiKeyValidated, String? registeredBarcode, bool isCompleted
});




}
/// @nodoc
class __$OnboardingStateEntityCopyWithImpl<$Res>
    implements _$OnboardingStateEntityCopyWith<$Res> {
  __$OnboardingStateEntityCopyWithImpl(this._self, this._then);

  final _OnboardingStateEntity _self;
  final $Res Function(_OnboardingStateEntity) _then;

/// Create a copy of OnboardingStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,Object? permissionsGranted = null,Object? privacyConsentAccepted = null,Object? apiKeyValidated = null,Object? registeredBarcode = freezed,Object? isCompleted = null,}) {
  return _then(_OnboardingStateEntity(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,permissionsGranted: null == permissionsGranted ? _self.permissionsGranted : permissionsGranted // ignore: cast_nullable_to_non_nullable
as bool,privacyConsentAccepted: null == privacyConsentAccepted ? _self.privacyConsentAccepted : privacyConsentAccepted // ignore: cast_nullable_to_non_nullable
as bool,apiKeyValidated: null == apiKeyValidated ? _self.apiKeyValidated : apiKeyValidated // ignore: cast_nullable_to_non_nullable
as bool,registeredBarcode: freezed == registeredBarcode ? _self.registeredBarcode : registeredBarcode // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PermissionsGateStatus {

 bool get fullScreenIntentGranted; bool get batteryOptimizationIgnored; bool get cameraGranted; bool get alarmPermissionGranted;
/// Create a copy of PermissionsGateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsGateStatusCopyWith<PermissionsGateStatus> get copyWith => _$PermissionsGateStatusCopyWithImpl<PermissionsGateStatus>(this as PermissionsGateStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PermissionsGateStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsGateStatus&&(identical(other.fullScreenIntentGranted, _this.fullScreenIntentGranted) || other.fullScreenIntentGranted == _this.fullScreenIntentGranted)&&(identical(other.batteryOptimizationIgnored, _this.batteryOptimizationIgnored) || other.batteryOptimizationIgnored == _this.batteryOptimizationIgnored)&&(identical(other.cameraGranted, _this.cameraGranted) || other.cameraGranted == _this.cameraGranted)&&(identical(other.alarmPermissionGranted, _this.alarmPermissionGranted) || other.alarmPermissionGranted == _this.alarmPermissionGranted));
}


@override
int get hashCode {
  final _this = this as PermissionsGateStatus;
  return Object.hash(runtimeType,_this.fullScreenIntentGranted,_this.batteryOptimizationIgnored,_this.cameraGranted,_this.alarmPermissionGranted);
}

@override
String toString() {
  final _this = this as PermissionsGateStatus;
  return 'PermissionsGateStatus(fullScreenIntentGranted: ${_this.fullScreenIntentGranted}, batteryOptimizationIgnored: ${_this.batteryOptimizationIgnored}, cameraGranted: ${_this.cameraGranted}, alarmPermissionGranted: ${_this.alarmPermissionGranted})';
}


}

/// @nodoc
abstract mixin class $PermissionsGateStatusCopyWith<$Res>  {
  factory $PermissionsGateStatusCopyWith(PermissionsGateStatus value, $Res Function(PermissionsGateStatus) _then) = _$PermissionsGateStatusCopyWithImpl;
@useResult
$Res call({
 bool fullScreenIntentGranted, bool batteryOptimizationIgnored, bool cameraGranted, bool alarmPermissionGranted
});




}
/// @nodoc
class _$PermissionsGateStatusCopyWithImpl<$Res>
    implements $PermissionsGateStatusCopyWith<$Res> {
  _$PermissionsGateStatusCopyWithImpl(this._self, this._then);

  final PermissionsGateStatus _self;
  final $Res Function(PermissionsGateStatus) _then;

/// Create a copy of PermissionsGateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullScreenIntentGranted = null,Object? batteryOptimizationIgnored = null,Object? cameraGranted = null,Object? alarmPermissionGranted = null,}) {
  return _then(PermissionsGateStatus(
fullScreenIntentGranted: null == fullScreenIntentGranted ? _self.fullScreenIntentGranted : fullScreenIntentGranted // ignore: cast_nullable_to_non_nullable
as bool,batteryOptimizationIgnored: null == batteryOptimizationIgnored ? _self.batteryOptimizationIgnored : batteryOptimizationIgnored // ignore: cast_nullable_to_non_nullable
as bool,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,alarmPermissionGranted: null == alarmPermissionGranted ? _self.alarmPermissionGranted : alarmPermissionGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionsGateStatus].
extension PermissionsGateStatusPatterns on PermissionsGateStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionsGateStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionsGateStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionsGateStatus value)  $default,){
final _that = this;
switch (_that) {
case _PermissionsGateStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionsGateStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionsGateStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool fullScreenIntentGranted,  bool batteryOptimizationIgnored,  bool cameraGranted,  bool alarmPermissionGranted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionsGateStatus() when $default != null:
return $default(_that.fullScreenIntentGranted,_that.batteryOptimizationIgnored,_that.cameraGranted,_that.alarmPermissionGranted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool fullScreenIntentGranted,  bool batteryOptimizationIgnored,  bool cameraGranted,  bool alarmPermissionGranted)  $default,) {final _that = this;
switch (_that) {
case _PermissionsGateStatus():
return $default(_that.fullScreenIntentGranted,_that.batteryOptimizationIgnored,_that.cameraGranted,_that.alarmPermissionGranted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool fullScreenIntentGranted,  bool batteryOptimizationIgnored,  bool cameraGranted,  bool alarmPermissionGranted)?  $default,) {final _that = this;
switch (_that) {
case _PermissionsGateStatus() when $default != null:
return $default(_that.fullScreenIntentGranted,_that.batteryOptimizationIgnored,_that.cameraGranted,_that.alarmPermissionGranted);case _:
  return null;

}
}

}

/// @nodoc


class _PermissionsGateStatus extends PermissionsGateStatus {
  const _PermissionsGateStatus({this.fullScreenIntentGranted = false, this.batteryOptimizationIgnored = false, this.cameraGranted = false, this.alarmPermissionGranted = false}): super._();
  

@override@JsonKey() final  bool fullScreenIntentGranted;
@override@JsonKey() final  bool batteryOptimizationIgnored;
@override@JsonKey() final  bool cameraGranted;
@override@JsonKey() final  bool alarmPermissionGranted;

/// Create a copy of PermissionsGateStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsGateStatusCopyWith<_PermissionsGateStatus> get copyWith => __$PermissionsGateStatusCopyWithImpl<_PermissionsGateStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionsGateStatus&&(identical(other.fullScreenIntentGranted, fullScreenIntentGranted) || other.fullScreenIntentGranted == fullScreenIntentGranted)&&(identical(other.batteryOptimizationIgnored, batteryOptimizationIgnored) || other.batteryOptimizationIgnored == batteryOptimizationIgnored)&&(identical(other.cameraGranted, cameraGranted) || other.cameraGranted == cameraGranted)&&(identical(other.alarmPermissionGranted, alarmPermissionGranted) || other.alarmPermissionGranted == alarmPermissionGranted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fullScreenIntentGranted,batteryOptimizationIgnored,cameraGranted,alarmPermissionGranted);
}

@override
String toString() {
    return 'PermissionsGateStatus(fullScreenIntentGranted: $fullScreenIntentGranted, batteryOptimizationIgnored: $batteryOptimizationIgnored, cameraGranted: $cameraGranted, alarmPermissionGranted: $alarmPermissionGranted)';
}


}

/// @nodoc
abstract mixin class _$PermissionsGateStatusCopyWith<$Res> implements $PermissionsGateStatusCopyWith<$Res> {
  factory _$PermissionsGateStatusCopyWith(_PermissionsGateStatus value, $Res Function(_PermissionsGateStatus) _then) = __$PermissionsGateStatusCopyWithImpl;
@override @useResult
$Res call({
 bool fullScreenIntentGranted, bool batteryOptimizationIgnored, bool cameraGranted, bool alarmPermissionGranted
});




}
/// @nodoc
class __$PermissionsGateStatusCopyWithImpl<$Res>
    implements _$PermissionsGateStatusCopyWith<$Res> {
  __$PermissionsGateStatusCopyWithImpl(this._self, this._then);

  final _PermissionsGateStatus _self;
  final $Res Function(_PermissionsGateStatus) _then;

/// Create a copy of PermissionsGateStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullScreenIntentGranted = null,Object? batteryOptimizationIgnored = null,Object? cameraGranted = null,Object? alarmPermissionGranted = null,}) {
  return _then(_PermissionsGateStatus(
fullScreenIntentGranted: null == fullScreenIntentGranted ? _self.fullScreenIntentGranted : fullScreenIntentGranted // ignore: cast_nullable_to_non_nullable
as bool,batteryOptimizationIgnored: null == batteryOptimizationIgnored ? _self.batteryOptimizationIgnored : batteryOptimizationIgnored // ignore: cast_nullable_to_non_nullable
as bool,cameraGranted: null == cameraGranted ? _self.cameraGranted : cameraGranted // ignore: cast_nullable_to_non_nullable
as bool,alarmPermissionGranted: null == alarmPermissionGranted ? _self.alarmPermissionGranted : alarmPermissionGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
