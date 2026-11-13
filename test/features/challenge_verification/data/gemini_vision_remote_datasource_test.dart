import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fajr_alarm/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockDio dio;
  late MockFlutterSecureStorage secureStorage;
  late GeminiVisionRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    secureStorage = MockFlutterSecureStorage();
    dataSource = GeminiVisionRemoteDataSource(
      dio: dio,
      secureStorage: secureStorage,
    );
  });

  Response<dynamic> buildSuccessResponse({
    required bool rug,
    required bool feet,
    required bool live,
    required bool verified,
    String reason = '',
  }) {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: ''),
      statusCode: 200,
      data: <String, dynamic>{
        'candidates': <Map<String, dynamic>>[
          <String, dynamic>{
            'content': <String, dynamic>{
              'parts': <Map<String, dynamic>>[
                <String, dynamic>{
                  'text': jsonEncode(<String, dynamic>{
                    'is_prayer_rug_present': rug,
                    'are_feet_on_rug': feet,
                    'is_real_live_photo': live,
                    'verified': verified,
                    'rejection_reason': reason,
                  }),
                },
              ],
            },
          },
        ],
      },
    );
  }

  test(
    'calls gemini-2.5-flash-lite with x-goog-api-key, schema, and purges RAM',
    () async {
      when(
        () => secureStorage.read(
          key: GeminiVisionRemoteDataSource.defaultApiKeyStorageKey,
        ),
      ).thenAnswer((_) async => 'test-byok-key');

      when(
        () => dio.post<dynamic>(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => buildSuccessResponse(
          rug: true,
          feet: true,
          live: true,
          verified: true,
        ),
      );

      final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3, 4]);
      final result = await dataSource.verifyPrayerRugPhoto(
        imageBytes: bytes,
        localeCode: 'en',
      );

      expect(result.verified, isTrue);
      expect(result.isPrayerRugPresent, isTrue);
      expect(result.areFeetOnRug, isTrue);
      expect(result.isRealLivePhoto, isTrue);
      expect(bytes.every((int b) => b == 0), isTrue);

      final VerificationResult captured = verify(
        () => dio.post<dynamic>(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        ),
      );
      final Map<String, dynamic> body =
          captured.captured[0] as Map<String, dynamic>;
      final Options options = captured.captured[1] as Options;
      expect(options.headers?['x-goog-api-key'], 'test-byok-key');
      final Map<String, dynamic> genConfig =
          body['generationConfig'] as Map<String, dynamic>;
      expect(genConfig['temperature'], 0.1);
      expect(genConfig['responseMimeType'], 'application/json');
      expect(genConfig['responseSchema'], isNotNull);
    },
  );

  test('falls back to gemini-2.5-flash when primary model fails', () async {
    when(
      () => secureStorage.read(
        key: GeminiVisionRemoteDataSource.defaultApiKeyStorageKey,
      ),
    ).thenAnswer((_) async => 'test-byok-key');

    when(
      () => dio.post<dynamic>(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 503,
        ),
      ),
    );

    when(
      () => dio.post<dynamic>(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => buildSuccessResponse(
        rug: true,
        feet: true,
        live: true,
        verified: true,
      ),
    );

    final Uint8List bytes = Uint8List.fromList(<int>[5, 6, 7]);
    final result = await dataSource.verifyPrayerRugPhoto(
      imageBytes: bytes,
      localeCode: 'ar',
    );

    expect(result.verified, isTrue);
    expect(bytes.every((int b) => b == 0), isTrue);
  });

  test(
    'throws GeminiApiException(403) and purges RAM when key missing',
    () async {
      when(
        () => secureStorage.read(
          key: GeminiVisionRemoteDataSource.defaultApiKeyStorageKey,
        ),
      ).thenAnswer((_) async => null);

      final Uint8List bytes = Uint8List.fromList(<int>[11, 22, 33]);
      await expectLater(
        () => dataSource.verifyPrayerRugPhoto(
          imageBytes: bytes,
          localeCode: 'en',
        ),
        throwsA(
          isA<GeminiApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            403,
          ),
        ),
      );
      expect(bytes.every((int b) => b == 0), isTrue);
    },
  );

  test('forces verified=false when any of the 3 conditions is false', () async {
    when(
      () => secureStorage.read(
        key: GeminiVisionRemoteDataSource.defaultApiKeyStorageKey,
      ),
    ).thenAnswer((_) async => 'test-byok-key');

    when(
      () => dio.post<dynamic>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => buildSuccessResponse(
        rug: true,
        feet: false,
        live: true,
        verified: true,
        reason: 'Feet not visible',
      ),
    );

    final result = await dataSource.verifyPrayerRugPhoto(
      imageBytes: Uint8List.fromList(<int>[1]),
      localeCode: 'en',
    );
    expect(result.verified, isFalse);
  });
}
