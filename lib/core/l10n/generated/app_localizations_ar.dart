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

  @override
  String get appearanceTitle => 'المظهر والتصميم';

  @override
  String get appearanceThemeModeLabel => 'وضع الألوان';

  @override
  String get appearanceThemeSystem => 'تلقائي';

  @override
  String get appearanceThemeLight => 'فاتح';

  @override
  String get appearanceThemeDark => 'داكن';

  @override
  String get appearanceDesignLabel => 'اختر التصميم';

  @override
  String get appearanceDesignHorizon => 'فجر هادئ (60-30-10)';

  @override
  String get appearanceDesignHorizonDesc =>
      'أردوازي وحجر جيري مطفي بلمسة رمليّة هادئة';

  @override
  String get appearanceDesignSanctuary => 'المحراب الزمردي';

  @override
  String get appearanceDesignSanctuaryDesc => 'زمردي عميق وخطوط معمارية هادئة';

  @override
  String get appearanceDesignEditorial => 'التحريري السويسري';

  @override
  String get appearanceDesignEditorialDesc =>
      'تباين حاد وبساطة الساعات الكلاسيكية';

  @override
  String get scheduleLocationMethodLabel => 'المدينة وطريقة الحساب';

  @override
  String get scheduleSelectCityTitle => 'اختر المدينة';

  @override
  String get scheduleSelectMethodTitle => 'طريقة حساب المواقيت';

  @override
  String get cityCairo => 'القاهرة';

  @override
  String get cityAlexandria => 'الإسكندرية';

  @override
  String get cityMakkah => 'مكة المكرمة';

  @override
  String get cityMadinah => 'المدينة المنورة';

  @override
  String get cityRiyadh => 'الرياض';

  @override
  String get cityDubai => 'دبي';

  @override
  String get cityIstanbul => 'إسطنبول';

  @override
  String get cityLondon => 'لندن';

  @override
  String get cityNewYork => 'نيويورك';

  @override
  String get methodEgyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get methodUmmAlQura => 'أم القرى';

  @override
  String get methodMuslimWorldLeague => 'رابطة العالم الإسلامي';

  @override
  String get methodNorthAmerica => 'أمريكا الشمالية (ISNA)';

  @override
  String get methodKarachi => 'كراتشي';

  @override
  String get methodDubai => 'دبي';

  @override
  String get methodTurkey => 'الشؤون الدينية التركية';

  @override
  String get appearanceDesignLiquid => 'الزجاج السائل';

  @override
  String get appearanceDesignLiquidDesc => 'زجاج جليدي شفاف ولمسة سماوية مضيئة';

  @override
  String get appearanceDesignDesert => 'سراب الصحراء';

  @override
  String get appearanceDesignDesertDesc => 'رمال دافئة وتيراكوتا ونحاس مصقول';

  @override
  String get appearanceDesignNordic => 'الصقيع الشمالي';

  @override
  String get appearanceDesignNordicDesc => 'بساطة إسكندنافية وأزرق جليدي نقي';

  @override
  String get appearanceDesignVelvet => 'مخمل منتصف الليل';

  @override
  String get appearanceDesignVelvetDesc => 'ليلي مخملي عميق ومدار ذهبي وردي';

  @override
  String get challengeRamOnlyBadge => 'في الذاكرة فقط • يُحذف خلال < 500ms';

  @override
  String get alarmChallengeRuleHint =>
      'لا يمكن إغلاق المنبّه قبل إتمام تحدي إثبات الفعل.';
}
