import 'package:fajr_alarm/features/alarm_ringing/data/datasources/alarm_platform_data_source.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.elgenius.fajralarm/alarm_platform');
  late AlarmPlatformDataSource dataSource;
  late List<MethodCall> recordedCalls;

  setUp(() {
    recordedCalls = <MethodCall>[];
    dataSource = AlarmPlatformDataSource(channel: channel);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          recordedCalls.add(call);
          switch (call.method) {
            case 'canUseFullScreenIntent':
              return true;
            case 'isIgnoringBatteryOptimizations':
              return false;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AlarmPlatformDataSource MethodChannel contract', () {
    test('scheduleAlarm sends epochMillis and isDryRun', () async {
      final scheduledAt = DateTime.utc(2026, 11, 14, 4, 45);
      await dataSource.scheduleAlarm(scheduledAt: scheduledAt, isDryRun: true);

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'scheduleAlarm');
      expect(recordedCalls.first.arguments, <String, Object?>{
        'scheduledAtEpochMillis': scheduledAt.millisecondsSinceEpoch,
        'isDryRun': true,
      });
    });

    test('cancelAllAlarms invokes cancelAllAlarms', () async {
      await dataSource.cancelAllAlarms();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'cancelAllAlarms');
    });

    test('startRinging sends isDryRun', () async {
      await dataSource.startRinging(isDryRun: false);

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'startRinging');
      expect(recordedCalls.first.arguments, <String, Object?>{
        'isDryRun': false,
      });
    });

    test('stopRinging invokes stopRinging', () async {
      await dataSource.stopRinging();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'stopRinging');
    });

    test('muteRingingAudio invokes muteRingingAudio', () async {
      await dataSource.muteRingingAudio();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'muteRingingAudio');
    });

    test('unmuteRingingAudio invokes unmuteRingingAudio', () async {
      await dataSource.unmuteRingingAudio();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'unmuteRingingAudio');
    });

    test('enableScreenPinning invokes enableScreenPinning', () async {
      await dataSource.enableScreenPinning();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'enableScreenPinning');
    });

    test('disableScreenPinning invokes disableScreenPinning', () async {
      await dataSource.disableScreenPinning();

      expect(recordedCalls, hasLength(1));
      expect(recordedCalls.first.method, 'disableScreenPinning');
    });

    test('canUseFullScreenIntent returns bool from channel', () async {
      final result = await dataSource.canUseFullScreenIntent();

      expect(result, isTrue);
      expect(recordedCalls.single.method, 'canUseFullScreenIntent');
    });

    test('requestFullScreenIntentPermission invokes channel', () async {
      await dataSource.requestFullScreenIntentPermission();

      expect(recordedCalls.single.method, 'requestFullScreenIntentPermission');
    });

    test('isIgnoringBatteryOptimizations returns bool from channel', () async {
      final result = await dataSource.isIgnoringBatteryOptimizations();

      expect(result, isFalse);
      expect(recordedCalls.single.method, 'isIgnoringBatteryOptimizations');
    });

    test('requestIgnoreBatteryOptimizations invokes channel', () async {
      await dataSource.requestIgnoreBatteryOptimizations();

      expect(recordedCalls.single.method, 'requestIgnoreBatteryOptimizations');
    });

    test('propagates PlatformException from channel', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            throw PlatformException(
              code: 'ALARM_ERROR',
              message: 'Exact alarm failed',
            );
          });

      await expectLater(
        () => dataSource.scheduleAlarm(
          scheduledAt: DateTime.utc(2026, 11, 14, 4, 45),
          isDryRun: false,
        ),
        throwsA(isA<PlatformException>()),
      );
    });
  });
}
