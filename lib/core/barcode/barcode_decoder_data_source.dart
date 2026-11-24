import 'package:flutter/services.dart';

/// Platform-channel bridge to the native FOSS barcode decoder
/// (`com.google.zxing:core` on Android, Apple `Vision` on iOS).
final class BarcodeDecoderDataSource {
  BarcodeDecoderDataSource({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  /// Canonical MethodChannel name shared with Android Kotlin & iOS Swift.
  static const String channelName = 'com.elgenius.fajralarm/barcode_decoder';

  final MethodChannel _channel;

  /// Decodes a single camera image plane and returns the trimmed barcode payload,
  /// or `null` when no barcode is detected or the platform decoder is unavailable.
  Future<String?> decodeFrame({
    required Uint8List bytes,
    required int width,
    required int height,
    required int bytesPerRow,
    required String format,
  }) async {
    if (bytes.isEmpty || width <= 0 || height <= 0 || bytesPerRow <= 0) {
      return null;
    }

    try {
      final String? raw = await _channel.invokeMethod<String>(
        'decodeFrame',
        <String, Object>{
          'bytes': bytes,
          'width': width,
          'height': height,
          'bytesPerRow': bytesPerRow,
          'format': format,
        },
      );
      final String? trimmed = raw?.trim();
      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }
      return trimmed;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
