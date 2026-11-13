# Fajr-Alarm Constitution (v1.0.0)

> Governing document for **Fajr-Alarm** (`ElGenius-developer/Fajr-Alarm`). On conflict: this Constitution > `CLAUDE.md` > `AGENTS.md` / `GEMINI.md` > machine-wide defaults.

## Constitution Check — FIRST Action Each Session

Before writing code, modifying files, or running commands, verify these gates hold for the change at hand:

1. **Pure Domain Isolation:** `domain/` contains pure Dart only (no `package:flutter`, no platform channels, no storage/HTTP packages).
2. **Feature-Based Clean Architecture:** Every feature lives under `lib/features/<feature>/{domain,data,presentation}` with `flutter_bloc` (Cubit/Bloc), `get_it`, `freezed`, and `fpdart` (`Either<Failure, T>`). Widgets never call repositories, network, or platform channels directly.
3. **Zero Secrets in Repo:** No API keys, tokens, or `.env` secrets committed or logged. BYOK Gemini keys live exclusively in `FlutterSecureStorage`.
4. **Zero Hardcoded UI Copy:** Every user-visible string goes through `.arb` / `AppLocalizations` with both `ar` and `en` keys and full RTL/LTR support.
5. **Test & Quality Gate:** TDD red-green-refactor, **80%+ coverage** on domain/bloc/repositories (`flutter test --coverage`), zero `dart analyze --fatal-infos` warnings, formatted with `dart format`.
6. **Git Hygiene:** Never push directly to `main`. All changes land via branch + reviewed PR.
7. **Proof-of-Execution:** Never claim `done` without real command output (`[STDOUT]`).

---

## 1. Architecture & Caching Contract

- **Pattern:** Feature-Based Clean Architecture (`lib/core/` + `lib/features/<feature>/{domain,data,presentation}`).
- **Data Flow:** `UI (Widget) → Cubit/Bloc → UseCase → Abstract Repository → RepositoryImpl → Local/Remote/Platform DataSource`.
- **Immutability:** Use `freezed` / `const` classes; never mutate entities or state in place.
- **Caching Strategy:** Local-First persistence via `hive_ce` / `drift` (plus Android `deviceProtectedStorage` for Direct Boot alarm metadata) so prayer times, streaks, settings, and active alarm state survive offline mode and device reboots.

## 2. Platform Contract (`v1.0`)

- **Android (`minSdk 29`, `targetSdk 35`):**
  - Exact alarms via `USE_EXACT_ALARM` + `setAlarmClock()`.
  - Full-screen lock-screen bypass via `FullScreenIntent` (`canUseFullScreenIntent()` checked in mandatory onboarding permission gate).
  - Continuous playback via `ForegroundService` (`foregroundServiceType="mediaPlayback"`), started from the alarm trigger (not `BOOT_COMPLETED`).
  - Reboot resilience via `LOCKED_BOOT_COMPLETED` (`directBootAware`) + `deviceProtectedStorage`.
  - Anti-cheating (`FR-5.1`, `FR-5.2`): multi-layered high-friction deterrence — `Activity.onKeyDown` + periodic `AudioManager.STREAM_ALARM` reset to `100%`, plus `ForegroundService` re-launch via `FullScreenIntent` and `startLockTask()` Screen Pinning.
- **iOS (`iOS 26+` only in `v1.0`; `iOS 15–25` deferred past `v1.0`):**
  - Native Swift channel wrapping `AlarmKit` (`NSAlarmKitUsageDescription`) using **Relentless AlarmKit Cascade**: pre-scheduled alarms at $T_0, T_0+5\text{m}, T_0+6\text{m}, \dots$ with `LiveActivityIntent` opening the challenge camera; sequence is cancelled only inside the app after `[COMPLETED]`.

## 3. Security, BYOK & Privacy

- **Zero Secrets:** Never hardcode keys or read/commit `.env` files. Open-source repo must remain 100% secret-free.
- **BYOK Gemini Vision:** REST transport with `x-goog-api-key` read from `FlutterSecureStorage`. Default `gemini-2.5-flash-lite`, fallback `gemini-2.5-flash`, `responseMimeType: application/json` + `responseSchema`.
- **Privacy Disclosure & Ephemeral Images:** Onboarding must explicitly obtain user consent noting Google's free-tier data/training terms. Captured challenge photos stay in RAM only, are never written to gallery/disk, and are purged (`< 500ms`) immediately after verification.

## 4. Localization & Arabic Formatting

- **App UI (`ar` / `en`):** Zero hardcoded user-visible strings anywhere in widgets, tooltips, dialogs, accessibility labels, or error messages. Use `AppLocalizations` (`.arb`). Support RTL/LTR cleanly via `EdgeInsetsDirectional` / `AlignmentDirectional`.
- **Agent Responses:** Whenever responding to the user in Arabic across any surface, wrap Arabic content in `<div dir="rtl">` (keeping code blocks, commands, and file paths in standard LTR blocks).

## 5. Testing & Quality Standards

- **TDD Mandatory:** Write failing unit/bloc/widget tests first (RED), implement minimal passing code (GREEN), refactor.
- **Coverage:** Minimum **80%** on `domain/`, `data/repositories/`, and `presentation/bloc|cubit/`. Mock/fake platform channels, sensors, camera, and HTTP clients at data-source boundaries.
- **Static Checks:** `dart format --set-exit-if-changed .` and `dart analyze --fatal-infos` must pass with zero issues before claiming completion.

## 6. Proof-of-Execution (Anti Silent-Failure)

1. State `[DEFINITION OF DONE]` with the exact verification commands before coding.
2. After coding, include raw `[STDOUT]` from commands actually executed in this session.
3. Verify at least one failure path (e.g., offline fallback, 429/403 API error, invalid sensor tilt) alongside the happy path.
4. End with `[STATUS]: done` only when all checks pass; otherwise `[STATUS]: implemented-pending-verification`. Fabricating stdout is a CRITICAL violation.

## 7. Git & PR Workflow

- **Never push directly to `main`.** Create a feature branch and open a PR.
- Commit format: `<type>: <description>` (`feat|fix|refactor|docs|test|chore|perf|ci`).
- Never commit API keys, debug keystore passwords, or `build/` artifacts.

