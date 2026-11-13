// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {

 String get message;
/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailureCopyWith<Failure> get copyWith => _$FailureCopyWithImpl<Failure>(this as Failure, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Failure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as Failure;
  return Object.hash(runtimeType,_this.message);
}

@override
String toString() {
  final _this = this as Failure;
  return 'Failure(message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $FailureCopyWith<$Res>  {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) _then) = _$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailureCopyWithImpl<$Res>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._self, this._then);

  final Failure _self;
  final $Res Function(Failure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CacheFailure value)?  cache,TResult Function( NetworkFailure value)?  network,TResult Function( ApiFailure value)?  api,TResult Function( PermissionFailure value)?  permission,TResult Function( PlatformFailure value)?  platform,TResult Function( ValidationFailure value)?  validation,TResult Function( SensorFailure value)?  sensor,TResult Function( CameraFailure value)?  camera,TResult Function( LockWindowFailure value)?  lockWindow,TResult Function( QuotaExceededFailure value)?  quotaExceeded,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CacheFailure() when cache != null:
return cache(_that);case NetworkFailure() when network != null:
return network(_that);case ApiFailure() when api != null:
return api(_that);case PermissionFailure() when permission != null:
return permission(_that);case PlatformFailure() when platform != null:
return platform(_that);case ValidationFailure() when validation != null:
return validation(_that);case SensorFailure() when sensor != null:
return sensor(_that);case CameraFailure() when camera != null:
return camera(_that);case LockWindowFailure() when lockWindow != null:
return lockWindow(_that);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CacheFailure value)  cache,required TResult Function( NetworkFailure value)  network,required TResult Function( ApiFailure value)  api,required TResult Function( PermissionFailure value)  permission,required TResult Function( PlatformFailure value)  platform,required TResult Function( ValidationFailure value)  validation,required TResult Function( SensorFailure value)  sensor,required TResult Function( CameraFailure value)  camera,required TResult Function( LockWindowFailure value)  lockWindow,required TResult Function( QuotaExceededFailure value)  quotaExceeded,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case CacheFailure():
return cache(_that);case NetworkFailure():
return network(_that);case ApiFailure():
return api(_that);case PermissionFailure():
return permission(_that);case PlatformFailure():
return platform(_that);case ValidationFailure():
return validation(_that);case SensorFailure():
return sensor(_that);case CameraFailure():
return camera(_that);case LockWindowFailure():
return lockWindow(_that);case QuotaExceededFailure():
return quotaExceeded(_that);case UnexpectedFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CacheFailure value)?  cache,TResult? Function( NetworkFailure value)?  network,TResult? Function( ApiFailure value)?  api,TResult? Function( PermissionFailure value)?  permission,TResult? Function( PlatformFailure value)?  platform,TResult? Function( ValidationFailure value)?  validation,TResult? Function( SensorFailure value)?  sensor,TResult? Function( CameraFailure value)?  camera,TResult? Function( LockWindowFailure value)?  lockWindow,TResult? Function( QuotaExceededFailure value)?  quotaExceeded,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case CacheFailure() when cache != null:
return cache(_that);case NetworkFailure() when network != null:
return network(_that);case ApiFailure() when api != null:
return api(_that);case PermissionFailure() when permission != null:
return permission(_that);case PlatformFailure() when platform != null:
return platform(_that);case ValidationFailure() when validation != null:
return validation(_that);case SensorFailure() when sensor != null:
return sensor(_that);case CameraFailure() when camera != null:
return camera(_that);case LockWindowFailure() when lockWindow != null:
return lockWindow(_that);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  cache,TResult Function( String message)?  network,TResult Function( String message,  int? statusCode)?  api,TResult Function( String message)?  permission,TResult Function( String message)?  platform,TResult Function( String message)?  validation,TResult Function( String message)?  sensor,TResult Function( String message)?  camera,TResult Function( String message)?  lockWindow,TResult Function( String message)?  quotaExceeded,TResult Function( String message)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CacheFailure() when cache != null:
return cache(_that.message);case NetworkFailure() when network != null:
return network(_that.message);case ApiFailure() when api != null:
return api(_that.message,_that.statusCode);case PermissionFailure() when permission != null:
return permission(_that.message);case PlatformFailure() when platform != null:
return platform(_that.message);case ValidationFailure() when validation != null:
return validation(_that.message);case SensorFailure() when sensor != null:
return sensor(_that.message);case CameraFailure() when camera != null:
return camera(_that.message);case LockWindowFailure() when lockWindow != null:
return lockWindow(_that.message);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  cache,required TResult Function( String message)  network,required TResult Function( String message,  int? statusCode)  api,required TResult Function( String message)  permission,required TResult Function( String message)  platform,required TResult Function( String message)  validation,required TResult Function( String message)  sensor,required TResult Function( String message)  camera,required TResult Function( String message)  lockWindow,required TResult Function( String message)  quotaExceeded,required TResult Function( String message)  unexpected,}) {final _that = this;
switch (_that) {
case CacheFailure():
return cache(_that.message);case NetworkFailure():
return network(_that.message);case ApiFailure():
return api(_that.message,_that.statusCode);case PermissionFailure():
return permission(_that.message);case PlatformFailure():
return platform(_that.message);case ValidationFailure():
return validation(_that.message);case SensorFailure():
return sensor(_that.message);case CameraFailure():
return camera(_that.message);case LockWindowFailure():
return lockWindow(_that.message);case QuotaExceededFailure():
return quotaExceeded(_that.message);case UnexpectedFailure():
return unexpected(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  cache,TResult? Function( String message)?  network,TResult? Function( String message,  int? statusCode)?  api,TResult? Function( String message)?  permission,TResult? Function( String message)?  platform,TResult? Function( String message)?  validation,TResult? Function( String message)?  sensor,TResult? Function( String message)?  camera,TResult? Function( String message)?  lockWindow,TResult? Function( String message)?  quotaExceeded,TResult? Function( String message)?  unexpected,}) {final _that = this;
switch (_that) {
case CacheFailure() when cache != null:
return cache(_that.message);case NetworkFailure() when network != null:
return network(_that.message);case ApiFailure() when api != null:
return api(_that.message,_that.statusCode);case PermissionFailure() when permission != null:
return permission(_that.message);case PlatformFailure() when platform != null:
return platform(_that.message);case ValidationFailure() when validation != null:
return validation(_that.message);case SensorFailure() when sensor != null:
return sensor(_that.message);case CameraFailure() when camera != null:
return camera(_that.message);case LockWindowFailure() when lockWindow != null:
return lockWindow(_that.message);case QuotaExceededFailure() when quotaExceeded != null:
return quotaExceeded(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CacheFailure implements Failure {
  const CacheFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheFailureCopyWith<CacheFailure> get copyWith => _$CacheFailureCopyWithImpl<CacheFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.cache(message: $message)';
}


}

/// @nodoc
abstract mixin class $CacheFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CacheFailureCopyWith(CacheFailure value, $Res Function(CacheFailure) _then) = _$CacheFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CacheFailureCopyWithImpl<$Res>
    implements $CacheFailureCopyWith<$Res> {
  _$CacheFailureCopyWithImpl(this._self, this._then);

  final CacheFailure _self;
  final $Res Function(CacheFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CacheFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NetworkFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ApiFailure implements Failure {
  const ApiFailure({required this.message, this.statusCode});
  

@override final  String message;
 final  int? statusCode;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiFailureCopyWith<ApiFailure> get copyWith => _$ApiFailureCopyWithImpl<ApiFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailure&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,statusCode);
}

@override
String toString() {
    return 'Failure.api(message: $message, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiFailureCopyWith(ApiFailure value, $Res Function(ApiFailure) _then) = _$ApiFailureCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode
});




}
/// @nodoc
class _$ApiFailureCopyWithImpl<$Res>
    implements $ApiFailureCopyWith<$Res> {
  _$ApiFailureCopyWithImpl(this._self, this._then);

  final ApiFailure _self;
  final $Res Function(ApiFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,}) {
  return _then(ApiFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class PermissionFailure implements Failure {
  const PermissionFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionFailureCopyWith<PermissionFailure> get copyWith => _$PermissionFailureCopyWithImpl<PermissionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.permission(message: $message)';
}


}

/// @nodoc
abstract mixin class $PermissionFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PermissionFailureCopyWith(PermissionFailure value, $Res Function(PermissionFailure) _then) = _$PermissionFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PermissionFailureCopyWithImpl<$Res>
    implements $PermissionFailureCopyWith<$Res> {
  _$PermissionFailureCopyWithImpl(this._self, this._then);

  final PermissionFailure _self;
  final $Res Function(PermissionFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PermissionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PlatformFailure implements Failure {
  const PlatformFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformFailureCopyWith<PlatformFailure> get copyWith => _$PlatformFailureCopyWithImpl<PlatformFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.platform(message: $message)';
}


}

/// @nodoc
abstract mixin class $PlatformFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $PlatformFailureCopyWith(PlatformFailure value, $Res Function(PlatformFailure) _then) = _$PlatformFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PlatformFailureCopyWithImpl<$Res>
    implements $PlatformFailureCopyWith<$Res> {
  _$PlatformFailureCopyWithImpl(this._self, this._then);

  final PlatformFailure _self;
  final $Res Function(PlatformFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PlatformFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidationFailure implements Failure {
  const ValidationFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.validation(message: $message)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ValidationFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SensorFailure implements Failure {
  const SensorFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SensorFailureCopyWith<SensorFailure> get copyWith => _$SensorFailureCopyWithImpl<SensorFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SensorFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.sensor(message: $message)';
}


}

/// @nodoc
abstract mixin class $SensorFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $SensorFailureCopyWith(SensorFailure value, $Res Function(SensorFailure) _then) = _$SensorFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SensorFailureCopyWithImpl<$Res>
    implements $SensorFailureCopyWith<$Res> {
  _$SensorFailureCopyWithImpl(this._self, this._then);

  final SensorFailure _self;
  final $Res Function(SensorFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SensorFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CameraFailure implements Failure {
  const CameraFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CameraFailureCopyWith<CameraFailure> get copyWith => _$CameraFailureCopyWithImpl<CameraFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CameraFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.camera(message: $message)';
}


}

/// @nodoc
abstract mixin class $CameraFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $CameraFailureCopyWith(CameraFailure value, $Res Function(CameraFailure) _then) = _$CameraFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CameraFailureCopyWithImpl<$Res>
    implements $CameraFailureCopyWith<$Res> {
  _$CameraFailureCopyWithImpl(this._self, this._then);

  final CameraFailure _self;
  final $Res Function(CameraFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CameraFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LockWindowFailure implements Failure {
  const LockWindowFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockWindowFailureCopyWith<LockWindowFailure> get copyWith => _$LockWindowFailureCopyWithImpl<LockWindowFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LockWindowFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.lockWindow(message: $message)';
}


}

/// @nodoc
abstract mixin class $LockWindowFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $LockWindowFailureCopyWith(LockWindowFailure value, $Res Function(LockWindowFailure) _then) = _$LockWindowFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LockWindowFailureCopyWithImpl<$Res>
    implements $LockWindowFailureCopyWith<$Res> {
  _$LockWindowFailureCopyWithImpl(this._self, this._then);

  final LockWindowFailure _self;
  final $Res Function(LockWindowFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LockWindowFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuotaExceededFailure implements Failure {
  const QuotaExceededFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotaExceededFailureCopyWith<QuotaExceededFailure> get copyWith => _$QuotaExceededFailureCopyWithImpl<QuotaExceededFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotaExceededFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.quotaExceeded(message: $message)';
}


}

/// @nodoc
abstract mixin class $QuotaExceededFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $QuotaExceededFailureCopyWith(QuotaExceededFailure value, $Res Function(QuotaExceededFailure) _then) = _$QuotaExceededFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$QuotaExceededFailureCopyWithImpl<$Res>
    implements $QuotaExceededFailureCopyWith<$Res> {
  _$QuotaExceededFailureCopyWithImpl(this._self, this._then);

  final QuotaExceededFailure _self;
  final $Res Function(QuotaExceededFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(QuotaExceededFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnexpectedFailure implements Failure {
  const UnexpectedFailure({required this.message});
  

@override final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'Failure.unexpected(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnexpectedFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
