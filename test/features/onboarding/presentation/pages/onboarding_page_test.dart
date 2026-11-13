import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository repository;
  late OnboardingCubit cubit;

  setUp(() {
    repository = MockOnboardingRepository();
    when(() => repository.updateStep(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.savePermissionsGranted(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.setPrivacyConsentAccepted(any()))
        .thenAnswer((_) async => const Right(unit));
    when(() => repository.getOnboardingState())
        .thenAnswer((_) async => const Right(OnboardingStateEntity()));
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

    cubit = OnboardingCubit(
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
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget buildTestApp({
    Locale locale = const Locale('en'),
    VoidCallback? onCompleted,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OnboardingCubit>.value(
        value: cubit,
        child: OnboardingPage(onCompleted: onCompleted),
      ),
    );
  }

  testWidgets(
    'Step 1 renders localized title and advances on preset city save',
    (WidgetTester tester) async {
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

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Location & City'), findsOneWidget);

      await tester.tap(find.text('Cairo'));
      await tester.pump();
      await tester.tap(
        find.byKey(const Key('onboarding_save_location_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mandatory Permissions Gate'), findsOneWidget);
    },
  );

  testWidgets(
    'Step 3 shows error banner when testing key without explicit consent',
    (WidgetTester tester) async {
      await cubit.goToStep(2);
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Privacy & Gemini API Key'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('onboarding_api_key_field')),
        'AIzaTestKey123',
      );
      final Finder testKeyButton = find.byKey(
        const Key('onboarding_test_key_button'),
      );
      await tester.ensureVisible(testKeyButton);
      await tester.tap(testKeyButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('onboarding_error_banner')), findsOneWidget);
      verifyNever(() => repository.validateGeminiKey(any()));
    },
  );

  testWidgets('Step 4 allows skipping barcode and fires onCompleted', (
    WidgetTester tester,
  ) async {
    bool completed = false;
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

    await cubit.goToStep(3);
    await tester.pumpWidget(buildTestApp(onCompleted: () => completed = true));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_skip_barcode_button')));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
  });

  testWidgets('renders Arabic RTL localization cleanly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp(locale: const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('إعداد منبه الفجر'), findsOneWidget);
    expect(find.text('الموقع والمدينة'), findsOneWidget);
  });
}
