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
