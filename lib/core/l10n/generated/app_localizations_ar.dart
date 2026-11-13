// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'منبه الفجر';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonSkip => 'تخطي الآن';

  @override
  String get commonDone => 'تم';

  @override
  String get commonErrorGeneric => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get navSchedule => 'المواقيت';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navChallenge => 'تحدي إثبات الفعل';

  @override
  String get navAlarm => 'منبه الفجر';

  @override
  String get navOnboarding => 'الإعداد الأولي';

  @override
  String get alarmRingingTitle => 'منبه الفجر';

  @override
  String get alarmStatusIdle => 'المنبه مجدول';

  @override
  String get alarmStatusLockedPreFajr => 'نافذة القفل قبل الفجر مفعّلة';

  @override
  String get alarmStatusRingingInitial => 'حان وقت صلاة الفجر!';

  @override
  String get alarmStatusSnoozed => 'غفوة — 5 دقائق';

  @override
  String get alarmStatusRingingRelentless => 'رنّ ملحّ — استيقظ الآن!';

  @override
  String get alarmStatusChallengeActive => 'التحدي قيد التنفيذ';

  @override
  String get alarmStatusCompleted => 'تم إتمام تحدي الفجر';

  @override
  String get alarmStatusVacationFrozen => 'وضع الإجازة مفعّل';

  @override
  String get alarmSnoozeButton => 'غفوة (5 دقائق)';

  @override
  String get alarmStartChallengeButton => 'بدء تحدي إثبات الفعل';

  @override
  String get alarmEmergencyHoldButton =>
      'اضغط باستمرار 60 ثانية لتجاوز الطوارئ';

  @override
  String alarmEmergencyMutedHint(int seconds) {
    return 'تم كتم الصوت — استمر بالضغط ($seconds ث متبقية)';
  }

  @override
  String get alarmEmergencyReleasedError =>
      'تم رفع الإصبع مبكراً — أُعيد العداد وعاد الرنّ.';

  @override
  String get alarmEmergencyNoQuota => 'لا يوجد رصيد طوارئ متبقٍ هذا الشهر.';

  @override
  String get alarmDryRunBadge => 'منبه تجريبي';

  @override
  String alarmSnoozeCountdown(String time) {
    return 'الرنّ التالي خلال $time';
  }

  @override
  String get alarmRelentlessLoopHint => 'يرنّ كل دقيقة واحدة حتى إتمام التحدي';

  @override
  String alarmEmergencyRemainingCount(int count) {
    return 'رصيد الطوارئ المتبقي: $count';
  }
}
