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

  @override
  String get challengeTitle => 'Proof-of-Action Challenge';

  @override
  String get challengePhotoInstruction =>
      'Stand on your prayer rug, point the camera down at your feet (-45° to -90°), and take a live photo.';

  @override
  String challengeTiltValid(String degrees) {
    return 'Standing angle OK ($degrees°)';
  }

  @override
  String challengeTiltInvalid(String degrees) {
    return 'Point phone downward between -45° and -90° (current: $degrees°)';
  }

  @override
  String get challengeCapturePhoto => 'Capture Live Photo';

  @override
  String get challengeToggleTorch => 'Toggle Flash';

  @override
  String get challengeVerifying => 'Verifying...';

  @override
  String get challengeVerifiedSuccess =>
      'Challenge completed! Alarm dismissed.';

  @override
  String get challengeRejectedDefault =>
      'Verification failed. Please stand on the prayer rug and try again.';

  @override
  String get challengeOfflineFallbackNotice =>
      'Offline mode active. Complete the fallback challenge.';

  @override
  String get challengeBarcodeTitle => 'Bathroom Barcode Challenge';

  @override
  String get challengeBarcodeInstruction =>
      'Walk to the bathroom and scan your registered product barcode.';

  @override
  String get challengeBarcodeMismatch =>
      'Scanned barcode does not match your registered bathroom product.';

  @override
  String get challengeTypingTitle => 'Standing Typing Challenge';

  @override
  String get challengeTypingInstruction =>
      'Hold your phone at a standing angle (-45° to -90°) and type the 120-character text exactly without pasting.';

  @override
  String challengeTypingCounter(int current, int target) {
    return '$current / $target';
  }

  @override
  String get challengeTypingSubmit => 'Verify Text';

  @override
  String get challengeTypingMismatch =>
      'Text does not match exactly or is incomplete.';

  @override
  String get challengeCameraUnavailable =>
      'Camera unavailable. Switching to Standing Typing Challenge.';

  @override
  String get challengeAdhkarPrompt =>
      'SubhanAllah wa bihamdihi, SubhanAllahil Azeem, Astaghfirullah al-Azeem wa atubu ilayhi, La ilaha illa Allah wahdahu now.';

  @override
  String get onboardingTitle => 'Fajr-Alarm Setup';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingStep1Title => 'Location & City';

  @override
  String get onboardingStep1Subtitle =>
      'Select your city or enter coordinates to calculate Fajr prayer times offline.';

  @override
  String get onboardingCityLabel => 'City Name';

  @override
  String get onboardingCityHint => 'e.g., Cairo';

  @override
  String get onboardingLatitudeLabel => 'Latitude';

  @override
  String get onboardingLongitudeLabel => 'Longitude';

  @override
  String get onboardingPresetCitiesLabel => 'Quick Select City';

  @override
  String get onboardingCityCairo => 'Cairo';

  @override
  String get onboardingCityMakkah => 'Makkah';

  @override
  String get onboardingCityMadinah => 'Madinah';

  @override
  String get onboardingCityRiyadh => 'Riyadh';

  @override
  String get onboardingCityIstanbul => 'Istanbul';

  @override
  String get onboardingCityLondon => 'London';

  @override
  String get onboardingLocationSaveButton => 'Save Location & Continue';

  @override
  String get onboardingLocationErrorInvalid =>
      'Please enter a valid city name and coordinates.';

  @override
  String get onboardingStep2Title => 'Mandatory Permissions Gate';

  @override
  String get onboardingStep2Subtitle =>
      'Fajr-Alarm requires these system permissions to ring reliably over your lock screen and verify your wake-up.';

  @override
  String get onboardingPermFullScreenTitle => 'Full-Screen Lock Bypass';

  @override
  String get onboardingPermFullScreenDesc =>
      'Allows the alarm challenge to appear directly over the lock screen.';

  @override
  String get onboardingPermBatteryTitle => 'Ignore Battery Optimizations';

  @override
  String get onboardingPermBatteryDesc =>
      'Prevents the OS from killing the Fajr alarm before dawn.';

  @override
  String get onboardingPermCameraTitle => 'Camera Access';

  @override
  String get onboardingPermCameraDesc =>
      'Required for the live Proof-of-Action prayer rug photo and barcode scan.';

  @override
  String get onboardingPermAlarmTitle => 'Exact Alarms / AlarmKit';

  @override
  String get onboardingPermAlarmDesc =>
      'Schedules exact Fajr wake-up alarms on Android and iOS 26+.';

  @override
  String get onboardingPermGranted => 'Granted';

  @override
  String get onboardingPermMissing => 'Required';

  @override
  String get onboardingPermRequestButton => 'Grant Permissions';

  @override
  String get onboardingPermRefreshButton => 'Refresh Status';

  @override
  String get onboardingPermGateBlocked =>
      'All mandatory permissions must be granted before continuing.';

  @override
  String get onboardingStep3Title => 'Privacy & Gemini API Key';

  @override
  String get onboardingStep3Subtitle =>
      'Fajr-Alarm uses your own Google AI Studio key (BYOK). No servers, no stored photos.';

  @override
  String get onboardingPrivacyNoticeTitle => 'Privacy & Free Tier Disclosure';

  @override
  String get onboardingPrivacyNoticeBody =>
      'Your challenge photos stay in RAM only and are purged immediately (< 500ms) without saving to disk or gallery. However, Google\'s Gemini API Free Tier may use submitted inputs and outputs to improve Google products and may be reviewed by human reviewers. You can enable billing in your Google AI Studio account to opt out of Google\'s free-tier data usage.';

  @override
  String get onboardingPrivacyConsentCheckbox =>
      'I understand Google\'s Free Tier terms and explicitly consent to sending live challenge photos to Gemini using my own API key.';

  @override
  String get onboardingApiKeyLabel => 'Gemini API Key';

  @override
  String get onboardingApiKeyHint => 'Paste your Google AI Studio key';

  @override
  String get onboardingTestKeyButton => 'Test & Save Key';

  @override
  String get onboardingTestingKey => 'Testing key...';

  @override
  String get onboardingKeyValidated => 'API key verified and saved securely.';

  @override
  String get onboardingConsentRequiredError =>
      'You must accept the privacy disclosure before saving your API key.';

  @override
  String get onboardingApiKeyInvalidError =>
      'API key validation failed. Check your key and connection.';

  @override
  String get onboardingStep4Title => 'Bathroom Barcode (Offline Fallback)';

  @override
  String get onboardingStep4Subtitle =>
      'Register a product barcode in your bathroom (e.g., toothpaste) as an offline Proof-of-Action fallback.';

  @override
  String get onboardingBarcodeLabel => 'Barcode Value';

  @override
  String get onboardingBarcodeHint => 'Scan or enter product barcode';

  @override
  String get onboardingRegisterBarcodeButton => 'Save Barcode & Finish';

  @override
  String get onboardingSkipBarcodeButton => 'Skip for now & Finish';

  @override
  String get onboardingCompletedMessage =>
      'Setup complete! You are ready for Fajr.';

  @override
  String get onboardingIncompleteError =>
      'Please complete all required setup steps first.';

  @override
  String get appearanceTitle => 'Appearance & Design';

  @override
  String get appearanceThemeModeLabel => 'Color Mode';

  @override
  String get appearanceThemeSystem => 'System';

  @override
  String get appearanceThemeLight => 'Light';

  @override
  String get appearanceThemeDark => 'Dark';

  @override
  String get appearanceDesignLabel => 'Visual Design';

  @override
  String get appearanceDesignHorizon => 'Quiet Dawn (60-30-10)';

  @override
  String get appearanceDesignHorizonDesc =>
      'Matte slate & limestone with muted champagne';

  @override
  String get appearanceDesignSanctuary => 'Emerald Sanctuary';

  @override
  String get appearanceDesignSanctuaryDesc => 'Deep forest & luminous jade';

  @override
  String get appearanceDesignEditorial => 'Swiss Editorial';

  @override
  String get appearanceDesignEditorialDesc => 'Crisp monochrome & vermilion';

  @override
  String get scheduleLocationMethodLabel => 'City & Method';

  @override
  String get scheduleSelectCityTitle => 'Select City';

  @override
  String get scheduleSelectMethodTitle => 'Calculation Method';

  @override
  String get cityCairo => 'Cairo';

  @override
  String get cityAlexandria => 'Alexandria';

  @override
  String get cityMakkah => 'Makkah';

  @override
  String get cityMadinah => 'Madinah';

  @override
  String get cityRiyadh => 'Riyadh';

  @override
  String get cityDubai => 'Dubai';

  @override
  String get cityIstanbul => 'Istanbul';

  @override
  String get cityLondon => 'London';

  @override
  String get cityNewYork => 'New York';

  @override
  String get methodEgyptian => 'Egyptian General Authority';

  @override
  String get methodUmmAlQura => 'Umm al-Qura';

  @override
  String get methodMuslimWorldLeague => 'Muslim World League';

  @override
  String get methodNorthAmerica => 'ISNA (North America)';

  @override
  String get methodKarachi => 'Karachi';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodTurkey => 'Diyanet (Turkey)';

  @override
  String get appearanceDesignLiquid => 'Liquid Glass';

  @override
  String get appearanceDesignLiquidDesc =>
      'Frosted arctic glass & luminous cyan';

  @override
  String get appearanceDesignDesert => 'Desert Mirage';

  @override
  String get appearanceDesignDesertDesc =>
      'Warm terracotta sand & burnished brass';

  @override
  String get appearanceDesignNordic => 'Nordic Frost';

  @override
  String get appearanceDesignNordicDesc =>
      'Scandinavian slate & crisp ice blue';

  @override
  String get appearanceDesignVelvet => 'Midnight Velvet';

  @override
  String get appearanceDesignVelvetDesc => 'Nocturnal plum & rose-gold orbit';

  @override
  String get challengeRamOnlyBadge => 'RAM only • Purged < 500ms';

  @override
  String get alarmChallengeRuleHint =>
      'Alarm stays active until Proof-of-Action is verified.';
}
