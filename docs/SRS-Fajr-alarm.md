# وثيقة متطلبات الأعمال ومواصفات البرمجيات النهائية (BRD & SRS)

**اسم المشروع:** منبه الفجر الذكي (`Fajr-Alarm`)  
**المنصات المستهدفة (`v1.0`):** Android 10+ (`minSdk 29`, `targetSdk 35`) و iOS 26+ (`AlarmKit`) — باستخدام Flutter + Native Platform Channels  
**الإصدار:** `1.0` (Final Locked Spec)  
**نموذج التشغيل والتوزيع:** Serverless / Local-First / BYOK — استخدام شخصي ومفتوح المصدر (`Open Source`) على GitHub (خارج متاجر التطبيقات)  
**الوثائق المرجعية:** [`GLOSSARY.md`](./GLOSSARY.md) · [`.claude/CONSTITUTION.md`](./.claude/CONSTITUTION.md) · [خريطة القرارات `#1` (`#2`–`#9`)](https://github.com/ElGenius-developer/Fajr-Alarm/issues/1)

---

# الجزء الأول: وثيقة متطلبات الأعمال (BRD)

## 1. نظرة عامة على المنتج (Product Overview)
تطبيق موبايل مخصص للاستيقاظ لصلاة الفجر، يعتمد على آلية **تحدي إثبات الفعل (`Proof-of-Action Challenge`)** بدلاً من المنبهات التقليدية. لا يتوقف المنبه بالضغط على زر الإغلاق أو الغفوة المتكررة، بل يستمر بنظام **الرنّ الملحّ (`Relentless Ringing`)** حتى ينهض المستخدم من سريره، يقف على سجادة الصلاة، ويلتقط صورة حية لقدميه عليها للتحقق عبر الذكاء الاصطناعي (أو ينفّذ المسار الأوفلاين المعتمد).

---

## 2. أهداف المشروع ومؤشرات الأداء المحلية (Objectives & Local-Only KPIs)
* **الهدف الأساسي:** القضاء على إغلاق المنبه أو تأجيله اللاواعي من قِبل **"الخصم النعسان (`Sleepy Self`)"** وقت الفجر.
* **الهدف التشغيلي:** إصدار `v1.0` بتكلفة خوادم صفرية (`Zero Server Cost`) وبدون أي Analytics أو تتبع خارجي.
* **مؤشرات الأداء المحلية (`Local-Only KPIs` — مخزنة 100% محلياً في `hive_ce`):**
  * **نسبة إتمام التحدي (`Challenge Completion Rate`):** المستهدف `> 85%` من إجمالي مرات إطلاق المنبه الحقيقي.
  * **متوسط زمن الاستيقاظ (`Time-to-Wake`):** المستهدف `< 7 دقائق` من لحظة الرنّ الأول حتى حالة `[COMPLETED]`.
  * **سلسلة الالتزام (`Streak`):** تتبع الأيام المتتالية محلياً مع دعم **تجميد سلسلة الالتزام (`Streak Freeze`)** أثناء **وضع الإجازة (`Vacation Mode`)** دون تأثرها بـ **المنبه التجريبي (`Dry-Run Alarm`)**.

---

## 3. نطاق العمل (Project Scope — v1.0)

| داخل النطاق (`In-Scope - v1.0`) | خارج النطاق (`Out-of-Scope - v1.0`) |
| :--- | :--- |
| استهداف Android 10+ (`minSdk 29` / `targetSdk 35`) و iOS 26+ (`AlarmKit`). | دعم `iOS 15–25` (مؤجل لما بعد `v1.0`). |
| استخدام شخصي وتوزيع مفتوح المصدر عبر GitHub (`Sideload` / Build محلي). | النشر على `Google Play` أو `App Store`. |
| حساب مواقيت الصلاة فلكياً أوفلاين (`adhan`) + كاش محلي لـ 30 يوماً. | أي Backend، خوادم، أو حسابات مستخدمين (`Auth/Login`). |
| جدولة منبه الفجر تلقائياً (نسبي للأذان أو يدوي) + Direct Boot في أندرويد. | أي Analytics أو تتبع سحابي خارجي (`Telemetry`). |
| نظام غفوة تصعيدي (5 دقائق أول مرة، ثم رنّ ملحّ كل دقيقة) + `AlarmKit Cascade` في iOS. | تدريب موديل ذكاء اصطناعي مخصص أو ربط ساعات ذكية (`WearOS` / `Watch`). |
| التحقق بالصورة الحية (`POV`: قدمين على سجادة صلاة) عبر Gemini REST API (`BYOK`). | الميزات الاجتماعية أو بوابات الدفع. |
| المسار الأوفلاين: **تحدي باركود الحمام** أولاً، يليه **تحدي الكتابة واقفاً**. | |
| ردع الخصم النعسان (حماية الصوت، تثبيت الشاشة، الساعة الرتيبة، `T - 30m` lock). | |
| **وضع الإجازة (`Vacation Mode`)** بمدة محددة + **تجاوز الطوارئ (`Emergency Override`)**. | |
| دعم ثنائي اللغة بالكامل: العربية (`RTL`) والإنجليزية (`LTR`) + Onboarding + منبه تجريبي. | |

---

## 4. نموذج التشغيل والخصوصية (BYOK & Privacy Contract)
* **نموذج BYOK (Bring Your Own Key):** يستخدم التطبيق مفتاح Google AI Studio الخاص بالمستخدم عبر طلبات REST مباشرة (`POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent` مع ترويسة `x-goog-api-key`) وتخزين المفتاح محلياً فقط في `FlutterSecureStorage` (`Keystore` / `Keychain`). **يُمنع منعاً باتاً وجود أي مفاتيح أو ملفات `.env` داخل المستودع.**
* **الموديلات المحددة:** الافتراضي `gemini-2.5-flash-lite` (أسرع وأعلى حصة مجانية)، والاحتياطي `gemini-2.5-flash`، مع تفعيل `responseMimeType: "application/json"` و `responseSchema`.
* **وعد الخصوصية الدقيق والموافقة الإلزامية:**
  * التطبيق نفسه **لا يمتلك خوادم ولا يخزن أو يحفظ أي صور** على المعرض أو وحدة التخزين الدائمة؛ تُعالج الصورة في الذاكرة المؤقتة (`RAM`) فقط وتُحذف فور استلام نتيجة التحقق خلال أقل من **`500ms`**.
  * نظراً لأن الطبقة المجانية (`Free Tier`) من Gemini API قد تستخدم المدخلات والمخرجات لتحسين منتجات Google وقد يراجعها مراجعون بشريون وفق شروط Google غير المدفوعة، يلتزم التطبيق بعرض **إفصاح خصوصية واضح وشاشة موافقة صريحة (`Explicit Consent`)** أثناء الـ Onboarding قبل حفظ المفتاح (مع الإشارة إلى إمكانية تفعيل الفوترة في حساب المستخدم لتعطيل ذلك لدى Google).

---

# الجزء الثاني: وثيقة مواصفات متطلبات البرمجيات (SRS)

## 1. المعمارية العامة للنظام والتخزين المحلي (Clean Architecture & Caching)
يعتمد التطبيق على **Feature-Based Clean Architecture** + `flutter_bloc` + `get_it` + `freezed` + `fpdart` (`Either<Failure, T>`):

```text
lib/
├── core/                         # DI (get_it), go_router, theme, failures, constants, l10n (.arb)
└── features/
    ├── onboarding/               # تدفق الإعداد الأولي (4 خطوات) وبوابة الصلاحيات
    ├── prayer_schedule/          # الحساب الفلكي (adhan) وكاش المواقيت والجدولة اليومية
    ├── alarm_ringing/            # آلة حالات المنبه، الغفوة، قفل الصوت/الشاشة، الطوارئ
    ├── challenge_verification/   # الكاميرا الحية، حساس الميل، Gemini REST، والباركود/الكتابة الأوفلاين
    └── settings_and_streak/      # الإعدادات، نافذة القفل، الإجازة، الرصيد الشهري، الـ KPIs المحلية
```

* **حدود الطبقات (`Strict Layer Isolation`):**
  * طبقة `domain/` (`entities`, `repositories`, `usecases`) بلغة **Dart نقية 100%** دون أي استيراد لـ `package:flutter` أو قنوات النظام أو مكتبات الشبكة والتخزين.
  * طبقة `presentation/` (`Bloc`/`Cubit` و `Widgets`) تتواصل حصراً مع `UseCases` دون استدعاء `Repositories` أو `MethodChannels` مباشرة.
  * كافة تفاصيل النظام الأصلية (Android و iOS) والكاميرا والحساسات والساعة الرتيبة تُعزل بالكامل داخل `data/datasources/` خلف عقود موحّدة في `domain/repositories/` (مثل `AlarmPlatformRepository`).
* **استراتيجية التخزين الثلاثي (`Three-Tier Local Persistence`):**
  1. **`FlutterSecureStorage`:** حصرياً لتخزين مفتاح Gemini API المشفر.
  2. **`deviceProtectedStorage` (Android Direct Boot):** لحفظ موعد المنبه القادم وحالة الرنّ النشطة، لضمان عمل `LOCKED_BOOT_COMPLETED` قبل فك قفل الشاشة بعد إعادة تشغيل الهاتف.
  3. **`hive_ce` (مع `TypeAdapters` صريحة):** لتخزين إعدادات المستخدم، سجل `Streaks` والـ KPIs المحلية، رصيد **تجاوز الطوارئ** الشهري، حالة **وضع الإجازة**، و**كاش مواقيت الفجر المحسوبة مسبقاً لمدة 30 يوماً (`30-day rolling cache`)**.

---

## 2. المتطلبات الوظيفية (Functional Requirements)

### FR-01: جدولة المنبه ومواقيت الصلاة (Prayer Schedule)
* **FR-1.1:** حساب وقت أذان الفجر يومياً أوفلاين باستخدام حزمة `adhan` بناءً على الإحداثيات أو المدينة المختارة، مع تخزين جدول الـ 30 يوماً القادمة في `hive_ce`.
* **FR-1.2:** إتاحة ضبط وقت المنبه نسبياً للأذان (مثلاً: قبل الأذان بـ 15 دقيقة، عند الأذان، أو بعده بـ 10 دقائق) أو ضبط **وقت يدوي ثابت**.
* **FR-1.3:** إعادة جدولة منبه اليوم التالي تلقائياً فور انتقال المنبه إلى حالة `[COMPLETED]`.

### FR-02: محرك الرنّ والتصعيد (Escalating Ringing Engine)
* **FR-2.1:** عند حلول موعد المنبه (`T_0`) يبدأ الرنّ بصوت متصاعد (`Crescendo`) إلى أقصى مستوى صوت لقناة التنبيهات (`STREAM_ALARM = 100%`).
* **FR-2.2:** تعرض شاشة الرنّ أزرار: **"غفوة"** (تظهر في الرنّ الأول فقط أو وفق عداد الغفوة)، **"إتمام التحدي"**، و**"حالة طوارئ"**.
* **FR-2.3:** منطق التصعيد:
  * **الغفوة الأولى:** تؤجل الرنّ لمدة **5 دقائق** اعتماداً على ساعة النظام الرتيبة (`Monotonic Clock`).
  * **الرنّ الملحّ (`Relentless Ringing`):** بعد انتهاء الغفوة الأولى (أو تجاهل الرنّ لمدة 60 ثانية)، يعاود المنبه الرنّ **كل دقيقة واحدة (`1-Min Loop`)** بلا توقف حتى إتمام التحدي.
* **FR-2.4 (عقد المنصات `v1.0`):**
  * **Android (`minSdk 29` / `targetSdk 35`):** استخدام `USE_EXACT_ALARM` + `AlarmManager.setAlarmClock()` + `FullScreenIntent` + `ForegroundService` (`foregroundServiceType="mediaPlayback"` يُشغّل من حدث الرنّ وليس من `BOOT_COMPLETED`) + `LOCKED_BOOT_COMPLETED` (`directBootAware`).
  * **iOS 26+ (`AlarmKit`):** استخدام **Relentless AlarmKit Cascade** عبر Swift channel: جدولة سلسلة منبهات `AlarmKit` مسبقاً ($T_0, T_0+5\text{m}, T_0+6\text{m}, T_0+7\text{m}, \dots$) مع ربط `LiveActivityIntent` / `AppIntent` بفتح التطبيق مباشرة على شاشة التحدي. لا تُلغى (`cancel`) السلسلة إلا برمجياً من داخل التطبيق بعد الوصول لحالة `[COMPLETED]`.

### FR-03: الكاميرا الحية والحساسات (Live Camera & Sensor Verification)
* **FR-3.1:** فتح الكاميرا الخلفية ببث حي داخل التطبيق فقط (`Live Camera Stream Only`) مع زر تشغيل/إيقاف الفلاش (`Torch`) للإضاءة المنخفضة.
* **FR-3.2 (`Accelerometer Tilt Check`):** التحقق من توجيه الهاتف للأسفل بزاوية وقوف تتراوح بين **`-45°` و `-90°`** قبل تفعيل زر الالتقاط.
* **FR-3.3:** تعطيل استيراد الصور من المعرض أو الملفات تماماً (`Gallery Picker Disabled`).

### FR-04: التحقق البصري والمسار الأوفلاين (Pragmatic Vision & Offline Fallback)
* **FR-4.1 (المسار السحابي المباشر — Online Primary):**
  * ضغط الصورة في الـ `RAM` (دقة ~`800x600`) وإرسالها عبر REST API إلى `gemini-2.5-flash-lite` (أو `gemini-2.5-flash` كاحتياطي عند الرفض/الخطأ).
  * **سياسة القبول المباشر (`Pragmatic Verification`):** تجنب التشدد المعقد؛ طالما تحققت زاوية الوقوف وصُوّرت بالكاميرا الحية وظهرت سجادة الصلاة وقدم واحدة على الأقل واقفة عليها بوضوح (وليست صورة شاشة إلكترونية)، يُقبل التحدي فوراً.
  * **عند القبول:** يتوقف المنبه وتُلغى سلسلة `AlarmKit`، تُمسح الصورة من الـ `RAM` خلال `< 500ms`، ويُحدَّث عداد الـ `Streak` (إلا في حالة **المنبه التجريبي**)، وتُجدول صلاة الغد.
  * **عند الرفض:** يظهر سبب الرفض بالعربية أو الإنجليزية (`rejection_reason`) مع إتاحة إعادة الالتقاط مباشرة واستمرار الرنّ الملحّ.
* **FR-4.2 (تسلسل المسار الأوفلاين — Offline Fallback Hierarchy):**
  * عند انقطاع الإنترنت أو فشل الطلب السحابي (`429`, `403`, `5xx`, `Timeout`, `SocketException`)، يتحول التطبيق فوراً للمسار الأوفلاين بالترتيب الإلزامي التالي لإغلاق ثغرة قطع الإنترنت في السرير:
    1. **تحدي باركود الحمام (`Bathroom Barcode Challenge` — الأساسي):** يُفرض مسح باركود منتج الحمام المسجل مسبقاً (مثل معجون الأسنان) لإجبار المستخدم على النهوض والمشي فعلياً.
    2. **تحدي الكتابة واقفاً (`Standing Typing Challenge` — الاحتياطي):** لا يُفتح إلا إذا **لم يسجل المستخدم باركود بعد** أو عند **تعطل الكاميرا**، ويتطلب كتابة فقرة أذكار من `120` حرفاً بدقة `100%` مع تعطيل اللصق واشتراط ثبات الهاتف بزاوية الوقوف (`-45°` إلى `-90°`).

### FR-05: نموذج التهديد وردع الغش (Sleepy-Self Threat Model & Deterrence)
* **نموذج التهديد المعتمد:** حماية موجهة ضد **"الخصم النعسان (`Sleepy Self`)"** ومحاولاته السريعة من السرير (كتم الصوت، إغلاق الشاشة، قطع الإنترنت، تصوير شاشة، تغيير الساعة، أو إلغاء المنبه قبل الفجر بدقائق). تُستبعد الهجمات التقنية المعقدة (`adb` من الكمبيوتر، إلغاء التثبيت، تعديل الكود).
* **FR-5.1 (ردع خفض الصوت — Android):** دمج اعتراض أزرار الهاردوير (`Activity.onKeyDown`) أثناء وجود الواجهة في الأمام مع مراقب دوري داخل `ForegroundService` يعيد مستوى `AudioManager.STREAM_ALARM` إلى `100%` لحظياً.
* **FR-5.2 (ردع الإغلاق — Android):** استمرارية `ForegroundService` وإعادة فتح شاشة التحدي عبر `FullScreenIntent` عند محاولة الخروج، مع تفعيل `startLockTask()` (`Screen Pinning`) كطبقة ردع إضافية (وتوثيق أمر `adb` اختياري للـ `Device Owner` لمن يرغب).
* **FR-5.3 (حماية التوقيت):** تعتمد جميع مدد الغفوة (`5m` / `1m`) والعد التنازلي للطوارئ (`60s`) على **الساعة الرتيبة (`SystemClock.elapsedRealtime` / `Monotonic Timer`)** فلا تتأثر بتغيير ساعة الهاتف يدوياً.
* **FR-5.4 (نافذة القفل قبل الفجر — `Pre-Fajr Lock Window`):** قفل تعديل وقت المنبه، أو تعطيله، أو تعديل رصيد الطوارئ الشهري، أو تفعيل **وضع الإجازة** بدءاً من **`30` دقيقة قبل موعد منبه الفجر (`T - 30m`)** وحتى إتمام التحدي (`[COMPLETED]`).

### FR-06: تجاوز الطوارئ ووضع الإجازة (Emergency Override & Vacation Mode)
* **FR-6.1 (`Vacation Mode`):** يُفعَّل فقط خارج **نافذة القفل (`T - 30m`)** وبمدة محددة مسبقاً بالأيام يختارها المستخدم. يطبّق النظام **تجميد سلسلة الالتزام (`Streak Freeze`)** طوال أيام الإجازة، ثم يعيد تفعيل منبه الفجر تلقائياً فور انتهاء المدة.
* **FR-6.2 (`Emergency Override`):**
  * يتوفر زر **"حالة طوارئ"** في شاشة الرنّ وفق **رصيد شهري قابل للتعديل في الإعدادات** (ويُقفل تعديل الرصيد خلال نافذة `T - 30m` وأثناء الرنّ).
  * **آلية الكتم الفوري والضغط المتواصل (`Touch-Mute + 60s Hold`):** بمجرد لمس وتثبيت الإصبع على الزر **يُكتم صوت المنبه فوراً طوال مدة اللمس** لتأمين الطوارئ الحقيقية، لكن لا يُلغى المنبه وتُسجَّل حالة `[COMPLETED]` إلا بعد إتمام **`60` ثانية متواصلة من الضغط**؛ وإذا رُفع الإصبع قبل اكتمالها يعود العداد للصفر ويعود الصوت للرنّ.

### FR-07: الإعداد الأولي واللغات والتجربة السريعة (Onboarding, i18n & Dry-Run)
* **FR-7.1 (`4-Step Onboarding`):**
  1. تحديد الموقع/المدينة لحساب أذان الفجر محلياً.
  2. **بوابة الصلاحيات الإلزامية (`Permissions Gate`):** فحص وطلب `canUseFullScreenIntent()` (Android 14+) و `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` وإذن الكاميرا والتنبيهات/AlarmKit.
  3. **إفصاح الخصوصية ومفتاح Gemini:** عرض إشعار الخصوصية وأخذ **موافقة صريحة (`Explicit Consent`)** على شروط Google Free Tier، ثم إدخال مفتاح Gemini API واختباره حياً (`Test Key`).
  4. **تسجيل باركود الحمام:** مسح باركود معجون الأسنان/الغسول للاحتياط الأوفلاين (مع إمكانية إكماله أو تعديله من الإعدادات لاحقاً).
* **FR-7.2 (`i18n & RTL`):** دعم كامل للغتين **العربية (`RTL`)** والإنجليزية (`LTR`) عبر ملفات `.arb` (`AppLocalizations`) مع زر تبديل اللغة داخل الإعدادات، وصفر نصوص مكتوبة مباشرة في واجهات Flutter.
* **FR-7.3 (`Dry-Run Alarm`):** زر **"تجربة المنبه الآن (بعد 10 ثوانٍ)"** في الإعدادات (خارج نافذة القفل) لتجربة الرنّ وشاشة القفل والكاميرا والباركود على الجهاز الحقيقي دون زيادة أو تصفير الـ `Streak`.

---

## 3. المتطلبات غير الوظيفية (Non-Functional Requirements)

| الفئة | المتطلب | المعيار المستهدف |
| :--- | :--- | :--- |
| **الأداء** | زمن التحقق عبر Gemini REST API (مع ضغط الصورة). | `< 4` ثوانٍ على 4G / Wi-Fi (تُحسم قياساتها بالتجربة الفعلية). |
| **الأمان** | تشفير وحفظ مفتاح API الخاص بالمستخدم. | `FlutterSecureStorage` (`Android Keystore` / `iOS Keychain`)؛ صفر أسرار في الريبو. |
| **الخصوصية** | عدم حفظ صور التحدي + الموافقة الصريحة على Free Tier. | معالجة في الـ `RAM` فقط ومسح فوري خلال `< 500ms`. |
| **الاعتمادية** | النجاة من إعادة تشغيل الهاتف قبل فك القفل. | `LOCKED_BOOT_COMPLETED` + `deviceProtectedStorage` في أندرويد؛ `AlarmKit Cascade` في iOS 26+. |
| **التوافق** | إصدارات أنظمة التشغيل في `v1.0`. | Android 10+ (`minSdk 29` / `targetSdk 35`) و iOS 26+. |
| **الجودة والاختبار** | تغطية الاختبارات والتحليل الساكن. | `80%+` coverage على `domain/` و `repositories/` و `bloc/`، وصفر تحذيرات `dart analyze --fatal-infos`. |

---

## 4. مواصفات التحقق بالذكاء الاصطناعي (Gemini REST Contract)
* **المسار:** `POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`
* **الموديل:** `gemini-2.5-flash-lite` (افتراضي) أو `gemini-2.5-flash` (احتياطي)، `temperature: 0.1`، `responseMimeType: "application/json"`.

```json
{
  "system_instruction": "You are a fair, pragmatic verification judge for a Fajr prayer wake-up alarm. Analyze the user's live POV photo and verify three conditions: 1) A prayer rug (Sajjada) is visible on the floor. 2) At least one human foot (barefoot or in socks) is clearly standing on the prayer rug. 3) It appears to be a real live room photo, NOT a photo of a digital screen, monitor, smartphone, or printed picture. If the user clearly woke up and stood on the prayer rug, accept it without unnecessary strictness. Respond strictly in JSON matching the schema.",
  "responseSchema": {
    "is_prayer_rug_present": "boolean",
    "are_feet_on_rug": "boolean",
    "is_real_live_photo": "boolean",
    "verified": "boolean (true ONLY if all three above are true)",
    "rejection_reason": "string (short helpful reason in the user's active locale ar/en if verified is false, empty if true)"
  }
}
```

---

## 5. مخطط حالات المنبه (Alarm State Machine)

```text
[IDLE / SCHEDULED]  ◄───(انتهاء مدة Vacation Mode تلقائياً)─── [VACATION_FROZEN]
        │  ▲
        │  └───────────────(إيقاف/تعديل مسموح فقط قبل T - 30m)
        ▼ (دخول T - 30m: Pre-Fajr Lock Window)
[LOCKED_PRE_FAJR]
        │ (حلول موعد المنبه T_0)
        ▼
[RINGING_INITIAL] ──(Snooze #1: 5m عبر Monotonic Clock)──► [SNOOZED_5_MIN]
        │                                                       │
        │ (بدء التحدي)                                          ▼ (انتهاء 5m)
        ├──────────────────► [CHALLENGE_ACTIVE] ◄── [RINGING_RELENTLESS (1-Min Loop)]
        │                         │    │                        ▲
        │ (Emergency Override:    │    └──(رفض AI / إعادة)──────┘
        │  كتم باللمس + 60s)      │
        ▼                         ▼ (نجاح Gemini أو باركود الحمام أو الكتابة واقفاً)
[COMPLETED / STOPPED] ◄───────────┘
        │
        └──► (مسح الصورة < 500ms + تحديث Streak + إلغاء AlarmKit Cascade + جدولة الغد)
```

---

## 6. مصفوفة الحالات الاستثنائية (Edge Cases Matrix)

| الحالة | سلوك النظام المعتمد |
| :--- | :--- |
| **انقطاع الإنترنت أو فشل API (`429`/`403`/`5xx`/Timeout)** | التحويل الفوري إلى **تحدي باركود الحمام** (أو **تحدي الكتابة واقفاً** إذا لم يُسجّل باركود أو تعطلت الكاميرا). |
| **إعادة تشغيل الهاتف قبل فك القفل (Android)** | استقبال `LOCKED_BOOT_COMPLETED` وقراءة الجدولة/الحالة من `deviceProtectedStorage` لإعادة جدولة/استئناف المنبه فوراً. |
| **محاولة تغيير ساعة الهاتف يدوياً للغش** | تجاهل `DateTime.now()` في مؤقتات الغفوة (`5m`/`1m`) والطوارئ (`60s`) والاعتماد على **الساعة الرتيبة (`Monotonic Clock`)**. |
| **محاولة إغلاق التطبيق أو ضغط Stop في iOS 26+** | استمرار سلسلة **Relentless AlarmKit Cascade** في الرنّ كل دقيقة حتى فتح التطبيق وإتمام التحدي (`[COMPLETED]`). |
| **رفع الإصبع مبكراً عن زر الطوارئ** | إعادة العداد فوراً إلى `0` واستئناف رنّ المنبه بأقصى صوت (`STREAM_ALARM = 100%`). |
| **تشغيل المنبه التجريبي (`Dry-Run Alarm`)** | يرنّ بعد 10 ثوانٍ ويفتح التحدي الكامل، ثم يعود لـ `[IDLE]` دون تعديل سجل `Streak` أو رصيد الطوارئ الشهري. |

---

## 7. حزمة التقنيات المعتمدة للتنفيذ (Approved Flutter Stack)
* **إدارة الحالة والمعمارية:** `flutter_bloc`, `get_it`, `freezed`, `fpdart`, `go_router`.
* **مواقيت الصلاة:** `adhan` (Pure Dart offline calculation).
* **التخزين المحلي:** `flutter_secure_storage` (BYOK key), `hive_ce` + `hive_ce_flutter` (Settings, Streaks, 30-day cache), Android `deviceProtectedStorage` (Direct Boot).
* **الشبكة والـ AI:** `dio` (أو `http`) للاتصال المباشر بـ Gemini REST API.
* **الكاميرا والحساسات والباركود:** `camera`, `sensors_plus`, `mobile_scanner`.
* **المنبهات والقنوات الأصلية:** Android (`MethodChannel`/`EventChannel` + `AlarmManager.setAlarmClock` + `ForegroundService` + `FullScreenIntent` + `startLockTask` + `AudioManager.STREAM_ALARM`) و iOS 26+ (Swift `AlarmKit` + `LiveActivityIntent` channel).
* **التعريب:** `flutter_localizations` + `intl` (`.arb` for `ar` and `en`).

---

## 8. استراتيجية الاختبارات وضمان الجودة (Testing Strategy — 80%+ Coverage)
* **اختبارات الوحدات والمعمارية (`Unit, Repository & Bloc Tests`):**
  * استخدام `mocktail` و `bloc_test` و `fake_async` لاختبار `domain/usecases/` و `data/repositories/` و `presentation/bloc/` بتغطية لا تقل عن **`80%`**.
  * استخدام `fake_async` لمحاكاة مرور الزمن واختبار الغفوة (`5m` ← `1m`)، والعد التنازلي لزر الطوارئ (`60s` مع الانقطاع المبكر)، و**نافذة القفل (`T - 30m`)**، وانتهاء **وضع الإجازة**.
  * اختبار مسارات الفشل (انقطاع الإنترنت، أخطاء Gemini `429`/`403`/`5xx`، زاوية ميل خاطئة، استنفاد الرصيد الشهري).
* **اختبارات عقود القنوات الأصلية (`MethodChannel Contract Tests`):**
  * استخدام `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler` للتحقق من دقة أسماء الدوال والمعاملات المرسلة والمستقبلة عبر قنوات Android و iOS 26+.
* **التحقق على الجهاز الحقيقي (`Real-Device Verification`):**
  * الاعتماد على **المنبه التجريبي (`Dry-Run Alarm — 10s`)** لاختبار تجاوز شاشة القفل، وقفل الصوت، وتثبيت الشاشة، والكاميرا، و`AlarmKit Cascade` على الهاتف الفعلي بأمان.
