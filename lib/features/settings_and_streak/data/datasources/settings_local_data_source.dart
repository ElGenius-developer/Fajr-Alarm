import 'package:hive_ce/hive.dart';

import '../../domain/entities/streak_stats.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/entities/vacation_mode_config.dart';

/// Hive type IDs reserved for the settings_and_streak feature.
abstract final class SettingsHiveTypeIds {
  static const int userSettings = 10;
  static const int streakStats = 11;
  static const int vacationModeConfig = 12;
}

/// Registers explicit typed Hive adapters for settings & streak entities.
void registerSettingsAdapters(HiveInterface hive) {
  if (!hive.isAdapterRegistered(SettingsHiveTypeIds.vacationModeConfig)) {
    hive.registerAdapter<VacationModeConfig>(VacationModeConfigAdapter());
  }
  if (!hive.isAdapterRegistered(SettingsHiveTypeIds.userSettings)) {
    hive.registerAdapter<UserSettings>(UserSettingsAdapter());
  }
  if (!hive.isAdapterRegistered(SettingsHiveTypeIds.streakStats)) {
    hive.registerAdapter<StreakStats>(StreakStatsAdapter());
  }
}

/// Explicit strongly-typed [TypeAdapter] for [VacationModeConfig] (zero `dynamic`).
class VacationModeConfigAdapter extends TypeAdapter<VacationModeConfig> {
  @override
  final int typeId = SettingsHiveTypeIds.vacationModeConfig;

  @override
  VacationModeConfig read(BinaryReader reader) {
    final startMillis = reader.readInt();
    final durationDays = reader.readInt();
    final endMillis = reader.readInt();
    return VacationModeConfig(
      startDate: DateTime.fromMillisecondsSinceEpoch(startMillis),
      durationDays: durationDays,
      endDate: DateTime.fromMillisecondsSinceEpoch(endMillis),
    );
  }

  @override
  void write(BinaryWriter writer, VacationModeConfig obj) {
    writer
      ..writeInt(obj.startDate.millisecondsSinceEpoch)
      ..writeInt(obj.durationDays)
      ..writeInt(obj.endDate.millisecondsSinceEpoch);
  }
}

/// Explicit strongly-typed [TypeAdapter] for [UserSettings] (zero `dynamic`).
class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = SettingsHiveTypeIds.userSettings;

  final VacationModeConfigAdapter _vacationAdapter =
      VacationModeConfigAdapter();

  @override
  UserSettings read(BinaryReader reader) {
    final locale = reader.readString();
    final monthlyEmergencyQuota = reader.readInt();
    final emergencyQuotaUsed = reader.readInt();
    final emergencyQuotaResetMonth = reader.readInt();
    final hasBarcode = reader.readBool();
    final bathroomBarcode = hasBarcode ? reader.readString() : null;
    final alarmOffsetMinutes = reader.readInt();
    final hasManualHour = reader.readBool();
    final manualAlarmHour = hasManualHour ? reader.readInt() : null;
    final hasManualMinute = reader.readBool();
    final manualAlarmMinute = hasManualMinute ? reader.readInt() : null;
    final hasVacation = reader.readBool();
    final vacationMode = hasVacation ? _vacationAdapter.read(reader) : null;

    return UserSettings(
      locale: locale,
      monthlyEmergencyQuota: monthlyEmergencyQuota,
      emergencyQuotaUsed: emergencyQuotaUsed,
      emergencyQuotaResetMonth: emergencyQuotaResetMonth,
      bathroomBarcode: bathroomBarcode,
      alarmOffsetMinutes: alarmOffsetMinutes,
      manualAlarmHour: manualAlarmHour,
      manualAlarmMinute: manualAlarmMinute,
      vacationMode: vacationMode,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeString(obj.locale)
      ..writeInt(obj.monthlyEmergencyQuota)
      ..writeInt(obj.emergencyQuotaUsed)
      ..writeInt(obj.emergencyQuotaResetMonth)
      ..writeBool(obj.bathroomBarcode != null);
    if (obj.bathroomBarcode != null) {
      writer.writeString(obj.bathroomBarcode!);
    }
    writer
      ..writeInt(obj.alarmOffsetMinutes)
      ..writeBool(obj.manualAlarmHour != null);
    if (obj.manualAlarmHour != null) {
      writer.writeInt(obj.manualAlarmHour!);
    }
    writer.writeBool(obj.manualAlarmMinute != null);
    if (obj.manualAlarmMinute != null) {
      writer.writeInt(obj.manualAlarmMinute!);
    }
    writer.writeBool(obj.vacationMode != null);
    if (obj.vacationMode != null) {
      _vacationAdapter.write(writer, obj.vacationMode!);
    }
  }
}

/// Explicit strongly-typed [TypeAdapter] for [StreakStats] (zero `dynamic`).
class StreakStatsAdapter extends TypeAdapter<StreakStats> {
  @override
  final int typeId = SettingsHiveTypeIds.streakStats;

  @override
  StreakStats read(BinaryReader reader) {
    final currentStreak = reader.readInt();
    final longestStreak = reader.readInt();
    final totalAlarms = reader.readInt();
    final completedAlarms = reader.readInt();
    final totalTimeToWakeSeconds = reader.readInt();
    final isFrozen = reader.readBool();
    final hasLastDate = reader.readBool();
    final lastCompletedDate = hasLastDate
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
        : null;

    return StreakStats(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalAlarms: totalAlarms,
      completedAlarms: completedAlarms,
      totalTimeToWakeSeconds: totalTimeToWakeSeconds,
      isFrozen: isFrozen,
      lastCompletedDate: lastCompletedDate,
    );
  }

  @override
  void write(BinaryWriter writer, StreakStats obj) {
    writer
      ..writeInt(obj.currentStreak)
      ..writeInt(obj.longestStreak)
      ..writeInt(obj.totalAlarms)
      ..writeInt(obj.completedAlarms)
      ..writeInt(obj.totalTimeToWakeSeconds)
      ..writeBool(obj.isFrozen)
      ..writeBool(obj.lastCompletedDate != null);
    if (obj.lastCompletedDate != null) {
      writer.writeInt(obj.lastCompletedDate!.millisecondsSinceEpoch);
    }
  }
}

/// Local storage contract for [UserSettings] and [StreakStats].
abstract interface class SettingsLocalDataSource {
  Future<UserSettings> getSettings();

  Future<UserSettings> saveSettings(UserSettings settings);

  Future<StreakStats> getStreakStats();

  Future<StreakStats> saveStreakStats(StreakStats stats);
}

/// Hive CE implementation of [SettingsLocalDataSource].
class HiveSettingsLocalDataSource implements SettingsLocalDataSource {
  HiveSettingsLocalDataSource({
    required this._settingsBox,
    required this._streakBox,
  });

  static const String settingsBoxName = 'user_settings_box';
  static const String streakBoxName = 'streak_stats_box';
  static const String _settingsKey = 'current_settings';
  static const String _streakKey = 'current_streak';

  final Box<UserSettings> _settingsBox;
  final Box<StreakStats> _streakBox;

  @override
  Future<UserSettings> getSettings() async {
    return _settingsBox.get(_settingsKey) ?? const UserSettings();
  }

  @override
  Future<UserSettings> saveSettings(UserSettings settings) async {
    await _settingsBox.put(_settingsKey, settings);
    return settings;
  }

  @override
  Future<StreakStats> getStreakStats() async {
    return _streakBox.get(_streakKey) ?? const StreakStats();
  }

  @override
  Future<StreakStats> saveStreakStats(StreakStats stats) async {
    await _streakBox.put(_streakKey, stats);
    return stats;
  }
}
