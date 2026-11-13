import 'dart:io';

import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('fajr_alarm_widget_test_');
    await sl.reset();
    await initDependencies(hivePath: tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets(
    'FajrAlarmApp renders initial schedule route and navigates to settings',
    (WidgetTester tester) async {
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
