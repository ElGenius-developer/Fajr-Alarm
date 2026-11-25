# Fajr-Alarm Shared Team Memory

> Committed, shared operational memory across machines and agents. Never record secrets, API keys, or personal data here.

## Architecture & Operating Model
- Serverless / Local-First / BYOK (Bring Your Own Key) Flutter app — zero backend, zero accounts, zero secrets committed to GitHub.
- Feature-Based Clean Architecture (`lib/core/` + `lib/features/<feature>/{domain,data,presentation}`) with `flutter_bloc`, `freezed`, `get_it`, `fpdart` (`Either<Failure, T>`), and local caching/storage where needed (`hive_ce` / `drift` + `deviceProtectedStorage` for Android Direct Boot alarms).

## Platform Contract (v1.0)
- **Android (`minSdk 29`, `targetSdk 35`):** `USE_EXACT_ALARM` + `setAlarmClock()`, `FullScreenIntent` (`canUseFullScreenIntent()` checked at onboarding), `ForegroundService` (`mediaPlayback`), `LOCKED_BOOT_COMPLETED` + `deviceProtectedStorage`, multi-layered volume (`onKeyDown` + `STREAM_ALARM` observer) & screen-pinning deterrence (`startLockTask()`).
- **iOS (`iOS 26+` only in v1.0):** `AlarmKit` via Swift MethodChannel using **Relentless AlarmKit Cascade** (pre-scheduled sequence $T_0, T_0+5\text{m}, T_0+6\text{m}, \dots$ cancelled only inside the app on `[COMPLETED]`). `iOS 15–25` support is deferred past `v1.0`.
- **iOS cascade rules (PR #18):** a reschedule replaces only cascades that have not started (opening the app recomputes "next Fajr" as tomorrow and must not silence today); only `cancelAllAlarms` (completion, override, disable, vacation) ends a started one. Both AlarmKit buttons re-arm in the background without unlock (+60s when none of ours rings within 120s), so Stop on a locked phone never ends the alarm. Trigger `isDryRun` comes from the ringing cascade's record, not the global last-scheduled flag.

## AI Verification & Privacy
- Primary Vision verification uses Gemini REST API (`gemini-2.5-flash-lite` default, `gemini-2.5-flash` fallback) with `responseMimeType: application/json` and `responseSchema`, authenticating with user-supplied key stored in `FlutterSecureStorage` (`x-goog-api-key`).
- Free-tier Gemini requests may be used by Google for training/review; explicit user consent during onboarding and immediate in-memory deletion (`< 500ms`) of captured photos are mandatory.

## Threat Model & Anti-Cheating Policy (#6)
- **Sleepy-Self Threat Model:** Defenses target quick in-bed cheats by the sleepy user (muting volume, locking screen, toggling Airplane Mode, photographing a screen, changing the system clock) — not complex technical attacks (`adb`, uninstalling, code modification).
- **Offline Fallback Hierarchy (`FR-4.2`):** Bathroom Barcode Scan is the primary offline challenge to enforce physical locomotion out of bed. The 120-char zero-error no-paste typing challenge is only available if no barcode is registered or camera fails, and requires holding the phone at the standing tilt angle (`-15°` to `25°` pitch, same range as `FR-3.2`).
- **Pragmatic POV Verification (`FR-03` / `FR-04`):** Live camera stream + standing tilt check (`-15°` to `25°` pitch — changed from `-45°`/`-90°` in PR #14 because the old range stopped users aiming the camera at their feet; source of truth: `TiltAngleReading.minValidPitchDegrees` / `maxValidPitchDegrees`) + balanced Gemini prompt that accepts any clear live photo of a foot standing on a prayer rug without overly complex/strict rejection loops.
- **Clock & Settings Guard (`FR-5.4`):** Snooze and ringing timers use the system monotonic clock (immune to manual wall-clock changes), and alarm edits / disabling / Vacation Mode are locked starting **30 minutes before Fajr alarm (`T - 30m`)** until `[COMPLETED]`.

## Emergency Override & Vacation Mode Policy (#7)
- **Emergency Override (`FR-6.2`):** Holding the Emergency button immediately mutes alarm audio while the finger remains pressed (safe for real emergencies), but requires a continuous **60-second hold** to cancel the alarm; releasing early resets the timer and resumes ringing.
- **Configurable Monthly Emergency Quota:** Settings include a user-adjustable monthly allowance for Emergency Override uses (editable outside the `T - 30m` Pre-Fajr Lock Window and active ringing state).
- **Vacation Mode (`FR-6.1`):** Requires selecting an explicit duration in days (outside the `T - 30m` lock window), applies a **Streak Freeze** (preserving the current streak without resetting), and automatically re-enables the Fajr alarm when the duration expires.

## Clean Architecture Boundaries & Caching (#8)
- **5 Feature Modules (`lib/features/`):** `onboarding`, `prayer_schedule`, `alarm_ringing`, `challenge_verification`, and `settings_and_streak` (plus `lib/core/` for DI, routing, theme, failures, and l10n).
- **Three-Tier Local Persistence:** (1) `FlutterSecureStorage` for the BYOK Gemini API key, (2) Android `deviceProtectedStorage` for Direct Boot (`LOCKED_BOOT_COMPLETED`) alarm schedule and active ringing state, and (3) `hive_ce` (with typed `TypeAdapters`) for settings, streaks, monthly emergency quota, and a 30-day rolling prayer-times cache.
- **Platform Channel Isolation:** `domain/` is 100% OS-agnostic pure Dart. All Android (`ForegroundService`, `FullScreenIntent`, `startLockTask`, `STREAM_ALARM`) and iOS 26+ (`Relentless AlarmKit Cascade`) native channels, camera, accelerometer, and monotonic clock live strictly inside `data/datasources/` behind unified domain repository contracts (e.g., `AlarmPlatformRepository`).

## Native Testing, Onboarding, i18n & Local KPIs (#9)
- **Automated Testing (`80%+ Coverage`):** Unit, Repository, and Bloc tests using `mocktail`, `bloc_test`, and `fake_async` (for time-travel testing of 5m/1m snooze, 60s emergency hold, and `T - 30m` lock window), plus `setMockMethodCallHandler` contract tests for native channels.
- **Real-Device Dry-Run Alarm:** In-app "Test Alarm in 10 Seconds" button in Settings (outside the lock window) runs the full native alarm + challenge loop without modifying the user's Streak.
- **Onboarding, i18n & Local KPIs:** 4-step onboarding (Location → Permissions Gate → Privacy Consent & Gemini Key Test → Bathroom Barcode registration); full `ar` (RTL) and `en` (LTR) `.arb` localization with language switcher; 100% local KPIs/Streaks in `hive_ce` with zero external analytics.

## Toolchain (2026-11-21)
- Flutter 3.50.1 (Shorebird bundles the same). `package:flutter/material.dart` is deprecated: import `package:material_ui/material_ui.dart`.
- Use `appLocalizationsDelegates` (`lib/core/l10n/app_localization_delegates.dart`), never `AppLocalizations.localizationsDelegates`: gen-l10n still emits `flutter_localizations` delegate types that `material_ui` widgets cannot find (Arabic widget tests fail with "No MaterialLocalizations found").
- Android: AGP 9.1.1, `compileSdk 36` (required by plugins); `targetSdk` stays 35.
- Device install: pass `DEVELOPMENT_TEAM=J52H7284YY CODE_SIGN_STYLE=Automatic -allowProvisioningUpdates` on the xcodebuild CLI (personal Apple account's Personal Team, never committed). After clearing `iOS DeviceSupport`, the first install needs a USB cable.
- Android snooze (PR #20): snooze arms a native `setAlarmClock` (request code 1003, separate from next-Fajr 1001) *before* stopping the ringing service; if arming fails it keeps ringing. `AlarmStorage` keeps the snooze mark (2h window) + due time so a relaunch can't grant a fresh snooze and `DirectBootReceiver` re-arms it after reboot. Trigger payloads carry `snoozeUsed`; the bloc then goes straight to relentless. iOS `scheduleSnoozeAlarm` is a no-op (cascade rings at T0+5m). Settings paths (disable, vacation, dry-run cancel) call `cancelNextFajrAlarm` (1001 only, snooze kept); only completion and emergency override call `cancelAllAlarms`. On iOS both map to the full cancel.

## F-Droid & FOSS Distribution (v1.0.0, 2026-11-25)
- **License & App ID:** MIT (`LICENSE` at repo root); `applicationId` remains `com.elgenius.fajralarm.fajr_alarm`.
- **FOSS Barcode Decoding:** Replaced `mobile_scanner` (which pulled Google ML Kit, Play Services, Firebase, and Clearcut `transport-backend-cct`) with `FossBarcodeScanner` (`lib/core/widgets/foss_barcode_scanner.dart`) over MethodChannel `com.elgenius.fajralarm/barcode_decoder`: `com.google.zxing:core:3.5.3` (`BarcodeDecoderPlugin.kt` on Android, stride-safe YUV + 90° CW portrait 1D fallback) and Apple `Vision` (`VNDetectBarcodesRequest` in `ios/Runner/AppDelegate.swift`).
- **Android Release & Manifest:** `android/app/build.gradle.kts` disables `dependenciesInfo` (`includeInApk = false`, `includeInBundle = false`) and leaves `release` unsigned for F-Droid. `AndroidManifest.xml` declares `INTERNET`, localizes `@string/app_name` (`values/strings.xml`, `values-ar/strings.xml`), and removes unused `RECORD_AUDIO` (`tools:node="remove"`).
- **Store Metadata & F-Droid Submission:** Fastlane metadata and screenshots live in `fastlane/metadata/android/{en-US,ar}/`. Tag `v1.0.0` points to PR #23 (`de093ed`). GitHub Release `v1.0.0` hosts the RSA-4096 v3 signed APK (`fajr-alarm-v1.0.0.apk`, keystore outside repo at `~/.fajr-release/fajr-alarm-release.jks`, public cert SHA-256 `d9ba2ba299c652813ac5ca27b00ce485b009c0bb8bd5398c538f586e0d372e6f`). F-Droid MR `!59111` (`AntiFeatures: NonFreeNet`, `Categories: [Alarm Clock, Religion]`, `srclibs: flutter@3.50.1`) passed all technical CI checks (`fdroid build`, `fdroid lint`, `fdroid rewritemeta`, `schema validation`, `check apk`) and was closed solely due to F-Droid's >3-month maintenance policy; recipe is saved at `~/.fajr-release/fdroid-submission-metadata.yml` (and `ElGenius-developer/fdroiddata:add-fajr-alarm`) for resubmission after late Feb 2027.
