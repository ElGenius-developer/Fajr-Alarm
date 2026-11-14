import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the 30-day Fajr schedule, alarm offset/manual configuration,
/// and Pre-Fajr Lock Window UI state.
class PrayerScheduleCubit extends Cubit<PrayerScheduleState> {
  PrayerScheduleCubit({
    required this._loadSchedule,
    required this._updateConfig,
    required this._rescheduleTomorrow,
  }) : super(const PrayerScheduleState.initial());

  final LoadPrayerScheduleUseCase _loadSchedule;
  final UpdateFajrAlarmConfigUseCase _updateConfig;
  final RescheduleTomorrowFajrUseCase _rescheduleTomorrow;

  /// Loads the persisted config and 30-day rolling schedule.
  Future<void> loadSchedule({DateTime? now}) async {
    if (isClosed) return;
    emit(const PrayerScheduleState.loading());
    final result = await _loadSchedule(now: now);
    if (isClosed) return;
    result.fold(
      (failure) => emit(PrayerScheduleState.error(failure: failure)),
      (overview) => emit(
        PrayerScheduleState.loaded(
          config: overview.config,
          schedules: overview.schedules,
          nextAlarmTime: overview.nextAlarmTime,
          isWithinLockWindow: overview.isWithinLockWindow,
          actionFailure: overview.actionFailure,
        ),
      ),
    );
  }

  /// Updates [FajrAlarmConfig] unless inside the Pre-Fajr Lock Window (T - 30m).
  Future<void> updateConfig(FajrAlarmConfig newConfig, {DateTime? now}) async {
    final currentState = state;
    final result = await _updateConfig(newConfig: newConfig, now: now);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (currentState is PrayerScheduleLoaded) {
          emit(currentState.copyWith(actionFailure: failure));
        } else {
          emit(PrayerScheduleState.error(failure: failure));
        }
      },
      (overview) => emit(
        PrayerScheduleState.loaded(
          config: overview.config,
          schedules: overview.schedules,
          nextAlarmTime: overview.nextAlarmTime,
          isWithinLockWindow: overview.isWithinLockWindow,
          actionFailure: overview.actionFailure,
        ),
      ),
    );
  }

  /// Triggers automatic rescheduling for tomorrow's Fajr after `[COMPLETED]`.
  Future<void> rescheduleAfterCompletion({DateTime? completedAt}) async {
    final result = await _rescheduleTomorrow(completedAt: completedAt);
    if (isClosed) return;
    await result.fold((failure) async {
      final currentState = state;
      if (currentState is PrayerScheduleLoaded) {
        emit(currentState.copyWith(actionFailure: failure));
      } else {
        emit(PrayerScheduleState.error(failure: failure));
      }
    }, (_) => loadSchedule(now: completedAt));
  }
}
