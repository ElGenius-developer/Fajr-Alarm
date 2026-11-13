import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:hive_ce/hive.dart';

/// Strongly-typed Hive persistence model for [FajrAlarmConfig].
class FajrAlarmConfigHiveModel {
  const FajrAlarmConfigHiveModel({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.calculationMethodIndex,
    required this.madhabIndex,
    required this.modeIndex,
    required this.offsetDirectionIndex,
    required this.offsetMinutes,
    required this.manualHour,
    required this.manualMinute,
    required this.isEnabled,
  });

  factory FajrAlarmConfigHiveModel.fromDomain(FajrAlarmConfig entity) {
    return FajrAlarmConfigHiveModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      cityName: entity.cityName ?? '',
      calculationMethodIndex: entity.calculationMethod.index,
      madhabIndex: entity.madhab.index,
      modeIndex: entity.mode.index,
      offsetDirectionIndex: entity.offsetDirection.index,
      offsetMinutes: entity.offsetMinutes,
      manualHour: entity.manualHour,
      manualMinute: entity.manualMinute,
      isEnabled: entity.isEnabled,
    );
  }

  final double latitude;
  final double longitude;
  final String cityName;
  final int calculationMethodIndex;
  final int madhabIndex;
  final int modeIndex;
  final int offsetDirectionIndex;
  final int offsetMinutes;
  final int manualHour;
  final int manualMinute;
  final bool isEnabled;

  FajrAlarmConfig toDomain() {
    return FajrAlarmConfig(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName.isEmpty ? null : cityName,
      calculationMethod:
          FajrCalculationMethod.values[calculationMethodIndex.clamp(
            0,
            FajrCalculationMethod.values.length - 1,
          )],
      madhab:
          FajrMadhab.values[madhabIndex.clamp(0, FajrMadhab.values.length - 1)],
      mode: FajrAlarmMode
          .values[modeIndex.clamp(0, FajrAlarmMode.values.length - 1)],
      offsetDirection:
          FajrOffsetDirection.values[offsetDirectionIndex.clamp(
            0,
            FajrOffsetDirection.values.length - 1,
          )],
      offsetMinutes: offsetMinutes,
      manualHour: manualHour,
      manualMinute: manualMinute,
      isEnabled: isEnabled,
    );
  }
}

/// Explicit [TypeAdapter] for [FajrAlarmConfigHiveModel] (zero `dynamic`).
class FajrAlarmConfigHiveAdapter extends TypeAdapter<FajrAlarmConfigHiveModel> {
  const FajrAlarmConfigHiveAdapter();

  static const int adapterTypeId = 21;

  @override
  int get typeId => adapterTypeId;

  @override
  FajrAlarmConfigHiveModel read(BinaryReader reader) {
    final latitude = reader.readDouble();
    final longitude = reader.readDouble();
    final cityName = reader.readString();
    final calculationMethodIndex = reader.readInt();
    final madhabIndex = reader.readInt();
    final modeIndex = reader.readInt();
    final offsetDirectionIndex = reader.readInt();
    final offsetMinutes = reader.readInt();
    final manualHour = reader.readInt();
    final manualMinute = reader.readInt();
    final isEnabled = reader.readBool();
    return FajrAlarmConfigHiveModel(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      calculationMethodIndex: calculationMethodIndex,
      madhabIndex: madhabIndex,
      modeIndex: modeIndex,
      offsetDirectionIndex: offsetDirectionIndex,
      offsetMinutes: offsetMinutes,
      manualHour: manualHour,
      manualMinute: manualMinute,
      isEnabled: isEnabled,
    );
  }

  @override
  void write(BinaryWriter writer, FajrAlarmConfigHiveModel obj) {
    writer
      ..writeDouble(obj.latitude)
      ..writeDouble(obj.longitude)
      ..writeString(obj.cityName)
      ..writeInt(obj.calculationMethodIndex)
      ..writeInt(obj.madhabIndex)
      ..writeInt(obj.modeIndex)
      ..writeInt(obj.offsetDirectionIndex)
      ..writeInt(obj.offsetMinutes)
      ..writeInt(obj.manualHour)
      ..writeInt(obj.manualMinute)
      ..writeBool(obj.isEnabled);
  }
}
