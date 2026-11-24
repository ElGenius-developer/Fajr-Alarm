import 'package:fajr_alarm/core/barcode/barcode_decoder_data_source.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    BarcodeDecoderDataSource.channelName,
  );
  late BarcodeDecoderDataSource dataSource;

  setUp(() {
    dataSource = BarcodeDecoderDataSource(channel: channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'decodeFrame sends expected arguments and returns trimmed payload',
    () async {
      MethodCall? capturedCall;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            capturedCall = call;
            return ' 6221234567890 ';
          });

      final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3, 4]);
      final String? result = await dataSource.decodeFrame(
        bytes: bytes,
        width: 2,
        height: 2,
        bytesPerRow: 2,
        format: 'yuv420',
      );

      expect(result, '6221234567890');
      expect(capturedCall?.method, 'decodeFrame');
      expect(capturedCall?.arguments, <String, Object>{
        'bytes': bytes,
        'width': 2,
        'height': 2,
        'bytesPerRow': 2,
        'format': 'yuv420',
      });
    },
  );

  test(
    'decodeFrame returns null when no barcode is found or payload is blank',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => '   ');

      final String? blankResult = await dataSource.decodeFrame(
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
        width: 2,
        height: 2,
        bytesPerRow: 2,
        format: 'yuv420',
      );
      expect(blankResult, isNull);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => null);

      final String? nullResult = await dataSource.decodeFrame(
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
        width: 2,
        height: 2,
        bytesPerRow: 2,
        format: 'bgra8888',
      );
      expect(nullResult, isNull);
    },
  );

  test(
    'decodeFrame returns null on PlatformException or MissingPluginException',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async {
            throw PlatformException(code: 'DECODE_ERROR', message: 'Boom');
          });

      final String? platformErrResult = await dataSource.decodeFrame(
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
        width: 2,
        height: 2,
        bytesPerRow: 2,
        format: 'yuv420',
      );
      expect(platformErrResult, isNull);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);

      final String? missingPluginResult = await dataSource.decodeFrame(
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
        width: 2,
        height: 2,
        bytesPerRow: 2,
        format: 'yuv420',
      );
      expect(missingPluginResult, isNull);
    },
  );

  test(
    'decodeFrame short-circuits invalid dimensions without invoking channel',
    () async {
      bool called = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async {
            called = true;
            return '123';
          });

      expect(
        await dataSource.decodeFrame(
          bytes: Uint8List(0),
          width: 2,
          height: 2,
          bytesPerRow: 2,
          format: 'yuv420',
        ),
        isNull,
      );
      expect(
        await dataSource.decodeFrame(
          bytes: Uint8List.fromList(<int>[1]),
          width: 0,
          height: 2,
          bytesPerRow: 2,
          format: 'yuv420',
        ),
        isNull,
      );
      expect(called, isFalse);
    },
  );
}
