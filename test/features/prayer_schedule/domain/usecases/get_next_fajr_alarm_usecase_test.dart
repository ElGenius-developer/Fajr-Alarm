import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/get_next_fajr_alarm_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetNextFajrAlarmUseCase useCase;

  final day1 = PrayerSchedule(
    date: DateTime(2026, 5, 1),
    fajrTime: DateTime(2026, 5, 1, 4, 15),
    sunriseTime: DateTime(2026, 5, 1, 5, 45),
    latitude: 30.0444,
    longitude: 31.2357,
    calculationMethod: 'egyptian',
    madhab: 'shafi',
  );

  final day2 = PrayerSchedule(
    date: DateTime(2026, 5, 2),
    fajrTime: DateTime(2026, 5, 2, 4, 14),
    sunriseTime: DateTime(2026, 5, 2, 5, 44),
    latitude: 30.0444,
    longitude: 31.2357,
    calculationMethod: 'egyptian',
    madhab: 'shafi',
  );

  setUp(() {
    useCase = const GetNextFajrAlarmUseCase();
  });

  group('GetNextFajrAlarmUseCase', () {
    test('returns Fajr time when mode is relative at Adhan', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        mode: FajrAlarmMode.relativeToAdhan,
        offsetDirection: FajrOffsetDirection.at,
      );

      final result = useCase(
        schedules: [day2, day1], // deliberately unsorted
        config: config,
        now: DateTime(2026, 5, 1, 3, 0),
      );

      expect(result.getOrElse((_) => null), DateTime(2026, 5, 1, 4, 15));
    });

    test('subtracts offsetMinutes when offsetDirection is before', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        mode: FajrAlarmMode.relativeToAdhan,
        offsetDirection: FajrOffsetDirection.before,
        offsetMinutes: 15,
      );

      final result = useCase(
        schedules: [day1, day2],
        config: config,
        now: DateTime(2026, 5, 1, 3, 0),
      );

      expect(result.getOrElse((_) => null), DateTime(2026, 5, 1, 4, 0));
    });

    test(
      'adds offsetMinutes and rolls to next day when today already passed',
      () {
        const config = FajrAlarmConfig(
          latitude: 30.0444,
          longitude: 31.2357,
          mode: FajrAlarmMode.relativeToAdhan,
          offsetDirection: FajrOffsetDirection.after,
          offsetMinutes: 10,
        );

        final result = useCase(
          schedules: [day1, day2],
          config: config,
          now: DateTime(2026, 5, 1, 4, 30),
        );

        expect(result.getOrElse((_) => null), DateTime(2026, 5, 2, 4, 24));
      },
    );

    test('returns manual fixed time when mode is manualTime', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        mode: FajrAlarmMode.manualTime,
        manualHour: 4,
        manualMinute: 45,
      );

      final result = useCase(
        schedules: const [],
        config: config,
        now: DateTime(2026, 5, 1, 4, 50),
      );

      expect(result.getOrElse((_) => null), DateTime(2026, 5, 2, 4, 45));
    });

    test('returns null when alarm is disabled', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        isEnabled: false,
      );

      final result = useCase(
        schedules: [day1],
        config: config,
        now: DateTime(2026, 5, 1, 3, 0),
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => DateTime(1999)), isNull);
    });

    test('returns CacheFailure when schedules are empty in relative mode', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        mode: FajrAlarmMode.relativeToAdhan,
      );

      final result = useCase(
        schedules: const [],
        config: config,
        now: DateTime(2026, 5, 1, 3, 0),
      );

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected CacheFailure'),
      );
    });

    test('returns ValidationFailure when offsetMinutes is negative', () {
      const config = FajrAlarmConfig(
        latitude: 30.0444,
        longitude: 31.2357,
        offsetMinutes: -5,
      );

      final result = useCase(
        schedules: [day1],
        config: config,
        now: DateTime(2026, 5, 1, 3, 0),
      );

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected ValidationFailure'),
      );
    });
  });
}
