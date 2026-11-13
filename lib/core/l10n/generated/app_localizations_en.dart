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
}
