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
}
