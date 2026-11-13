import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:hive_ce/hive.dart';

/// Strongly-typed Hive persistence model for a single day's [PrayerSchedule].
class PrayerScheduleHiveModel {
  const PrayerScheduleHiveModel({
    required this.dateMillis,
    required this.fajrTimeMillis,
    required this.sunriseTimeMillis,
    required this.latitude,
    required this.longitude,
    required this.calculationMethod,
    required this.madhab,
  });

  factory PrayerScheduleHiveModel.fromDomain(PrayerSchedule entity) {
    return PrayerScheduleHiveModel(
      dateMillis: entity.date.millisecondsSinceEpoch,
      fajrTimeMillis: entity.fajrTime.millisecondsSinceEpoch,
      sunriseTimeMillis: entity.sunriseTime.millisecondsSinceEpoch,
      latitude: entity.latitude,
      longitude: entity.longitude,
      calculationMethod: entity.calculationMethod,
      madhab: entity.madhab,
    );
  }

  final int dateMillis;
  final int fajrTimeMillis;
  final int sunriseTimeMillis;
  final double latitude;
  final double longitude;
  final String calculationMethod;
  final String madhab;

  PrayerSchedule toDomain() {
    return PrayerSchedule(
      date: DateTime.fromMillisecondsSinceEpoch(dateMillis),
      fajrTime: DateTime.fromMillisecondsSinceEpoch(fajrTimeMillis),
      sunriseTime: DateTime.fromMillisecondsSinceEpoch(sunriseTimeMillis),
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      madhab: madhab,
    );
  }
}

/// Explicit [TypeAdapter] for [PrayerScheduleHiveModel] (zero `dynamic`).
class PrayerScheduleHiveAdapter extends TypeAdapter<PrayerScheduleHiveModel> {
  const PrayerScheduleHiveAdapter();

  static const int adapterTypeId = 10;

  @override
  int get typeId => adapterTypeId;

  @override
  PrayerScheduleHiveModel read(BinaryReader reader) {
    final dateMillis = reader.readInt();
    final fajrTimeMillis = reader.readInt();
    final sunriseTimeMillis = reader.readInt();
    final latitude = reader.readDouble();
    final longitude = reader.readDouble();
    final calculationMethod = reader.readString();
    final madhab = reader.readString();
    return PrayerScheduleHiveModel(
      dateMillis: dateMillis,
      fajrTimeMillis: fajrTimeMillis,
      sunriseTimeMillis: sunriseTimeMillis,
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      madhab: madhab,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerScheduleHiveModel obj) {
    writer
      ..writeInt(obj.dateMillis)
      ..writeInt(obj.fajrTimeMillis)
      ..writeInt(obj.sunriseTimeMillis)
      ..writeDouble(obj.latitude)
      ..writeDouble(obj.longitude)
      ..writeString(obj.calculationMethod)
      ..writeString(obj.madhab);
  }
}
