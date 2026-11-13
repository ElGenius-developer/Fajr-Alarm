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

  @override
  String get scheduleTitle => 'Fajr Schedule';

  @override
  String get scheduleNextAlarmLabel => 'Next Fajr Alarm';

  @override
  String get scheduleAlarmDisabled => 'Alarm is disabled';

  @override
  String get scheduleTodayFajrLabel => 'Today\'s Fajr Adhan';

  @override
  String get scheduleSunriseLabel => 'Sunrise';

  @override
  String get scheduleLockWindowActiveBanner =>
      'Pre-Fajr Lock Window active: alarm changes are locked until the challenge is completed.';

  @override
  String get scheduleModeRelative => 'Relative to Adhan';

  @override
  String get scheduleModeManual => 'Manual Fixed Time';

  @override
  String get scheduleOffsetBefore => 'Before Adhan';

  @override
  String get scheduleOffsetAt => 'At Adhan';

  @override
  String get scheduleOffsetAfter => 'After Adhan';

  @override
  String scheduleOffsetMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get scheduleLocationLabel => 'Location';

  @override
  String get scheduleCalculationMethodLabel => 'Calculation Method';

  @override
  String get schedule30DayTitle => '30-Day Rolling Schedule';

  @override
  String get scheduleRecalculateButton => 'Recalculate 30-Day Schedule';

  @override
  String get scheduleEnableSwitchLabel => 'Enable Fajr Alarm';

  @override
  String get scheduleManualTimeLabel => 'Manual Alarm Time';

  @override
  String get scheduleEmptyState =>
      'No cached prayer schedule found. Tap recalculate to generate 30 days offline.';

  @override
  String get scheduleErrorLockWindow =>
      'Cannot modify alarm during Pre-Fajr Lock Window (T - 30m).';
}
