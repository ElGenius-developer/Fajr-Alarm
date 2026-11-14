// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tilt_angle_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TiltAngleReading {

 double get pitchDegrees; bool get isWithinStandingRange;
/// Create a copy of TiltAngleReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TiltAngleReadingCopyWith<TiltAngleReading> get copyWith => _$TiltAngleReadingCopyWithImpl<TiltAngleReading>(this as TiltAngleReading, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TiltAngleReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TiltAngleReading&&(identical(other.pitchDegrees, _this.pitchDegrees) || other.pitchDegrees == _this.pitchDegrees)&&(identical(other.isWithinStandingRange, _this.isWithinStandingRange) || other.isWithinStandingRange == _this.isWithinStandingRange));
}


@override
int get hashCode {
  final _this = this as TiltAngleReading;
  return Object.hash(runtimeType,_this.pitchDegrees,_this.isWithinStandingRange);
}

@override
String toString() {
  final _this = this as TiltAngleReading;
  return 'TiltAngleReading(pitchDegrees: ${_this.pitchDegrees}, isWithinStandingRange: ${_this.isWithinStandingRange})';
}


}

/// @nodoc
abstract mixin class $TiltAngleReadingCopyWith<$Res>  {
  factory $TiltAngleReadingCopyWith(TiltAngleReading value, $Res Function(TiltAngleReading) _then) = _$TiltAngleReadingCopyWithImpl;
@useResult
$Res call({
 double pitchDegrees, bool isWithinStandingRange
});




}
/// @nodoc
class _$TiltAngleReadingCopyWithImpl<$Res>
    implements $TiltAngleReadingCopyWith<$Res> {
  _$TiltAngleReadingCopyWithImpl(this._self, this._then);

  final TiltAngleReading _self;
  final $Res Function(TiltAngleReading) _then;

/// Create a copy of TiltAngleReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pitchDegrees = null,Object? isWithinStandingRange = null,}) {
  return _then(TiltAngleReading(
pitchDegrees: null == pitchDegrees ? _self.pitchDegrees : pitchDegrees // ignore: cast_nullable_to_non_nullable
as double,isWithinStandingRange: null == isWithinStandingRange ? _self.isWithinStandingRange : isWithinStandingRange // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TiltAngleReading].
extension TiltAngleReadingPatterns on TiltAngleReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TiltAngleReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TiltAngleReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TiltAngleReading value)  $default,){
final _that = this;
switch (_that) {
case _TiltAngleReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TiltAngleReading value)?  $default,){
final _that = this;
switch (_that) {
case _TiltAngleReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double pitchDegrees,  bool isWithinStandingRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TiltAngleReading() when $default != null:
return $default(_that.pitchDegrees,_that.isWithinStandingRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double pitchDegrees,  bool isWithinStandingRange)  $default,) {final _that = this;
switch (_that) {
case _TiltAngleReading():
return $default(_that.pitchDegrees,_that.isWithinStandingRange);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double pitchDegrees,  bool isWithinStandingRange)?  $default,) {final _that = this;
switch (_that) {
case _TiltAngleReading() when $default != null:
return $default(_that.pitchDegrees,_that.isWithinStandingRange);case _:
  return null;

}
}

}

/// @nodoc


class _TiltAngleReading extends TiltAngleReading {
  const _TiltAngleReading({required this.pitchDegrees, required this.isWithinStandingRange}): super._();
  

@override final  double pitchDegrees;
@override final  bool isWithinStandingRange;

/// Create a copy of TiltAngleReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TiltAngleReadingCopyWith<_TiltAngleReading> get copyWith => __$TiltAngleReadingCopyWithImpl<_TiltAngleReading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TiltAngleReading&&(identical(other.pitchDegrees, pitchDegrees) || other.pitchDegrees == pitchDegrees)&&(identical(other.isWithinStandingRange, isWithinStandingRange) || other.isWithinStandingRange == isWithinStandingRange));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pitchDegrees,isWithinStandingRange);
}

@override
String toString() {
    return 'TiltAngleReading(pitchDegrees: $pitchDegrees, isWithinStandingRange: $isWithinStandingRange)';
}


}

/// @nodoc
abstract mixin class _$TiltAngleReadingCopyWith<$Res> implements $TiltAngleReadingCopyWith<$Res> {
  factory _$TiltAngleReadingCopyWith(_TiltAngleReading value, $Res Function(_TiltAngleReading) _then) = __$TiltAngleReadingCopyWithImpl;
@override @useResult
$Res call({
 double pitchDegrees, bool isWithinStandingRange
});




}
/// @nodoc
class __$TiltAngleReadingCopyWithImpl<$Res>
    implements _$TiltAngleReadingCopyWith<$Res> {
  __$TiltAngleReadingCopyWithImpl(this._self, this._then);

  final _TiltAngleReading _self;
  final $Res Function(_TiltAngleReading) _then;

/// Create a copy of TiltAngleReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pitchDegrees = null,Object? isWithinStandingRange = null,}) {
  return _then(_TiltAngleReading(
pitchDegrees: null == pitchDegrees ? _self.pitchDegrees : pitchDegrees // ignore: cast_nullable_to_non_nullable
as double,isWithinStandingRange: null == isWithinStandingRange ? _self.isWithinStandingRange : isWithinStandingRange // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
