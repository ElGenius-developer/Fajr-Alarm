import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/tilt_sensor_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/data/repositories/challenge_verification_repository_impl.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MockGeminiVisionRemoteDataSource extends Mock
    implements GeminiVisionRemoteDataSource {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('TiltSensorDataSource', () {
    test('calculates pitch degrees accurately for key orientations', () {
      expect(
        TiltSensorDataSource.calculatePitchDegrees(0, 0, 9.8),
        closeTo(0.0, 0.1),
      );
      expect(
        TiltSensorDataSource.calculatePitchDegrees(0, 6.93, 6.93),
        closeTo(-45.0, 0.5),
      );
      expect(
        TiltSensorDataSource.calculatePitchDegrees(0, 9.8, 0),
        closeTo(-90.0, 0.1),
      );
      expect(
        TiltSensorDataSource.calculatePitchDegrees(0, 6.93, -6.93),
        closeTo(-135.0, 0.5),
      );
    });

    test('streams and reads current tilt angle from accelerometer', () async {
      final controller = StreamController<AccelerometerEvent>.broadcast();
      final dataSource = TiltSensorDataSource(
        accelerometerStream: controller.stream,
      );

      final Future<TiltAngleReading> nextReading = dataSource
          .getCurrentTiltAngle();
      controller.add(AccelerometerEvent(0, 0, 9.8, DateTime.now()));
      final TiltAngleReading reading = await nextReading;

      expect(reading.isWithinStandingRange, isTrue);
      expect(reading.pitchDegrees, closeTo(0.0, 0.1));
      await controller.close();
    });
  });

  group('ChallengeVerificationRepositoryImpl', () {
    late MockGeminiVisionRemoteDataSource remote;
    late MockFlutterSecureStorage secureStorage;
    late StreamController<AccelerometerEvent> accelController;
    late ChallengeVerificationRepositoryImpl repository;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      remote = MockGeminiVisionRemoteDataSource();
      secureStorage = MockFlutterSecureStorage();
      accelController = StreamController<AccelerometerEvent>.broadcast();
      repository = ChallengeVerificationRepositoryImpl(
        remoteDataSource: remote,
        tiltSensorDataSource: TiltSensorDataSource(
          accelerometerStream: accelController.stream,
        ),
        secureStorage: secureStorage,
      );
    });

    tearDown(() async {
      await accelController.close();
    });

    test('maps HTTP 429, 403, 500 DioExceptions to ApiFailure', () async {
      for (final int code in <int>[429, 403, 500]) {
        when(
          () => remote.verifyPrayerRugPhoto(
            imageBytes: any(named: 'imageBytes'),
            localeCode: 'en',
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: ''),
              statusCode: code,
            ),
          ),
        );

        final result = await repository.verifyPrayerRugPhoto(
          imageBytes: Uint8List.fromList(<int>[1]),
          localeCode: 'en',
        );
        result.fold(
          (f) => expect(
            f,
            isA<ApiFailure>().having((e) => e.statusCode, 'statusCode', code),
          ),
          (_) => fail('Expected Left'),
        );
      }
    });

    test('maps timeout and SocketException to NetworkFailure', () async {
      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final timeoutResult = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      timeoutResult.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );

      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(const SocketException('No internet'));

      final socketResult = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      socketResult.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('verifies registered bathroom barcode', () async {
      when(
        () => secureStorage.read(
          key: ChallengeVerificationRepositoryImpl.defaultBarcodeStorageKey,
        ),
      ).thenAnswer((_) async => '622000111');

      final matched = await repository.verifyBathroomBarcode(
        scannedBarcode: '622000111',
      );
      final mismatched = await repository.verifyBathroomBarcode(
        scannedBarcode: '999999999',
      );
      final hasBarcode = await repository.hasRegisteredBathroomBarcode();

      expect(matched.getOrElse((_) => false), isTrue);
      expect(mismatched.getOrElse((_) => true), isFalse);
      expect(hasBarcode.getOrElse((_) => false), isTrue);
    });

    test(
      'verifies standing typing and handles missing barcode / watchTiltAngle',
      () async {
        when(
          () => secureStorage.read(
            key: ChallengeVerificationRepositoryImpl.defaultBarcodeStorageKey,
          ),
        ).thenAnswer((_) async => null);

        final missingBarcode = await repository.verifyBathroomBarcode(
          scannedBarcode: '123',
        );
        expect(missingBarcode.isLeft(), isTrue);

        final hasNoBarcode = await repository.hasRegisteredBathroomBarcode();
        expect(hasNoBarcode.getOrElse((_) => true), isFalse);

        final validTyping = await repository.verifyStandingTyping(
          typedText: 'a' * 120,
          expectedText: 'a' * 120,
        );
        final invalidTyping = await repository.verifyStandingTyping(
          typedText: 'short',
          expectedText: 'a' * 120,
        );
        expect(validTyping.getOrElse((_) => false), isTrue);
        expect(invalidTyping.getOrElse((_) => true), isFalse);

        final readings = <TiltAngleReading>[];
        final sub = repository.watchTiltAngle().listen((either) {
          either.fold((_) {}, readings.add);
        });
        accelController.add(AccelerometerEvent(0, 0, 9.8, DateTime.now()));
        await Future<void>.delayed(Duration.zero);
        expect(readings, hasLength(1));
        expect(readings.first.isWithinStandingRange, isTrue);
        await sub.cancel();
      },
    );

    test('returns verified result and maps GeminiApiException/Timeout/unexpected/generic Dio', () async {
      const verifiedResult = ChallengeVerificationResult(
        isPrayerRugPresent: true,
        areFeetOnRug: true,
        isRealLivePhoto: true,
        verified: true,
        rejectionReason: '',
      );
      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenAnswer((_) async => verifiedResult);

      final ok = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1, 2]),
        localeCode: 'en',
      );
      expect(ok.getOrElse((_) => throw Exception()), verifiedResult);

      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(
        const GeminiApiException(message: 'bad key', statusCode: 401),
      );
      final apiErr = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      apiErr.fold(
        (f) => expect(f, isA<ApiFailure>()),
        (_) => fail('Expected ApiFailure'),
      );

      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(TimeoutException('slow'));
      final timeoutErr = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      timeoutErr.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected NetworkFailure'),
      );

      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.cancel,
        ),
      );
      final dioOther = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      dioOther.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected NetworkFailure'),
      );

      when(
        () => remote.verifyPrayerRugPhoto(
          imageBytes: any(named: 'imageBytes'),
          localeCode: 'en',
        ),
      ).thenThrow(StateError('boom'));
      final unexpectedErr = await repository.verifyPrayerRugPhoto(
        imageBytes: Uint8List.fromList(<int>[1]),
        localeCode: 'en',
      );
      unexpectedErr.fold(
        (f) => expect(f, isA<UnexpectedFailure>()),
        (_) => fail('Expected UnexpectedFailure'),
      );
    });

    test('maps getCurrentTiltAngle, watchTiltAngle errors, and secure storage failures', () async {
      final futureReading = repository.getCurrentTiltAngle();
      accelController.add(AccelerometerEvent(0, 6.93, 6.93, DateTime.now()));
      final readingResult = await futureReading;
      expect(readingResult.isRight(), isTrue);

      final errors = <Failure>[];
      final errSub = repository.watchTiltAngle().listen((either) {
        either.fold(errors.add, (_) {});
      });
      accelController.addError(StateError('sensor error'));
      await Future<void>.delayed(Duration.zero);
      expect(errors, hasLength(1));
      expect(errors.first, isA<SensorFailure>());
      await errSub.cancel();

      final closedRepo = ChallengeVerificationRepositoryImpl(
        remoteDataSource: remote,
        tiltSensorDataSource: TiltSensorDataSource(
          accelerometerStream: const Stream<AccelerometerEvent>.empty(),
        ),
        secureStorage: secureStorage,
      );
      final closedTilt = await closedRepo.getCurrentTiltAngle();
      closedTilt.fold(
        (f) => expect(f, isA<SensorFailure>()),
        (_) => fail('Expected SensorFailure'),
      );

      final timeoutRepo = ChallengeVerificationRepositoryImpl(
        remoteDataSource: remote,
        tiltSensorDataSource: TiltSensorDataSource(
          accelerometerStream: Stream<AccelerometerEvent>.error(
            TimeoutException('sensor timeout'),
          ),
        ),
        secureStorage: secureStorage,
      );
      final timeoutTilt = await timeoutRepo.getCurrentTiltAngle();
      timeoutTilt.fold(
        (f) => expect(f, isA<SensorFailure>()),
        (_) => fail('Expected SensorFailure'),
      );

      when(() => secureStorage.read(key: any(named: 'key')))
          .thenThrow(Exception('keychain err'));
      final verifyErr = await repository.verifyBathroomBarcode(
        scannedBarcode: '123',
      );
      final hasErr = await repository.hasRegisteredBathroomBarcode();
      expect(verifyErr.isLeft(), isTrue);
      expect(hasErr.isLeft(), isTrue);
    });
  });
}
