import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_state.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPrayerScheduleCubit extends MockCubit<PrayerScheduleState>
    implements PrayerScheduleCubit {}

void main() {
  late MockPrayerScheduleCubit mockCubit;

  setUp(() {
    mockCubit = MockPrayerScheduleCubit();
  });

  Widget buildTestable(Locale locale) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<PrayerScheduleCubit>.value(
        value: mockCubit,
        child: const PrayerSchedulePage(),
      ),
    );
  }

  group('PrayerSchedulePage', () {
    testWidgets('renders localized schedule and lock banner in Arabic RTL', (
      tester,
    ) async {
      final nextAlarm = DateTime(2026, 5, 1, 4, 15);
      when(() => mockCubit.state).thenReturn(
        PrayerScheduleState.loaded(
          config: const FajrAlarmConfig(latitude: 30.0444, longitude: 31.2357),
          schedules: [
            PrayerSchedule(
              date: DateTime(2026, 5, 1),
              fajrTime: nextAlarm,
              sunriseTime: DateTime(2026, 5, 1, 5, 45),
              latitude: 30.0444,
              longitude: 31.2357,
              calculationMethod: 'egyptian',
              madhab: 'shafi',
            ),
          ],
          nextAlarmTime: nextAlarm,
          isWithinLockWindow: true,
        ),
      );

      await tester.pumpWidget(buildTestable(const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('جدول صلاة الفجر'), findsOneWidget);
      expect(find.byIcon(Icons.lock_clock), findsOneWidget);
    });

    testWidgets('renders English LTR schedule when unlocked', (tester) async {
      final nextAlarm = DateTime(2026, 5, 1, 4, 15);
      when(() => mockCubit.state).thenReturn(
        PrayerScheduleState.loaded(
          config: const FajrAlarmConfig(latitude: 30.0444, longitude: 31.2357),
          schedules: [
            PrayerSchedule(
              date: DateTime(2026, 5, 1),
              fajrTime: nextAlarm,
              sunriseTime: DateTime(2026, 5, 1, 5, 45),
              latitude: 30.0444,
              longitude: 31.2357,
              calculationMethod: 'egyptian',
              madhab: 'shafi',
            ),
          ],
          nextAlarmTime: nextAlarm,
          isWithinLockWindow: false,
        ),
      );

      await tester.pumpWidget(buildTestable(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Fajr Schedule'), findsOneWidget);
      expect(find.byIcon(Icons.lock_clock), findsNothing);
    });

    testWidgets('renders error view with localized retry button', (
      tester,
    ) async {
      when(() => mockCubit.state).thenReturn(
        const PrayerScheduleState.error(
          failure: Failure.lockWindow(message: 'Locked'),
        ),
      );
      when(() => mockCubit.loadSchedule()).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestable(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      verify(() => mockCubit.loadSchedule()).called(1);
    });
  });
}
