import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository repository;

  OnboardingCubit buildCubit() {
    return OnboardingCubit(
      repository: repository,
      saveLocationUseCase: SaveLocationUseCase(repository),
      checkPermissionsGateUseCase: CheckPermissionsGateUseCase(repository),
      validateAndSaveGeminiKeyUseCase: ValidateAndSaveGeminiKeyUseCase(
        repository,
      ),
      registerBathroomBarcodeUseCase: RegisterBathroomBarcodeUseCase(
        repository,
      ),
      completeOnboardingUseCase: CompleteOnboardingUseCase(repository),
    );
  }

  setUp(() {
    repository = MockOnboardingRepository();
    when(() => repository.updateStep(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.savePermissionsGranted(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.setPrivacyConsentAccepted(any()))
        .thenAnswer((_) async => const Right(unit));
  });

  blocTest<OnboardingCubit, OnboardingState>(
    'loadOnboarding loads entity and permissions status',
    build: () {
      when(() => repository.getOnboardingState())
          .thenAnswer((_) async => const Right(OnboardingStateEntity(step: 1)));
      when(() => repository.checkPermissions()).thenAnswer(
        (_) async => const Right(
          PermissionsGateStatus(
            fullScreenIntentGranted: true,
            batteryOptimizationIgnored: true,
            cameraGranted: true,
            alarmPermissionGranted: true,
          ),
        ),
      );
      return buildCubit();
    },
    act: (OnboardingCubit cubit) => cubit.loadOnboarding(),
    expect: () => <OnboardingState>[
      const OnboardingState(isLoading: true),
      const OnboardingState(
        entity: OnboardingStateEntity(step: 1, permissionsGranted: true),
        permissionsStatus: PermissionsGateStatus(
          fullScreenIntentGranted: true,
          batteryOptimizationIgnored: true,
          cameraGranted: true,
          alarmPermissionGranted: true,
        ),
        isLoading: false,
      ),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'saveLocation saves coordinates and advances to step 1',
    build: () {
      when(
        () => repository.saveLocation(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        ),
      ).thenAnswer(
        (_) async => const Right(
          OnboardingStateEntity(
            latitude: 30.0444,
            longitude: 31.2357,
            cityName: 'Cairo',
          ),
        ),
      );
      return buildCubit();
    },
    act: (OnboardingCubit cubit) => cubit.saveLocation(
      latitude: 30.0444,
      longitude: 31.2357,
      cityName: 'Cairo',
    ),
    expect: () => <OnboardingState>[
      const OnboardingState(isSubmitting: true),
      const OnboardingState(
        entity: OnboardingStateEntity(
          step: 1,
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        ),
        isSubmitting: false,
      ),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'continueFromPermissionsGate blocks when permissions are missing',
    build: buildCubit,
    seed: () => const OnboardingState(
      entity: OnboardingStateEntity(step: 1),
      permissionsStatus: PermissionsGateStatus(fullScreenIntentGranted: false),
    ),
    act: (OnboardingCubit cubit) => cubit.continueFromPermissionsGate(),
    expect: () => <OnboardingState>[
      const OnboardingState(
        entity: OnboardingStateEntity(step: 1),
        permissionsStatus: PermissionsGateStatus(
          fullScreenIntentGranted: false,
        ),
        error: Failure.permission(
          message: 'All mandatory permissions must be granted.',
        ),
      ),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'validateAndSaveApiKey rejects when privacyConsentAccepted is false',
    build: buildCubit,
    seed: () => const OnboardingState(
      entity: OnboardingStateEntity(step: 2, privacyConsentAccepted: false),
    ),
    act: (OnboardingCubit cubit) => cubit.validateAndSaveApiKey('AIzaTest'),
    expect: () => <OnboardingState>[
      const OnboardingState(
        entity: OnboardingStateEntity(step: 2, privacyConsentAccepted: false),
        isValidatingKey: true,
      ),
      const OnboardingState(
        entity: OnboardingStateEntity(
          step: 2,
          privacyConsentAccepted: false,
          apiKeyValidated: false,
        ),
        isValidatingKey: false,
        error: Failure.validation(
          message: 'Explicit privacy consent is required before saving Gemini API key.',
        ),
      ),
    ],
    verify: (_) {
      verifyNever(() => repository.validateGeminiKey(any()));
      verifyNever(() => repository.saveGeminiKey(any()));
    },
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'validateAndSaveApiKey validates, saves key, and advances to step 3 when consent is true',
    build: () {
      when(() => repository.validateGeminiKey('AIzaValid'))
          .thenAnswer((_) async => const Right(true));
      when(() => repository.saveGeminiKey('AIzaValid'))
          .thenAnswer((_) async => const Right(unit));
      return buildCubit();
    },
    seed: () => const OnboardingState(
      entity: OnboardingStateEntity(step: 2, privacyConsentAccepted: true),
    ),
    act: (OnboardingCubit cubit) => cubit.validateAndSaveApiKey('AIzaValid'),
    expect: () => <OnboardingState>[
      const OnboardingState(
        entity: OnboardingStateEntity(step: 2, privacyConsentAccepted: true),
        isValidatingKey: true,
      ),
      const OnboardingState(
        entity: OnboardingStateEntity(
          step: 3,
          privacyConsentAccepted: true,
          apiKeyValidated: true,
        ),
        isValidatingKey: false,
      ),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'registerBarcodeAndComplete supports skipping with null and completes onboarding',
    build: () {
      const OnboardingStateEntity ready = OnboardingStateEntity(
        step: 3,
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'Cairo',
        permissionsGranted: true,
        privacyConsentAccepted: true,
        apiKeyValidated: true,
      );
      when(() => repository.registerBathroomBarcode(null))
          .thenAnswer((_) async => const Right(unit));
      when(() => repository.getOnboardingState())
          .thenAnswer((_) async => const Right(ready));
      when(() => repository.completeOnboarding())
          .thenAnswer((_) async => Right(ready.copyWith(isCompleted: true)));
      return buildCubit();
    },
    seed: () => const OnboardingState(
      entity: OnboardingStateEntity(
        step: 3,
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'Cairo',
        permissionsGranted: true,
        privacyConsentAccepted: true,
        apiKeyValidated: true,
      ),
    ),
    act: (OnboardingCubit cubit) => cubit.registerBarcodeAndComplete(null),
    expect: () => <OnboardingState>[
      const OnboardingState(
        entity: OnboardingStateEntity(
          step: 3,
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
          permissionsGranted: true,
          privacyConsentAccepted: true,
          apiKeyValidated: true,
        ),
        isSubmitting: true,
      ),
      const OnboardingState(
        entity: OnboardingStateEntity(
          step: 3,
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
          permissionsGranted: true,
          privacyConsentAccepted: true,
          apiKeyValidated: true,
          isCompleted: true,
        ),
        isSubmitting: false,
      ),
    ],
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'checkPermissions updates permissionsStatus and continueFromPermissionsGate advances when allGranted',
    build: () {
      when(() => repository.requestPermissions()).thenAnswer(
        (_) async => const Right(
          PermissionsGateStatus(
            fullScreenIntentGranted: true,
            batteryOptimizationIgnored: true,
            cameraGranted: true,
            alarmPermissionGranted: true,
          ),
        ),
      );
      return buildCubit();
    },
    seed: () => const OnboardingState(entity: OnboardingStateEntity(step: 1)),
    act: (OnboardingCubit cubit) async {
      await cubit.checkPermissions(request: true);
      await cubit.continueFromPermissionsGate();
    },
    expect: () => <OnboardingState>[
      const OnboardingState(
        entity: OnboardingStateEntity(step: 1),
        isSubmitting: true,
      ),
      const OnboardingState(
        entity: OnboardingStateEntity(step: 1, permissionsGranted: true),
        permissionsStatus: PermissionsGateStatus(
          fullScreenIntentGranted: true,
          batteryOptimizationIgnored: true,
          cameraGranted: true,
          alarmPermissionGranted: true,
        ),
        isSubmitting: false,
      ),
      const OnboardingState(
        entity: OnboardingStateEntity(step: 2, permissionsGranted: true),
        permissionsStatus: PermissionsGateStatus(
          fullScreenIntentGranted: true,
          batteryOptimizationIgnored: true,
          cameraGranted: true,
          alarmPermissionGranted: true,
        ),
        isSubmitting: false,
      ),
    ],
  );
}
