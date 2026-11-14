import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/gemini_key_validator_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_permissions_data_source.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

/// Concrete implementation of [OnboardingRepository].
final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({
    required this._localDataSource,
    required this._geminiKeyValidatorDataSource,
    required this._permissionsDataSource,
    this._prayerScheduleRepository,
  });

  final OnboardingLocalDataSource _localDataSource;
  final GeminiKeyValidatorDataSource _geminiKeyValidatorDataSource;
  final OnboardingPermissionsDataSource _permissionsDataSource;
  final PrayerScheduleRepository? _prayerScheduleRepository;

  @override
  Future<Either<Failure, OnboardingStateEntity>> getOnboardingState() async {
    try {
      final OnboardingStateEntity state = await _localDataSource
          .getOnboardingState();
      return Right(state);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnboardingStateEntity>> saveLocation({
    required double latitude,
    required double longitude,
    required String cityName,
  }) async {
    try {
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      final OnboardingStateEntity updated = current.copyWith(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName,
      );
      await _localDataSource.saveOnboardingState(updated);

      if (_prayerScheduleRepository != null) {
        final Either<Failure, FajrAlarmConfig> configResult =
            await _prayerScheduleRepository.getAlarmConfig();
        final Failure? syncFailure = await configResult.fold(
          (Failure failure) async => failure,
          (FajrAlarmConfig config) async {
            final Either<Failure, Unit> saveResult =
                await _prayerScheduleRepository.saveAlarmConfig(
                  config.copyWith(
                    latitude: latitude,
                    longitude: longitude,
                    cityName: cityName,
                  ),
                );
            return saveResult.fold((Failure f) => f, (_) => null);
          },
        );
        if (syncFailure != null) {
          return Left<Failure, OnboardingStateEntity>(syncFailure);
        }
      }

      return Right(updated);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermissionsGateStatus>> checkPermissions() async {
    try {
      final PermissionsGateStatus status = await _permissionsDataSource
          .checkPermissions();
      return Right(status);
    } on PlatformException catch (e) {
      return Left(
        Failure.platform(
          message: e.message ?? 'Platform permission check failed.',
        ),
      );
    } catch (e) {
      return Left(Failure.permission(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PermissionsGateStatus>> requestPermissions() async {
    try {
      final PermissionsGateStatus status = await _permissionsDataSource
          .requestPermissions();
      return Right(status);
    } on PlatformException catch (e) {
      return Left(
        Failure.platform(
          message: e.message ?? 'Platform permission request failed.',
        ),
      );
    } catch (e) {
      return Left(Failure.permission(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePermissionsGranted(bool granted) async {
    try {
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      await _localDataSource.saveOnboardingState(
        current.copyWith(permissionsGranted: granted),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setPrivacyConsentAccepted(bool accepted) async {
    try {
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      await _localDataSource.saveOnboardingState(
        current.copyWith(privacyConsentAccepted: accepted),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateGeminiKey(String apiKey) async {
    try {
      final bool isValid = await _geminiKeyValidatorDataSource.validateKey(
        apiKey,
      );
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      await _localDataSource.saveOnboardingState(
        current.copyWith(apiKeyValidated: isValid),
      );
      return Right(isValid);
    } on GeminiQuotaException catch (e) {
      return Left(Failure.quotaExceeded(message: e.message));
    } on GeminiNetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on GeminiApiException catch (e) {
      return Left(Failure.api(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveGeminiKey(String apiKey) async {
    try {
      await _localDataSource.saveGeminiKey(apiKey);
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getGeminiKey() async {
    try {
      final String? key = await _localDataSource.getGeminiKey();
      return Right(key);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerBathroomBarcode(String? barcode) async {
    try {
      final String? raw = barcode?.trim();
      final String? normalized = (raw == null || raw.isEmpty) ? null : raw;
      await _localDataSource.saveBathroomBarcode(normalized);
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      await _localDataSource.saveOnboardingState(
        current.copyWith(registeredBarcode: normalized),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnboardingStateEntity>> completeOnboarding() async {
    try {
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      final OnboardingStateEntity completed = current.copyWith(
        isCompleted: true,
      );
      await _localDataSource.saveOnboardingState(completed);
      return Right(completed);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStep(int step) async {
    try {
      final OnboardingStateEntity current = await _localDataSource
          .getOnboardingState();
      await _localDataSource.saveOnboardingState(current.copyWith(step: step));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
