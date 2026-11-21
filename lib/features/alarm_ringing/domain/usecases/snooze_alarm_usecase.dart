import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Snoozes the initial Fajr alarm once for 5 minutes (FR-2.3).
class SnoozeAlarmUseCase {
  const SnoozeAlarmUseCase(
    this._platformRepository, {
    this._now = DateTime.now,
  });

  static const Duration snoozeDuration = Duration(minutes: 5);

  final AlarmPlatformRepository _platformRepository;
  final DateTime Function() _now;

  Future<Either<Failure, AlarmStateEntity>> call(
    AlarmStateEntity currentState,
  ) async {
    if (currentState.status != AlarmStatus.ringingInitial ||
        currentState.snoozeUsed) {
      return left(
        const Failure.validation(
          message: 'Snooze is only allowed once during initial ringing.',
        ),
      );
    }

    // Arm first: if the backup alarm can't be set, keep ringing rather than
    // trust a Dart timer that dies with the app process.
    final armResult = await _platformRepository.scheduleSnoozeAlarm(
      at: _now().add(snoozeDuration),
      isDryRun: currentState.isDryRun,
    );
    if (armResult.isLeft()) {
      return armResult.map((_) => currentState);
    }

    final stopResult = await _platformRepository.stopRinging();
    return stopResult.map(
      (_) => currentState.copyWith(
        status: AlarmStatus.snoozed5Min,
        snoozeUsed: true,
      ),
    );
  }
}
