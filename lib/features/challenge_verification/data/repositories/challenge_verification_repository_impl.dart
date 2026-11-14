import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/tilt_sensor_datasource.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/repositories/challenge_verification_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

/// Concrete [ChallengeVerificationRepository] backed by Gemini Vision REST,
/// `sensors_plus` accelerometer, and `FlutterSecureStorage`.
class ChallengeVerificationRepositoryImpl
    implements ChallengeVerificationRepository {
  ChallengeVerificationRepositoryImpl({
    required this._remoteDataSource,
    required this._tiltSensorDataSource,
    required this._secureStorage,
    this.barcodeStorageKey = defaultBarcodeStorageKey,
  });

  static const String defaultBarcodeStorageKey = 'bathroom_barcode';

  final GeminiVisionRemoteDataSource _remoteDataSource;
  final TiltSensorDataSource _tiltSensorDataSource;
  final FlutterSecureStorage _secureStorage;
  final String barcodeStorageKey;

  @override
  Future<Either<Failure, ChallengeVerificationResult>> verifyPrayerRugPhoto({
    required Uint8List imageBytes,
    required String localeCode,
  }) async {
    try {
      final ChallengeVerificationResult result = await _remoteDataSource
          .verifyPrayerRugPhoto(imageBytes: imageBytes, localeCode: localeCode);
      return Right(result);
    } on GeminiApiException catch (e) {
      return Left(Failure.api(message: e.message, statusCode: e.statusCode));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } on SocketException catch (e) {
      return Left(Failure.network(message: e.message));
    } on TimeoutException catch (e) {
      return Left(
        Failure.network(message: e.message ?? 'Gemini request timed out.'),
      );
    } catch (e) {
      return Left(Failure.unexpected(message: e.toString()));
    }
  }

  Failure _mapDioException(DioException e) {
    final int? statusCode = e.response?.statusCode;
    if (statusCode != null) {
      return Failure.api(
        message: e.message ?? 'Gemini API error ($statusCode).',
        statusCode: statusCode,
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.error is SocketException) {
      return Failure.network(
        message: e.message ?? 'Network connection unavailable.',
      );
    }
    return Failure.network(message: e.message ?? 'Network error.');
  }

  @override
  Stream<Either<Failure, TiltAngleReading>> watchTiltAngle() {
    return _tiltSensorDataSource.watchTiltAngle().transform(
      StreamTransformer<
        TiltAngleReading,
        Either<Failure, TiltAngleReading>
      >.fromHandlers(
        handleData:
            (
              TiltAngleReading reading,
              EventSink<Either<Failure, TiltAngleReading>> sink,
            ) {
              sink.add(Right<Failure, TiltAngleReading>(reading));
            },
        handleError:
            (
              Object error,
              StackTrace stackTrace,
              EventSink<Either<Failure, TiltAngleReading>> sink,
            ) {
              sink.add(
                Left<Failure, TiltAngleReading>(
                  Failure.sensor(message: error.toString()),
                ),
              );
            },
      ),
    );
  }

  @override
  Future<Either<Failure, TiltAngleReading>> getCurrentTiltAngle() async {
    try {
      final TiltAngleReading reading = await _tiltSensorDataSource
          .getCurrentTiltAngle();
      return Right(reading);
    } on TimeoutException {
      return const Left(
        Failure.sensor(message: 'Accelerometer reading timed out.'),
      );
    } catch (e) {
      return Left(Failure.sensor(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyBathroomBarcode({
    required String scannedBarcode,
  }) async {
    try {
      final String? registered = await _secureStorage.read(
        key: barcodeStorageKey,
      );
      if (registered == null || registered.trim().isEmpty) {
        return const Left(
          Failure.cache(message: 'No bathroom barcode registered.'),
        );
      }
      return Right(scannedBarcode.trim() == registered.trim());
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyStandingTyping({
    required String typedText,
    required String expectedText,
  }) async {
    if (expectedText.length != 120 || typedText.length != 120) {
      return const Right(false);
    }
    return Right(typedText == expectedText);
  }

  @override
  Future<Either<Failure, bool>> hasRegisteredBathroomBarcode() async {
    try {
      final String? registered = await _secureStorage.read(
        key: barcodeStorageKey,
      );
      return Right(registered != null && registered.trim().isNotEmpty);
    } catch (e) {
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
