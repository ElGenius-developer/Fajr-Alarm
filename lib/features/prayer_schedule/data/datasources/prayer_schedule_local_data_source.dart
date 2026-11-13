import 'package:fajr_alarm/features/prayer_schedule/data/models/fajr_alarm_config_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/prayer_schedule_hive_model.dart';
import 'package:hive_ce/hive.dart';

/// Local persistence contract for the 30-day rolling Fajr schedule and config.
abstract interface class PrayerScheduleLocalDataSource {
  Future<List<PrayerScheduleHiveModel>> get30DaySchedule();
  Future<void> save30DaySchedule(List<PrayerScheduleHiveModel> schedules);
  Future<FajrAlarmConfigHiveModel?> getAlarmConfig();
  Future<void> saveAlarmConfig(FajrAlarmConfigHiveModel config);
  Future<DateTime?> getNextScheduledAlarm();
  Future<void> saveNextScheduledAlarm(DateTime? alarmTime);
}

/// `hive_ce` implementation using explicit [TypeAdapter]s and strongly-typed boxes.
class PrayerScheduleLocalDataSourceImpl
    implements PrayerScheduleLocalDataSource {
  PrayerScheduleLocalDataSourceImpl(this._hive);

  static const String scheduleBoxName = 'prayer_schedule_30d_box';
  static const String configBoxName = 'fajr_alarm_config_box';
  static const String metaBoxName = 'prayer_schedule_meta_box';

  static const String _configKey = 'current_config';
  static const String _nextAlarmKey = 'next_scheduled_alarm_ms';

  final HiveInterface _hive;

  void _ensureAdaptersRegistered() {
    if (!_hive.isAdapterRegistered(PrayerScheduleHiveAdapter.adapterTypeId)) {
      _hive.registerAdapter(const PrayerScheduleHiveAdapter());
    }
    if (!_hive.isAdapterRegistered(FajrAlarmConfigHiveAdapter.adapterTypeId)) {
      _hive.registerAdapter(const FajrAlarmConfigHiveAdapter());
    }
  }

  Future<Box<PrayerScheduleHiveModel>> _openScheduleBox() async {
    _ensureAdaptersRegistered();
    if (_hive.isBoxOpen(scheduleBoxName)) {
      return _hive.box<PrayerScheduleHiveModel>(scheduleBoxName);
    }
    return _hive.openBox<PrayerScheduleHiveModel>(scheduleBoxName);
  }

  Future<Box<FajrAlarmConfigHiveModel>> _openConfigBox() async {
    _ensureAdaptersRegistered();
    if (_hive.isBoxOpen(configBoxName)) {
      return _hive.box<FajrAlarmConfigHiveModel>(configBoxName);
    }
    return _hive.openBox<FajrAlarmConfigHiveModel>(configBoxName);
  }

  Future<Box<int>> _openMetaBox() async {
    if (_hive.isBoxOpen(metaBoxName)) {
      return _hive.box<int>(metaBoxName);
    }
    return _hive.openBox<int>(metaBoxName);
  }

  @override
  Future<List<PrayerScheduleHiveModel>> get30DaySchedule() async {
    final box = await _openScheduleBox();
    final items = box.values.toList(growable: false)
      ..sort((a, b) => a.dateMillis.compareTo(b.dateMillis));
    return items;
  }

  @override
  Future<void> save30DaySchedule(
    List<PrayerScheduleHiveModel> schedules,
  ) async {
    final box = await _openScheduleBox();
    await box.clear();
    final entries = <String, PrayerScheduleHiveModel>{};
    for (var i = 0; i < schedules.length; i++) {
      entries['day_$i'] = schedules[i];
    }
    await box.putAll(entries);
  }

  @override
  Future<FajrAlarmConfigHiveModel?> getAlarmConfig() async {
    final box = await _openConfigBox();
    return box.get(_configKey);
  }

  @override
  Future<void> saveAlarmConfig(FajrAlarmConfigHiveModel config) async {
    final box = await _openConfigBox();
    await box.put(_configKey, config);
  }

  @override
  Future<DateTime?> getNextScheduledAlarm() async {
    final box = await _openMetaBox();
    final millis = box.get(_nextAlarmKey);
    if (millis == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> saveNextScheduledAlarm(DateTime? alarmTime) async {
    final box = await _openMetaBox();
    if (alarmTime == null) {
      await box.delete(_nextAlarmKey);
      return;
    }
    await box.put(_nextAlarmKey, alarmTime.millisecondsSinceEpoch);
  }
}
