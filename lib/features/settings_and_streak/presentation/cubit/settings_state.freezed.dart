// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 bool get isLoading; UserSettings get settings; StreakStats get streakStats; bool get isWithinLockWindow; Failure? get failure; DateTime? get dryRunScheduledAt;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&(identical(other.streakStats, _this.streakStats) || other.streakStats == _this.streakStats)&&(identical(other.isWithinLockWindow, _this.isWithinLockWindow) || other.isWithinLockWindow == _this.isWithinLockWindow)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.dryRunScheduledAt, _this.dryRunScheduledAt) || other.dryRunScheduledAt == _this.dryRunScheduledAt));
}


@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.isLoading,_this.settings,_this.streakStats,_this.isWithinLockWindow,_this.failure,_this.dryRunScheduledAt);
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(isLoading: ${_this.isLoading}, settings: ${_this.settings}, streakStats: ${_this.streakStats}, isWithinLockWindow: ${_this.isWithinLockWindow}, failure: ${_this.failure}, dryRunScheduledAt: ${_this.dryRunScheduledAt})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, UserSettings settings, StreakStats streakStats, bool isWithinLockWindow, Failure? failure, DateTime? dryRunScheduledAt
});


$UserSettingsCopyWith<$Res> get settings;$StreakStatsCopyWith<$Res> get streakStats;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? settings = null,Object? streakStats = null,Object? isWithinLockWindow = null,Object? failure = freezed,Object? dryRunScheduledAt = freezed,}) {
  return _then(SettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,streakStats: null == streakStats ? _self.streakStats : streakStats // ignore: cast_nullable_to_non_nullable
as StreakStats,isWithinLockWindow: null == isWithinLockWindow ? _self.isWithinLockWindow : isWithinLockWindow // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,dryRunScheduledAt: freezed == dryRunScheduledAt ? _self.dryRunScheduledAt : dryRunScheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get settings {
  
  return $UserSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakStatsCopyWith<$Res> get streakStats {
  
  return $StreakStatsCopyWith<$Res>(_self.streakStats, (value) {
    return _then(_self.copyWith(streakStats: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  UserSettings settings,  StreakStats streakStats,  bool isWithinLockWindow,  Failure? failure,  DateTime? dryRunScheduledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isLoading,_that.settings,_that.streakStats,_that.isWithinLockWindow,_that.failure,_that.dryRunScheduledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  UserSettings settings,  StreakStats streakStats,  bool isWithinLockWindow,  Failure? failure,  DateTime? dryRunScheduledAt)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.isLoading,_that.settings,_that.streakStats,_that.isWithinLockWindow,_that.failure,_that.dryRunScheduledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  UserSettings settings,  StreakStats streakStats,  bool isWithinLockWindow,  Failure? failure,  DateTime? dryRunScheduledAt)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.isLoading,_that.settings,_that.streakStats,_that.isWithinLockWindow,_that.failure,_that.dryRunScheduledAt);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.isLoading = false, this.settings = const UserSettings(), this.streakStats = const StreakStats(), this.isWithinLockWindow = false, this.failure, this.dryRunScheduledAt});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  UserSettings settings;
@override@JsonKey() final  StreakStats streakStats;
@override@JsonKey() final  bool isWithinLockWindow;
@override final  Failure? failure;
@override final  DateTime? dryRunScheduledAt;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.streakStats, streakStats) || other.streakStats == streakStats)&&(identical(other.isWithinLockWindow, isWithinLockWindow) || other.isWithinLockWindow == isWithinLockWindow)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.dryRunScheduledAt, dryRunScheduledAt) || other.dryRunScheduledAt == dryRunScheduledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,settings,streakStats,isWithinLockWindow,failure,dryRunScheduledAt);
}

@override
String toString() {
    return 'SettingsState(isLoading: $isLoading, settings: $settings, streakStats: $streakStats, isWithinLockWindow: $isWithinLockWindow, failure: $failure, dryRunScheduledAt: $dryRunScheduledAt)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, UserSettings settings, StreakStats streakStats, bool isWithinLockWindow, Failure? failure, DateTime? dryRunScheduledAt
});


@override $UserSettingsCopyWith<$Res> get settings;@override $StreakStatsCopyWith<$Res> get streakStats;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? settings = null,Object? streakStats = null,Object? isWithinLockWindow = null,Object? failure = freezed,Object? dryRunScheduledAt = freezed,}) {
  return _then(_SettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,streakStats: null == streakStats ? _self.streakStats : streakStats // ignore: cast_nullable_to_non_nullable
as StreakStats,isWithinLockWindow: null == isWithinLockWindow ? _self.isWithinLockWindow : isWithinLockWindow // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,dryRunScheduledAt: freezed == dryRunScheduledAt ? _self.dryRunScheduledAt : dryRunScheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get settings {
  
  return $UserSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StreakStatsCopyWith<$Res> get streakStats {
  
  return $StreakStatsCopyWith<$Res>(_self.streakStats, (value) {
    return _then(_self.copyWith(streakStats: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
