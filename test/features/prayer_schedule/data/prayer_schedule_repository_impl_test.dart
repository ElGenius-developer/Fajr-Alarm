import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/datasources/prayer_schedule_local_data_source.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/fajr_alarm_config_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/models/prayer_schedule_hive_model.dart';
import 'package:fajr_alarm/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPrayerScheduleLocalDataSource extends Mock
    implements PrayerScheduleLocalDataSource {}

void main() {
  late MockPrayerScheduleLocalDataSource mockDataSource;
  late PrayerScheduleRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      FajrAlarmConfigHiveModel.fromDomain(
        PrayerScheduleRepositoryImpl.defaultConfig,
      ),
    );
    registerFallbackValue(<PrayerScheduleHiveModel>[]);
  });

  setUp(() {
    mockDataSource = MockPrayerScheduleLocalDataSource();
    repository = PrayerScheduleRepositoryImpl(mockDataSource);
  });

  group('PrayerScheduleRepositoryImpl', () {
    test('getCached30DaySchedule maps models to domain entities', () async {
      final entity = PrayerSchedule(
        date: DateTime(2026, 5, 1),
        fajrTime: DateTime(2026, 5, 1, 4, 15),
        sunriseTime: DateTime(2026, 5, 1, 5, 45),
        latitude: 30.0444,
        longitude: 31.2357,
        calculationMethod: 'egyptian',
        madhab: 'shafi',
      );
      when(
        () => mockDataSource.get30DaySchedule(),
      ).thenAnswer((_) async => [PrayerScheduleHiveModel.fromDomain(entity)]);

      final result = await repository.getCached30DaySchedule();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => const []), [entity]);
    });

    test('getCached30DaySchedule returns CacheFailure on exception', () async {
      when(() => mockDataSource.get30DaySchedule())
          .thenThrow(Exception('disk corrupt'));

      final result = await repository.getCached30DaySchedule();

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected CacheFailure'),
      );
    });

    test('getAlarmConfig returns defaultConfig when none stored', () async {
      when(() => mockDataSource.getAlarmConfig()).thenAnswer((_) async => null);

      final result = await repository.getAlarmConfig();

      expect(
        result.getOrElse(
          (_) => const FajrAlarmConfig(latitude: 0, longitude: 0),
        ),
        PrayerScheduleRepositoryImpl.defaultConfig,
      );
    });

    test('saveAlarmConfig delegates to local data source', () async {
      when(() => mockDataSource.saveAlarmConfig(any()))
          .thenAnswer((_) async {});

      final result = await repository.saveAlarmConfig(
        PrayerScheduleRepositoryImpl.defaultConfig,
      );

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockDataSource.saveAlarmConfig(any())).called(1);
    });
  });
}
