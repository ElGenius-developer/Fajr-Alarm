import 'dart:async';

import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/core/l10n/app_localization_delegates.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/router/app_router.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_state.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const FajrAlarmApp());
}

/// Root application widget with RTL/LTR localization and Material 3 theming.
class FajrAlarmApp extends StatefulWidget {
  const FajrAlarmApp({super.key, this.router});

  final GoRouter? router;

  @override
  State<FajrAlarmApp> createState() => _FajrAlarmAppState();
}

class _FajrAlarmAppState extends State<FajrAlarmApp>
    with WidgetsBindingObserver {
  late final GoRouter _router = widget.router ?? createAppRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (sl.isRegistered<AlarmPlatformRepository>()) {
      sl<AlarmPlatformRepository>().listenForAlarmTriggers(
        ({required bool isDryRun, required bool snoozeUsed}) =>
            _openAlarmRinging(isDryRun: isDryRun, snoozeUsed: snoozeUsed),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_consumePendingAlarmTrigger());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_consumePendingAlarmTrigger());
    }
  }

  Future<void> _consumePendingAlarmTrigger() async {
    if (!mounted || !sl.isRegistered<AlarmPlatformRepository>()) {
      return;
    }
    final result = await sl<AlarmPlatformRepository>()
        .consumePendingAlarmTrigger();
    if (!mounted) {
      return;
    }
    result.fold((_) {}, (Map<String, dynamic>? payload) {
      if (payload != null) {
        _openAlarmRinging(
          isDryRun: payload['isDryRun'] as bool? ?? false,
          snoozeUsed: payload['snoozeUsed'] as bool? ?? false,
        );
      }
    });
  }

  void _openAlarmRinging({required bool isDryRun, bool snoozeUsed = false}) {
    if (!mounted) {
      return;
    }
    final String location = _router.routeInformationProvider.value.uri.path;
    if (location == AppRoutes.alarmRinging || location == AppRoutes.challenge) {
      return;
    }
    final int remainingOverrides = sl.isRegistered<SettingsCubit>()
        ? sl<SettingsCubit>().state.settings.remainingEmergencyQuota
        : 3;
    final int startedAtMs = DateTime.now().millisecondsSinceEpoch;
    _router.go(
      '${AppRoutes.alarmRinging}?autoTrigger=true&dryRun=$isDryRun&remainingOverrides=$remainingOverrides&startedAt=$startedAtMs&snoozeUsed=$snoozeUsed',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (sl.isRegistered<AlarmPlatformRepository>()) {
      sl<AlarmPlatformRepository>().listenForAlarmTriggers(null);
    }
    if (widget.router == null) {
      _router.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: sl<SettingsCubit>()..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (SettingsState previous, SettingsState current) =>
            previous.settings.locale != current.settings.locale ||
            previous.settings.themeMode != current.settings.themeMode ||
            previous.settings.designStyle != current.settings.designStyle,
        builder: (BuildContext context, SettingsState state) {
          final style = AppDesignStyle.fromKey(state.settings.designStyle);
          final isArabic = state.settings.locale == 'ar';
          return MaterialApp.router(
            locale: Locale(state.settings.locale),
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: AppTheme.light(style, isArabic),
            darkTheme: AppTheme.dark(style, isArabic),
            themeMode: AppTheme.parseThemeMode(state.settings.themeMode),
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
