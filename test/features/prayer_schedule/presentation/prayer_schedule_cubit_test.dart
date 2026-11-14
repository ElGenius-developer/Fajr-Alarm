import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadPrayerScheduleUseCase extends Mock
    implements LoadPrayerScheduleUseCase {}

class MockUpdateFajrAlarmConfigUseCase extends Mock
    implements UpdateFajrAlarmConfigUseCase {}

class MockRescheduleTomorrowFajrUseCase extends Mock
    implements RescheduleTomorrowFajrUseCase {}

void main() {
  late MockLoadPrayerScheduleUseCase mockLoad;
  late MockUpdateFajrAlarmConfigUseCase mockUpdate;
  late MockRescheduleTomorrowFajrUseCase mockReschedule;

  const config = FajrAlarmConfig(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'Cairo',
  );
  final nextAlarm = DateTime(2026, 5, 1, 4, 15);
  final schedules = [
    PrayerSchedule(
      date: DateTime(2026, 5, 1),
      fajrTime: nextAlarm,
      sunriseTime: DateTime(2026, 5, 1, 5, 45),
      latitude: 30.0444,
      longitude: 31.2357,
      calculationMethod: 'egyptian',
      madhab: 'shafi',
    ),
  ];

  final overview = PrayerScheduleOverview(
    config: config,
    schedules: schedules,
    nextAlarmTime: nextAlarm,
    isWithinLockWindow: false,
  );

  setUpAll(() {
    registerFallbackValue(config);
  });

  setUp(() {
    mockLoad = MockLoadPrayerScheduleUseCase();
    mockUpdate = MockUpdateFajrAlarmConfigUseCase();
    mockReschedule = MockRescheduleTomorrowFajrUseCase();
  });

  group('PrayerScheduleCubit', () {
    blocTest<PrayerScheduleCubit, PrayerScheduleState>(
      'emits [loading, loaded] when loadSchedule succeeds',
      build: () {
        when(() => mockLoad(now: any(named: 'now')))
            .thenAnswer((_) async => Right(overview));
        return PrayerScheduleCubit(
          loadSchedule: mockLoad,
          updateConfig: mockUpdate,
          rescheduleTomorrow: mockReschedule,
        );
      },
      act: (cubit) => cubit.loadSchedule(now: DateTime(2026, 5, 1, 2, 0)),
      expect: () => [
        const PrayerScheduleState.loading(),
        PrayerScheduleState.loaded(
          config: config,
          schedules: schedules,
          nextAlarmTime: nextAlarm,
          isWithinLockWindow: false,
        ),
      ],
    );

    blocTest<PrayerScheduleCubit, PrayerScheduleState>(
      'emits [loading, error] when loadSchedule fails',
      build: () {
        when(() => mockLoad(now: any(named: 'now'))).thenAnswer(
          (_) async => const Left(Failure.cache(message: 'Read failed')),
        );
        return PrayerScheduleCubit(
          loadSchedule: mockLoad,
          updateConfig: mockUpdate,
          rescheduleTomorrow: mockReschedule,
        );
      },
      act: (cubit) => cubit.loadSchedule(),
      expect: () => [
        const PrayerScheduleState.loading(),
        const PrayerScheduleState.error(
          failure: Failure.cache(message: 'Read failed'),
        ),
      ],
    );

    blocTest<PrayerScheduleCubit, PrayerScheduleState>(
      'preserves loaded state with actionFailure when updateConfig hits LockWindowFailure',
      seed: () => PrayerScheduleState.loaded(
        config: config,
        schedules: schedules,
        nextAlarmTime: nextAlarm,
        isWithinLockWindow: true,
      ),
      build: () {
        when(
          () => mockUpdate(
            newConfig: any(named: 'newConfig'),
            now: any(named: 'now'),
          ),
        ).thenAnswer(
          (_) async => const Left(Failure.lockWindow(message: 'Locked')),
        );
        return PrayerScheduleCubit(
          loadSchedule: mockLoad,
          updateConfig: mockUpdate,
          rescheduleTomorrow: mockReschedule,
        );
      },
      act: (cubit) => cubit.updateConfig(config.copyWith(isEnabled: false)),
      expect: () => [
        PrayerScheduleState.loaded(
          config: config,
          schedules: schedules,
          nextAlarmTime: nextAlarm,
          isWithinLockWindow: true,
          actionFailure: const Failure.lockWindow(message: 'Locked'),
        ),
      ],
    );

    blocTest<PrayerScheduleCubit, PrayerScheduleState>(
      'rescheduleAfterCompletion triggers rescheduleTomorrow and reloads',
      build: () {
        when(() => mockReschedule(completedAt: any(named: 'completedAt')))
            .thenAnswer((_) async => Right(nextAlarm));
        when(() => mockLoad(now: any(named: 'now')))
            .thenAnswer((_) async => Right(overview));
        return PrayerScheduleCubit(
          loadSchedule: mockLoad,
          updateConfig: mockUpdate,
          rescheduleTomorrow: mockReschedule,
        );
      },
      act: (cubit) => cubit.rescheduleAfterCompletion(
        completedAt: DateTime(2026, 5, 1, 4, 20),
      ),
      expect: () => [
        const PrayerScheduleState.loading(),
        PrayerScheduleState.loaded(
          config: config,
          schedules: schedules,
          nextAlarmTime: nextAlarm,
          isWithinLockWindow: false,
        ),
      ],
    );

    test('does not throw if closed while loadSchedule is in flight', () async {
      final completer = Completer<Either<Failure, PrayerScheduleOverview>>();
      when(() => mockLoad(now: any(named: 'now')))
          .thenAnswer((_) => completer.future);

      final cubit = PrayerScheduleCubit(
        loadSchedule: mockLoad,
        updateConfig: mockUpdate,
        rescheduleTomorrow: mockReschedule,
      );

      final future = cubit.loadSchedule();
      await cubit.close();
      completer.complete(Right(overview));
      await future;
    });
  });
}
