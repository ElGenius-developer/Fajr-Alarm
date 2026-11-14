import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr-Alarm'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get commonSkip;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get commonErrorGeneric;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navChallenge.
  ///
  /// In en, this message translates to:
  /// **'Proof-of-Action Challenge'**
  String get navChallenge;

  /// No description provided for @navAlarm.
  ///
  /// In en, this message translates to:
  /// **'Fajr Alarm'**
  String get navAlarm;

  /// No description provided for @navOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get navOnboarding;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleNextAlarmLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Fajr Alarm'**
  String get scheduleNextAlarmLabel;

  /// No description provided for @scheduleAlarmDisabled.
  ///
  /// In en, this message translates to:
  /// **'Alarm is disabled'**
  String get scheduleAlarmDisabled;

  /// No description provided for @scheduleTodayFajrLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fajr Adhan'**
  String get scheduleTodayFajrLabel;

  /// No description provided for @scheduleSunriseLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get scheduleSunriseLabel;

  /// No description provided for @scheduleLockWindowActiveBanner.
  ///
  /// In en, this message translates to:
  /// **'Pre-Fajr Lock Window active: alarm changes are locked until the challenge is completed.'**
  String get scheduleLockWindowActiveBanner;

  /// No description provided for @scheduleModeRelative.
  ///
  /// In en, this message translates to:
  /// **'Relative to Adhan'**
  String get scheduleModeRelative;

  /// No description provided for @scheduleModeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual Fixed Time'**
  String get scheduleModeManual;

  /// No description provided for @scheduleOffsetBefore.
  ///
  /// In en, this message translates to:
  /// **'Before Adhan'**
  String get scheduleOffsetBefore;

  /// No description provided for @scheduleOffsetAt.
  ///
  /// In en, this message translates to:
  /// **'At Adhan'**
  String get scheduleOffsetAt;

  /// No description provided for @scheduleOffsetAfter.
  ///
  /// In en, this message translates to:
  /// **'After Adhan'**
  String get scheduleOffsetAfter;

  /// No description provided for @scheduleOffsetMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String scheduleOffsetMinutesLabel(int minutes);

  /// No description provided for @scheduleLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get scheduleLocationLabel;

  /// No description provided for @scheduleCalculationMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get scheduleCalculationMethodLabel;

  /// No description provided for @schedule30DayTitle.
  ///
  /// In en, this message translates to:
  /// **'30-Day Rolling Schedule'**
  String get schedule30DayTitle;

  /// No description provided for @scheduleRecalculateButton.
  ///
  /// In en, this message translates to:
  /// **'Recalculate 30-Day Schedule'**
  String get scheduleRecalculateButton;

  /// No description provided for @scheduleEnableSwitchLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable Fajr Alarm'**
  String get scheduleEnableSwitchLabel;

  /// No description provided for @scheduleManualTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual Alarm Time'**
  String get scheduleManualTimeLabel;

  /// No description provided for @scheduleEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No cached prayer schedule found. Tap recalculate to generate 30 days offline.'**
  String get scheduleEmptyState;

  /// No description provided for @scheduleErrorLockWindow.
  ///
  /// In en, this message translates to:
  /// **'Cannot modify alarm during Pre-Fajr Lock Window (T - 30m).'**
  String get scheduleErrorLockWindow;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsKpisTitle.
  ///
  /// In en, this message translates to:
  /// **'Local-Only KPIs & Streak'**
  String get settingsKpisTitle;

  /// No description provided for @settingsCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get settingsCurrentStreak;

  /// No description provided for @settingsLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get settingsLongestStreak;

  /// No description provided for @settingsStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String settingsStreakDays(int count);

  /// No description provided for @settingsStreakFrozenBadge.
  ///
  /// In en, this message translates to:
  /// **'Streak Frozen (Vacation)'**
  String get settingsStreakFrozenBadge;

  /// No description provided for @settingsCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get settingsCompletionRate;

  /// No description provided for @settingsAvgTimeToWake.
  ///
  /// In en, this message translates to:
  /// **'Avg. Time-to-Wake'**
  String get settingsAvgTimeToWake;

  /// No description provided for @settingsMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String settingsMinutesValue(String minutes);

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsVacationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vacation Mode'**
  String get settingsVacationTitle;

  /// No description provided for @settingsVacationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause Fajr alarms with Streak Freeze for a fixed number of days.'**
  String get settingsVacationSubtitle;

  /// No description provided for @settingsVacationDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (days)'**
  String get settingsVacationDurationLabel;

  /// No description provided for @settingsVacationActivateButton.
  ///
  /// In en, this message translates to:
  /// **'Activate Vacation Mode'**
  String get settingsVacationActivateButton;

  /// No description provided for @settingsVacationActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String settingsVacationActiveUntil(String date);

  /// No description provided for @settingsEmergencyQuotaTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Emergency Override Quota'**
  String get settingsEmergencyQuotaTitle;

  /// No description provided for @settingsEmergencyQuotaRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} remaining this month'**
  String settingsEmergencyQuotaRemaining(int remaining, int total);

  /// No description provided for @settingsDryRunTitle.
  ///
  /// In en, this message translates to:
  /// **'10-Second Dry-Run Alarm'**
  String get settingsDryRunTitle;

  /// No description provided for @settingsDryRunSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test alarm audio, lock screen, and camera without affecting your streak.'**
  String get settingsDryRunSubtitle;

  /// No description provided for @settingsDryRunButton.
  ///
  /// In en, this message translates to:
  /// **'Test Alarm Now (10s)'**
  String get settingsDryRunButton;

  /// No description provided for @settingsDryRunCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel Dry-Run Alarm'**
  String get settingsDryRunCancelButton;

  /// No description provided for @settingsDryRunScheduled.
  ///
  /// In en, this message translates to:
  /// **'Dry-run alarm scheduled for 10 seconds from now.'**
  String get settingsDryRunScheduled;

  /// No description provided for @settingsDryRunCancelled.
  ///
  /// In en, this message translates to:
  /// **'Dry-run alarm cancelled.'**
  String get settingsDryRunCancelled;

  /// No description provided for @settingsLockWindowNotice.
  ///
  /// In en, this message translates to:
  /// **'Pre-Fajr Lock Window active (T - 30m): alarm, quota, and vacation changes are locked.'**
  String get settingsLockWindowNotice;

  /// No description provided for @settingsErrorLockWindow.
  ///
  /// In en, this message translates to:
  /// **'Action blocked during the 30-minute Pre-Fajr Lock Window.'**
  String get settingsErrorLockWindow;

  /// No description provided for @settingsErrorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'Monthly emergency override quota exceeded.'**
  String get settingsErrorQuotaExceeded;

  /// No description provided for @settingsErrorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value.'**
  String get settingsErrorValidation;

  /// No description provided for @alarmRingingTitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr Alarm'**
  String get alarmRingingTitle;

  /// No description provided for @alarmStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Alarm Scheduled'**
  String get alarmStatusIdle;

  /// No description provided for @alarmStatusLockedPreFajr.
  ///
  /// In en, this message translates to:
  /// **'Pre-Fajr Lock Window Active'**
  String get alarmStatusLockedPreFajr;

  /// No description provided for @alarmStatusRingingInitial.
  ///
  /// In en, this message translates to:
  /// **'Time for Fajr!'**
  String get alarmStatusRingingInitial;

  /// No description provided for @alarmStatusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed — 5 Minutes'**
  String get alarmStatusSnoozed;

  /// No description provided for @alarmStatusRingingRelentless.
  ///
  /// In en, this message translates to:
  /// **'Relentless Ringing — Wake Up!'**
  String get alarmStatusRingingRelentless;

  /// No description provided for @alarmStatusChallengeActive.
  ///
  /// In en, this message translates to:
  /// **'Challenge in Progress'**
  String get alarmStatusChallengeActive;

  /// No description provided for @alarmStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Fajr Alarm Completed'**
  String get alarmStatusCompleted;

  /// No description provided for @alarmStatusVacationFrozen.
  ///
  /// In en, this message translates to:
  /// **'Vacation Mode Active'**
  String get alarmStatusVacationFrozen;

  /// No description provided for @alarmSnoozeButton.
  ///
  /// In en, this message translates to:
  /// **'Snooze (5 min)'**
  String get alarmSnoozeButton;

  /// No description provided for @alarmStartChallengeButton.
  ///
  /// In en, this message translates to:
  /// **'Start Proof-of-Action Challenge'**
  String get alarmStartChallengeButton;

  /// No description provided for @alarmEmergencyHoldButton.
  ///
  /// In en, this message translates to:
  /// **'Hold 60s for Emergency Override'**
  String get alarmEmergencyHoldButton;

  /// No description provided for @alarmEmergencyMutedHint.
  ///
  /// In en, this message translates to:
  /// **'Audio muted — keep holding ({seconds}s left)'**
  String alarmEmergencyMutedHint(int seconds);

  /// No description provided for @alarmEmergencyReleasedError.
  ///
  /// In en, this message translates to:
  /// **'Released early — timer reset and alarm resumed.'**
  String get alarmEmergencyReleasedError;

  /// No description provided for @alarmEmergencyNoQuota.
  ///
  /// In en, this message translates to:
  /// **'No emergency overrides remaining this month.'**
  String get alarmEmergencyNoQuota;

  /// No description provided for @alarmDryRunBadge.
  ///
  /// In en, this message translates to:
  /// **'Dry-Run Test Alarm'**
  String get alarmDryRunBadge;

  /// No description provided for @alarmSnoozeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Next ring in {time}'**
  String alarmSnoozeCountdown(String time);

  /// No description provided for @alarmRelentlessLoopHint.
  ///
  /// In en, this message translates to:
  /// **'Ringing every 1 minute until challenge is completed'**
  String get alarmRelentlessLoopHint;

  /// No description provided for @alarmEmergencyRemainingCount.
  ///
  /// In en, this message translates to:
  /// **'Emergency overrides left: {count}'**
  String alarmEmergencyRemainingCount(int count);

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Proof-of-Action Challenge'**
  String get challengeTitle;

  /// No description provided for @challengePhotoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Stand on your prayer rug, point the camera down at your feet (-15° to 25°), and take a live photo.'**
  String get challengePhotoInstruction;

  /// No description provided for @challengeTiltValid.
  ///
  /// In en, this message translates to:
  /// **'Standing angle OK ({degrees}°)'**
  String challengeTiltValid(String degrees);

  /// No description provided for @challengeTiltInvalid.
  ///
  /// In en, this message translates to:
  /// **'Hold phone at a standing angle between -15° and 25° (current: {degrees}°)'**
  String challengeTiltInvalid(String degrees);

  /// No description provided for @challengeCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture Live Photo'**
  String get challengeCapturePhoto;

  /// No description provided for @challengeToggleTorch.
  ///
  /// In en, this message translates to:
  /// **'Toggle Flash'**
  String get challengeToggleTorch;

  /// No description provided for @challengeVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get challengeVerifying;

  /// No description provided for @challengeVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Challenge completed! Alarm dismissed.'**
  String get challengeVerifiedSuccess;

  /// No description provided for @challengeRejectedDefault.
  ///
  /// In en, this message translates to:
  /// **'Verification failed. Please stand on the prayer rug and try again.'**
  String get challengeRejectedDefault;

  /// No description provided for @challengeOfflineFallbackNotice.
  ///
  /// In en, this message translates to:
  /// **'Offline mode active. Complete the fallback challenge.'**
  String get challengeOfflineFallbackNotice;

  /// No description provided for @challengeBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Bathroom Barcode Challenge'**
  String get challengeBarcodeTitle;

  /// No description provided for @challengeBarcodeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Walk to the bathroom and scan your registered product barcode.'**
  String get challengeBarcodeInstruction;

  /// No description provided for @challengeBarcodeMismatch.
  ///
  /// In en, this message translates to:
  /// **'Scanned barcode does not match your registered bathroom product.'**
  String get challengeBarcodeMismatch;

  /// No description provided for @challengeTypingTitle.
  ///
  /// In en, this message translates to:
  /// **'Standing Typing Challenge'**
  String get challengeTypingTitle;

  /// No description provided for @challengeTypingInstruction.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone at a standing angle (-15° to 25°) and type the 120-character text exactly without pasting.'**
  String get challengeTypingInstruction;

  /// No description provided for @challengeTypingCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String challengeTypingCounter(int current, int target);

  /// No description provided for @challengeTypingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify Text'**
  String get challengeTypingSubmit;

  /// No description provided for @challengeTypingMismatch.
  ///
  /// In en, this message translates to:
  /// **'Text does not match exactly or is incomplete.'**
  String get challengeTypingMismatch;

  /// No description provided for @challengeCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable. Switching to Standing Typing Challenge.'**
  String get challengeCameraUnavailable;

  /// No description provided for @challengeAdhkarPrompt.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah wa bihamdihi, SubhanAllahil Azeem, Astaghfirullah al-Azeem wa atubu ilayhi, La ilaha illa Allah wahdahu now.'**
  String get challengeAdhkarPrompt;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr-Alarm Setup'**
  String get onboardingTitle;

  /// No description provided for @onboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// No description provided for @onboardingStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Location & City'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your city or enter coordinates to calculate Fajr prayer times offline.'**
  String get onboardingStep1Subtitle;

  /// No description provided for @onboardingCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get onboardingCityLabel;

  /// No description provided for @onboardingCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cairo'**
  String get onboardingCityHint;

  /// No description provided for @onboardingLatitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get onboardingLatitudeLabel;

  /// No description provided for @onboardingLongitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get onboardingLongitudeLabel;

  /// No description provided for @onboardingPresetCitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick Select City'**
  String get onboardingPresetCitiesLabel;

  /// No description provided for @onboardingCityCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get onboardingCityCairo;

  /// No description provided for @onboardingCityMakkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get onboardingCityMakkah;

  /// No description provided for @onboardingCityMadinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get onboardingCityMadinah;

  /// No description provided for @onboardingCityRiyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get onboardingCityRiyadh;

  /// No description provided for @onboardingCityIstanbul.
  ///
  /// In en, this message translates to:
  /// **'Istanbul'**
  String get onboardingCityIstanbul;

  /// No description provided for @onboardingCityLondon.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get onboardingCityLondon;

  /// No description provided for @onboardingLocationSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Location & Continue'**
  String get onboardingLocationSaveButton;

  /// No description provided for @onboardingLocationErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid city name and coordinates.'**
  String get onboardingLocationErrorInvalid;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Mandatory Permissions Gate'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr-Alarm requires these system permissions to ring reliably over your lock screen and verify your wake-up.'**
  String get onboardingStep2Subtitle;

  /// No description provided for @onboardingPermFullScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Full-Screen Lock Bypass'**
  String get onboardingPermFullScreenTitle;

  /// No description provided for @onboardingPermFullScreenDesc.
  ///
  /// In en, this message translates to:
  /// **'Allows the alarm challenge to appear directly over the lock screen.'**
  String get onboardingPermFullScreenDesc;

  /// No description provided for @onboardingPermBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore Battery Optimizations'**
  String get onboardingPermBatteryTitle;

  /// No description provided for @onboardingPermBatteryDesc.
  ///
  /// In en, this message translates to:
  /// **'Prevents the OS from killing the Fajr alarm before dawn.'**
  String get onboardingPermBatteryDesc;

  /// No description provided for @onboardingPermCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get onboardingPermCameraTitle;

  /// No description provided for @onboardingPermCameraDesc.
  ///
  /// In en, this message translates to:
  /// **'Required for the live Proof-of-Action prayer rug photo and barcode scan.'**
  String get onboardingPermCameraDesc;

  /// No description provided for @onboardingPermAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact Alarms / AlarmKit'**
  String get onboardingPermAlarmTitle;

  /// No description provided for @onboardingPermAlarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedules exact Fajr wake-up alarms on Android and iOS 26+.'**
  String get onboardingPermAlarmDesc;

  /// No description provided for @onboardingPermGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get onboardingPermGranted;

  /// No description provided for @onboardingPermMissing.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get onboardingPermMissing;

  /// No description provided for @onboardingPermRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get onboardingPermRequestButton;

  /// No description provided for @onboardingPermRefreshButton.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get onboardingPermRefreshButton;

  /// No description provided for @onboardingPermGateBlocked.
  ///
  /// In en, this message translates to:
  /// **'All mandatory permissions must be granted before continuing.'**
  String get onboardingPermGateBlocked;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Gemini API Key'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr-Alarm uses your own Google AI Studio key (BYOK). No servers, no stored photos.'**
  String get onboardingStep3Subtitle;

  /// No description provided for @onboardingPrivacyNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Free Tier Disclosure'**
  String get onboardingPrivacyNoticeTitle;

  /// No description provided for @onboardingPrivacyNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Your challenge photos stay in RAM only and are purged immediately (< 500ms) without saving to disk or gallery. However, Google\'s Gemini API Free Tier may use submitted inputs and outputs to improve Google products and may be reviewed by human reviewers. You can enable billing in your Google AI Studio account to opt out of Google\'s free-tier data usage.'**
  String get onboardingPrivacyNoticeBody;

  /// No description provided for @onboardingPrivacyConsentCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I understand Google\'s Free Tier terms and explicitly consent to sending live challenge photos to Gemini using my own API key.'**
  String get onboardingPrivacyConsentCheckbox;

  /// No description provided for @onboardingApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key'**
  String get onboardingApiKeyLabel;

  /// No description provided for @onboardingApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your Google AI Studio key'**
  String get onboardingApiKeyHint;

  /// No description provided for @onboardingTestKeyButton.
  ///
  /// In en, this message translates to:
  /// **'Test & Save Key'**
  String get onboardingTestKeyButton;

  /// No description provided for @onboardingTestingKey.
  ///
  /// In en, this message translates to:
  /// **'Testing key...'**
  String get onboardingTestingKey;

  /// No description provided for @onboardingKeyValidated.
  ///
  /// In en, this message translates to:
  /// **'API key verified and saved securely.'**
  String get onboardingKeyValidated;

  /// No description provided for @onboardingConsentRequiredError.
  ///
  /// In en, this message translates to:
  /// **'You must accept the privacy disclosure before saving your API key.'**
  String get onboardingConsentRequiredError;

  /// No description provided for @onboardingApiKeyInvalidError.
  ///
  /// In en, this message translates to:
  /// **'API key validation failed. Check your key and connection.'**
  String get onboardingApiKeyInvalidError;

  /// No description provided for @onboardingStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Bathroom Barcode (Offline Fallback)'**
  String get onboardingStep4Title;

  /// No description provided for @onboardingStep4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Register a product barcode in your bathroom (e.g., toothpaste) as an offline Proof-of-Action fallback.'**
  String get onboardingStep4Subtitle;

  /// No description provided for @onboardingBarcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode Value'**
  String get onboardingBarcodeLabel;

  /// No description provided for @onboardingBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Scan or enter product barcode'**
  String get onboardingBarcodeHint;

  /// No description provided for @onboardingScanBarcodeButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode with Camera'**
  String get onboardingScanBarcodeButton;

  /// No description provided for @onboardingScanBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at a bathroom item barcode (e.g., toothpaste)'**
  String get onboardingScanBarcodeHint;

  /// No description provided for @onboardingStopScanButton.
  ///
  /// In en, this message translates to:
  /// **'Close Camera'**
  String get onboardingStopScanButton;

  /// No description provided for @onboardingOrEnterManually.
  ///
  /// In en, this message translates to:
  /// **'or enter barcode manually'**
  String get onboardingOrEnterManually;

  /// No description provided for @onboardingBarcodeScannedBadge.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {code}'**
  String onboardingBarcodeScannedBadge(String code);

  /// No description provided for @onboardingScannerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera scanner unavailable here. Enter the code below.'**
  String get onboardingScannerUnavailable;

  /// No description provided for @onboardingToggleFlashTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle flash'**
  String get onboardingToggleFlashTooltip;

  /// No description provided for @onboardingRegisterBarcodeButton.
  ///
  /// In en, this message translates to:
  /// **'Save Barcode & Finish'**
  String get onboardingRegisterBarcodeButton;

  /// No description provided for @onboardingSkipBarcodeButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now & Finish'**
  String get onboardingSkipBarcodeButton;

  /// No description provided for @onboardingCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Setup complete! You are ready for Fajr.'**
  String get onboardingCompletedMessage;

  /// No description provided for @onboardingIncompleteError.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required setup steps first.'**
  String get onboardingIncompleteError;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Design'**
  String get appearanceTitle;

  /// No description provided for @appearanceThemeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Mode'**
  String get appearanceThemeModeLabel;

  /// No description provided for @appearanceThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceThemeSystem;

  /// No description provided for @appearanceThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceThemeLight;

  /// No description provided for @appearanceThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceThemeDark;

  /// No description provided for @appearanceDesignLabel.
  ///
  /// In en, this message translates to:
  /// **'Visual Design'**
  String get appearanceDesignLabel;

  /// No description provided for @appearanceDesignHorizon.
  ///
  /// In en, this message translates to:
  /// **'Quiet Dawn (60-30-10)'**
  String get appearanceDesignHorizon;

  /// No description provided for @appearanceDesignHorizonDesc.
  ///
  /// In en, this message translates to:
  /// **'Matte slate & limestone with muted champagne'**
  String get appearanceDesignHorizonDesc;

  /// No description provided for @appearanceDesignSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Emerald Sanctuary'**
  String get appearanceDesignSanctuary;

  /// No description provided for @appearanceDesignSanctuaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep forest & luminous jade'**
  String get appearanceDesignSanctuaryDesc;

  /// No description provided for @appearanceDesignEditorial.
  ///
  /// In en, this message translates to:
  /// **'Swiss Editorial'**
  String get appearanceDesignEditorial;

  /// No description provided for @appearanceDesignEditorialDesc.
  ///
  /// In en, this message translates to:
  /// **'Crisp monochrome & vermilion'**
  String get appearanceDesignEditorialDesc;

  /// No description provided for @scheduleLocationMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'City & Method'**
  String get scheduleLocationMethodLabel;

  /// No description provided for @scheduleSelectCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get scheduleSelectCityTitle;

  /// No description provided for @scheduleSelectMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get scheduleSelectMethodTitle;

  /// No description provided for @cityCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cityCairo;

  /// No description provided for @cityAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get cityAlexandria;

  /// No description provided for @cityMakkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get cityMakkah;

  /// No description provided for @cityMadinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get cityMadinah;

  /// No description provided for @cityRiyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get cityRiyadh;

  /// No description provided for @cityDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get cityDubai;

  /// No description provided for @cityIstanbul.
  ///
  /// In en, this message translates to:
  /// **'Istanbul'**
  String get cityIstanbul;

  /// No description provided for @cityLondon.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get cityLondon;

  /// No description provided for @cityNewYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get cityNewYork;

  /// No description provided for @methodEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority'**
  String get methodEgyptian;

  /// No description provided for @methodUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm al-Qura'**
  String get methodUmmAlQura;

  /// No description provided for @methodMuslimWorldLeague.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMuslimWorldLeague;

  /// No description provided for @methodNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'ISNA (North America)'**
  String get methodNorthAmerica;

  /// No description provided for @methodKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get methodKarachi;

  /// No description provided for @methodDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// No description provided for @methodTurkey.
  ///
  /// In en, this message translates to:
  /// **'Diyanet (Turkey)'**
  String get methodTurkey;

  /// No description provided for @appearanceDesignLiquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid Glass'**
  String get appearanceDesignLiquid;

  /// No description provided for @appearanceDesignLiquidDesc.
  ///
  /// In en, this message translates to:
  /// **'Frosted arctic glass & luminous cyan'**
  String get appearanceDesignLiquidDesc;

  /// No description provided for @appearanceDesignDesert.
  ///
  /// In en, this message translates to:
  /// **'Desert Mirage'**
  String get appearanceDesignDesert;

  /// No description provided for @appearanceDesignDesertDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm terracotta sand & burnished brass'**
  String get appearanceDesignDesertDesc;

  /// No description provided for @appearanceDesignNordic.
  ///
  /// In en, this message translates to:
  /// **'Nordic Frost'**
  String get appearanceDesignNordic;

  /// No description provided for @appearanceDesignNordicDesc.
  ///
  /// In en, this message translates to:
  /// **'Scandinavian slate & crisp ice blue'**
  String get appearanceDesignNordicDesc;

  /// No description provided for @appearanceDesignVelvet.
  ///
  /// In en, this message translates to:
  /// **'Midnight Velvet'**
  String get appearanceDesignVelvet;

  /// No description provided for @appearanceDesignVelvetDesc.
  ///
  /// In en, this message translates to:
  /// **'Nocturnal plum & rose-gold orbit'**
  String get appearanceDesignVelvetDesc;

  /// No description provided for @challengeRamOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'RAM only • Purged < 500ms'**
  String get challengeRamOnlyBadge;

  /// No description provided for @alarmChallengeRuleHint.
  ///
  /// In en, this message translates to:
  /// **'Alarm stays active until Proof-of-Action is verified.'**
  String get alarmChallengeRuleHint;

  /// No description provided for @settingsBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Bathroom Barcode (Offline Fallback)'**
  String get settingsBarcodeTitle;

  /// No description provided for @settingsBarcodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used to verify wake-up when offline or when Gemini API is unreachable.'**
  String get settingsBarcodeSubtitle;

  /// No description provided for @settingsBarcodeRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered barcode: {code}'**
  String settingsBarcodeRegistered(String code);

  /// No description provided for @settingsBarcodeNotSet.
  ///
  /// In en, this message translates to:
  /// **'No bathroom barcode registered yet'**
  String get settingsBarcodeNotSet;

  /// No description provided for @settingsBarcodeScanOrEditButton.
  ///
  /// In en, this message translates to:
  /// **'Scan or Edit Barcode'**
  String get settingsBarcodeScanOrEditButton;

  /// No description provided for @settingsBarcodeClearButton.
  ///
  /// In en, this message translates to:
  /// **'Remove Barcode'**
  String get settingsBarcodeClearButton;

  /// No description provided for @settingsBarcodeSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Bathroom barcode saved.'**
  String get settingsBarcodeSavedMessage;

  /// No description provided for @settingsBarcodeClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Bathroom barcode removed.'**
  String get settingsBarcodeClearedMessage;

  /// No description provided for @settingsApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key & Privacy'**
  String get settingsApiKeyTitle;

  /// No description provided for @settingsApiKeyVerified.
  ///
  /// In en, this message translates to:
  /// **'API key verified and stored securely'**
  String get settingsApiKeyVerified;

  /// No description provided for @settingsApiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'No verified Gemini API key'**
  String get settingsApiKeyNotSet;

  /// No description provided for @settingsApiKeyUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Gemini API Key'**
  String get settingsApiKeyUpdateButton;

  /// No description provided for @settingsAlarmAndLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm Timing, Location & Method'**
  String get settingsAlarmAndLocationTitle;

  /// No description provided for @settingsEditLocationMethodButton.
  ///
  /// In en, this message translates to:
  /// **'Edit City, Coordinates & Method'**
  String get settingsEditLocationMethodButton;

  /// No description provided for @settingsPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'System Permissions Status'**
  String get settingsPermissionsTitle;

  /// No description provided for @settingsVacationDeactivateButton.
  ///
  /// In en, this message translates to:
  /// **'End Vacation Mode Now'**
  String get settingsVacationDeactivateButton;

  /// No description provided for @settingsAlarmAndLocationSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Alarm and location settings saved.'**
  String get settingsAlarmAndLocationSavedMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
