import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_permissions_data_source.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'com.elgenius.fajralarm/onboarding_permissions',
  );

  late MethodChannelOnboardingPermissionsDataSource dataSource;

  setUp(() {
    dataSource = MethodChannelOnboardingPermissionsDataSource(channel: channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('checkPermissions parses granted map from MethodChannel', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          expect(call.method, 'checkPermissions');
          return <String, dynamic>{
            'fullScreenIntentGranted': true,
            'batteryOptimizationIgnored': true,
            'cameraGranted': true,
            'alarmPermissionGranted': true,
          };
        });

    final PermissionsGateStatus status = await dataSource.checkPermissions();

    expect(status.allGranted, isTrue);
  });

  test(
    'requestPermissions returns default false status when channel returns null',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'requestPermissions');
            return null;
          });

      final PermissionsGateStatus status = await dataSource
          .requestPermissions();

      expect(status, const PermissionsGateStatus());
      expect(status.allGranted, isFalse);
    },
  );
}
