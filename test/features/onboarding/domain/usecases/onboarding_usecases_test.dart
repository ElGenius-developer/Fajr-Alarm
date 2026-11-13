import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository repository;

  setUp(() {
    repository = MockOnboardingRepository();
  });

  group('SaveLocationUseCase', () {
    late SaveLocationUseCase useCase;

    setUp(() {
      useCase = SaveLocationUseCase(repository);
    });

    test('saves trimmed city and valid coordinates', () async {
      const OnboardingStateEntity expected = OnboardingStateEntity(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'Cairo',
      );
      when(
        () => repository.saveLocation(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        ),
      ).thenAnswer((_) async => const Right(expected));

      final Either<Failure, OnboardingStateEntity> result = await useCase(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: '  Cairo  ',
      );

      expect(result, const Right<Failure, OnboardingStateEntity>(expected));
      verify(
        () => repository.saveLocation(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        ),
      ).called(1);
    });

    test('returns ValidationFailure when cityName is empty', () async {
      final Either<Failure, OnboardingStateEntity> result = await useCase(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: '   ',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyZeroInteractions(repository);
    });

    test('returns ValidationFailure when latitude is out of range', () async {
      final Either<Failure, OnboardingStateEntity> result = await useCase(
        latitude: 95.0,
        longitude: 31.2357,
        cityName: 'Cairo',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns ValidationFailure when longitude is out of range', () async {
      final Either<Failure, OnboardingStateEntity> result = await useCase(
        latitude: 30.0444,
        longitude: -181.0,
        cityName: 'Cairo',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('CheckPermissionsGateUseCase', () {
    late CheckPermissionsGateUseCase useCase;

    setUp(() {
      useCase = CheckPermissionsGateUseCase(repository);
    });

    test('checks permissions and persists allGranted=true', () async {
      const PermissionsGateStatus granted = PermissionsGateStatus(
        fullScreenIntentGranted: true,
        batteryOptimizationIgnored: true,
        cameraGranted: true,
        alarmPermissionGranted: true,
      );
      when(() => repository.checkPermissions())
          .thenAnswer((_) async => const Right(granted));
      when(() => repository.savePermissionsGranted(true))
          .thenAnswer((_) async => const Right(unit));

      final Either<Failure, PermissionsGateStatus> result = await useCase();

      expect(result, const Right<Failure, PermissionsGateStatus>(granted));
      verify(() => repository.savePermissionsGranted(true)).called(1);
    });

    test('requests permissions when request=true and persists false', () async {
      const PermissionsGateStatus partial = PermissionsGateStatus(
        fullScreenIntentGranted: true,
        batteryOptimizationIgnored: false,
        cameraGranted: true,
        alarmPermissionGranted: true,
      );
      when(() => repository.requestPermissions())
          .thenAnswer((_) async => const Right(partial));
      when(() => repository.savePermissionsGranted(false))
          .thenAnswer((_) async => const Right(unit));

      final Either<Failure, PermissionsGateStatus> result = await useCase(
        request: true,
      );

      expect(result, const Right<Failure, PermissionsGateStatus>(partial));
      verify(() => repository.requestPermissions()).called(1);
      verify(() => repository.savePermissionsGranted(false)).called(1);
    });
  });

  group('ValidateAndSaveGeminiKeyUseCase', () {
    late ValidateAndSaveGeminiKeyUseCase useCase;

    setUp(() {
      useCase = ValidateAndSaveGeminiKeyUseCase(repository);
    });

    test('rejects key save without explicit privacy consent', () async {
      final Either<Failure, bool> result = await useCase(
        apiKey: 'AIzaTestKey123',
        privacyConsentAccepted: false,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyZeroInteractions(repository);
    });

    test('rejects empty key even when consent is accepted', () async {
      final Either<Failure, bool> result = await useCase(
        apiKey: '   ',
        privacyConsentAccepted: true,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyZeroInteractions(repository);
    });

    test(
      'validates and saves key when consent is true and key is valid',
      () async {
        when(() => repository.validateGeminiKey('AIzaTestKey123'))
            .thenAnswer((_) async => const Right(true));
        when(() => repository.setPrivacyConsentAccepted(true))
            .thenAnswer((_) async => const Right(unit));
        when(() => repository.saveGeminiKey('AIzaTestKey123'))
            .thenAnswer((_) async => const Right(unit));

        final Either<Failure, bool> result = await useCase(
          apiKey: '  AIzaTestKey123  ',
          privacyConsentAccepted: true,
        );

        expect(result, const Right<Failure, bool>(true));
        verify(() => repository.validateGeminiKey('AIzaTestKey123')).called(1);
        verify(() => repository.setPrivacyConsentAccepted(true)).called(1);
        verify(() => repository.saveGeminiKey('AIzaTestKey123')).called(1);
      },
    );

    test('does not save key when live validation returns false', () async {
      when(() => repository.validateGeminiKey('bad-key'))
          .thenAnswer((_) async => const Right(false));

      final Either<Failure, bool> result = await useCase(
        apiKey: 'bad-key',
        privacyConsentAccepted: true,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (Failure f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => repository.saveGeminiKey(any()));
    });
  });

  group('RegisterBathroomBarcodeUseCase', () {
    late RegisterBathroomBarcodeUseCase useCase;

    setUp(() {
      useCase = RegisterBathroomBarcodeUseCase(repository);
    });

    test('saves trimmed barcode', () async {
      when(() => repository.registerBathroomBarcode('123456789'))
          .thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        barcode: ' 123456789 ',
      );

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.registerBathroomBarcode('123456789')).called(1);
    });

    test('allows skipping with null', () async {
      when(() => repository.registerBathroomBarcode(null))
          .thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(barcode: null);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.registerBathroomBarcode(null)).called(1);
    });

    test('rejects blank non-null barcode', () async {
      final Either<Failure, Unit> result = await useCase(barcode: '   ');

      expect(result.isLeft(), isTrue);
      verifyZeroInteractions(repository);
    });
  });

  group('CompleteOnboardingUseCase', () {
    late CompleteOnboardingUseCase useCase;

    setUp(() {
      useCase = CompleteOnboardingUseCase(repository);
    });

    test('completes onboarding when all prerequisites are satisfied', () async {
      const OnboardingStateEntity ready = OnboardingStateEntity(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'Cairo',
        permissionsGranted: true,
        privacyConsentAccepted: true,
        apiKeyValidated: true,
      );
      final OnboardingStateEntity completed = ready.copyWith(isCompleted: true);

      when(() => repository.getOnboardingState())
          .thenAnswer((_) async => const Right(ready));
      when(() => repository.completeOnboarding())
          .thenAnswer((_) async => Right(completed));

      final Either<Failure, OnboardingStateEntity> result = await useCase();

      expect(result, Right<Failure, OnboardingStateEntity>(completed));
      verify(() => repository.completeOnboarding()).called(1);
    });

    test(
      'returns ValidationFailure when prerequisites are incomplete',
      () async {
        const OnboardingStateEntity incomplete = OnboardingStateEntity(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
          permissionsGranted: false,
          privacyConsentAccepted: true,
          apiKeyValidated: true,
        );
        when(() => repository.getOnboardingState())
            .thenAnswer((_) async => const Right(incomplete));

        final Either<Failure, OnboardingStateEntity> result = await useCase();

        expect(result.isLeft(), isTrue);
        result.fold(
          (Failure f) => expect(f, isA<ValidationFailure>()),
          (_) => fail('Expected Left'),
        );
        verifyNever(() => repository.completeOnboarding());
      },
    );
  });
}
