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
