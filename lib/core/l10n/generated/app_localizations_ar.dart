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
