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

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Proof-of-Action Challenge'**
  String get challengeTitle;

  /// No description provided for @challengePhotoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Stand on your prayer rug, point the camera down at your feet (-45° to -90°), and take a live photo.'**
  String get challengePhotoInstruction;

  /// No description provided for @challengeTiltValid.
  ///
  /// In en, this message translates to:
  /// **'Standing angle OK ({degrees}°)'**
  String challengeTiltValid(String degrees);

  /// No description provided for @challengeTiltInvalid.
  ///
  /// In en, this message translates to:
  /// **'Point phone downward between -45° and -90° (current: {degrees}°)'**
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
  /// **'Hold your phone at a standing angle (-45° to -90°) and type the 120-character text exactly without pasting.'**
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
