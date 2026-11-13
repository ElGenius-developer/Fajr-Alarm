import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:hive_ce/hive.dart';

/// Hive-backed immutable data model for [OnboardingStateEntity].
final class OnboardingStateModel {
  const OnboardingStateModel({
    this.step = 0,
    this.latitude,
    this.longitude,
    this.cityName,
    this.permissionsGranted = false,
    this.privacyConsentAccepted = false,
    this.apiKeyValidated = false,
    this.registeredBarcode,
    this.isCompleted = false,
  });

  final int step;
  final double? latitude;
  final double? longitude;
  final String? cityName;
  final bool permissionsGranted;
  final bool privacyConsentAccepted;
  final bool apiKeyValidated;
  final String? registeredBarcode;
  final bool isCompleted;

  factory OnboardingStateModel.fromEntity(OnboardingStateEntity entity) {
    return OnboardingStateModel(
      step: entity.step,
      latitude: entity.latitude,
      longitude: entity.longitude,
      cityName: entity.cityName,
      permissionsGranted: entity.permissionsGranted,
      privacyConsentAccepted: entity.privacyConsentAccepted,
      apiKeyValidated: entity.apiKeyValidated,
      registeredBarcode: entity.registeredBarcode,
      isCompleted: entity.isCompleted,
    );
  }

  OnboardingStateEntity toEntity() {
    return OnboardingStateEntity(
      step: step,
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      permissionsGranted: permissionsGranted,
      privacyConsentAccepted: privacyConsentAccepted,
      apiKeyValidated: apiKeyValidated,
      registeredBarcode: registeredBarcode,
      isCompleted: isCompleted,
    );
  }
}

/// Explicit [TypeAdapter] for [OnboardingStateModel] (typeId: 10).
final class OnboardingStateModelAdapter
    extends TypeAdapter<OnboardingStateModel> {
  @override
  final int typeId = 10;

  @override
  OnboardingStateModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, Object?> fields = <int, Object?>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingStateModel(
      step: (fields[0] as int?) ?? 0,
      latitude: fields[1] as double?,
      longitude: fields[2] as double?,
      cityName: fields[3] as String?,
      permissionsGranted: (fields[4] as bool?) ?? false,
      privacyConsentAccepted: (fields[5] as bool?) ?? false,
      apiKeyValidated: (fields[6] as bool?) ?? false,
      registeredBarcode: fields[7] as String?,
      isCompleted: (fields[8] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingStateModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.step)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.cityName)
      ..writeByte(4)
      ..write(obj.permissionsGranted)
      ..writeByte(5)
      ..write(obj.privacyConsentAccepted)
      ..writeByte(6)
      ..write(obj.apiKeyValidated)
      ..writeByte(7)
      ..write(obj.registeredBarcode)
      ..writeByte(8)
      ..write(obj.isCompleted);
  }
}
