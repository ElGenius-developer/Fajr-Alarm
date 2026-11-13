import 'dart:async';
import 'dart:typed_data';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/resolve_offline_fallback_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_standing_typing_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/pages/challenge_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChallengeVerificationRepository extends Mock
    implements ChallengeVerificationRepository {}

void main() {
  late MockChallengeVerificationRepository repository;
  late StreamController<Either<Failure, TiltAngleReading>> tiltController;
  late ChallengeCubit cubit;

  setUp(() {
    repository = MockChallengeVerificationRepository();
    tiltController =
        StreamController<Either<Failure, TiltAngleReading>>.broadcast();
    when(() => repository.watchTiltAngle())
        .thenAnswer((_) => tiltController.stream);

    cubit = ChallengeCubit(
      verifyPrayerRugPhoto: VerifyPrayerRugPhotoUseCase(repository),
      verifyBathroomBarcode: VerifyBathroomBarcodeUseCase(repository),
      verifyStandingTyping: VerifyStandingTypingUseCase(repository),
      resolveOfflineFallback: ResolveOfflineFallbackUseCase(repository),
      repository: repository,
    );
  });

  tearDown(() async {
    await cubit.close();
    await tiltController.close();
  });

  Widget buildTestablePage() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ChallengeCubit>.value(
        value: cubit,
        child: ChallengePage(
          cameraPreviewOverride: const SizedBox(key: Key('mock-camera')),
          scannerOverride: const SizedBox(key: Key('mock-scanner')),
          onCapturePhotoOverride: () async =>
              Uint8List.fromList(<int>[1, 2, 3]),
        ),
      ),
    );
  }

  testWidgets(
    'capture button is disabled when tilt is invalid and enabled when valid',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestablePage());
      await tester.pumpAndSettle();

      // Initially no tilt reading -> disabled
      FilledButton captureButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(captureButton.onPressed, isNull);

      // Emit valid standing tilt (-60°)
      tiltController.add(Right(TiltAngleReading.fromPitch(-60.0)));
      await tester.pump(Duration.zero);
      await tester.pump();

      captureButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(captureButton.onPressed, isNotNull);

      // Emit invalid flat tilt (-10°)
      tiltController.add(Right(TiltAngleReading.fromPitch(-10.0)));
      await tester.pump(Duration.zero);
      await tester.pump();

      captureButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(captureButton.onPressed, isNull);
    },
  );

  testWidgets('standing typing TextField has paste/selection disabled', (
    WidgetTester tester,
  ) async {
    when(() => repository.hasRegisteredBathroomBarcode())
        .thenAnswer((_) async => const Right(false));

    await tester.pumpWidget(buildTestablePage());
    await tester.pumpAndSettle();

    await cubit.reportCameraUnavailable();
    await tester.pumpAndSettle();

    expect(cubit.state.mode, ChallengeMode.standingTyping);
    final TextField textField = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(textField.enableInteractiveSelection, isFalse);
    expect(textField.contextMenuBuilder, isNull);
  });

  testWidgets(
    'torch toggle updates isTorchOn and offline fallback renders scanner',
    (WidgetTester tester) async {
      registerFallbackValue(Uint8List(0));
      when(() => repository.hasRegisteredBathroomBarcode())
          .thenAnswer((_) async => const Right(true));
      when(() => repository.getCurrentTiltAngle())
          .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-60.0)));
      when(
        () => repository.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: any(named: 'localeCode'),
        ),
      ).thenAnswer(
        (_) async => const Left(Failure.network(message: 'Offline')),
      );

      await tester.pumpWidget(buildTestablePage());
      await tester.pumpAndSettle();

      expect(cubit.state.isTorchOn, isFalse);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(cubit.state.isTorchOn, isTrue);

      tiltController.add(Right(TiltAngleReading.fromPitch(-60.0)));
      await tester.pump(Duration.zero);
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(cubit.state.mode, ChallengeMode.bathroomBarcode);
      expect(find.byKey(const Key('mock-scanner')), findsOneWidget);
    },
  );
}
