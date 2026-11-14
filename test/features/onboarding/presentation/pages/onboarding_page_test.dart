import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/check_permissions_gate_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/register_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/save_location_usecase.dart';
import 'package:fajr_alarm/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fajr_alarm/features/onboarding/presentation/widgets/barcode_step_view.dart';
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
    BarcodeScannerBuilder? barcodeScannerBuilder,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<OnboardingCubit>.value(
        value: cubit,
        child: OnboardingPage(
          onCompleted: onCompleted,
          barcodeScannerBuilder: barcodeScannerBuilder,
        ),
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

  testWidgets(
    'Step 3 shows API key invalid message instead of consent error when consent is checked',
    (WidgetTester tester) async {
      when(() => repository.validateGeminiKey('AIzaInvalid')).thenAnswer(
        (_) async => const Left(Failure.validation(message: 'Bad key')),
      );

      await cubit.goToStep(2);
      await cubit.setPrivacyConsent(true);
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('onboarding_api_key_field')),
        'AIzaInvalid',
      );
      final Finder testKeyButton = find.byKey(
        const Key('onboarding_test_key_button'),
      );
      await tester.ensureVisible(testKeyButton);
      await tester.tap(testKeyButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('onboarding_error_banner')), findsOneWidget);
      expect(
        find.text('API key validation failed. Check your key and connection.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'You must accept the privacy disclosure before saving your API key.',
        ),
        findsNothing,
      );
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

  testWidgets(
    'all onboarding steps render without layout error under AppTheme',
    (WidgetTester tester) async {
      for (int step = 0; step < 4; step++) {
        await cubit.goToStep(step);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: AppTheme.light(AppDesignStyle.horizon),
            darkTheme: AppTheme.dark(AppDesignStyle.horizon),
            themeMode: ThemeMode.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<OnboardingCubit>.value(
              value: cubit,
              child: const OnboardingPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      expect(find.byKey(const Key('onboarding_barcode_field')), findsOneWidget);
      expect(
        find.byKey(const Key('onboarding_scan_barcode_button')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Step 4 camera scan captures barcode, displays badge, and completes onboarding',
    (WidgetTester tester) async {
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
      when(() => repository.registerBathroomBarcode('FAJR-SCAN-999'))
          .thenAnswer((_) async => const Right(unit));
      when(() => repository.getOnboardingState())
          .thenAnswer((_) async => const Right(ready));
      when(() => repository.completeOnboarding())
          .thenAnswer((_) async => Right(ready.copyWith(isCompleted: true)));

      await cubit.goToStep(3);
      await tester.pumpWidget(
        buildTestApp(
          onCompleted: () => completed = true,
          barcodeScannerBuilder:
              (BuildContext context, ValueChanged<String> onDetected) {
                return TextButton(
                  key: const Key('fake_detected_barcode_trigger'),
                  onPressed: () => onDetected('FAJR-SCAN-999'),
                  child: const Text('Trigger Scan'),
                );
              },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('onboarding_scan_barcode_button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('fake_detected_barcode_trigger')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('onboarding_stop_scan_button')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('fake_detected_barcode_trigger')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('fake_detected_barcode_trigger')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('onboarding_barcode_scanned_badge')),
        findsOneWidget,
      );
      expect(find.text('Scanned: FAJR-SCAN-999'), findsOneWidget);

      final TextField field = tester.widget<TextField>(
        find.byKey(const Key('onboarding_barcode_field')),
      );
      expect(field.controller?.text, 'FAJR-SCAN-999');

      final Finder registerButton = find.byKey(
        const Key('onboarding_register_barcode_button'),
      );
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      verify(() => repository.registerBathroomBarcode('FAJR-SCAN-999'))
          .called(1);
    },
  );

  testWidgets('Step 4 close camera button returns to scan prompt', (
    WidgetTester tester,
  ) async {
    await cubit.goToStep(3);
    await tester.pumpWidget(
      buildTestApp(
        barcodeScannerBuilder: (_, _) =>
            const SizedBox(key: Key('fake_live_scanner_preview')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_scan_barcode_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fake_live_scanner_preview')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_stop_scan_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fake_live_scanner_preview')), findsNothing);
    expect(
      find.byKey(const Key('onboarding_scan_barcode_button')),
      findsOneWidget,
    );
  });
}
