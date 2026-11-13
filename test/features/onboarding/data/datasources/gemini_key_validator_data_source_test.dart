import 'package:dio/dio.dart';
import 'package:fajr_alarm/features/onboarding/data/datasources/gemini_key_validator_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late GeminiKeyValidatorDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = MockDio();
    dataSource = GeminiKeyValidatorDataSourceImpl(dio);
  });

  test('returns true on HTTP 200 and sends x-goog-api-key header', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options')))
        .thenAnswer(
          (_) async => Response<dynamic>(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ),
        );

    final bool result = await dataSource.validateKey('AIzaValidKey');

    expect(result, isTrue);
    final VerificationResult captured = verify(
      () => dio.get<dynamic>(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite',
        options: captureAny(named: 'options'),
      ),
    );
    final Options options = captured.captured.single as Options;
    expect(options.headers?['x-goog-api-key'], 'AIzaValidKey');
  });

  test('returns false on HTTP 401 or 403', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options')))
        .thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: ''),
              statusCode: 403,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

    final bool result = await dataSource.validateKey('bad-key');
    expect(result, isFalse);
  });

  test('throws GeminiQuotaException on HTTP 429', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options')))
        .thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: ''),
              statusCode: 429,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

    expect(
      () => dataSource.validateKey('rate-limited'),
      throwsA(isA<GeminiQuotaException>()),
    );
  });

  test('throws GeminiNetworkException on connection timeout', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options')))
        .thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

    expect(
      () => dataSource.validateKey('any-key'),
      throwsA(isA<GeminiNetworkException>()),
    );
  });

  test('throws GeminiApiException on HTTP 500', () async {
    when(() => dio.get<dynamic>(any(), options: any(named: 'options')))
        .thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
            ),
            type: DioExceptionType.badResponse,
          ),
        );

    expect(
      () => dataSource.validateKey('any-key'),
      throwsA(isA<GeminiApiException>()),
    );
  });
}
