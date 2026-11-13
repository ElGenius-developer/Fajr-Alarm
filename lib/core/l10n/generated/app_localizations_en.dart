// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fajr-Alarm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSkip => 'Skip for now';

  @override
  String get commonDone => 'Done';

  @override
  String get commonErrorGeneric =>
      'An unexpected error occurred. Please try again.';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navSettings => 'Settings';

  @override
  String get navChallenge => 'Proof-of-Action Challenge';

  @override
  String get navAlarm => 'Fajr Alarm';

  @override
  String get navOnboarding => 'Setup';
}
