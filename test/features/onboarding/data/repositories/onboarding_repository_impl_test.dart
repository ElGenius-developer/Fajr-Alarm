import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/gemini_key_validator_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_permissions_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements OnboardingLocalDataSource {}

class MockGeminiValidator extends Mock
    implements GeminiKeyValidatorDataSource {}

class MockPermissionsDataSource extends Mock
    implements OnboardingPermissionsDataSource {}

void main() {
  late MockLocalDataSource localDataSource;
  late MockGeminiValidator validator;
  late MockPermissionsDataSource permissionsDataSource;
  late OnboardingRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const OnboardingStateEntity());
  });

  setUp(() {
    localDataSource = MockLocalDataSource();
    validator = MockGeminiValidator();
    permissionsDataSource = MockPermissionsDataSource();
    repository = OnboardingRepositoryImpl(
      localDataSource: localDataSource,
      geminiKeyValidatorDataSource: validator,
      permissionsDataSource: permissionsDataSource,
    );
  });

  test('saveLocation persists coordinates and city name', () async {
    when(() => localDataSource.getOnboardingState())
        .thenAnswer((_) async => const OnboardingStateEntity());
    when(() => localDataSource.saveOnboardingState(any())).thenAnswer(
      (Invocation inv) async =>
          inv.positionalArguments.first as OnboardingStateEntity,
    );

    final Either<Failure, OnboardingStateEntity> result = await repository
        .saveLocation(
          latitude: 21.3891,
          longitude: 39.8579,
          cityName: 'Makkah',
        );

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('Expected Right'), (OnboardingStateEntity entity) {
      expect(entity.cityName, 'Makkah');
      expect(entity.latitude, 21.3891);
      expect(entity.longitude, 39.8579);
    });
  });

  test('checkPermissions maps PlatformException to PlatformFailure', () async {
    when(() => permissionsDataSource.checkPermissions()).thenThrow(
      PlatformException(code: 'UNAVAILABLE', message: 'Not supported'),
    );

    final Either<Failure, PermissionsGateStatus> result = await repository
        .checkPermissions();

    expect(result.isLeft(), isTrue);
    result.fold(
      (Failure f) => expect(f, isA<PlatformFailure>()),
      (_) => fail('Expected Left'),
    );
  });

  test(
    'validateGeminiKey maps GeminiQuotaException to QuotaExceededFailure',
    () async {
      when(() => validator.validateKey('key'))
          .thenThrow(const GeminiQuotaException(message: '429'));

      final Either<Failure, bool> result = await repository.validateGeminiKey(
        'key',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<QuotaExceededFailure>()),
        (_) => fail('Expected Left'),
      );
    },
  );

  test(
    'validateGeminiKey maps GeminiNetworkException to NetworkFailure',
    () async {
      when(() => validator.validateKey('key'))
          .thenThrow(const GeminiNetworkException(message: 'offline'));

      final Either<Failure, bool> result = await repository.validateGeminiKey(
        'key',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    },
  );

  test('completeOnboarding sets isCompleted=true', () async {
    when(() => localDataSource.getOnboardingState()).thenAnswer(
      (_) async => const OnboardingStateEntity(
        latitude: 30.0,
        longitude: 31.0,
        cityName: 'Cairo',
        permissionsGranted: true,
        privacyConsentAccepted: true,
        apiKeyValidated: true,
      ),
    );
    when(() => localDataSource.saveOnboardingState(any())).thenAnswer(
      (Invocation inv) async =>
          inv.positionalArguments.first as OnboardingStateEntity,
    );

    final Either<Failure, OnboardingStateEntity> result = await repository
        .completeOnboarding();

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('Expected Right'),
      (OnboardingStateEntity entity) => expect(entity.isCompleted, isTrue),
    );
  });

  test(
    'getOnboardingState returns entity and maps exceptions to CacheFailure',
    () async {
      when(() => localDataSource.getOnboardingState())
          .thenAnswer((_) async => const OnboardingStateEntity(step: 2));

      final Either<Failure, OnboardingStateEntity> ok = await repository
          .getOnboardingState();
      expect(
        ok,
        const Right<Failure, OnboardingStateEntity>(
          OnboardingStateEntity(step: 2),
        ),
      );

      when(() => localDataSource.getOnboardingState())
          .thenThrow(Exception('db'));
      final Either<Failure, OnboardingStateEntity> err = await repository
          .getOnboardingState();
      err.fold(
        (Failure f) => expect(f, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    },
  );

  test('requestPermissions, savePermissionsGranted, setPrivacyConsentAccepted, save/getGeminiKey, registerBarcode, updateStep', () async {
    when(() => localDataSource.getOnboardingState())
        .thenAnswer((_) async => const OnboardingStateEntity());
    when(() => localDataSource.saveOnboardingState(any())).thenAnswer(
      (Invocation inv) async =>
          inv.positionalArguments.first as OnboardingStateEntity,
    );
    when(() => localDataSource.saveGeminiKey('k')).thenAnswer((_) async {});
    when(() => localDataSource.getGeminiKey()).thenAnswer((_) async => 'k');
    when(
      () => permissionsDataSource.requestPermissions(),
    ).thenAnswer((_) async => const PermissionsGateStatus(cameraGranted: true));

    expect((await repository.requestPermissions()).isRight(), isTrue);
    expect((await repository.savePermissionsGranted(true)).isRight(), isTrue);
    expect(
      (await repository.setPrivacyConsentAccepted(true)).isRight(),
      isTrue,
    );
    expect((await repository.saveGeminiKey('k')).isRight(), isTrue);
    expect(await repository.getGeminiKey(), const Right<Failure, String?>('k'));
    expect((await repository.registerBathroomBarcode('123')).isRight(), isTrue);
    expect((await repository.updateStep(2)).isRight(), isTrue);
  });

  test('validateGeminiKey maps GeminiApiException to ApiFailure', () async {
    when(() => validator.validateKey('key'))
        .thenThrow(const GeminiApiException(message: 'err', statusCode: 500));

    final Either<Failure, bool> result = await repository.validateGeminiKey(
      'key',
    );
    result.fold(
      (Failure f) => expect(f, isA<ApiFailure>()),
      (_) => fail('Expected Left'),
    );
  });
}
