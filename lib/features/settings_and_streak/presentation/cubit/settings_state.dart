import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/streak_stats.dart';
import '../../domain/entities/user_settings.dart';

part 'settings_state.freezed.dart';

/// Immutable presentation state for [SettingsCubit].
@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isLoading,
    @Default(UserSettings()) UserSettings settings,
    @Default(StreakStats()) StreakStats streakStats,
    @Default(false) bool isWithinLockWindow,
    Failure? failure,
    DateTime? dryRunScheduledAt,
  }) = _SettingsState;
}
