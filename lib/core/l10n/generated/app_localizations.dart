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
