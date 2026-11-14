// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StreakStats {

 int get currentStreak; int get longestStreak; int get totalAlarms; int get completedAlarms; int get totalTimeToWakeSeconds; bool get isFrozen; DateTime? get lastCompletedDate;
/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakStatsCopyWith<StreakStats> get copyWith => _$StreakStatsCopyWithImpl<StreakStats>(this as StreakStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StreakStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakStats&&(identical(other.currentStreak, _this.currentStreak) || other.currentStreak == _this.currentStreak)&&(identical(other.longestStreak, _this.longestStreak) || other.longestStreak == _this.longestStreak)&&(identical(other.totalAlarms, _this.totalAlarms) || other.totalAlarms == _this.totalAlarms)&&(identical(other.completedAlarms, _this.completedAlarms) || other.completedAlarms == _this.completedAlarms)&&(identical(other.totalTimeToWakeSeconds, _this.totalTimeToWakeSeconds) || other.totalTimeToWakeSeconds == _this.totalTimeToWakeSeconds)&&(identical(other.isFrozen, _this.isFrozen) || other.isFrozen == _this.isFrozen)&&(identical(other.lastCompletedDate, _this.lastCompletedDate) || other.lastCompletedDate == _this.lastCompletedDate));
}


@override
int get hashCode {
  final _this = this as StreakStats;
  return Object.hash(runtimeType,_this.currentStreak,_this.longestStreak,_this.totalAlarms,_this.completedAlarms,_this.totalTimeToWakeSeconds,_this.isFrozen,_this.lastCompletedDate);
}

@override
String toString() {
  final _this = this as StreakStats;
  return 'StreakStats(currentStreak: ${_this.currentStreak}, longestStreak: ${_this.longestStreak}, totalAlarms: ${_this.totalAlarms}, completedAlarms: ${_this.completedAlarms}, totalTimeToWakeSeconds: ${_this.totalTimeToWakeSeconds}, isFrozen: ${_this.isFrozen}, lastCompletedDate: ${_this.lastCompletedDate})';
}


}

/// @nodoc
abstract mixin class $StreakStatsCopyWith<$Res>  {
  factory $StreakStatsCopyWith(StreakStats value, $Res Function(StreakStats) _then) = _$StreakStatsCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int longestStreak, int totalAlarms, int completedAlarms, int totalTimeToWakeSeconds, bool isFrozen, DateTime? lastCompletedDate
});




}
/// @nodoc
class _$StreakStatsCopyWithImpl<$Res>
    implements $StreakStatsCopyWith<$Res> {
  _$StreakStatsCopyWithImpl(this._self, this._then);

  final StreakStats _self;
  final $Res Function(StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? totalAlarms = null,Object? completedAlarms = null,Object? totalTimeToWakeSeconds = null,Object? isFrozen = null,Object? lastCompletedDate = freezed,}) {
  return _then(StreakStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalAlarms: null == totalAlarms ? _self.totalAlarms : totalAlarms // ignore: cast_nullable_to_non_nullable
as int,completedAlarms: null == completedAlarms ? _self.completedAlarms : completedAlarms // ignore: cast_nullable_to_non_nullable
as int,totalTimeToWakeSeconds: null == totalTimeToWakeSeconds ? _self.totalTimeToWakeSeconds : totalTimeToWakeSeconds // ignore: cast_nullable_to_non_nullable
as int,isFrozen: null == isFrozen ? _self.isFrozen : isFrozen // ignore: cast_nullable_to_non_nullable
as bool,lastCompletedDate: freezed == lastCompletedDate ? _self.lastCompletedDate : lastCompletedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakStats].
extension StreakStatsPatterns on StreakStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakStats value)  $default,){
final _that = this;
switch (_that) {
case _StreakStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakStats value)?  $default,){
final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int totalAlarms,  int completedAlarms,  int totalTimeToWakeSeconds,  bool isFrozen,  DateTime? lastCompletedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.totalAlarms,_that.completedAlarms,_that.totalTimeToWakeSeconds,_that.isFrozen,_that.lastCompletedDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  int totalAlarms,  int completedAlarms,  int totalTimeToWakeSeconds,  bool isFrozen,  DateTime? lastCompletedDate)  $default,) {final _that = this;
switch (_that) {
case _StreakStats():
return $default(_that.currentStreak,_that.longestStreak,_that.totalAlarms,_that.completedAlarms,_that.totalTimeToWakeSeconds,_that.isFrozen,_that.lastCompletedDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int longestStreak,  int totalAlarms,  int completedAlarms,  int totalTimeToWakeSeconds,  bool isFrozen,  DateTime? lastCompletedDate)?  $default,) {final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.totalAlarms,_that.completedAlarms,_that.totalTimeToWakeSeconds,_that.isFrozen,_that.lastCompletedDate);case _:
  return null;

}
}

}

/// @nodoc


class _StreakStats extends StreakStats {
  const _StreakStats({this.currentStreak = 0, this.longestStreak = 0, this.totalAlarms = 0, this.completedAlarms = 0, this.totalTimeToWakeSeconds = 0, this.isFrozen = false, this.lastCompletedDate}): super._();
  

@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  int totalAlarms;
@override@JsonKey() final  int completedAlarms;
@override@JsonKey() final  int totalTimeToWakeSeconds;
@override@JsonKey() final  bool isFrozen;
@override final  DateTime? lastCompletedDate;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakStatsCopyWith<_StreakStats> get copyWith => __$StreakStatsCopyWithImpl<_StreakStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakStats&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalAlarms, totalAlarms) || other.totalAlarms == totalAlarms)&&(identical(other.completedAlarms, completedAlarms) || other.completedAlarms == completedAlarms)&&(identical(other.totalTimeToWakeSeconds, totalTimeToWakeSeconds) || other.totalTimeToWakeSeconds == totalTimeToWakeSeconds)&&(identical(other.isFrozen, isFrozen) || other.isFrozen == isFrozen)&&(identical(other.lastCompletedDate, lastCompletedDate) || other.lastCompletedDate == lastCompletedDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentStreak,longestStreak,totalAlarms,completedAlarms,totalTimeToWakeSeconds,isFrozen,lastCompletedDate);
}

@override
String toString() {
    return 'StreakStats(currentStreak: $currentStreak, longestStreak: $longestStreak, totalAlarms: $totalAlarms, completedAlarms: $completedAlarms, totalTimeToWakeSeconds: $totalTimeToWakeSeconds, isFrozen: $isFrozen, lastCompletedDate: $lastCompletedDate)';
}


}

/// @nodoc
abstract mixin class _$StreakStatsCopyWith<$Res> implements $StreakStatsCopyWith<$Res> {
  factory _$StreakStatsCopyWith(_StreakStats value, $Res Function(_StreakStats) _then) = __$StreakStatsCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int longestStreak, int totalAlarms, int completedAlarms, int totalTimeToWakeSeconds, bool isFrozen, DateTime? lastCompletedDate
});




}
/// @nodoc
class __$StreakStatsCopyWithImpl<$Res>
    implements _$StreakStatsCopyWith<$Res> {
  __$StreakStatsCopyWithImpl(this._self, this._then);

  final _StreakStats _self;
  final $Res Function(_StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? totalAlarms = null,Object? completedAlarms = null,Object? totalTimeToWakeSeconds = null,Object? isFrozen = null,Object? lastCompletedDate = freezed,}) {
  return _then(_StreakStats(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalAlarms: null == totalAlarms ? _self.totalAlarms : totalAlarms // ignore: cast_nullable_to_non_nullable
as int,completedAlarms: null == completedAlarms ? _self.completedAlarms : completedAlarms // ignore: cast_nullable_to_non_nullable
as int,totalTimeToWakeSeconds: null == totalTimeToWakeSeconds ? _self.totalTimeToWakeSeconds : totalTimeToWakeSeconds // ignore: cast_nullable_to_non_nullable
as int,isFrozen: null == isFrozen ? _self.isFrozen : isFrozen // ignore: cast_nullable_to_non_nullable
as bool,lastCompletedDate: freezed == lastCompletedDate ? _self.lastCompletedDate : lastCompletedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
