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
}
