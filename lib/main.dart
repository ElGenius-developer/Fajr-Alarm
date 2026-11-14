import 'package:fajr_alarm/core/di/injection.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/router/app_router.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const FajrAlarmApp());
}

/// Root application widget with RTL/LTR localization and Material 3 theming.
class FajrAlarmApp extends StatelessWidget {
  const FajrAlarmApp({super.key});

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
          return MaterialApp.router(
            locale: Locale(state.settings.locale),
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: AppTheme.light(style),
            darkTheme: AppTheme.dark(style),
            themeMode: AppTheme.parseThemeMode(state.settings.themeMode),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
