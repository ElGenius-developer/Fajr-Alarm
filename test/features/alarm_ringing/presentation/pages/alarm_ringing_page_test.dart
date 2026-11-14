import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_state.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/pages/alarm_ringing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAlarmRingingBloc
    extends MockBloc<AlarmRingingEvent, AlarmRingingState>
    implements AlarmRingingBloc {}

void main() {
  late MockAlarmRingingBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const AlarmRingingEvent.snoozeRequested());
  });

  setUp(() {
    mockBloc = MockAlarmRingingBloc();
  });

  Widget buildTestWidget({
    Locale locale = const Locale('en'),
    VoidCallback? onStartChallenge,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<AlarmRingingBloc>.value(
        value: mockBloc,
        child: AlarmRingingPage(onStartChallenge: onStartChallenge),
      ),
    );
  }

  group('AlarmRingingPage', () {
    testWidgets(
      'shows Snooze, Start Challenge, and Emergency Hold in ringingInitial (EN)',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const AlarmRingingState(
            entity: AlarmStateEntity(
              status: AlarmStatus.ringingInitial,
              remainingEmergencyOverrides: 3,
            ),
          ),
        );

        var challengeTapped = false;
        await tester.pumpWidget(
          buildTestWidget(onStartChallenge: () => challengeTapped = true),
        );

        expect(find.text('Time for Fajr!'), findsOneWidget);
        expect(find.text('Snooze (5 min)'), findsOneWidget);
        expect(find.text('Start Proof-of-Action Challenge'), findsOneWidget);
        expect(find.text('Hold 60s for Emergency Override'), findsOneWidget);
        expect(find.text('Emergency overrides left: 3'), findsOneWidget);

        await tester.tap(find.text('Snooze (5 min)'));
        verify(() => mockBloc.add(const AlarmRingingEvent.snoozeRequested()))
            .called(1);

        await tester.tap(find.text('Start Proof-of-Action Challenge'));
        verify(() => mockBloc.add(const AlarmRingingEvent.challengeStarted()))
            .called(1);
        expect(challengeTapped, isTrue);
      },
    );

    testWidgets(
      'renders Arabic RTL localization in ringingRelentless without Snooze',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const AlarmRingingState(
            entity: AlarmStateEntity(
              status: AlarmStatus.ringingRelentless,
              snoozeUsed: true,
              isDryRun: true,
              remainingEmergencyOverrides: 2,
            ),
          ),
        );

        await tester.pumpWidget(buildTestWidget(locale: const Locale('ar')));

        expect(find.text('منبه تجريبي'), findsOneWidget);
        expect(find.text('رنين متواصل — استيقظ الآن!'), findsOneWidget);
        expect(find.text('غفوة (5 دقائق)'), findsNothing);
        expect(find.text('بدء تحدي إثبات الفعل'), findsOneWidget);
      },
    );

    testWidgets('shows snooze countdown in snoozed5Min', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const AlarmRingingState(
          entity: AlarmStateEntity(
            status: AlarmStatus.snoozed5Min,
            snoozeUsed: true,
          ),
          snoozeRemainingSeconds: 295,
        ),
      );

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Snoozed — 5 Minutes'), findsOneWidget);
      expect(find.text('Next ring in 04:55'), findsOneWidget);
      expect(find.text('Snooze (5 min)'), findsNothing);
    });

    testWidgets(
      'dispatches emergency hold start on pointer down and release on pointer up',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const AlarmRingingState(
            entity: AlarmStateEntity(
              status: AlarmStatus.ringingRelentless,
              remainingEmergencyOverrides: 2,
            ),
            isEmergencyMuted: true,
            emergencyHoldElapsedSeconds: 15,
          ),
        );

        await tester.pumpWidget(buildTestWidget());

        expect(
          find.text('Audio muted — keep holding (45s left)'),
          findsOneWidget,
        );
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Audio muted — keep holding (45s left)')),
        );
        verify(
          () => mockBloc.add(const AlarmRingingEvent.emergencyHoldStarted()),
        ).called(1);

        await gesture.up();
        verify(
          () => mockBloc.add(const AlarmRingingEvent.emergencyHoldReleased()),
        ).called(1);
      },
    );

    testWidgets(
      'shows no quota message and early release error when applicable',
      (tester) async {
        when(() => mockBloc.state).thenReturn(
          const AlarmRingingState(
            entity: AlarmStateEntity(
              status: AlarmStatus.ringingInitial,
              remainingEmergencyOverrides: 0,
            ),
            emergencyReleasedEarly: true,
          ),
        );

        await tester.pumpWidget(buildTestWidget());

        expect(
          find.text('No emergency overrides remaining this month.'),
          findsOneWidget,
        );
        expect(
          find.text('Released early — timer reset and alarm resumed.'),
          findsOneWidget,
        );
      },
    );
  });
}
