// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrayerScheduleState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerScheduleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PrayerScheduleState()';
}


}

/// @nodoc
class $PrayerScheduleStateCopyWith<$Res>  {
$PrayerScheduleStateCopyWith(PrayerScheduleState _, $Res Function(PrayerScheduleState) __);
}


/// Adds pattern-matching-related methods to [PrayerScheduleState].
extension PrayerScheduleStatePatterns on PrayerScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PrayerScheduleInitial value)?  initial,TResult Function( PrayerScheduleLoading value)?  loading,TResult Function( PrayerScheduleLoaded value)?  loaded,TResult Function( PrayerScheduleError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PrayerScheduleInitial() when initial != null:
return initial(_that);case PrayerScheduleLoading() when loading != null:
return loading(_that);case PrayerScheduleLoaded() when loaded != null:
return loaded(_that);case PrayerScheduleError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PrayerScheduleInitial value)  initial,required TResult Function( PrayerScheduleLoading value)  loading,required TResult Function( PrayerScheduleLoaded value)  loaded,required TResult Function( PrayerScheduleError value)  error,}){
final _that = this;
switch (_that) {
case PrayerScheduleInitial():
return initial(_that);case PrayerScheduleLoading():
return loading(_that);case PrayerScheduleLoaded():
return loaded(_that);case PrayerScheduleError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PrayerScheduleInitial value)?  initial,TResult? Function( PrayerScheduleLoading value)?  loading,TResult? Function( PrayerScheduleLoaded value)?  loaded,TResult? Function( PrayerScheduleError value)?  error,}){
final _that = this;
switch (_that) {
case PrayerScheduleInitial() when initial != null:
return initial(_that);case PrayerScheduleLoading() when loading != null:
return loading(_that);case PrayerScheduleLoaded() when loaded != null:
return loaded(_that);case PrayerScheduleError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( FajrAlarmConfig config,  List<PrayerSchedule> schedules,  DateTime? nextAlarmTime,  bool isWithinLockWindow,  Failure? actionFailure)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PrayerScheduleInitial() when initial != null:
return initial();case PrayerScheduleLoading() when loading != null:
return loading();case PrayerScheduleLoaded() when loaded != null:
return loaded(_that.config,_that.schedules,_that.nextAlarmTime,_that.isWithinLockWindow,_that.actionFailure);case PrayerScheduleError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( FajrAlarmConfig config,  List<PrayerSchedule> schedules,  DateTime? nextAlarmTime,  bool isWithinLockWindow,  Failure? actionFailure)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case PrayerScheduleInitial():
return initial();case PrayerScheduleLoading():
return loading();case PrayerScheduleLoaded():
return loaded(_that.config,_that.schedules,_that.nextAlarmTime,_that.isWithinLockWindow,_that.actionFailure);case PrayerScheduleError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( FajrAlarmConfig config,  List<PrayerSchedule> schedules,  DateTime? nextAlarmTime,  bool isWithinLockWindow,  Failure? actionFailure)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case PrayerScheduleInitial() when initial != null:
return initial();case PrayerScheduleLoading() when loading != null:
return loading();case PrayerScheduleLoaded() when loaded != null:
return loaded(_that.config,_that.schedules,_that.nextAlarmTime,_that.isWithinLockWindow,_that.actionFailure);case PrayerScheduleError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PrayerScheduleInitial implements PrayerScheduleState {
  const PrayerScheduleInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerScheduleInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PrayerScheduleState.initial()';
}


}




/// @nodoc


class PrayerScheduleLoading implements PrayerScheduleState {
  const PrayerScheduleLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerScheduleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PrayerScheduleState.loading()';
}


}




/// @nodoc


class PrayerScheduleLoaded implements PrayerScheduleState {
  const PrayerScheduleLoaded({required this.config, required  List<PrayerSchedule> schedules, required this.nextAlarmTime, required this.isWithinLockWindow, this.actionFailure}): _schedules = schedules;
  

 final  FajrAlarmConfig config;
 final  List<PrayerSchedule> _schedules;
 List<PrayerSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

 final  DateTime? nextAlarmTime;
 final  bool isWithinLockWindow;
 final  Failure? actionFailure;

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerScheduleLoadedCopyWith<PrayerScheduleLoaded> get copyWith => _$PrayerScheduleLoadedCopyWithImpl<PrayerScheduleLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerScheduleLoaded&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.schedules, _schedules)&&(identical(other.nextAlarmTime, nextAlarmTime) || other.nextAlarmTime == nextAlarmTime)&&(identical(other.isWithinLockWindow, isWithinLockWindow) || other.isWithinLockWindow == isWithinLockWindow)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,config,const DeepCollectionEquality().hash(_schedules),nextAlarmTime,isWithinLockWindow,actionFailure);
}

@override
String toString() {
    return 'PrayerScheduleState.loaded(config: $config, schedules: $schedules, nextAlarmTime: $nextAlarmTime, isWithinLockWindow: $isWithinLockWindow, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class $PrayerScheduleLoadedCopyWith<$Res> implements $PrayerScheduleStateCopyWith<$Res> {
  factory $PrayerScheduleLoadedCopyWith(PrayerScheduleLoaded value, $Res Function(PrayerScheduleLoaded) _then) = _$PrayerScheduleLoadedCopyWithImpl;
@useResult
$Res call({
 FajrAlarmConfig config, List<PrayerSchedule> schedules, DateTime? nextAlarmTime, bool isWithinLockWindow, Failure? actionFailure
});


$FajrAlarmConfigCopyWith<$Res> get config;$FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class _$PrayerScheduleLoadedCopyWithImpl<$Res>
    implements $PrayerScheduleLoadedCopyWith<$Res> {
  _$PrayerScheduleLoadedCopyWithImpl(this._self, this._then);

  final PrayerScheduleLoaded _self;
  final $Res Function(PrayerScheduleLoaded) _then;

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? config = null,Object? schedules = null,Object? nextAlarmTime = freezed,Object? isWithinLockWindow = null,Object? actionFailure = freezed,}) {
  return _then(PrayerScheduleLoaded(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FajrAlarmConfig,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<PrayerSchedule>,nextAlarmTime: freezed == nextAlarmTime ? _self.nextAlarmTime : nextAlarmTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isWithinLockWindow: null == isWithinLockWindow ? _self.isWithinLockWindow : isWithinLockWindow // ignore: cast_nullable_to_non_nullable
as bool,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FajrAlarmConfigCopyWith<$Res> get config {
  
  return $FajrAlarmConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get actionFailure {
    if (_self.actionFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.actionFailure!, (value) {
    return _then(_self.copyWith(actionFailure: value));
  });
}
}

/// @nodoc


class PrayerScheduleError implements PrayerScheduleState {
  const PrayerScheduleError({required this.failure});
  

 final  Failure failure;

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrayerScheduleErrorCopyWith<PrayerScheduleError> get copyWith => _$PrayerScheduleErrorCopyWithImpl<PrayerScheduleError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PrayerScheduleError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'PrayerScheduleState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PrayerScheduleErrorCopyWith<$Res> implements $PrayerScheduleStateCopyWith<$Res> {
  factory $PrayerScheduleErrorCopyWith(PrayerScheduleError value, $Res Function(PrayerScheduleError) _then) = _$PrayerScheduleErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PrayerScheduleErrorCopyWithImpl<$Res>
    implements $PrayerScheduleErrorCopyWith<$Res> {
  _$PrayerScheduleErrorCopyWithImpl(this._self, this._then);

  final PrayerScheduleError _self;
  final $Res Function(PrayerScheduleError) _then;

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PrayerScheduleError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PrayerScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
