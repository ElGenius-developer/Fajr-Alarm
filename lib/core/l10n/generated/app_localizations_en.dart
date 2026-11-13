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

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsKpisTitle => 'Local-Only KPIs & Streak';

  @override
  String get settingsCurrentStreak => 'Current Streak';

  @override
  String get settingsLongestStreak => 'Longest Streak';

  @override
  String settingsStreakDays(int count) {
    return '$count days';
  }

  @override
  String get settingsStreakFrozenBadge => 'Streak Frozen (Vacation)';

  @override
  String get settingsCompletionRate => 'Completion Rate';

  @override
  String get settingsAvgTimeToWake => 'Avg. Time-to-Wake';

  @override
  String settingsMinutesValue(String minutes) {
    return '$minutes min';
  }

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsVacationTitle => 'Vacation Mode';

  @override
  String get settingsVacationSubtitle =>
      'Pause Fajr alarms with Streak Freeze for a fixed number of days.';

  @override
  String get settingsVacationDurationLabel => 'Duration (days)';

  @override
  String get settingsVacationActivateButton => 'Activate Vacation Mode';

  @override
  String settingsVacationActiveUntil(String date) {
    return 'Active until $date';
  }

  @override
  String get settingsEmergencyQuotaTitle => 'Monthly Emergency Override Quota';

  @override
  String settingsEmergencyQuotaRemaining(int remaining, int total) {
    return '$remaining of $total remaining this month';
  }

  @override
  String get settingsDryRunTitle => '10-Second Dry-Run Alarm';

  @override
  String get settingsDryRunSubtitle =>
      'Test alarm audio, lock screen, and camera without affecting your streak.';

  @override
  String get settingsDryRunButton => 'Test Alarm Now (10s)';

  @override
  String get settingsDryRunScheduled =>
      'Dry-run alarm scheduled for 10 seconds from now.';

  @override
  String get settingsLockWindowNotice =>
      'Pre-Fajr Lock Window active (T - 30m): alarm, quota, and vacation changes are locked.';

  @override
  String get settingsErrorLockWindow =>
      'Action blocked during the 30-minute Pre-Fajr Lock Window.';

  @override
  String get settingsErrorQuotaExceeded =>
      'Monthly emergency override quota exceeded.';

  @override
  String get settingsErrorValidation => 'Please enter a valid value.';

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
