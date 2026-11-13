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
  String get alarmRingingTitle => 'Fajr Alarm';

  @override
  String get alarmStatusIdle => 'Alarm Scheduled';

  @override
  String get alarmStatusLockedPreFajr => 'Pre-Fajr Lock Window Active';

  @override
  String get alarmStatusRingingInitial => 'Time for Fajr!';

  @override
  String get alarmStatusSnoozed => 'Snoozed — 5 Minutes';

  @override
  String get alarmStatusRingingRelentless => 'Relentless Ringing — Wake Up!';

  @override
  String get alarmStatusChallengeActive => 'Challenge in Progress';

  @override
  String get alarmStatusCompleted => 'Fajr Alarm Completed';

  @override
  String get alarmStatusVacationFrozen => 'Vacation Mode Active';

  @override
  String get alarmSnoozeButton => 'Snooze (5 min)';

  @override
  String get alarmStartChallengeButton => 'Start Proof-of-Action Challenge';

  @override
  String get alarmEmergencyHoldButton => 'Hold 60s for Emergency Override';

  @override
  String alarmEmergencyMutedHint(int seconds) {
    return 'Audio muted — keep holding (${seconds}s left)';
  }

  @override
  String get alarmEmergencyReleasedError =>
      'Released early — timer reset and alarm resumed.';

  @override
  String get alarmEmergencyNoQuota =>
      'No emergency overrides remaining this month.';

  @override
  String get alarmDryRunBadge => 'Dry-Run Test Alarm';

  @override
  String alarmSnoozeCountdown(String time) {
    return 'Next ring in $time';
  }

  @override
  String get alarmRelentlessLoopHint =>
      'Ringing every 1 minute until challenge is completed';

  @override
  String alarmEmergencyRemainingCount(int count) {
    return 'Emergency overrides left: $count';
  }
}
