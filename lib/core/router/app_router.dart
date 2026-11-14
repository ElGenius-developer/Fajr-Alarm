import 'dart:async';
import 'dart:math' as math;

import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_state_entity.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/usecases/complete_alarm_usecase.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/pages/alarm_ringing_page.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/pages/challenge_page.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/usecases/reschedule_tomorrow_fajr_usecase.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/consume_emergency_quota_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/domain/usecases/record_alarm_completion_usecase.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';

/// Canonical route paths for Fajr-Alarm.
abstract final class AppRoutes {
  static const String schedule = '/';
  static const String onboarding = '/onboarding';
  static const String alarmRinging = '/alarm-ringing';
  static const String challenge = '/challenge';
  static const String settings = '/settings';
}

/// Builds a fresh [GoRouter] configured with an onboarding gate on `/`.
GoRouter createAppRouter({
  OnboardingRepository? onboardingRepository,
  String initialLocation = AppRoutes.schedule,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (BuildContext context, GoRouterState state) async {
      if (state.matchedLocation != AppRoutes.schedule) {
        return null;
      }
      final OnboardingRepository? repo =
          onboardingRepository ??
          (sl.isRegistered<OnboardingRepository>()
              ? sl<OnboardingRepository>()
              : null);
      if (repo == null) {
        return null;
      }
      final Either<Failure, OnboardingStateEntity> onboardingResult = await repo
          .getOnboardingState();
      final bool isCompleted = onboardingResult.fold(
        (_) => false,
        (OnboardingStateEntity entity) => entity.isCompleted,
      );
      return isCompleted ? null : AppRoutes.onboarding;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.schedule,
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<PrayerScheduleCubit>(
              create: (_) => sl<PrayerScheduleCubit>()..loadSchedule(),
              child: PrayerSchedulePage(
                onOpenSettings: () {
                  if (sl.isRegistered<SettingsCubit>()) {
                    unawaited(sl<SettingsCubit>().load());
                  }
                  context.push(AppRoutes.settings);
                },
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<OnboardingCubit>(
              create: (_) => sl<OnboardingCubit>()..loadOnboarding(),
              child: OnboardingPage(
                onCompleted: () => context.go(AppRoutes.schedule),
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.alarmRinging,
        builder: (BuildContext context, GoRouterState state) {
          final bool isDryRun = state.uri.queryParameters['dryRun'] == 'true';
          final bool autoTrigger =
              state.uri.queryParameters['autoTrigger'] == 'true';
          final int remainingOverrides =
              int.tryParse(
                state.uri.queryParameters['remainingOverrides'] ?? '',
              ) ??
              3;
          final int startedAtMs =
              int.tryParse(state.uri.queryParameters['startedAt'] ?? '') ??
              DateTime.now().millisecondsSinceEpoch;

          return BlocProvider<AlarmRingingBloc>(
            create: (_) {
              final AlarmRingingBloc bloc = sl<AlarmRingingBloc>();
              if (autoTrigger) {
                bloc.add(
                  AlarmRingingEvent.alarmTriggered(
                    scheduledAt: DateTime.now(),
                    isDryRun: isDryRun,
                    remainingEmergencyOverrides: remainingOverrides,
                  ),
                );
              }
              return bloc;
            },
            child: AlarmRingingPage(
              onStartChallenge: () => context.go(
                '${AppRoutes.challenge}?dryRun=$isDryRun&startedAt=$startedAtMs',
              ),
              onEmergencyCompleted: () async {
                await finalizeEmergencyOverride(isDryRun: isDryRun);
                if (context.mounted) {
                  context.go(AppRoutes.schedule);
                }
              },
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.challenge,
        builder: (BuildContext context, GoRouterState state) {
          final bool isDryRun = state.uri.queryParameters['dryRun'] == 'true';
          final int? startedAtMs = int.tryParse(
            state.uri.queryParameters['startedAt'] ?? '',
          );
          final DateTime? startedAt = startedAtMs != null
              ? DateTime.fromMillisecondsSinceEpoch(startedAtMs)
              : null;

          return BlocProvider<ChallengeCubit>(
            create: (_) => sl<ChallengeCubit>(),
            child: ChallengePage(
              onChallengeCompleted: () async {
                await finalizeChallengeCompletion(
                  isDryRun: isDryRun,
                  startedAt: startedAt,
                );
                if (context.mounted) {
                  context.go(AppRoutes.schedule);
                }
              },
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
    ],
  );
}

/// Stops ringing/pinning/cascade alarms, updates streak KPIs, and schedules tomorrow.
Future<void> finalizeChallengeCompletion({
  required bool isDryRun,
  DateTime? startedAt,
}) async {
  final DateTime now = DateTime.now();
  if (sl.isRegistered<CompleteAlarmUseCase>()) {
    await sl<CompleteAlarmUseCase>()(
      AlarmStateEntity(status: AlarmStatus.challengeActive, isDryRun: isDryRun),
    );
  }
  final int elapsedSeconds = startedAt != null
      ? math.max(0, now.difference(startedAt).inSeconds)
      : 0;
  if (sl.isRegistered<RecordAlarmCompletionUseCase>()) {
    await sl<RecordAlarmCompletionUseCase>()(
      timeToWakeSeconds: elapsedSeconds,
      isDryRun: isDryRun,
      completed: true,
      completedAt: now,
    );
  }
  if (sl.isRegistered<RescheduleTomorrowFajrUseCase>()) {
    await sl<RescheduleTomorrowFajrUseCase>()(completedAt: now);
  }
  if (sl.isRegistered<SettingsCubit>()) {
    sl<SettingsCubit>().clearActiveDryRun();
    await sl<SettingsCubit>().load();
  }
}

/// Consumes monthly emergency quota, records incomplete wake, and reschedules tomorrow.
Future<void> finalizeEmergencyOverride({required bool isDryRun}) async {
  final DateTime now = DateTime.now();
  if (!isDryRun && sl.isRegistered<ConsumeEmergencyQuotaUseCase>()) {
    await sl<ConsumeEmergencyQuotaUseCase>()(now: now);
  }
  if (!isDryRun && sl.isRegistered<RecordAlarmCompletionUseCase>()) {
    await sl<RecordAlarmCompletionUseCase>()(
      timeToWakeSeconds: 0,
      isDryRun: false,
      completed: false,
      completedAt: now,
    );
  }
  if (sl.isRegistered<RescheduleTomorrowFajrUseCase>()) {
    await sl<RescheduleTomorrowFajrUseCase>()(completedAt: now);
  }
  if (sl.isRegistered<SettingsCubit>()) {
    sl<SettingsCubit>().clearActiveDryRun();
    await sl<SettingsCubit>().load();
  }
}
