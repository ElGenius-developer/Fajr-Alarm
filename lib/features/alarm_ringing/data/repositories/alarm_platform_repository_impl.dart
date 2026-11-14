import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/alarm_platform_repository.dart';
import '../datasources/alarm_platform_data_source.dart';

/// Repository implementation delegating alarm platform operations to [AlarmPlatformDataSource].
class AlarmPlatformRepositoryImpl implements AlarmPlatformRepository {
  AlarmPlatformRepositoryImpl({required this.dataSource});

  final AlarmPlatformDataSource dataSource;

  @override
  Future<Either<Failure, Unit>> scheduleAlarm({
    required DateTime scheduledAt,
    required bool isDryRun,
  }) => _guard(() async {
    await dataSource.scheduleAlarm(
      scheduledAt: scheduledAt,
      isDryRun: isDryRun,
    );
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> cancelAllAlarms() => _guard(() async {
    await dataSource.cancelAllAlarms();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> startRinging({required bool isDryRun}) =>
      _guard(() async {
        await dataSource.startRinging(isDryRun: isDryRun);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> stopRinging() => _guard(() async {
    await dataSource.stopRinging();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> muteRingingAudio() => _guard(() async {
    await dataSource.muteRingingAudio();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> unmuteRingingAudio() => _guard(() async {
    await dataSource.unmuteRingingAudio();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> enableScreenPinning() => _guard(() async {
    await dataSource.enableScreenPinning();
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> disableScreenPinning() => _guard(() async {
    await dataSource.disableScreenPinning();
    return unit;
  });

  @override
  Future<Either<Failure, bool>> canUseFullScreenIntent() =>
      _guard(dataSource.canUseFullScreenIntent);

  @override
  Future<Either<Failure, Unit>> requestFullScreenIntentPermission() =>
      _guard(() async {
        await dataSource.requestFullScreenIntentPermission();
        return unit;
      });

  @override
  Future<Either<Failure, bool>> isIgnoringBatteryOptimizations() =>
      _guard(dataSource.isIgnoringBatteryOptimizations);

  @override
  Future<Either<Failure, Unit>> requestIgnoreBatteryOptimizations() =>
      _guard(() async {
        await dataSource.requestIgnoreBatteryOptimizations();
        return unit;
      });

  @override
  Future<Either<Failure, Map<String, dynamic>?>> consumePendingAlarmTrigger() =>
      _guard(dataSource.consumePendingAlarmTrigger);

  @override
  void listenForAlarmTriggers(
    void Function({required bool isDryRun})? onTriggered,
  ) {
    dataSource.setAlarmTriggeredHandler(onTriggered);
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on PlatformException catch (error) {
      final message = error.message ?? error.code;
      if (error.code == 'PERMISSION_DENIED') {
        return Left(Failure.permission(message: message));
      }
      return Left(Failure.platform(message: message));
    } on MissingPluginException catch (error) {
      return Left(
        Failure.platform(
          message: error.message ?? 'Alarm platform channel not registered',
        ),
      );
    } catch (_) {
      return const Left(
        Failure.unexpected(message: 'Unexpected alarm platform failure'),
      );
    }
  }
}
