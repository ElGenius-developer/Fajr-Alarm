import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Handles Touch-Mute + 60s continuous hold Emergency Override (FR-6.2).
class EmergencyOverrideUseCase {
  const EmergencyOverrideUseCase(this._platformRepository);

  final AlarmPlatformRepository _platformRepository;

  /// Immediately mutes ringing audio on finger down if monthly quota remains.
  Future<Either<Failure, Unit>> beginTouchMute({
    required int remainingEmergencyOverrides,
  }) async {
    if (remainingEmergencyOverrides <= 0) {
      return left(
        const Failure.quotaExceeded(
          message: 'No emergency overrides remaining this month.',
        ),
      );
    }
    return _platformRepository.muteRingingAudio();
  }

  /// Unmutes ringing audio when the user releases the button before 60s.
  Future<Either<Failure, Unit>> cancelEarlyRelease() {
    return _platformRepository.unmuteRingingAudio();
  }

  /// Completes emergency override after 60s continuous hold.
  Future<Either<Failure, AlarmStateEntity>> completeOverride(
    AlarmStateEntity currentState,
  ) async {
    if (currentState.remainingEmergencyOverrides <= 0) {
      return left(
        const Failure.quotaExceeded(
          message: 'No emergency overrides remaining this month.',
        ),
      );
    }

    final stopResult = await _platformRepository.stopRinging();
    if (stopResult.isLeft()) {
      return stopResult.map((_) => currentState);
    }

    await _platformRepository.disableScreenPinning();
    await _platformRepository.cancelAllAlarms();

    final nextQuota = currentState.isDryRun
        ? currentState.remainingEmergencyOverrides
        : currentState.remainingEmergencyOverrides - 1;

    return right(
      currentState.copyWith(
        status: AlarmStatus.completed,
        remainingEmergencyOverrides: nextQuota,
      ),
    );
  }
}
