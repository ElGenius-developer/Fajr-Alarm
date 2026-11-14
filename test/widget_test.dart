import 'dart:io';

import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/features/onboarding/data/models/onboarding_state_model.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fajr_alarm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;

  const MethodChannel alarmChannel = MethodChannel(
    'com.elgenius.fajralarm/alarm_platform',
  );
  const MethodChannel permissionsChannel = MethodChannel(
    'com.elgenius.fajralarm/onboarding_permissions',
  );

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          alarmChannel,
          (MethodCall call) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          permissionsChannel,
          (MethodCall call) async => <String, bool>{
            'fullScreenIntentGranted': true,
            'batteryOptimizationIgnored': true,
            'cameraGranted': true,
            'alarmPermissionGranted': true,
          },
        );
    tempDir = await Directory.systemTemp.createTemp('fajr_alarm_widget_test_');
    await sl.reset();
    await initDependencies(hivePath: tempDir.path);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(alarmChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionsChannel, null);
    await sl.reset();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets(
    'FajrAlarmApp redirects initial route to onboarding until completed',
    (WidgetTester tester) async {
      await tester.pumpWidget(const FajrAlarmApp());
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();

      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(
        find.byKey(const Key('schedule_open_settings_button')),
        findsNothing,
      );
      await tester.runAsync(
        () => Hive.box<OnboardingStateModel>('onboarding_state_box').flush(),
      );
    },
  );

  testWidgets(
    'FajrAlarmApp renders schedule route when onboarding completed and navigates to settings',
    (WidgetTester tester) async {
      await tester.runAsync(
        () => sl<OnboardingRepository>().completeOnboarding(),
      );

      await tester.pumpWidget(const FajrAlarmApp());
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();

      expect(
        find.byKey(const Key('schedule_open_settings_button')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('schedule_open_settings_button')));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    },
  );
}
