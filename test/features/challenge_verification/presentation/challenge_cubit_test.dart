import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/resolve_offline_fallback_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_standing_typing_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockVerifyPrayerRugPhotoUseCase extends Mock
    implements VerifyPrayerRugPhotoUseCase {}

class MockVerifyBathroomBarcodeUseCase extends Mock
    implements VerifyBathroomBarcodeUseCase {}

class MockVerifyStandingTypingUseCase extends Mock
    implements VerifyStandingTypingUseCase {}

class MockResolveOfflineFallbackUseCase extends Mock
    implements ResolveOfflineFallbackUseCase {}

class MockChallengeVerificationRepository extends Mock
    implements ChallengeVerificationRepository {}

void main() {
  late MockVerifyPrayerRugPhotoUseCase verifyPhoto;
  late MockVerifyBathroomBarcodeUseCase verifyBarcode;
  late MockVerifyStandingTypingUseCase verifyTyping;
  late MockResolveOfflineFallbackUseCase resolveFallback;
  late MockChallengeVerificationRepository repository;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    verifyPhoto = MockVerifyPrayerRugPhotoUseCase();
    verifyBarcode = MockVerifyBathroomBarcodeUseCase();
    verifyTyping = MockVerifyStandingTypingUseCase();
    resolveFallback = MockResolveOfflineFallbackUseCase();
    repository = MockChallengeVerificationRepository();
    when(() => repository.watchTiltAngle()).thenAnswer(
      (_) => const Stream<Either<Failure, TiltAngleReading>>.empty(),
    );
  });

  ChallengeCubit buildCubit() => ChallengeCubit(
    verifyPrayerRugPhoto: verifyPhoto,
    verifyBathroomBarcode: verifyBarcode,
    verifyStandingTyping: verifyTyping,
    resolveOfflineFallback: resolveFallback,
    repository: repository,
  );

  group('ChallengeCubit', () {
    blocTest<ChallengeCubit, ChallengeState>(
      'emits verified when submitPhoto succeeds',
      build: buildCubit,
      setUp: () {
        when(
          () => verifyPhoto(
            imageBytes: any(named: 'imageBytes'),
            localeCode: 'en',
          ),
        ).thenAnswer(
          (_) async => const Right(
            ChallengeVerificationResult(
              isPrayerRugPresent: true,
              areFeetOnRug: true,
              isRealLivePhoto: true,
              verified: true,
              rejectionReason: '',
            ),
          ),
        );
      },
      act: (cubit) => cubit.submitPhoto(
        imageBytes: Uint8List.fromList(<int>[1, 2]),
        localeCode: 'en',
      ),
      expect: () => <ChallengeState>[
        const ChallengeState(status: ChallengeStatus.verifying),
        const ChallengeState(
          status: ChallengeStatus.verified,
          verificationResult: ChallengeVerificationResult(
            isPrayerRugPresent: true,
            areFeetOnRug: true,
            isRealLivePhoto: true,
            verified: true,
            rejectionReason: '',
          ),
        ),
      ],
    );

    for (final Failure apiOrNetworkFailure in <Failure>[
      const Failure.api(message: 'Rate limited', statusCode: 429),
      const Failure.api(message: 'Forbidden', statusCode: 403),
      const Failure.api(message: 'Server error', statusCode: 500),
      const Failure.network(message: 'Timeout'),
    ]) {
      blocTest<ChallengeCubit, ChallengeState>(
        'triggers offline fallback to bathroomBarcode on $apiOrNetworkFailure',
        build: buildCubit,
        setUp: () {
          when(
            () => verifyPhoto(
              imageBytes: any(named: 'imageBytes'),
              localeCode: 'en',
            ),
          ).thenAnswer((_) async => Left(apiOrNetworkFailure));
          when(
            () => resolveFallback(isCameraAvailable: true),
          ).thenAnswer((_) async => const Right(ChallengeMode.bathroomBarcode));
        },
        act: (cubit) => cubit.submitPhoto(
          imageBytes: Uint8List.fromList(<int>[1, 2]),
          localeCode: 'en',
        ),
        expect: () => <ChallengeState>[
          const ChallengeState(status: ChallengeStatus.verifying),
          ChallengeState(
            mode: ChallengeMode.bathroomBarcode,
            status: ChallengeStatus.fallbackTriggered,
            failure: apiOrNetworkFailure,
          ),
        ],
      );
    }

    blocTest<ChallengeCubit, ChallengeState>(
      'switches to standingTyping when camera is unavailable',
      build: buildCubit,
      setUp: () {
        when(() => resolveFallback(isCameraAvailable: false))
            .thenAnswer((_) async => const Right(ChallengeMode.standingTyping));
      },
      act: (cubit) => cubit.reportCameraUnavailable(),
      expect: () => <ChallengeState>[
        const ChallengeState(isCameraAvailable: false),
        const ChallengeState(
          mode: ChallengeMode.standingTyping,
          status: ChallengeStatus.fallbackTriggered,
          isCameraAvailable: false,
          failure: Failure.camera(message: 'Camera unavailable'),
        ),
      ],
    );

    blocTest<ChallengeCubit, ChallengeState>(
      'verifies bathroom barcode match',
      build: buildCubit,
      setUp: () {
        when(() => verifyBarcode(scannedBarcode: '123456'))
            .thenAnswer((_) async => const Right(true));
      },
      act: (cubit) => cubit.submitBarcode('123456'),
      expect: () => <ChallengeState>[
        const ChallengeState(status: ChallengeStatus.verifying),
        const ChallengeState(status: ChallengeStatus.verified),
      ],
    );

    blocTest<ChallengeCubit, ChallengeState>(
      'verifies standing typing 120-char match',
      build: buildCubit,
      setUp: () {
        when(() => verifyTyping(typedText: 'x' * 120, expectedText: 'x' * 120))
            .thenAnswer((_) async => const Right(true));
      },
      act: (cubit) async {
        cubit.setTypingPrompt('x' * 120);
        cubit.updateTypedText('x' * 120);
        await cubit.submitStandingTyping();
      },
      expect: () => <ChallengeState>[
        ChallengeState(typingPrompt: 'x' * 120),
        ChallengeState(typingPrompt: 'x' * 120, typedText: 'x' * 120),
        ChallengeState(
          typingPrompt: 'x' * 120,
          typedText: 'x' * 120,
          status: ChallengeStatus.verifying,
        ),
        ChallengeState(
          typingPrompt: 'x' * 120,
          typedText: 'x' * 120,
          status: ChallengeStatus.verified,
        ),
      ],
    );
  });
}
