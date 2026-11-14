# Fajr-Alarm Shared Team Memory

> Committed, shared operational memory across machines and agents. Never record secrets, API keys, or personal data here.

## Architecture & Operating Model
- Serverless / Local-First / BYOK (Bring Your Own Key) Flutter app — zero backend, zero accounts, zero secrets committed to GitHub.
- Feature-Based Clean Architecture (`lib/core/` + `lib/features/<feature>/{domain,data,presentation}`) with `flutter_bloc`, `freezed`, `get_it`, `fpdart` (`Either<Failure, T>`), and local caching/storage where needed (`hive_ce` / `drift` + `deviceProtectedStorage` for Android Direct Boot alarms).

## Platform Contract (v1.0)
- **Android (`minSdk 29`, `targetSdk 35`):** `USE_EXACT_ALARM` + `setAlarmClock()`, `FullScreenIntent` (`canUseFullScreenIntent()` checked at onboarding), `ForegroundService` (`mediaPlayback`), `LOCKED_BOOT_COMPLETED` + `deviceProtectedStorage`, multi-layered volume (`onKeyDown` + `STREAM_ALARM` observer) & screen-pinning deterrence (`startLockTask()`).
- **iOS (`iOS 26+` only in v1.0):** `AlarmKit` via Swift MethodChannel using **Relentless AlarmKit Cascade** (pre-scheduled sequence $T_0, T_0+5\text{m}, T_0+6\text{m}, \dots$ cancelled only inside the app on `[COMPLETED]`). `iOS 15–25` support is deferred past `v1.0`.

## AI Verification & Privacy
- Primary Vision verification uses Gemini REST API (`gemini-2.5-flash-lite` default, `gemini-2.5-flash` fallback) with `responseMimeType: application/json` and `responseSchema`, authenticating with user-supplied key stored in `FlutterSecureStorage` (`x-goog-api-key`).
- Free-tier Gemini requests may be used by Google for training/review; explicit user consent during onboarding and immediate in-memory deletion (`< 500ms`) of captured photos are mandatory.

## Threat Model & Anti-Cheating Policy (#6)
- **Sleepy-Self Threat Model:** Defenses target quick in-bed cheats by the sleepy user (muting volume, locking screen, toggling Airplane Mode, photographing a screen, changing the system clock) — not complex technical attacks (`adb`, uninstalling, code modification).
- **Offline Fallback Hierarchy (`FR-4.2`):** Bathroom Barcode Scan is the primary offline challenge to enforce physical locomotion out of bed. The 120-char zero-error no-paste typing challenge is only available if no barcode is registered or camera fails, and requires holding the phone at the standing tilt angle (`-45°` to `-90°`).
- **Pragmatic POV Verification (`FR-03` / `FR-04`):** Live camera stream + standing tilt check (`-45°` to `-90°`) + balanced Gemini prompt that accepts any clear live photo of a foot standing on a prayer rug without overly complex/strict rejection loops.
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

