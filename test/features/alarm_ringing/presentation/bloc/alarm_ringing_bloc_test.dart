import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/time/monotonic_clock.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/emergency_override_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/start_relentless_ringing_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAlarmPlatformRepository extends Mock
    implements AlarmPlatformRepository {}

class FakeMonotonicClock implements MonotonicClock {
  FakeMonotonicClock(this._elapsedProvider);

  final Duration Function() _elapsedProvider;

  @override
  Duration get elapsed => _elapsedProvider();

  @override
  int get elapsedMilliseconds => elapsed.inMilliseconds;
}

void main() {
  late MockAlarmPlatformRepository mockRepo;

  setUp(() {
    mockRepo = MockAlarmPlatformRepository();
    when(() => mockRepo.startRinging(isDryRun: any(named: 'isDryRun')))
        .thenAnswer((_) async => right(unit));
    when(() => mockRepo.stopRinging()).thenAnswer((_) async => right(unit));
    when(() => mockRepo.muteRingingAudio())
        .thenAnswer((_) async => right(unit));
    when(() => mockRepo.unmuteRingingAudio())
        .thenAnswer((_) async => right(unit));
    when(() => mockRepo.enableScreenPinning())
        .thenAnswer((_) async => right(unit));
    when(() => mockRepo.disableScreenPinning())
        .thenAnswer((_) async => right(unit));
    when(() => mockRepo.cancelAllAlarms()).thenAnswer((_) async => right(unit));
  });

  AlarmRingingBloc createBloc(MonotonicClock clock) {
    return AlarmRingingBloc(
      clock: clock,
      platformRepository: mockRepo,
      snoozeAlarmUseCase: SnoozeAlarmUseCase(mockRepo),
      startRelentlessRingingUseCase: StartRelentlessRingingUseCase(mockRepo),
      emergencyOverrideUseCase: EmergencyOverrideUseCase(mockRepo),
      completeAlarmUseCase: CompleteAlarmUseCase(mockRepo),
    );
  }

  group('AlarmRingingBloc', () {
    blocTest<AlarmRingingBloc, AlarmRingingState>(
      'transitions IDLE -> LOCKED_PRE_FAJR -> RINGING_INITIAL -> CHALLENGE_ACTIVE -> COMPLETED',
      build: () => createBloc(FakeMonotonicClock(() => Duration.zero)),
      act: (bloc) async {
        bloc.add(
          AlarmRingingEvent.preFajrLockEntered(
            scheduledAt: DateTime(2026, 1, 1, 5, 0),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.alarmTriggered());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.challengeStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.challengeSucceeded());
      },
      expect: () => [
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.lockedPreFajr,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.ringingInitial,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.challengeActive,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.completed,
        ),
      ],
      verify: (_) {
        verify(() => mockRepo.startRinging(isDryRun: false)).called(1);
        verify(() => mockRepo.stopRinging()).called(1);
        verify(() => mockRepo.disableScreenPinning()).called(1);
        verify(() => mockRepo.cancelAllAlarms()).called(1);
      },
    );

    test(
      '5m snooze escalates to ringingRelentless and loops every 1 minute',
      () {
        fakeAsync((async) {
          final clock = FakeMonotonicClock(() => async.elapsed);
          final bloc = createBloc(clock);

          bloc.add(const AlarmRingingEvent.alarmTriggered());
          async.flushMicrotasks();
          expect(bloc.state.entity.status, AlarmStatus.ringingInitial);

          // Request 5-minute snooze
          bloc.add(const AlarmRingingEvent.snoozeRequested());
          async.flushMicrotasks();
          expect(bloc.state.entity.status, AlarmStatus.snoozed5Min);
          expect(bloc.state.entity.snoozeUsed, isTrue);
          expect(bloc.state.snoozeRemainingSeconds, 300);

          // Advance 4m59s -> still snoozed
          async.elapse(const Duration(minutes: 4, seconds: 59));
          expect(bloc.state.entity.status, AlarmStatus.snoozed5Min);
          expect(bloc.state.snoozeRemainingSeconds, 1);

          // Advance 1s -> 5m elapsed -> ringingRelentless (cycle 1)
          async.elapse(const Duration(seconds: 1));
          expect(bloc.state.entity.status, AlarmStatus.ringingRelentless);
          expect(bloc.state.entity.relentlessCycleCount, 1);

          // Advance 1m -> 1-min relentless loop triggers cycle 2
          async.elapse(const Duration(minutes: 1));
          expect(bloc.state.entity.status, AlarmStatus.ringingRelentless);
          expect(bloc.state.entity.relentlessCycleCount, 2);

          // Advance another 1m -> cycle 3
          async.elapse(const Duration(minutes: 1));
          expect(bloc.state.entity.relentlessCycleCount, 3);

          bloc.close();
        });
      },
    );

    test('ignoring initial ring for 60s escalates to ringingRelentless', () {
      fakeAsync((async) {
        final clock = FakeMonotonicClock(() => async.elapsed);
        final bloc = createBloc(clock);

        bloc.add(const AlarmRingingEvent.alarmTriggered());
        async.flushMicrotasks();
        expect(bloc.state.entity.status, AlarmStatus.ringingInitial);

        async.elapse(const Duration(seconds: 60));
        expect(bloc.state.entity.status, AlarmStatus.ringingRelentless);
        expect(bloc.state.entity.relentlessCycleCount, 1);

        bloc.close();
      });
    });

    test('Emergency Override: Touch-Mute mutes immediately, early release resets timer & unmutes, 60s continuous hold completes', () {
      fakeAsync((async) {
        final clock = FakeMonotonicClock(() => async.elapsed);
        final bloc = createBloc(clock);

        bloc.add(
          const AlarmRingingEvent.alarmTriggered(
            remainingEmergencyOverrides: 2,
          ),
        );
        async.flushMicrotasks();

        // Finger down -> immediate Touch-Mute
        bloc.add(const AlarmRingingEvent.emergencyHoldStarted());
        async.flushMicrotasks();
        expect(bloc.state.isEmergencyMuted, isTrue);
        expect(bloc.state.emergencyHoldElapsedSeconds, 0);
        verify(() => mockRepo.muteRingingAudio()).called(1);

        // Hold for 20s then release early
        async.elapse(const Duration(seconds: 20));
        expect(bloc.state.emergencyHoldElapsedSeconds, 20);

        bloc.add(const AlarmRingingEvent.emergencyHoldReleased());
        async.flushMicrotasks();
        expect(bloc.state.isEmergencyMuted, isFalse);
        expect(bloc.state.emergencyHoldElapsedSeconds, 0);
        expect(bloc.state.emergencyReleasedEarly, isTrue);
        verify(() => mockRepo.unmuteRingingAudio()).called(1);

        // Hold again for full 60s
        bloc.add(const AlarmRingingEvent.emergencyHoldStarted());
        async.flushMicrotasks();
        expect(bloc.state.isEmergencyMuted, isTrue);
        expect(bloc.state.emergencyReleasedEarly, isFalse);

        async.elapse(const Duration(seconds: 59));
        expect(bloc.state.entity.status, AlarmStatus.ringingInitial);
        expect(bloc.state.emergencyHoldElapsedSeconds, 59);

        async.elapse(const Duration(seconds: 1));
        expect(bloc.state.entity.status, AlarmStatus.completed);
        expect(bloc.state.entity.remainingEmergencyOverrides, 1);
        expect(bloc.state.isEmergencyMuted, isFalse);

        bloc.close();
      });
    });

    test(
      'Emergency Override fails with QuotaExceededFailure when quota is 0',
      () {
        fakeAsync((async) {
          final clock = FakeMonotonicClock(() => async.elapsed);
          final bloc = createBloc(clock);

          bloc.add(
            const AlarmRingingEvent.alarmTriggered(
              remainingEmergencyOverrides: 0,
            ),
          );
          async.flushMicrotasks();

          bloc.add(const AlarmRingingEvent.emergencyHoldStarted());
          async.flushMicrotasks();

          expect(bloc.state.isEmergencyMuted, isFalse);
          expect(bloc.state.failure, isA<QuotaExceededFailure>());
          verifyNever(() => mockRepo.muteRingingAudio());

          bloc.close();
        });
      },
    );

    blocTest<AlarmRingingBloc, AlarmRingingState>(
      'challengeRejected returns to ringingRelentless and vacation mode toggles idle <-> vacationFrozen',
      build: () => createBloc(FakeMonotonicClock(() => Duration.zero)),
      act: (bloc) async {
        bloc.add(const AlarmRingingEvent.vacationFrozen());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.vacationEnded());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.alarmTriggered());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.challengeStarted());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const AlarmRingingEvent.challengeRejected());
      },
      expect: () => [
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.vacationFrozen,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.idle,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.ringingInitial,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.challengeActive,
        ),
        isA<AlarmRingingState>().having(
          (s) => s.entity.status,
          'status',
          AlarmStatus.ringingRelentless,
        ),
      ],
    );
  });
}
