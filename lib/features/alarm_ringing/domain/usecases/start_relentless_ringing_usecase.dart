import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Triggers relentless 1-minute loop ringing and screen pinning (FR-2.3, FR-5.2).
class StartRelentlessRingingUseCase {
  const StartRelentlessRingingUseCase(this._platformRepository);

  final AlarmPlatformRepository _platformRepository;

  Future<Either<Failure, AlarmStateEntity>> call(
    AlarmStateEntity currentState,
  ) async {
    final startResult = await _platformRepository.startRinging(
      isDryRun: currentState.isDryRun,
    );
    if (startResult.isLeft()) {
      return startResult.map((_) => currentState);
    }

    await _platformRepository.enableScreenPinning();

    return right(
      currentState.copyWith(
        status: AlarmStatus.ringingRelentless,
        relentlessCycleCount: currentState.relentlessCycleCount + 1,
      ),
    );
  }
}
