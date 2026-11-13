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

