import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Stops ringing, disables screen pinning, cancels cascade, and marks completed.
class CompleteAlarmUseCase {
  const CompleteAlarmUseCase(this._platformRepository);

  final AlarmPlatformRepository _platformRepository;

  Future<Either<Failure, AlarmStateEntity>> call(
    AlarmStateEntity currentState,
  ) async {
    final stopResult = await _platformRepository.stopRinging();
    if (stopResult.isLeft()) {
      return stopResult.map((_) => currentState);
    }

    await _platformRepository.disableScreenPinning();
    await _platformRepository.cancelAllAlarms();

    return right(currentState.copyWith(status: AlarmStatus.completed));
  }
}
