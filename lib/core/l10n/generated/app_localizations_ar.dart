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
  String get onboardingTitle => 'إعداد منبه الفجر';

  @override
  String onboardingStepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get onboardingStep1Title => 'الموقع والمدينة';

  @override
  String get onboardingStep1Subtitle =>
      'اختر مدينتك أو أدخل الإحداثيات لحساب مواقيت صلاة الفجر دون إنترنت.';

  @override
  String get onboardingCityLabel => 'اسم المدينة';

  @override
  String get onboardingCityHint => 'مثال: القاهرة';

  @override
  String get onboardingLatitudeLabel => 'خط العرض';

  @override
  String get onboardingLongitudeLabel => 'خط الطول';

  @override
  String get onboardingPresetCitiesLabel => 'اختيار سريع للمدينة';

  @override
  String get onboardingCityCairo => 'القاهرة';

  @override
  String get onboardingCityMakkah => 'مكة المكرمة';

  @override
  String get onboardingCityMadinah => 'المدينة المنورة';

  @override
  String get onboardingCityRiyadh => 'الرياض';

  @override
  String get onboardingCityIstanbul => 'إسطنبول';

  @override
  String get onboardingCityLondon => 'لندن';

  @override
  String get onboardingLocationSaveButton => 'حفظ الموقع والمتابعة';

  @override
  String get onboardingLocationErrorInvalid =>
      'يرجى إدخال اسم مدينة وإحداثيات صحيحة.';

  @override
  String get onboardingStep2Title => 'بوابة الصلاحيات الإلزامية';

  @override
  String get onboardingStep2Subtitle =>
      'يحتاج منبه الفجر إلى هذه الصلاحيات للرنّ فوق شاشة القفل والتحقق من نهوضك.';

  @override
  String get onboardingPermFullScreenTitle => 'العرض فوق شاشة القفل';

  @override
  String get onboardingPermFullScreenDesc =>
      'يسمح بظهور تحدي المنبه مباشرة فوق شاشة القفل.';

  @override
  String get onboardingPermBatteryTitle => 'استثناء تحسين البطارية';

  @override
  String get onboardingPermBatteryDesc =>
      'يمنع النظام من إيقاف منبه الفجر قبل الفجر.';

  @override
  String get onboardingPermCameraTitle => 'صلاحية الكاميرا';

  @override
  String get onboardingPermCameraDesc =>
      'مطلوبة لتصوير سجادة الصلاة الحية ومسح الباركود.';

  @override
  String get onboardingPermAlarmTitle => 'المنبهات الدقيقة / AlarmKit';

  @override
  String get onboardingPermAlarmDesc =>
      'يجدول منبهات الفجر الدقيقة على أندرويد وiOS 26+.';

  @override
  String get onboardingPermGranted => 'ممنوحة';

  @override
  String get onboardingPermMissing => 'مطلوبة';

  @override
  String get onboardingPermRequestButton => 'منح الصلاحيات';

  @override
  String get onboardingPermRefreshButton => 'تحديث الحالة';

  @override
  String get onboardingPermGateBlocked =>
      'يجب منح جميع الصلاحيات الإلزامية قبل المتابعة.';

  @override
  String get onboardingStep3Title => 'الخصوصية ومفتاح Gemini';

  @override
  String get onboardingStep3Subtitle =>
      'يستخدم منبه الفجر مفتاح Google AI Studio الخاص بك (BYOK) دون خوادم أو حفظ للصور.';

  @override
  String get onboardingPrivacyNoticeTitle => 'إفصاح الخصوصية والطبقة المجانية';

  @override
  String get onboardingPrivacyNoticeBody =>
      'تُعالج صور التحدي في الذاكرة المؤقتة (RAM) فقط وتُحذف فوراً (< 500ms) دون حفظها في المعرض أو القرص. ومع ذلك، قد تستخدم الطبقة المجانية (Free Tier) من Gemini API المدخلات والمخرجات لتحسين منتجات Google وقد يراجعها مراجعون بشريون. يمكنك تفعيل الفوترة في حساب Google AI Studio لتعطيل ذلك.';

  @override
  String get onboardingPrivacyConsentCheckbox =>
      'أفهم شروط الطبقة المجانية من Google وأوافق صراحةً على إرسال صور التحدي الحية إلى Gemini باستخدام مفتاحي الخاص.';

  @override
  String get onboardingApiKeyLabel => 'مفتاح Gemini API';

  @override
  String get onboardingApiKeyHint => 'الصق مفتاح Google AI Studio الخاص بك';

  @override
  String get onboardingTestKeyButton => 'اختبار وحفظ المفتاح';

  @override
  String get onboardingTestingKey => 'جارٍ اختبار المفتاح...';

  @override
  String get onboardingKeyValidated => 'تم التحقق من المفتاح وحفظه بأمان.';

  @override
  String get onboardingConsentRequiredError =>
      'يجب الموافقة على إفصاح الخصوصية قبل حفظ مفتاح API.';

  @override
  String get onboardingApiKeyInvalidError =>
      'فشل التحقق من المفتاح. تأكد من المفتاح والاتصال.';

  @override
  String get onboardingStep4Title => 'تحدي باركود الحمام (البديل الأوفلاين)';

  @override
  String get onboardingStep4Subtitle =>
      'سجّل باركود منتج في الحمام (مثل معجون الأسنان) كبديل أوفلاين لإثبات النهوض.';

  @override
  String get onboardingBarcodeLabel => 'قيمة الباركود';

  @override
  String get onboardingBarcodeHint => 'امسح أو أدخل باركود المنتج';

  @override
  String get onboardingRegisterBarcodeButton => 'حفظ الباركود والإنهاء';

  @override
  String get onboardingSkipBarcodeButton => 'تخطي الآن والإنهاء';

  @override
  String get onboardingCompletedMessage =>
      'اكتمل الإعداد! أنت جاهز لصلاة الفجر.';

  @override
  String get onboardingIncompleteError =>
      'يرجى إكمال جميع خطوات الإعداد المطلوبة أولاً.';
}
