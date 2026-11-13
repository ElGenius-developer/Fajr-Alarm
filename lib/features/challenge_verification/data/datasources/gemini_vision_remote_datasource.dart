import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_verification_result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Exception thrown when Gemini Vision REST calls fail or return invalid payloads.
class GeminiApiException implements Exception {
  const GeminiApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'GeminiApiException($statusCode): $message';
}

/// Remote data source calling the Gemini REST `generateContent` endpoint.
class GeminiVisionRemoteDataSource {
  GeminiVisionRemoteDataSource({
    required this._dio,
    required this._secureStorage,
    this.apiKeyStorageKey = defaultApiKeyStorageKey,
  });

  static const String defaultApiKeyStorageKey = 'gemini_api_key';
  static const String primaryModel = 'gemini-2.5-flash-lite';
  static const String fallbackModel = 'gemini-2.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static const String systemInstruction =
      'You are a fair, pragmatic verification judge for a Fajr prayer wake-up alarm. '
      'Analyze the user\'s live POV photo and verify three conditions: '
      '1) A prayer rug (Sajjada) is visible on the floor. '
      '2) At least one human foot (barefoot or in socks) is clearly standing on the prayer rug. '
      '3) It appears to be a real live room photo, NOT a photo of a digital screen, monitor, smartphone, or printed picture. '
      'If the user clearly woke up and stood on the prayer rug, accept it without unnecessary strictness. '
      'Respond strictly in JSON matching the schema.';

  static const Map<String, dynamic> responseSchema = <String, dynamic>{
    'type': 'OBJECT',
    'properties': <String, dynamic>{
      'is_prayer_rug_present': <String, dynamic>{'type': 'BOOLEAN'},
      'are_feet_on_rug': <String, dynamic>{'type': 'BOOLEAN'},
      'is_real_live_photo': <String, dynamic>{'type': 'BOOLEAN'},
      'verified': <String, dynamic>{'type': 'BOOLEAN'},
      'rejection_reason': <String, dynamic>{'type': 'STRING'},
    },
    'required': <String>[
      'is_prayer_rug_present',
      'are_feet_on_rug',
      'is_real_live_photo',
      'verified',
      'rejection_reason',
    ],
  };

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final String apiKeyStorageKey;

  /// Verifies [imageBytes] via [primaryModel], falling back to [fallbackModel]
  /// if the primary call fails. Zeroes [imageBytes] in `finally` (< 500ms).
  Future<ChallengeVerificationResult> verifyPrayerRugPhoto({
    required Uint8List imageBytes,
    required String localeCode,
  }) async {
    try {
      final String? apiKey = await _secureStorage.read(key: apiKeyStorageKey);
      if (apiKey == null || apiKey.trim().isEmpty) {
        throw const GeminiApiException(
          statusCode: 403,
          message: 'Missing Gemini API key in secure storage.',
        );
      }

      final String encodedImage = base64Encode(imageBytes);
      final Map<String, dynamic> body = _buildRequestBody(
        encodedImage: encodedImage,
        localeCode: localeCode,
      );

      try {
        return await _callModel(
          model: primaryModel,
          apiKey: apiKey.trim(),
          body: body,
        );
      } on Object {
        // Fall back to gemini-2.5-flash when primary fails or rejects.
        return await _callModel(
          model: fallbackModel,
          apiKey: apiKey.trim(),
          body: body,
        );
      }
    } finally {
      if (imageBytes.isNotEmpty) {
        imageBytes.fillRange(0, imageBytes.length, 0);
      }
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required String encodedImage,
    required String localeCode,
  }) {
    return <String, dynamic>{
      'system_instruction': <String, dynamic>{
        'parts': <Map<String, dynamic>>[
          <String, dynamic>{'text': systemInstruction},
        ],
      },
      'contents': <Map<String, dynamic>>[
        <String, dynamic>{
          'parts': <Map<String, dynamic>>[
            <String, dynamic>{
              'text':
                  'Verify this live POV photo. Active locale for rejection_reason: $localeCode',
            },
            <String, dynamic>{
              'inline_data': <String, dynamic>{
                'mime_type': 'image/jpeg',
                'data': encodedImage,
              },
            },
          ],
        },
      ],
      'generationConfig': <String, dynamic>{
        'temperature': 0.1,
        'responseMimeType': 'application/json',
        'responseSchema': responseSchema,
      },
    };
  }

  Future<ChallengeVerificationResult> _callModel({
    required String model,
    required String apiKey,
    required Map<String, dynamic> body,
  }) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      '$_baseUrl/$model:generateContent',
      data: body,
      options: Options(
        headers: <String, dynamic>{
          'x-goog-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    final int? statusCode = response.statusCode;
    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw GeminiApiException(
        statusCode: statusCode,
        message: 'Gemini API returned HTTP $statusCode.',
      );
    }

    return _parseResponse(response.data);
  }

  ChallengeVerificationResult _parseResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const GeminiApiException(
        message: 'Unexpected non-map response from Gemini API.',
      );
    }

    final dynamic candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw const GeminiApiException(
        message: 'No candidates returned from Gemini API.',
      );
    }

    final dynamic firstCandidate = candidates.first;
    if (firstCandidate is! Map<String, dynamic>) {
      throw const GeminiApiException(message: 'Invalid candidate format.');
    }

    final dynamic content = firstCandidate['content'];
    if (content is! Map<String, dynamic>) {
      throw const GeminiApiException(message: 'Missing content in candidate.');
    }

    final dynamic parts = content['parts'];
    if (parts is! List || parts.isEmpty) {
      throw const GeminiApiException(message: 'Missing parts in content.');
    }

    final dynamic firstPart = parts.first;
    if (firstPart is! Map<String, dynamic>) {
      throw const GeminiApiException(message: 'Invalid part format.');
    }

    final dynamic rawText = firstPart['text'];
    if (rawText is! String || rawText.trim().isEmpty) {
      throw const GeminiApiException(message: 'Empty JSON text in response.');
    }

    final dynamic decoded = jsonDecode(rawText);
    if (decoded is! Map<String, dynamic>) {
      throw const GeminiApiException(
        message: 'Decoded Gemini JSON is not an object.',
      );
    }

    final ChallengeVerificationResult parsed =
        ChallengeVerificationResult.fromJson(decoded);
    final bool allThreePass =
        parsed.isPrayerRugPresent &&
        parsed.areFeetOnRug &&
        parsed.isRealLivePhoto;
    return parsed.copyWith(verified: parsed.verified && allThreePass);
  }
}
