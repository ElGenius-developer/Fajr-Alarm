### Topic
SRS review via `/wayfinder`, GitHub decision map (`#1`–`#9`), platform scope resolution (`#5`), and full project onboarding (rules, `save-session`, Flutter/Dart skills).

### Context
Project setup, BRD/SRS validation, and AI workflow initialization for `ElGenius-developer/Fajr-Alarm` (`SRS-Fajr-alarm.md`, `.claude/`, `.agents/`, `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `docs/agents/`).

### What WORKED (with evidence)
- **Public GitHub repository & initial commit** — confirmed by: `gh repo create ElGenius-developer/Fajr-Alarm --public --source=. --push` succeeded and pushed `SRS-Fajr-alarm.md` to `main`.
- **Wayfinder Map `#1` and tickets `#2`–`#9` with native sub-issue & blocking links** — confirmed by: `gh api repos/ElGenius-developer/Fajr-Alarm/issues/1/sub_issues -q 'length'` returned `8` and `#5` `blocked_by` returned `[2, 3]`.
- **Parallel research tickets `#2` (iOS), `#3` (Android), `#4` (Gemini)** — confirmed by: resolution comments posted and issues `#2`, `#3`, `#4` closed on GitHub; Map `#1` updated.
- **Grilling ticket `#5` ("نطاق المنصات في v1")** — confirmed by: resolution comment posted (`#issuecomment-6859404746`), issue `#5` closed, and Map `#1` updated under `Decisions so far` and `Out of scope`.
- **Session memory & settings validation** — confirmed by: `python3 .claude/scripts/rebuild_digest.py` exited `0`, `node -e "JSON.parse(require('fs').readFileSync('.claude/settings.json','utf8'))"` passed, and `node .claude/scripts/session-index.js` printed the session index header.

### Problems & Solutions
- **Problem:** Draft SRS assumed absolute `startLockTask()` prevention, hardware volume-down interception anywhere, and pre-iOS 26 continuous alarm guarantees.
  - **Root cause:** Android Screen Pinning without `Device Owner` is user-escapable, `onKeyDown` requires foreground Activity focus, and iOS < 26 caps local notification sounds at 30s / 64 pending while `AlarmKit` requires iOS 26+.
  - **Attempts:**
    - Researched official Android 14/15 and iOS AlarmKit capabilities in `#2` and `#3` — **outcome:** worked, surfaced exact OS boundaries.
  - **Final solution:** Updated design contract in `#5` to multi-layered deterrence (`ForegroundService` + `FullScreenIntent` + `startLockTask()`, `onKeyDown` + `STREAM_ALARM` observer) and `iOS 26+` **Relentless AlarmKit Cascade** for `v1.0` (deferring `iOS 15–25` past `v1.0`).
- **Problem:** Draft SRS privacy promise conflicted with Gemini free-tier data terms.
  - **Root cause:** Free-tier Gemini API inputs may be used by Google for model training and human review (`#4`).
  - **Attempts:**
    - Checked `google_generative_ai` vs `firebase_ai` vs raw REST — **outcome:** worked (`google_generative_ai` is deprecated, `firebase_ai` binds to developer Firebase project).
  - **Final solution:** Standardized on raw REST with `x-goog-api-key` stored in `FlutterSecureStorage`, `gemini-2.5-flash-lite` default (`gemini-2.5-flash` fallback), `responseSchema` JSON output, mandatory onboarding consent, and `< 500ms` RAM-only photo purge.

### Decisions Made
- **Personal-use + Open Source without secrets** — reason: removes Play/App Store review blockers for sideloaded Android permissions while keeping zero API keys or `.env` files on GitHub (BYOK stored locally in `FlutterSecureStorage`).
- **v1.0 target platforms: Android 10+ (`minSdk 29`, `targetSdk 35`) + iOS 26+ (`AlarmKit`)** — reason: owner's personal iPhone runs iOS 27; `iOS 15–25` 64-notification best-effort path deferred past `v1.0` so `v1.0` keeps real wake-up guarantees.
- **Android Direct Boot & Onboarding Permission Gate** — reason: `LOCKED_BOOT_COMPLETED` + `deviceProtectedStorage` ensures alarms survive overnight reboot before unlock; onboarding checks `canUseFullScreenIntent()` and `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`.
- **Relentless AlarmKit Cascade on iOS 26+** — reason: Apple's `AlarmKit` Lock Screen UI includes an unhideable OS `Stop` button; pre-scheduling $T_0, T_0+5\text{m}, T_0+6\text{m}\dots$ and cancelling only after `[COMPLETED]` inside the app closes that escape hatch.
- **Feature-Based Clean Architecture + local cache** — reason: pure-Dart `domain/`, `flutter_bloc`, `get_it`, `freezed`, `fpdart`, and local caching (`hive_ce`/`drift` + `deviceProtectedStorage`) isolate platform channels and guarantee offline reliability.

### Files Touched
- `SRS-Fajr-alarm.md` — initial BRD & SRS committed to `main`.
- `.claude/CONSTITUTION.md` — authoritative project constitution (Clean Architecture, v1.0 platform contract, BYOK/privacy, i18n/RTL, 80% TDD gate, proof-of-execution).
- `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` — project rulebook and concise cross-agent loaders.
- `.claude/rules/common/*`, `.claude/rules/dart/*` — project-local copies of Claude common and Dart/Flutter rules.
- `.claude/skills/*`, `.agents/skills/*`, `.claude/commands/*` — `save-session`, `sessions`, `rebuild-digest`, `fajr-app-pr-guard`, `speckit-*`, and 52 total Flutter/Dart/UI/Guard/Workflow skills.
- `.claude/hooks/*`, `.claude/scripts/*`, `.claude/settings.json` — `block-push-to-main.sh`, `proof-of-execution.sh`, `session-index.js`, `rebuild_digest.py`, `graph-staleness.sh`, `memory-health.sh`.
- `.claude/memory.md`, `.claude/agents/session-rag.md`, `.claude/sessions/INDEX.md`, `.claude/sessions/DIGEST.md` — shared team memory and session RAG system.
- `docs/agents/{issue-tracker,triage-labels,domain}.md` — GitHub Wayfinder/triage/domain conventions.

### Open Questions / Blockers
- Open Wayfinder frontier tickets on GitHub: `#6` (Threat Model & Anti-Cheating Policy) and `#8` (Clean Architecture Layer Boundaries & Caching).
- Blocked Wayfinder tickets: `#7` (Emergency Override & Vacation Mode, blocked by `#6`) and `#9` (Native Test Strategy, blocked by `#8`).
- Research links/limits cited by subagents in `#2`, `#3`, `#4` (exact Gemini RPM/RPD, Android 14/15 doc URLs, Apple AlarmKit API details) should be spot-checked against live docs when finalizing `SRS-Fajr-alarm.md`.

### Exact Next Step
Run `/wayfinder #1` to resolve frontier ticket `#6` ("نموذج التهديد وسياسة الغش") or `#8` ("حدود الطبقات في Clean Architecture والـ cache"), then merge/open PR for branch `chore/onboard-project-and-skills`.
