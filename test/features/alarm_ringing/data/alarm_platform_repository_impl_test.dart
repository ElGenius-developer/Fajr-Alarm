import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/data/datasources/alarm_platform_data_source.dart';
import 'package:fajr_alarm/features/alarm_ringing/data/repositories/alarm_platform_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.elgenius.fajralarm/alarm_platform');
  late AlarmPlatformDataSource dataSource;
  late AlarmPlatformRepositoryImpl repository;

  setUp(() {
    dataSource = AlarmPlatformDataSource(channel: channel);
    repository = AlarmPlatformRepositoryImpl(dataSource: dataSource);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AlarmPlatformRepositoryImpl happy paths', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            switch (call.method) {
              case 'canUseFullScreenIntent':
                return true;
              case 'isIgnoringBatteryOptimizations':
                return true;
              default:
                return null;
            }
          });
    });

    test('returns Right(unit) for all void platform commands', () async {
      final scheduledAt = DateTime.utc(2026, 11, 14, 5, 0);

      expect(
        await repository.scheduleAlarm(
          scheduledAt: scheduledAt,
          isDryRun: false,
        ),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.cancelAllAlarms(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.startRinging(isDryRun: true),
        const Right<Failure, Unit>(unit),
      );
      expect(await repository.stopRinging(), const Right<Failure, Unit>(unit));
      expect(
        await repository.muteRingingAudio(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.unmuteRingingAudio(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.enableScreenPinning(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.disableScreenPinning(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.requestFullScreenIntentPermission(),
        const Right<Failure, Unit>(unit),
      );
      expect(
        await repository.requestIgnoreBatteryOptimizations(),
        const Right<Failure, Unit>(unit),
      );
    });

    test('returns Right(bool) for permission query methods', () async {
      expect(
        await repository.canUseFullScreenIntent(),
        const Right<Failure, bool>(true),
      );
      expect(
        await repository.isIgnoringBatteryOptimizations(),
        const Right<Failure, bool>(true),
      );
    });
  });

  group('AlarmPlatformRepositoryImpl failure paths', () {
    test(
      'maps PERMISSION_DENIED PlatformException to PermissionFailure',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall call) async {
              throw PlatformException(
                code: 'PERMISSION_DENIED',
                message: 'Exact alarm permission missing',
              );
            });

        final result = await repository.scheduleAlarm(
          scheduledAt: DateTime.utc(2026, 11, 14, 5, 0),
          isDryRun: false,
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<PermissionFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test('maps generic PlatformException to PlatformFailure', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            throw PlatformException(
              code: 'SERVICE_ERROR',
              message: 'Foreground service failed to start',
            );
          });

      final result = await repository.startRinging(isDryRun: false);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<PlatformFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('maps MissingPluginException to PlatformFailure', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);

      final result = await repository.canUseFullScreenIntent();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<PlatformFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
