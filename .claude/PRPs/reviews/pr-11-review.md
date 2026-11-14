[DEFINITION OF DONE]
- Inspect `git diff main...HEAD` and commit `c4034b4` without modifying any files.
- Verify adherence to `.claude/CONSTITUTION.md` and `CLAUDE.md` across architecture, domain purity, localization/RTL, security/BYOK/privacy, native Android (`minSdk 29`, `targetSdk 35`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `MainActivity`, `AlarmForegroundService`), and iOS 26+ (`AlarmKitManager`, `AppDelegate`).
- Run `dart format --output=none --set-exit-if-changed .`, `dart analyze --fatal-infos`, and `flutter test --no-pub`.
- Compare against baseline `.claude/PRPs/reviews/pr-11-review.md` and emit `VERDICT: APPROVE` or `VERDICT: REQUEST_CHANGES` with severity-grouped findings, exact `file:line` citations, and observed `[STDOUT]`.

### Review Todo Checklist
- [x] Read [CLAUDE.md](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/CLAUDE.md), [.claude/CONSTITUTION.md](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/.claude/CONSTITUTION.md), and baseline review [pr-11-review.md](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/.claude/PRPs/reviews/pr-11-review.md)
- [x] Inspect `git diff main...HEAD` (`223` files) and commit `c4034b4` (`51` files)
- [x] Verify Clean Architecture boundaries, pure Dart `domain/`, `.arb` AR/EN parity, RTL directional widgets, and secret/privacy gates
- [x] Verify native Android (`AndroidManifest.xml`, `build.gradle.kts`, `MainActivity.kt`, `AlarmForegroundService.kt`, `AlarmReceiver.kt`, `DirectBootReceiver.kt`, `AlarmStorage.kt`) and iOS 26+ (`AlarmKitManager.swift`, `AppDelegate.swift`, `Info.plist`)
- [x] Execute verification gates (`dart format`, `dart analyze --fatal-infos`, `flutter test --no-pub`) and audit `lcov.info` layer coverage

---

# Pre-Merge Code Review — PR #11 (`feat/fajr-alarm-v1` → `main`)

**Reviewer:** Argon (Read-Only Pre-Merge Gate)
**HEAD Commit Reviewed:** `c4034b438187d601a572cce9308bf8a772910686` (`fix: resolve Hydrogen QA findings and complete native alarm-to-challenge wiring`)
**VERDICT: APPROVE**

---

## 1. Resolution of Baseline Review ([pr-11-review.md](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/.claude/PRPs/reviews/pr-11-review.md)) & Hydrogen QA Findings

All **3 HIGH** and **2 MEDIUM** issues from the prior review baseline, as well as all **8 QA findings from Hydrogen**, have been resolved in commit `c4034b4` and verified by `36` new automated tests (`234` total passing tests, up from `198`):

1. **[RESOLVED — Prior HIGH #1] Onboarding & Runtime Storage / Native Permissions / Router Gate:**
   - **Shared Barcode Store:** [onboarding_local_data_source.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/onboarding/data/datasources/onboarding_local_data_source.dart#L26-L68) and [onboarding_repository_impl.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/onboarding/data/repositories/onboarding_repository_impl.dart#L186-L196) now persist the normalized bathroom barcode into `FlutterSecureStorage` under `OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey` (`'bathroom_barcode'`), matching [injection.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/di/injection.dart#L291-L299) and [challenge_verification_repository_impl.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/data/repositories/challenge_verification_repository_impl.dart#L26-L31).
   - **Native Permissions Channel (`com.elgenius.fajralarm/onboarding_permissions`):** Registered on Android in [MainActivity.kt](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt#L64-L85) (`OnboardingPermissionsPlugin` at [MainActivity.kt](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt#L140-L222)) and on iOS in [AppDelegate.swift](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/AppDelegate.swift#L27-L35) + [AlarmKitManager.swift](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/AlarmKitManager.swift#L272-L328).
   - **Location Sync & Router Gate:** [onboarding_repository_impl.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/onboarding/data/repositories/onboarding_repository_impl.dart#L50-L72) syncs saved onboarding coordinates/city into `PrayerScheduleRepository.saveAlarmConfig`, and `createAppRouter` in [app_router.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/router/app_router.dart#L39-L65) redirects `/` (`AppRoutes.schedule`) to `/onboarding` until `entity.isCompleted` is `true`.

2. **[RESOLVED — Prior HIGH #2] OS Alarm Scheduling on Load / Config Update / Reschedule:**
   - [prayer_schedule_repository_impl.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart#L118-L142) bridges `saveNextScheduledAlarm(alarmTime)` directly to `AlarmPlatformRepository.scheduleAlarm(scheduledAt: alarmTime, isDryRun: false)` when non-null and `cancelAllAlarms()` when null (wired in [injection.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/di/injection.dart#L143-L145)).
   - Scheduling failures propagate into `PrayerScheduleOverview.actionFailure` in [load_prayer_schedule_usecase.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/domain/usecases/load_prayer_schedule_usecase.dart#L80-L97) and [update_fajr_alarm_config_usecase.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/domain/usecases/update_fajr_alarm_config_usecase.dart#L70-L89).

3. **[RESOLVED — Prior HIGH #3] `isClosed` Lifecycle Guards on Async `Cubit` / `Bloc` Emissions:**
   - Added `if (isClosed) return;` and `_safeEmit(...)` guards across all async gaps and stream subscriptions in [challenge_cubit.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/presentation/cubit/challenge_cubit.dart#L39-L242), [onboarding_cubit.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/onboarding/presentation/bloc/onboarding_cubit.dart#L32-L243), [prayer_schedule_cubit.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart#L20-L71), [settings_cubit.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/settings_and_streak/presentation/cubit/settings_cubit.dart#L45-L325), and [alarm_ringing_bloc.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart#L88-L360).

4. **[RESOLVED — Prior MEDIUM #1] Immediate Ephemeral Camera File Deletion:**
   - [challenge_page.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/presentation/pages/challenge_page.dart#L134-L144) wraps `await file.readAsBytes()` in a `try / finally` block that immediately deletes `File(file.path)` if it exists, complementing the `< 500ms` RAM zeroing (`imageBytes.fillRange(0, imageBytes.length, 0)`) in [gemini_vision_remote_datasource.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart#L99-L103).

5. **[RESOLVED — Prior MEDIUM #2] Layer Test Coverage Above 80%:**
   - `domain/`: `383/421` (**90.97%**)
   - `data/repositories/`: `225/258` (**87.21%**, up from `71.79%`)
   - `presentation/bloc|cubit/`: `419/515` (**81.36%**, up from `79.86%`)
   - Core layers aggregate: `1,027/1,194` (**86.01%**)

6. **[RESOLVED — Hydrogen QA Findings]:**
   - Native alarm trigger to Flutter `AlarmRingingPage` navigation (`consumePendingAlarmTrigger` & `onAlarmTriggered` in [MainActivity.kt](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt#L33-L61), [AlarmKitManager.swift](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/AlarmKitManager.swift#L55-L83), [main.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/main.dart#L35-L88), and [app_router.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/router/app_router.dart#L118-L162)).
   - End-to-end completion & emergency override finalization (`finalizeChallengeCompletion` and `finalizeEmergencyOverride` in [app_router.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/router/app_router.dart#L192-L243)).
   - Offset minutes `ChoiceChip` selector and manual `showTimePicker` in [prayer_schedule_page.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart#L697-L783), plus today's date lookup in [prayer_schedule_page.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart#L143-L174).
   - Dry-run alarm cancellation ([cancel_dry_run_alarm_usecase.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/settings_and_streak/domain/usecases/cancel_dry_run_alarm_usecase.dart#L1-L32), [injection.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/di/injection.dart#L203-L213), [settings_page.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/settings_and_streak/presentation/pages/settings_page.dart#L539-L549)) and Pre-Fajr Lock Window `nextAlarmProvider` wiring in [injection.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/di/injection.dart#L248-L254).
   - Broadcast-safe `StreamTransformer.fromHandlers` error mapping in [challenge_verification_repository_impl.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/data/repositories/challenge_verification_repository_impl.dart#L78-L105).

---

## 2. Constitutional & Architectural Compliance Audit

| Constitutional Gate | Status | Evidence |
|---|---|---|
| **Feature-Based Clean Architecture** | PASS | `lib/core/` + 5 features (`onboarding`, `prayer_schedule`, `alarm_ringing`, `challenge_verification`, `settings_and_streak`) with strict `{domain,data,presentation}` separation, `flutter_bloc`, `get_it`, `freezed`, and `fpdart` (`Either<Failure, T>`). |
| **Pure Dart `domain/`** | PASS | `55` domain Dart files audited; `0` forbidden imports (`package:flutter`, `hive`, `dio`, `flutter_secure_storage`, `camera`, `mobile_scanner`, `sensors_plus`, `go_router`). |
| **Zero Hardcoded UI Strings & RTL** | PASS | `195` EN keys in [app_en.arb](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/l10n/app_en.arb#L1-L552) and `195` AR keys in [app_ar.arb](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/core/l10n/app_ar.arb#L1-L198) (`0` missing keys in either locale); `0` non-directional `EdgeInsets.only/fromLTRB` or `Alignment.*Left/Right` usages in `presentation/`. |
| **Zero Secrets / BYOK / Privacy** | PASS | `0` secrets across `lib/`, `android/`, `ios/`, `test/`, `.claude/`. Gemini key stored exclusively in `FlutterSecureStorage` ([onboarding_local_data_source.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/onboarding/data/datasources/onboarding_local_data_source.dart#L25-L56)) and sent via `x-goog-api-key` ([gemini_vision_remote_datasource.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart#L149-L153)). |
| **Native Android (`minSdk 29`, `targetSdk 35`)** | PASS | [build.gradle.kts](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/build.gradle.kts#L22-L23) sets `minSdk = 29`, `targetSdk = 35`; [AndroidManifest.xml](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/AndroidManifest.xml#L2-L62) declares `SCHEDULE_EXACT_ALARM` (`maxSdkVersion="32"`), `USE_EXACT_ALARM`, `USE_FULL_SCREEN_INTENT`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `directBootAware="true"` receivers/service; [AlarmStorage.kt](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmStorage.kt#L20-L23) uses `createDeviceProtectedStorageContext()`. |
| **Native iOS 26+ (`AlarmKit`)** | PASS | [Info.plist](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/Info.plist#L27-L30) declares `NSAlarmKitUsageDescription` and `NSCameraUsageDescription`; [AlarmKitManager.swift](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/AlarmKitManager.swift#L16-L48) implements `OpenFajrChallengeIntent: LiveActivityIntent` and the Relentless Cascade ($T_0, T_0+5\text{m}, T_0+6\text{m}, \dots, T_0+15\text{m}$). |

---

## 3. Findings by Severity

### CRITICAL
None (`0`).

### HIGH
None (`0`).

### MEDIUM
None (`0`).

### LOW
1. **Oversized Presentation File (`1,352` lines)** — [prayer_schedule_page.dart](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart#L1-L1352)
   - Exceeds the 800-line file size guideline. Private sub-widgets (`_NextAlarmHeroCard`, `_AlarmConfigCard`, `_LocationMethodBottomSheet`, `_ScheduleDayRow`) are well-structured `StatelessWidget`/`StatefulWidget` classes and can be extracted into `lib/features/prayer_schedule/presentation/widgets/` in a follow-up cleanup PR.
2. **Release Build Uses Debug Signing Config** — [build.gradle.kts](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/build.gradle.kts#L33-L37)
   - `signingConfig = signingConfigs.getByName("debug")` is used for local release builds (`TODO` present); configure an externalized upload keystore before Play Store distribution.

### NOTES
- Native system notification / AlarmKit alert titles in [AlarmForegroundService.kt](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt#L188-L189) and [AlarmKitManager.swift](file:///Users/ahmed/Documents/GitHub/Fajr-Alarm/ios/Runner/AlarmKitManager.swift#L176-L185) use English literals at the OS boundary (`LocalizedStringResource` on iOS); optional platform-level `strings.xml` / `Localizable.xcstrings` localization can be added in a future release.

---

## 4. Verification Gates (`[STDOUT]`)

[STDOUT]
```text
$ dart format --output=none --set-exit-if-changed .
Formatted 142 files (0 changed) in 1.18 seconds.

$ dart analyze --fatal-infos
Analyzing Fajr-Alarm...
No issues found!

$ flutter test --no-pub
00:00 +0: loading /Users/ahmed/Documents/GitHub/Fajr-Alarm/test/core/monotonic_clock_test.dart
...
00:19 +228: /Users/ahmed/Documents/GitHub/Fajr-Alarm/test/widget_test.dart: FajrAlarmApp redirects initial route to onboarding until completed
00:20 +233: /Users/ahmed/Documents/GitHub/Fajr-Alarm/test/widget_test.dart: FajrAlarmApp renders schedule route when onboarding completed and navigates to settings
00:21 +234: All tests passed!

$ python3 <domain_arb_rtl_secret_coverage_audit>
DOMAIN_FILES: 55 VIOLATIONS: 0
ARB_EN_KEYS: 195 ARB_AR_KEYS: 195 EN_ONLY: set() AR_ONLY: set()
RTL_ISSUES: 0
SECRET_HITS: 0 []
LARGE_FILES (>800 lines): [('lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart', 1352)]
COV_domain: 383/421 (90.97%)
COV_data_repos: 225/258 (87.21%)
COV_bloc_cubit: 419/515 (81.36%)
COV_all_non_gen: 3188/4072 (78.29%)
```
