import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPrayerScheduleRepository extends Mock
    implements PrayerScheduleRepository {}

void main() {
  late MockPrayerScheduleRepository mockRepository;
  late Calculate30DayFajrScheduleUseCase calculateUseCase;
  late GetNextFajrAlarmUseCase getNextUseCase;
  late RescheduleTomorrowFajrUseCase rescheduleUseCase;

  const config = FajrAlarmConfig(
    latitude: 30.0444,
    longitude: 31.2357,
    calculationMethod: FajrCalculationMethod.egyptian,
  );

  setUpAll(() {
    registerFallbackValue(<PrayerSchedule>[]);
  });

  setUp(() {
    mockRepository = MockPrayerScheduleRepository();
    calculateUseCase = Calculate30DayFajrScheduleUseCase(mockRepository);
    getNextUseCase = const GetNextFajrAlarmUseCase();
    rescheduleUseCase = RescheduleTomorrowFajrUseCase(
      repository: mockRepository,
      calculate30DaySchedule: calculateUseCase,
      getNextFajrAlarm: getNextUseCase,
    );
  });

  group('RescheduleTomorrowFajrUseCase', () {
    test(
      'reschedules tomorrow Fajr using cached schedule when available',
      () async {
        final today = PrayerSchedule(
          date: DateTime(2026, 5, 1),
          fajrTime: DateTime(2026, 5, 1, 4, 15),
          sunriseTime: DateTime(2026, 5, 1, 5, 45),
          latitude: 30.0444,
          longitude: 31.2357,
          calculationMethod: 'egyptian',
          madhab: 'shafi',
        );
        final tomorrow = PrayerSchedule(
          date: DateTime(2026, 5, 2),
          fajrTime: DateTime(2026, 5, 2, 4, 14),
          sunriseTime: DateTime(2026, 5, 2, 5, 44),
          latitude: 30.0444,
          longitude: 31.2357,
          calculationMethod: 'egyptian',
          madhab: 'shafi',
        );

        when(() => mockRepository.getAlarmConfig())
            .thenAnswer((_) async => const Right(config));
        when(() => mockRepository.getCached30DaySchedule())
            .thenAnswer((_) async => Right([today, tomorrow]));
        when(() => mockRepository.saveNextScheduledAlarm(tomorrow.fajrTime))
            .thenAnswer((_) async => const Right(unit));

        final result = await rescheduleUseCase(
          completedAt: DateTime(2026, 5, 1, 4, 20),
        );

        expect(result.getOrElse((_) => null), tomorrow.fajrTime);
        verify(() => mockRepository.saveNextScheduledAlarm(tomorrow.fajrTime))
            .called(1);
      },
    );

    test('recalculates 30-day schedule when cache is empty', () async {
      when(() => mockRepository.getAlarmConfig())
          .thenAnswer((_) async => const Right(config));
      when(() => mockRepository.getCached30DaySchedule())
          .thenAnswer((_) async => const Right([]));
      when(() => mockRepository.save30DaySchedule(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockRepository.saveNextScheduledAlarm(any()))
          .thenAnswer((_) async => const Right(unit));

      final completedAt = DateTime(2026, 5, 1, 5, 0);
      final result = await rescheduleUseCase(completedAt: completedAt);

      expect(result.isRight(), isTrue);
      final nextAlarm = result.getOrElse((_) => null);
      expect(nextAlarm, isNotNull);
      expect(nextAlarm!.day, 2);
      verify(() => mockRepository.save30DaySchedule(any())).called(1);
      verify(() => mockRepository.saveNextScheduledAlarm(nextAlarm)).called(1);
    });

    test('propagates CacheFailure when getAlarmConfig fails', () async {
      when(() => mockRepository.getAlarmConfig()).thenAnswer(
        (_) async => const Left(Failure.cache(message: 'Config missing')),
      );

      final result = await rescheduleUseCase(
        completedAt: DateTime(2026, 5, 1, 4, 20),
      );

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected CacheFailure'),
      );
    });
  });
}
