import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
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
          _PlaceholderScreen(title: AppLocalizations.of(context)!.navSchedule),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (BuildContext context, GoRouterState state) =>
          _PlaceholderScreen(
            title: AppLocalizations.of(context)!.navOnboarding,
          ),
    ),
    GoRoute(
      path: AppRoutes.alarmRinging,
      builder: (BuildContext context, GoRouterState state) =>
          _PlaceholderScreen(title: AppLocalizations.of(context)!.navAlarm),
    ),
    GoRoute(
      path: AppRoutes.challenge,
      builder: (BuildContext context, GoRouterState state) =>
          _PlaceholderScreen(title: AppLocalizations.of(context)!.navChallenge),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          _PlaceholderScreen(title: AppLocalizations.of(context)!.navSettings),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
