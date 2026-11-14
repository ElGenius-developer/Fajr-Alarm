import 'package:dio/dio.dart';

/// Exception thrown when Gemini API key validation fails due to an HTTP error.
final class GeminiApiException implements Exception {
  const GeminiApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;
}

/// Exception thrown when Gemini API returns HTTP 429 quota exceeded.
final class GeminiQuotaException implements Exception {
  const GeminiQuotaException({required this.message});

  final String message;
}

/// Exception thrown when Gemini API cannot be reached due to network issues.
final class GeminiNetworkException implements Exception {
  const GeminiNetworkException({required this.message});

  final String message;
}

/// Contract for live Gemini API key validation.
abstract interface class GeminiKeyValidatorDataSource {
  Future<bool> validateKey(String apiKey);
}

/// Validates a BYOK Gemini API key via a minimal `models` GET request with `x-goog-api-key`.
final class GeminiKeyValidatorDataSourceImpl
    implements GeminiKeyValidatorDataSource {
  const GeminiKeyValidatorDataSourceImpl(this._dio);

  static const String _modelsCheckUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite';

  final Dio _dio;

  @override
  Future<bool> validateKey(String apiKey) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        _modelsCheckUrl,
        options: Options(headers: <String, String>{'x-goog-api-key': apiKey}),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      final int? statusCode = e.response?.statusCode;
      if (statusCode == 429) {
        throw const GeminiQuotaException(
          message: 'Gemini API quota exceeded (429).',
        );
      }
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        return false;
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw GeminiNetworkException(
          message: e.message ?? 'Network error while validating Gemini key.',
        );
      }
      if (statusCode != null) {
        throw GeminiApiException(
          message: 'Gemini API error ($statusCode).',
          statusCode: statusCode,
        );
      }
      throw GeminiNetworkException(
        message: e.message ?? 'Unable to reach Gemini API.',
      );
    }
  }
}
