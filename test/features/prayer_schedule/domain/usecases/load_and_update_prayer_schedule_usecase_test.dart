import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/is_within_pre_fajr_lock_window_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPrayerScheduleRepository extends Mock
    implements PrayerScheduleRepository {}

void main() {
  late MockPrayerScheduleRepository mockRepository;
  late Calculate30DayFajrScheduleUseCase calculateUseCase;
  late GetNextFajrAlarmUseCase getNextUseCase;
  late IsWithinPreFajrLockWindowUseCase lockWindowUseCase;
  late LoadPrayerScheduleUseCase loadUseCase;
  late UpdateFajrAlarmConfigUseCase updateUseCase;

  const config = FajrAlarmConfig(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'Cairo',
    calculationMethod: FajrCalculationMethod.egyptian,
  );

  setUpAll(() {
    registerFallbackValue(config);
    registerFallbackValue(<PrayerSchedule>[]);
  });

  setUp(() {
    mockRepository = MockPrayerScheduleRepository();
    calculateUseCase = Calculate30DayFajrScheduleUseCase(mockRepository);
    getNextUseCase = const GetNextFajrAlarmUseCase();
    lockWindowUseCase = const IsWithinPreFajrLockWindowUseCase();
    loadUseCase = LoadPrayerScheduleUseCase(
      repository: mockRepository,
      calculate30DaySchedule: calculateUseCase,
      getNextFajrAlarm: getNextUseCase,
      isWithinLockWindow: lockWindowUseCase,
    );
    updateUseCase = UpdateFajrAlarmConfigUseCase(
      repository: mockRepository,
      calculate30DaySchedule: calculateUseCase,
      getNextFajrAlarm: getNextUseCase,
      isWithinLockWindow: lockWindowUseCase,
    );
  });

  group('LoadPrayerScheduleUseCase', () {
    test('calculates and caches 30-day schedule when cache is empty', () async {
      when(() => mockRepository.getAlarmConfig())
          .thenAnswer((_) async => const Right(config));
      when(() => mockRepository.getCached30DaySchedule())
          .thenAnswer((_) async => const Right([]));
      when(() => mockRepository.save30DaySchedule(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.saveNextScheduledAlarm(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await loadUseCase(now: DateTime(2026, 5, 1, 2, 0));

      expect(result.isRight(), isTrue);
      result.fold((f) => fail('Expected Right, got $f'), (overview) {
        expect(overview.schedules, hasLength(30));
        expect(overview.nextAlarmTime, isNotNull);
        expect(overview.isWithinLockWindow, isFalse);
      });
      verify(() => mockRepository.save30DaySchedule(any())).called(1);
    });
  });

  group('UpdateFajrAlarmConfigUseCase', () {
    test('returns LockWindowFailure when inside T - 30m window', () async {
      final alarmTime = DateTime(2026, 5, 1, 4, 30);
      when(() => mockRepository.getNextScheduledAlarm())
          .thenAnswer((_) async => Right(alarmTime));

      final result = await updateUseCase(
        newConfig: config.copyWith(isEnabled: false),
        now: DateTime(2026, 5, 1, 4, 10),
      );

      result.fold(
        (failure) => expect(failure, isA<LockWindowFailure>()),
        (_) => fail('Expected LockWindowFailure'),
      );
      verifyNever(() => mockRepository.saveAlarmConfig(any()));
    });

    test(
      'saves config and recalculates 30-day schedule when unlocked',
      () async {
        final alarmTime = DateTime(2026, 5, 1, 4, 30);
        when(() => mockRepository.getNextScheduledAlarm())
            .thenAnswer((_) async => Right(alarmTime));
        when(() => mockRepository.saveAlarmConfig(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockRepository.save30DaySchedule(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockRepository.saveNextScheduledAlarm(any()))
            .thenAnswer((_) async => const Right(unit));

        final result = await updateUseCase(
          newConfig: config.copyWith(offsetMinutes: 10),
          now: DateTime(2026, 5, 1, 2, 0),
        );

        expect(result.isRight(), isTrue);
        verify(() => mockRepository.saveAlarmConfig(any())).called(1);
        verify(() => mockRepository.save30DaySchedule(any())).called(1);
      },
    );

    test('returns saved overview with actionFailure when saveNextScheduledAlarm fails', () async {
      final alarmTime = DateTime(2026, 5, 1, 4, 30);
      when(() => mockRepository.getNextScheduledAlarm())
          .thenAnswer((_) async => Right(alarmTime));
      when(() => mockRepository.saveAlarmConfig(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.save30DaySchedule(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.saveNextScheduledAlarm(any())).thenAnswer(
        (_) async => const Left(Failure.platform(message: 'OS error')),
      );

      final result = await updateUseCase(
        newConfig: config.copyWith(offsetMinutes: 10),
        now: DateTime(2026, 5, 1, 2, 0),
      );

      result.fold((failure) => fail('Expected Right overview, got $failure'), (
        overview,
      ) {
        expect(overview.config.offsetMinutes, 10);
        expect(overview.actionFailure, isA<PlatformFailure>());
      });
    });
  });
}
