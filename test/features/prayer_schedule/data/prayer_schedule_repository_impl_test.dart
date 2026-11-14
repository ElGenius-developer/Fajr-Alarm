import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
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

class MockAlarmPlatformRepository extends Mock
    implements AlarmPlatformRepository {}

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

    test('saveNextScheduledAlarm schedules OS alarm when non-null', () async {
      final mockPlatform = MockAlarmPlatformRepository();
      final wiredRepo = PrayerScheduleRepositoryImpl(
        mockDataSource,
        alarmPlatformRepository: mockPlatform,
      );
      final target = DateTime(2026, 5, 1, 4, 15);
      when(() => mockDataSource.saveNextScheduledAlarm(target))
          .thenAnswer((_) async {});
      when(
        () => mockPlatform.scheduleAlarm(scheduledAt: target, isDryRun: false),
      ).thenAnswer((_) async => const Right(unit));

      final result = await wiredRepo.saveNextScheduledAlarm(target);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockDataSource.saveNextScheduledAlarm(target)).called(1);
      verify(
        () => mockPlatform.scheduleAlarm(scheduledAt: target, isDryRun: false),
      ).called(1);
    });

    test('saveNextScheduledAlarm cancels OS alarms when null', () async {
      final mockPlatform = MockAlarmPlatformRepository();
      final wiredRepo = PrayerScheduleRepositoryImpl(
        mockDataSource,
        alarmPlatformRepository: mockPlatform,
      );
      when(() => mockDataSource.saveNextScheduledAlarm(null))
          .thenAnswer((_) async {});
      when(() => mockPlatform.cancelAllAlarms())
          .thenAnswer((_) async => const Right(unit));

      final result = await wiredRepo.saveNextScheduledAlarm(null);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockDataSource.saveNextScheduledAlarm(null)).called(1);
      verify(() => mockPlatform.cancelAllAlarms()).called(1);
    });

    test('saveNextScheduledAlarm propagates platform failure', () async {
      final mockPlatform = MockAlarmPlatformRepository();
      final wiredRepo = PrayerScheduleRepositoryImpl(
        mockDataSource,
        alarmPlatformRepository: mockPlatform,
      );
      final target = DateTime(2026, 5, 1, 4, 15);
      when(() => mockDataSource.saveNextScheduledAlarm(target))
          .thenAnswer((_) async {});
      when(
        () => mockPlatform.scheduleAlarm(scheduledAt: target, isDryRun: false),
      ).thenAnswer(
        (_) async => const Left(Failure.permission(message: 'Denied')),
      );

      final result = await wiredRepo.saveNextScheduledAlarm(target);

      result.fold(
        (failure) => expect(failure, isA<PermissionFailure>()),
        (_) => fail('Expected PermissionFailure'),
      );
    });

    test(
      'save30DaySchedule delegates to local data source and handles errors',
      () async {
        final entity = PrayerSchedule(
          date: DateTime(2026, 5, 1),
          fajrTime: DateTime(2026, 5, 1, 4, 15),
          sunriseTime: DateTime(2026, 5, 1, 5, 45),
          latitude: 30.0444,
          longitude: 31.2357,
          calculationMethod: 'egyptian',
          madhab: 'shafi',
        );
        when(() => mockDataSource.save30DaySchedule(any()))
            .thenAnswer((_) async {});

        final ok = await repository.save30DaySchedule([entity]);
        expect(ok, const Right<Failure, Unit>(unit));

        when(() => mockDataSource.save30DaySchedule(any()))
            .thenThrow(Exception('write err'));
        final err = await repository.save30DaySchedule([entity]);
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'getAlarmConfig returns stored domain config and handles errors',
      () async {
        final custom = FajrAlarmConfig(
          latitude: 21.4225,
          longitude: 39.8262,
          cityName: 'Makkah',
          calculationMethod: FajrCalculationMethod.ummAlQura,
        );
        when(
          () => mockDataSource.getAlarmConfig(),
        ).thenAnswer((_) async => FajrAlarmConfigHiveModel.fromDomain(custom));

        final ok = await repository.getAlarmConfig();
        expect(ok, Right<Failure, FajrAlarmConfig>(custom));

        when(() => mockDataSource.getAlarmConfig())
            .thenThrow(Exception('read err'));
        final err = await repository.getAlarmConfig();
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'saveAlarmConfig returns CacheFailure when data source throws',
      () async {
        when(() => mockDataSource.saveAlarmConfig(any()))
            .thenThrow(Exception('write err'));

        final err = await repository.saveAlarmConfig(
          PrayerScheduleRepositoryImpl.defaultConfig,
        );
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'getNextScheduledAlarm returns stored alarm and handles errors',
      () async {
        final target = DateTime(2026, 5, 2, 4, 14);
        when(() => mockDataSource.getNextScheduledAlarm())
            .thenAnswer((_) async => target);

        final ok = await repository.getNextScheduledAlarm();
        expect(ok, Right<Failure, DateTime?>(target));

        when(() => mockDataSource.getNextScheduledAlarm())
            .thenThrow(Exception('read err'));
        final err = await repository.getNextScheduledAlarm();
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'saveNextScheduledAlarm returns CacheFailure when local save throws',
      () async {
        when(() => mockDataSource.saveNextScheduledAlarm(any()))
            .thenThrow(Exception('write err'));

        final err = await repository.saveNextScheduledAlarm(
          DateTime(2026, 5, 2, 4, 14),
        );
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'save30DaySchedule delegates to local data source and handles errors',
      () async {
        final entity = PrayerSchedule(
          date: DateTime(2026, 5, 1),
          fajrTime: DateTime(2026, 5, 1, 4, 15),
          sunriseTime: DateTime(2026, 5, 1, 5, 45),
          latitude: 30.0444,
          longitude: 31.2357,
          calculationMethod: 'egyptian',
          madhab: 'shafi',
        );
        when(() => mockDataSource.save30DaySchedule(any()))
            .thenAnswer((_) async {});

        final ok = await repository.save30DaySchedule([entity]);
        expect(ok, const Right<Failure, Unit>(unit));

        when(() => mockDataSource.save30DaySchedule(any()))
            .thenThrow(Exception('write err'));
        final err = await repository.save30DaySchedule([entity]);
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'getAlarmConfig returns stored domain config and handles errors',
      () async {
        final custom = FajrAlarmConfig(
          latitude: 21.4225,
          longitude: 39.8262,
          cityName: 'Makkah',
          calculationMethod: FajrCalculationMethod.ummAlQura,
        );
        when(
          () => mockDataSource.getAlarmConfig(),
        ).thenAnswer((_) async => FajrAlarmConfigHiveModel.fromDomain(custom));

        final ok = await repository.getAlarmConfig();
        expect(ok, Right<Failure, FajrAlarmConfig>(custom));

        when(() => mockDataSource.getAlarmConfig())
            .thenThrow(Exception('read err'));
        final err = await repository.getAlarmConfig();
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'saveAlarmConfig returns CacheFailure when data source throws',
      () async {
        when(() => mockDataSource.saveAlarmConfig(any()))
            .thenThrow(Exception('write err'));

        final err = await repository.saveAlarmConfig(
          PrayerScheduleRepositoryImpl.defaultConfig,
        );
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'getNextScheduledAlarm returns stored alarm and handles errors',
      () async {
        final target = DateTime(2026, 5, 2, 4, 14);
        when(() => mockDataSource.getNextScheduledAlarm())
            .thenAnswer((_) async => target);

        final ok = await repository.getNextScheduledAlarm();
        expect(ok, Right<Failure, DateTime?>(target));

        when(() => mockDataSource.getNextScheduledAlarm())
            .thenThrow(Exception('read err'));
        final err = await repository.getNextScheduledAlarm();
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );

    test(
      'saveNextScheduledAlarm returns CacheFailure when local save throws',
      () async {
        when(() => mockDataSource.saveNextScheduledAlarm(any()))
            .thenThrow(Exception('write err'));

        final err = await repository.saveNextScheduledAlarm(
          DateTime(2026, 5, 2, 4, 14),
        );
        err.fold(
          (f) => expect(f, isA<CacheFailure>()),
          (_) => fail('Expected CacheFailure'),
        );
      },
    );
  });
}
