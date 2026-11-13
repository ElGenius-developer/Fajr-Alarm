import 'package:freezed_annotation/freezed_annotation.dart';

part 'fajr_alarm_config.freezed.dart';

/// Supported astronomical calculation methods for Fajr prayer time.
enum FajrCalculationMethod {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  moonSightingCommittee,
  northAmerica,
  kuwait,
  qatar,
  singapore,
  tehran,
  turkey,
}

/// Juristic school for prayer time calculation.
enum FajrMadhab { shafi, hanafi }

/// Whether the alarm fires relative to Fajr Adhan or at a fixed manual time.
enum FajrAlarmMode { relativeToAdhan, manualTime }

/// Direction of offset relative to Fajr Adhan.
enum FajrOffsetDirection { before, at, after }

/// Immutable user configuration for Fajr alarm scheduling.
@freezed
sealed class FajrAlarmConfig with _$FajrAlarmConfig {
  const factory FajrAlarmConfig({
    required double latitude,
    required double longitude,
    String? cityName,
    @Default(FajrCalculationMethod.egyptian)
    FajrCalculationMethod calculationMethod,
    @Default(FajrMadhab.shafi) FajrMadhab madhab,
    @Default(FajrAlarmMode.relativeToAdhan) FajrAlarmMode mode,
    @Default(FajrOffsetDirection.at) FajrOffsetDirection offsetDirection,
    @Default(0) int offsetMinutes,
    @Default(4) int manualHour,
    @Default(30) int manualMinute,
    @Default(true) bool isEnabled,
  }) = _FajrAlarmConfig;
}
