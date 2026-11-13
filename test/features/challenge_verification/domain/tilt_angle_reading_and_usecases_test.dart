import 'dart:typed_data';

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/resolve_offline_fallback_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_bathroom_barcode_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/usecases/verify_standing_typing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockChallengeVerificationRepository extends Mock
    implements ChallengeVerificationRepository {}

void main() {
  late MockChallengeVerificationRepository repository;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    repository = MockChallengeVerificationRepository();
  });

  group('TiltAngleReading.fromPitch', () {
    test('accepts boundaries -45.0° and -90.0° and values between', () {
      expect(TiltAngleReading.fromPitch(-45.0).isWithinStandingRange, isTrue);
      expect(TiltAngleReading.fromPitch(-67.5).isWithinStandingRange, isTrue);
      expect(TiltAngleReading.fromPitch(-90.0).isWithinStandingRange, isTrue);
    });

    test('rejects angles outside -45.0°..-90.0°', () {
      expect(TiltAngleReading.fromPitch(-44.9).isWithinStandingRange, isFalse);
      expect(TiltAngleReading.fromPitch(-90.1).isWithinStandingRange, isFalse);
      expect(TiltAngleReading.fromPitch(0.0).isWithinStandingRange, isFalse);
      expect(TiltAngleReading.fromPitch(45.0).isWithinStandingRange, isFalse);
    });
  });

  group('VerifyPrayerRugPhotoUseCase', () {
    late VerifyPrayerRugPhotoUseCase useCase;

    setUp(() {
      useCase = VerifyPrayerRugPhotoUseCase(repository);
    });

    test('returns ValidationFailure when imageBytes is empty', () async {
      final result = await useCase(imageBytes: Uint8List(0), localeCode: 'en');
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'returns SensorFailure and zeroes RAM buffer when tilt is invalid',
      () async {
        when(() => repository.getCurrentTiltAngle())
            .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-20.0)));
        final Uint8List buffer = Uint8List.fromList(<int>[10, 20, 30, 40]);

        final result = await useCase(imageBytes: buffer, localeCode: 'en');

        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<SensorFailure>()),
          (_) => fail('Expected Left'),
        );
        expect(buffer.every((int b) => b == 0), isTrue);
        verifyNever(
          () => repository.verifyPrayerRugPhoto(
            imageBytes: any(named: 'imageBytes'),
            localeCode: any(named: 'localeCode'),
          ),
        );
      },
    );

    test('returns verified result and zeroes RAM buffer on success', () async {
      when(() => repository.getCurrentTiltAngle())
          .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-65.0)));
      const expected = ChallengeVerificationResult(
        isPrayerRugPresent: true,
        areFeetOnRug: true,
        isRealLivePhoto: true,
        verified: true,
        rejectionReason: '',
      );
      when(
        () => repository.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'ar',
        ),
      ).thenAnswer((_) async => const Right(expected));

      final Uint8List buffer = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);
      final result = await useCase(imageBytes: buffer, localeCode: 'ar');

      expect(
        result,
        const Right<Failure, ChallengeVerificationResult>(expected),
      );
      expect(buffer.every((int b) => b == 0), isTrue);
    });

    test('zeroes RAM buffer even when repository throws', () async {
      when(() => repository.getCurrentTiltAngle())
          .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-65.0)));
      when(
        () => repository.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(Exception('boom'));

      final Uint8List buffer = Uint8List.fromList(<int>[99, 88, 77]);
      await expectLater(
        () => useCase(imageBytes: buffer, localeCode: 'en'),
        throwsException,
      );
      expect(buffer.every((int b) => b == 0), isTrue);
    });
  });

  group('VerifyBathroomBarcodeUseCase', () {
    late VerifyBathroomBarcodeUseCase useCase;

    setUp(() {
      useCase = VerifyBathroomBarcodeUseCase(repository);
    });

    test('returns ValidationFailure on empty barcode', () async {
      final result = await useCase(scannedBarcode: '   ');
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('trims barcode and delegates to repository', () async {
      when(() => repository.verifyBathroomBarcode(scannedBarcode: '622123456'))
          .thenAnswer((_) async => const Right(true));

      final result = await useCase(scannedBarcode: ' 622123456 ');
      expect(result, const Right<Failure, bool>(true));
    });
  });

  group('VerifyStandingTypingUseCase', () {
    late VerifyStandingTypingUseCase useCase;
    final String validPrompt = 'a' * 120;

    setUp(() {
      useCase = VerifyStandingTypingUseCase(repository);
    });

    test(
      'returns ValidationFailure if expectedText is not 120 chars',
      () async {
        final result = await useCase(typedText: 'abc', expectedText: 'abc');
        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<ValidationFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test('returns SensorFailure if tilt is outside -45°..-90°', () async {
      when(() => repository.getCurrentTiltAngle())
          .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-10.0)));

      final result = await useCase(
        typedText: validPrompt,
        expectedText: validPrompt,
      );
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<SensorFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Right(false) when typed text does not match', () async {
      when(() => repository.getCurrentTiltAngle())
          .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-60.0)));

      final result = await useCase(
        typedText: '${'a' * 119}b',
        expectedText: validPrompt,
      );
      expect(result, const Right<Failure, bool>(false));
    });

    test(
      'returns Right(true) on exact 120-char match with valid tilt',
      () async {
        when(() => repository.getCurrentTiltAngle())
            .thenAnswer((_) async => Right(TiltAngleReading.fromPitch(-75.0)));
        when(
          () => repository.verifyStandingTyping(
            typedText: validPrompt,
            expectedText: validPrompt,
          ),
        ).thenAnswer((_) async => const Right(true));

        final result = await useCase(
          typedText: validPrompt,
          expectedText: validPrompt,
        );
        expect(result, const Right<Failure, bool>(true));
      },
    );
  });

  group('ResolveOfflineFallbackUseCase', () {
    late ResolveOfflineFallbackUseCase useCase;

    setUp(() {
      useCase = ResolveOfflineFallbackUseCase(repository);
    });

    test(
      'returns bathroomBarcode when camera works and barcode is registered',
      () async {
        when(() => repository.hasRegisteredBathroomBarcode())
            .thenAnswer((_) async => const Right(true));

        final result = await useCase(isCameraAvailable: true);
        expect(
          result,
          const Right<Failure, ChallengeMode>(ChallengeMode.bathroomBarcode),
        );
      },
    );

    test('returns standingTyping when no barcode is registered', () async {
      when(() => repository.hasRegisteredBathroomBarcode())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase(isCameraAvailable: true);
      expect(
        result,
        const Right<Failure, ChallengeMode>(ChallengeMode.standingTyping),
      );
    });

    test(
      'returns standingTyping immediately when camera is unavailable',
      () async {
        final result = await useCase(isCameraAvailable: false);
        expect(
          result,
          const Right<Failure, ChallengeMode>(ChallengeMode.standingTyping),
        );
        verifyNever(() => repository.hasRegisteredBathroomBarcode());
      },
    );
  });
}
