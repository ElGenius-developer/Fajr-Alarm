import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPrayerScheduleRepository extends Mock
    implements PrayerScheduleRepository {}

void main() {
  late MockPrayerScheduleRepository mockRepository;
  late Calculate30DayFajrScheduleUseCase useCase;

  const cairoConfig = FajrAlarmConfig(
    latitude: 30.0444,
    longitude: 31.2357,
    cityName: 'Cairo',
    calculationMethod: FajrCalculationMethod.egyptian,
    madhab: FajrMadhab.shafi,
  );

  setUpAll(() {
    registerFallbackValue(<PrayerSchedule>[]);
  });

  setUp(() {
    mockRepository = MockPrayerScheduleRepository();
    useCase = Calculate30DayFajrScheduleUseCase(mockRepository);
  });

  group('Calculate30DayFajrScheduleUseCase', () {
    test(
      'calculates 30 consecutive days offline and persists to repository',
      () async {
        when(() => mockRepository.save30DaySchedule(any()))
            .thenAnswer((_) async => const Right(unit));

        final startDate = DateTime(2026, 5, 1, 14, 30);
        final result = await useCase(config: cairoConfig, startDate: startDate);

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Expected Right, got $failure'), (
          schedules,
        ) {
          expect(schedules, hasLength(30));
          expect(schedules.first.date, DateTime(2026, 5, 1));
          expect(schedules.last.date, DateTime(2026, 5, 30));
          for (final day in schedules) {
            expect(day.fajrTime.isBefore(day.sunriseTime), isTrue);
            expect(day.latitude, cairoConfig.latitude);
            expect(day.longitude, cairoConfig.longitude);
            expect(day.calculationMethod, 'egyptian');
            expect(day.madhab, 'shafi');
          }
        });
        verify(() => mockRepository.save30DaySchedule(any())).called(1);
      },
    );

    test('returns ValidationFailure when latitude is out of range', () async {
      const invalidConfig = FajrAlarmConfig(latitude: 95.0, longitude: 31.0);

      final result = await useCase(config: invalidConfig, persist: false);

      expect(result, isA<Left<Failure, List<PrayerSchedule>>>());
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepository.save30DaySchedule(any()));
    });

    test('returns ValidationFailure when longitude is out of range', () async {
      const invalidConfig = FajrAlarmConfig(latitude: 30.0, longitude: -181.0);

      final result = await useCase(config: invalidConfig, persist: false);

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns CacheFailure if repository save fails', () async {
      when(() => mockRepository.save30DaySchedule(any())).thenAnswer(
        (_) async => const Left(Failure.cache(message: 'Hive write error')),
      );

      final result = await useCase(
        config: cairoConfig,
        startDate: DateTime(2026, 5, 1),
      );

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
