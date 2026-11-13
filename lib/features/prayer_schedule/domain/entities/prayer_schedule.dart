import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_schedule.freezed.dart';

/// Immutable domain entity representing a single day's calculated Fajr schedule.
@freezed
sealed class PrayerSchedule with _$PrayerSchedule {
  const factory PrayerSchedule({
    required DateTime date,
    required DateTime fajrTime,
    required DateTime sunriseTime,
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required String madhab,
  }) = _PrayerSchedule;
}
