import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_schedule_state.freezed.dart';

/// Immutable UI state for [PrayerScheduleCubit].
@freezed
sealed class PrayerScheduleState with _$PrayerScheduleState {
  const factory PrayerScheduleState.initial() = PrayerScheduleInitial;

  const factory PrayerScheduleState.loading() = PrayerScheduleLoading;

  const factory PrayerScheduleState.loaded({
    required FajrAlarmConfig config,
    required List<PrayerSchedule> schedules,
    required DateTime? nextAlarmTime,
    required bool isWithinLockWindow,
    Failure? actionFailure,
  }) = PrayerScheduleLoaded;

  const factory PrayerScheduleState.error({required Failure failure}) =
      PrayerScheduleError;
}
