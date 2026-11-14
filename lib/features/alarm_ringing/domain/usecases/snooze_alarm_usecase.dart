import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Snoozes the initial Fajr alarm once for 5 minutes (FR-2.3).
class SnoozeAlarmUseCase {
  const SnoozeAlarmUseCase(this._platformRepository);

  final AlarmPlatformRepository _platformRepository;

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

    final stopResult = await _platformRepository.stopRinging();
    return stopResult.map(
      (_) => currentState.copyWith(
        status: AlarmStatus.snoozed5Min,
        snoozeUsed: true,
      ),
    );
  }
}
