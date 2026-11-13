import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/emergency_override_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/start_relentless_ringing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAlarmPlatformRepository extends Mock
    implements AlarmPlatformRepository {}

void main() {
  late MockAlarmPlatformRepository mockRepo;
  late SnoozeAlarmUseCase snoozeUseCase;
  late StartRelentlessRingingUseCase relentlessUseCase;
  late EmergencyOverrideUseCase emergencyUseCase;
  late CompleteAlarmUseCase completeUseCase;

  setUp(() {
    mockRepo = MockAlarmPlatformRepository();
    snoozeUseCase = SnoozeAlarmUseCase(mockRepo);
    relentlessUseCase = StartRelentlessRingingUseCase(mockRepo);
    emergencyUseCase = EmergencyOverrideUseCase(mockRepo);
    completeUseCase = CompleteAlarmUseCase(mockRepo);

    when(() => mockRepo.stopRinging()).thenAnswer((_) async => right(unit));
    when(() => mockRepo.startRinging(isDryRun: any(named: 'isDryRun')))
        .thenAnswer((_) async => right(unit));
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

  group('SnoozeAlarmUseCase', () {
    test(
      'transitions from ringingInitial to snoozed5Min and stops ringing',
      () async {
        const initial = AlarmStateEntity(status: AlarmStatus.ringingInitial);

        final result = await snoozeUseCase(initial);

        expect(
          result,
          right<Failure, AlarmStateEntity>(
            initial.copyWith(status: AlarmStatus.snoozed5Min, snoozeUsed: true),
          ),
        );
        verify(() => mockRepo.stopRinging()).called(1);
      },
    );

    test('returns ValidationFailure when snooze already used', () async {
      const state = AlarmStateEntity(
        status: AlarmStatus.ringingInitial,
        snoozeUsed: true,
      );

      final result = await snoozeUseCase(state);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepo.stopRinging());
    });

    test('returns ValidationFailure when not in ringingInitial', () async {
      const state = AlarmStateEntity(status: AlarmStatus.ringingRelentless);

      final result = await snoozeUseCase(state);

      expect(result.isLeft(), isTrue);
      verifyNever(() => mockRepo.stopRinging());
    });
  });

  group('StartRelentlessRingingUseCase', () {
    test(
      'starts ringing, enables screen pinning, increments cycle count',
      () async {
        const state = AlarmStateEntity(
          status: AlarmStatus.snoozed5Min,
          snoozeUsed: true,
        );

        final result = await relentlessUseCase(state);

        expect(
          result,
          right<Failure, AlarmStateEntity>(
            state.copyWith(
              status: AlarmStatus.ringingRelentless,
              relentlessCycleCount: 1,
            ),
          ),
        );
        verify(() => mockRepo.startRinging(isDryRun: false)).called(1);
        verify(() => mockRepo.enableScreenPinning()).called(1);
      },
    );

    test('propagates PlatformFailure when startRinging fails', () async {
      when(() => mockRepo.startRinging(isDryRun: any(named: 'isDryRun')))
          .thenAnswer((_) async => left(const PlatformFailure(message: 'err')));

      const state = AlarmStateEntity(status: AlarmStatus.snoozed5Min);
      final result = await relentlessUseCase(state);

      expect(result.isLeft(), isTrue);
      verifyNever(() => mockRepo.enableScreenPinning());
    });
  });

  group('EmergencyOverrideUseCase', () {
    test('beginTouchMute calls muteRingingAudio when quota > 0', () async {
      final result = await emergencyUseCase.beginTouchMute(
        remainingEmergencyOverrides: 2,
      );

      expect(result, right<Failure, Unit>(unit));
      verify(() => mockRepo.muteRingingAudio()).called(1);
    });

    test(
      'beginTouchMute returns QuotaExceededFailure when quota == 0',
      () async {
        final result = await emergencyUseCase.beginTouchMute(
          remainingEmergencyOverrides: 0,
        );

        result.fold(
          (failure) => expect(failure, isA<QuotaExceededFailure>()),
          (_) => fail('Expected QuotaExceededFailure'),
        );
        verifyNever(() => mockRepo.muteRingingAudio());
      },
    );

    test('cancelEarlyRelease calls unmuteRingingAudio', () async {
      final result = await emergencyUseCase.cancelEarlyRelease();

      expect(result, right<Failure, Unit>(unit));
      verify(() => mockRepo.unmuteRingingAudio()).called(1);
    });

    test('completeOverride stops ringing, disables pinning, cancels alarms, and decrements quota', () async {
      const state = AlarmStateEntity(
        status: AlarmStatus.ringingRelentless,
        remainingEmergencyOverrides: 3,
      );

      final result = await emergencyUseCase.completeOverride(state);

      expect(
        result,
        right<Failure, AlarmStateEntity>(
          state.copyWith(
            status: AlarmStatus.completed,
            remainingEmergencyOverrides: 2,
          ),
        ),
      );
      verify(() => mockRepo.stopRinging()).called(1);
      verify(() => mockRepo.disableScreenPinning()).called(1);
      verify(() => mockRepo.cancelAllAlarms()).called(1);
    });

    test('completeOverride does not decrement quota in dry-run mode', () async {
      const state = AlarmStateEntity(
        status: AlarmStatus.ringingInitial,
        isDryRun: true,
        remainingEmergencyOverrides: 3,
      );

      final result = await emergencyUseCase.completeOverride(state);

      expect(
        result,
        right<Failure, AlarmStateEntity>(
          state.copyWith(
            status: AlarmStatus.completed,
            remainingEmergencyOverrides: 3,
          ),
        ),
      );
    });
  });

  group('CompleteAlarmUseCase', () {
    test('stops ringing, disables pinning, cancels alarms, transitions to completed', () async {
      const state = AlarmStateEntity(status: AlarmStatus.challengeActive);

      final result = await completeUseCase(state);

      expect(
        result,
        right<Failure, AlarmStateEntity>(
          state.copyWith(status: AlarmStatus.completed),
        ),
      );
      verify(() => mockRepo.stopRinging()).called(1);
      verify(() => mockRepo.disableScreenPinning()).called(1);
      verify(() => mockRepo.cancelAllAlarms()).called(1);
    });
  });
}
