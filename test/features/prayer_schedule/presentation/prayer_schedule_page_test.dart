import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
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

  setUpAll(() {
    registerFallbackValue(
      const FajrAlarmConfig(latitude: 30.0444, longitude: 31.2357),
    );
  });

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

    testWidgets(
      'renders offset chips in relative before mode and updates offsetMinutes',
      (tester) async {
        const initialConfig = FajrAlarmConfig(
          latitude: 30.0444,
          longitude: 31.2357,
          mode: FajrAlarmMode.relativeToAdhan,
          offsetDirection: FajrOffsetDirection.before,
          offsetMinutes: 15,
        );
        final today = DateTime.now();
        final todayFajr = DateTime(today.year, today.month, today.day, 4, 25);
        when(() => mockCubit.state).thenReturn(
          PrayerScheduleState.loaded(
            config: initialConfig,
            schedules: [
              PrayerSchedule(
                date: DateTime(today.year, today.month, today.day),
                fajrTime: todayFajr,
                sunriseTime: DateTime(
                  today.year,
                  today.month,
                  today.day,
                  5,
                  55,
                ),
                latitude: 30.0444,
                longitude: 31.2357,
                calculationMethod: 'egyptian',
                madhab: 'shafi',
              ),
            ],
            nextAlarmTime: todayFajr.subtract(const Duration(minutes: 15)),
            isWithinLockWindow: false,
          ),
        );
        when(() => mockCubit.updateConfig(any())).thenAnswer((_) async {});

        await tester.pumpWidget(buildTestable(const Locale('en')));
        await tester.pumpAndSettle();

        final chip30 = find.byKey(const Key('schedule_offset_chip_30'));
        expect(chip30, findsOneWidget);
        await tester.ensureVisible(chip30);
        await tester.tap(chip30);
        await tester.pump();

        verify(
          () =>
              mockCubit.updateConfig(initialConfig.copyWith(offsetMinutes: 30)),
        ).called(1);
      },
    );

    testWidgets('renders manual time picker tile in manualTime mode', (
      tester,
    ) async {
      final today = DateTime.now();
      const manualConfig = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        mode: FajrAlarmMode.manualTime,
        manualHour: 4,
        manualMinute: 45,
      );
      when(() => mockCubit.state).thenReturn(
        PrayerScheduleState.loaded(
          config: manualConfig,
          schedules: [
            PrayerSchedule(
              date: DateTime(today.year, today.month, today.day),
              fajrTime: DateTime(today.year, today.month, today.day, 4, 20),
              sunriseTime: DateTime(today.year, today.month, today.day, 5, 50),
              latitude: 30.0444,
              longitude: 31.2357,
              calculationMethod: 'egyptian',
              madhab: 'shafi',
            ),
          ],
          nextAlarmTime: DateTime(today.year, today.month, today.day, 4, 45),
          isWithinLockWindow: false,
        ),
      );

      await tester.pumpWidget(buildTestable(const Locale('en')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('schedule_manual_time_picker')),
        findsOneWidget,
      );
    });

    testWidgets(
      'segmented buttons keep English labels single-line under soft AppTheme',
      (tester) async {
        final today = DateTime.now();
        when(() => mockCubit.state).thenReturn(
          PrayerScheduleState.loaded(
            config: const FajrAlarmConfig(
              latitude: 30.0444,
              longitude: 31.2357,
            ),
            schedules: [
              PrayerSchedule(
                date: DateTime(today.year, today.month, today.day),
                fajrTime: DateTime(today.year, today.month, today.day, 4, 50),
                sunriseTime: DateTime(
                  today.year,
                  today.month,
                  today.day,
                  6,
                  19,
                ),
                latitude: 30.0444,
                longitude: 31.2357,
                calculationMethod: 'egyptian',
                madhab: 'shafi',
              ),
            ],
            nextAlarmTime: DateTime(today.year, today.month, today.day, 4, 50),
            isWithinLockWindow: false,
          ),
        );

        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            theme: AppTheme.light(AppDesignStyle.horizon),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<PrayerScheduleCubit>.value(
              value: mockCubit,
              child: const PrayerSchedulePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        for (final label in const [
          'Relative to Adhan',
          'Manual Fixed Time',
          'Before Adhan',
          'At Adhan',
          'After Adhan',
        ]) {
          final textWidget = tester.widget<Text>(find.text(label));
          expect(textWidget.maxLines, 1);
          expect(textWidget.softWrap, isFalse);
          expect(tester.getSize(find.text(label)).height, lessThan(24));
        }
      },
    );
  });
}
