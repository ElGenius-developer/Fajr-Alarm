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
  String get scheduleTitle => 'جدول صلاة الفجر';

  @override
  String get scheduleNextAlarmLabel => 'منبه الفجر القادم';

  @override
  String get scheduleAlarmDisabled => 'المنبه متوقف';

  @override
  String get scheduleTodayFajrLabel => 'أذان الفجر اليوم';

  @override
  String get scheduleSunriseLabel => 'الشروق';

  @override
  String get scheduleLockWindowActiveBanner =>
      'نافذة القفل قبل الفجر مفعّلة: تعديل المنبه مقفول حتى إتمام التحدي.';

  @override
  String get scheduleModeRelative => 'نسبي لأذان الفجر';

  @override
  String get scheduleModeManual => 'وقت يدوي ثابت';

  @override
  String get scheduleOffsetBefore => 'قبل الأذان';

  @override
  String get scheduleOffsetAt => 'عند الأذان';

  @override
  String get scheduleOffsetAfter => 'بعد الأذان';

  @override
  String scheduleOffsetMinutesLabel(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get scheduleLocationLabel => 'الموقع';

  @override
  String get scheduleCalculationMethodLabel => 'طريقة الحساب';

  @override
  String get schedule30DayTitle => 'جدول الـ 30 يوماً القادمة';

  @override
  String get scheduleRecalculateButton => 'إعادة حساب جدول 30 يوماً';

  @override
  String get scheduleEnableSwitchLabel => 'تفعيل منبه الفجر';

  @override
  String get scheduleManualTimeLabel => 'وقت المنبه اليدوي';

  @override
  String get scheduleEmptyState =>
      'لا يوجد جدول مواقيت محفوظ. اضغط لإعادة الحساب أوفلاين لـ 30 يوماً.';

  @override
  String get scheduleErrorLockWindow =>
      'لا يمكن تعديل المنبه خلال نافذة القفل قبل الفجر (30 دقيقة قبل الموعد).';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsKpisTitle => 'مؤشرات الأداء وسلسلة الالتزام';

  @override
  String get settingsCurrentStreak => 'السلسلة الحالية';

  @override
  String get settingsLongestStreak => 'أطول سلسلة';

  @override
  String settingsStreakDays(int count) {
    return '$count يوم';
  }

  @override
  String get settingsStreakFrozenBadge => 'السلسلة مجمدة (إجازة)';

  @override
  String get settingsCompletionRate => 'نسبة الإتمام';

  @override
  String get settingsAvgTimeToWake => 'متوسط زمن الاستيقاظ';

  @override
  String settingsMinutesValue(String minutes) {
    return '$minutes د';
  }

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsVacationTitle => 'وضع الإجازة';

  @override
  String get settingsVacationSubtitle =>
      'إيقاف منبه الفجر مؤقتاً مع تجميد سلسلة الالتزام لعدد محدد من الأيام.';

  @override
  String get settingsVacationDurationLabel => 'المدة (بالأيام)';

  @override
  String get settingsVacationActivateButton => 'تفعيل وضع الإجازة';

  @override
  String settingsVacationActiveUntil(String date) {
    return 'مفعّل حتى $date';
  }

  @override
  String get settingsEmergencyQuotaTitle => 'رصيد تجاوز الطوارئ الشهري';

  @override
  String settingsEmergencyQuotaRemaining(int remaining, int total) {
    return 'المتبقي $remaining من $total هذا الشهر';
  }

  @override
  String get settingsDryRunTitle => 'منبه تجريبي (بعد 10 ثوانٍ)';

  @override
  String get settingsDryRunSubtitle =>
      'اختبر صوت المنبه وشاشة القفل والكاميرا دون التأثير على سلسلة الالتزام.';

  @override
  String get settingsDryRunButton => 'تجربة المنبه الآن (10 ثوانٍ)';

  @override
  String get settingsDryRunScheduled =>
      'تمت جدولة المنبه التجريبي ليرنّ بعد 10 ثوانٍ.';

  @override
  String get settingsLockWindowNotice =>
      'نافذة القفل قبل الفجر مفعّلة (T - 30m): تعديل المنبه والرصيد والإجازة مقفل.';

  @override
  String get settingsErrorLockWindow =>
      'هذا الإجراء محظور خلال نافذة القفل قبل الفجر (30 دقيقة).';

  @override
  String get settingsErrorQuotaExceeded =>
      'تم استنفاد رصيد تجاوز الطوارئ الشهري.';

  @override
  String get settingsErrorValidation => 'يرجى إدخال قيمة صالحة.';

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

  @override
  String get challengeTitle => 'تحدي إثبات الفعل';

  @override
  String get challengePhotoInstruction =>
      'قف على سجادة الصلاة ووجّه الكاميرا للأسفل نحو قدميك بزاوية (-45° إلى -90°) والتقط صورة حية.';

  @override
  String challengeTiltValid(String degrees) {
    return 'زاوية الوقوف صحيحة ($degrees°)';
  }

  @override
  String challengeTiltInvalid(String degrees) {
    return 'وجّه الهاتف للأسفل بين -45° و -90° (الحالية: $degrees°)';
  }

  @override
  String get challengeCapturePhoto => 'التقاط صورة حية';

  @override
  String get challengeToggleTorch => 'تشغيل/إيقاف الفلاش';

  @override
  String get challengeVerifying => 'جارٍ التحقق...';

  @override
  String get challengeVerifiedSuccess =>
      'تم إتمام التحدي بنجاح! تم إيقاف المنبه.';

  @override
  String get challengeRejectedDefault =>
      'فشل التحقق. يرجى الوقوف على سجادة الصلاة والمحاولة مرة أخرى.';

  @override
  String get challengeOfflineFallbackNotice =>
      'تم التبديل للوضع الأوفلاين. أكمل التحدي البديل.';

  @override
  String get challengeBarcodeTitle => 'تحدي باركود الحمام';

  @override
  String get challengeBarcodeInstruction =>
      'انهض وامشِ إلى الحمام وامسح باركود المنتج المسجل مسبقاً.';

  @override
  String get challengeBarcodeMismatch =>
      'الباركود الممسوح لا يطابق المنتج المسجل.';

  @override
  String get challengeTypingTitle => 'تحدي الكتابة واقفاً';

  @override
  String get challengeTypingInstruction =>
      'احمل الهاتف بزاوية الوقوف (-45° إلى -90°) واكتب نص الأذكار من 120 حرفاً بدقة تامة دون لصق.';

  @override
  String challengeTypingCounter(int current, int target) {
    return '$current / $target';
  }

  @override
  String get challengeTypingSubmit => 'تحقق من النص';

  @override
  String get challengeTypingMismatch => 'النص غير مطابق تماماً أو غير مكتمل.';

  @override
  String get challengeCameraUnavailable =>
      'الكاميرا غير متاحة. تم التبديل إلى تحدي الكتابة واقفاً.';

  @override
  String get challengeAdhkarPrompt =>
      'سبحان الله وبحمده سبحان الله العظيم أستغفر الله العظيم وأتوب إليه لا إله إلا الله وحده لا شريك له له الملك وله الحمد كله';
}
