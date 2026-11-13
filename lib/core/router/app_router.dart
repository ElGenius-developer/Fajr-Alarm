import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/pages/alarm_ringing_page.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/pages/challenge_page.dart';
import 'package:fajr_alarm/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:fajr_alarm/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Canonical route paths for Fajr-Alarm.
abstract final class AppRoutes {
  static const String schedule = '/';
  static const String onboarding = '/onboarding';
  static const String alarmRinging = '/alarm-ringing';
  static const String challenge = '/challenge';
  static const String settings = '/settings';
}

/// Application router configured with [GoRouter].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.schedule,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.schedule,
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<PrayerScheduleCubit>(
            create: (_) => sl<PrayerScheduleCubit>()..loadSchedule(),
            child: PrayerSchedulePage(
              onOpenSettings: () => context.push(AppRoutes.settings),
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
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<AlarmRingingBloc>(
            create: (_) => sl<AlarmRingingBloc>(),
            child: AlarmRingingPage(
              onStartChallenge: () => context.go(AppRoutes.challenge),
            ),
          ),
    ),
    GoRoute(
      path: AppRoutes.challenge,
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<ChallengeCubit>(
            create: (_) => sl<ChallengeCubit>(),
            child: ChallengePage(
              onChallengeCompleted: () => context.go(AppRoutes.schedule),
            ),
          ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsPage(),
    ),
  ],
);
