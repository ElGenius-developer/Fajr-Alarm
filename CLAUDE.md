# CLAUDE.md — Fajr-Alarm

Guidance for AI coding agents working in `ElGenius-developer/Fajr-Alarm`.

> **Governing Document:** [`.claude/CONSTITUTION.md`](.claude/CONSTITUTION.md) is the authoritative source of all project rules. On conflict, the Constitution wins.

## Constitution Check — FIRST Action Required

Verify these gates before writing code, editing files, or running commands:

- [ ] Pure Dart `domain/` layer — zero `package:flutter`, network, storage, or channel imports
- [ ] Feature-Based Clean Architecture (`lib/features/<feature>/{domain,data,presentation}`) + `flutter_bloc` + `get_it` + `freezed` + `fpdart` (`Either`)
- [ ] Zero secrets in repo — BYOK Gemini key in `FlutterSecureStorage` only; never read/commit `.env`
- [ ] Zero hardcoded user-visible strings — `.arb` / `AppLocalizations` (`ar` + `en`) + RTL-safe widgets
- [ ] TDD + 80%+ coverage on domain/bloc/repositories (`flutter test --coverage`), `dart analyze --fatal-infos`, `dart format`
- [ ] Never push directly to `main`; use feature branches and PRs
- [ ] Proof-of-Execution: end claims of completion with real `[STDOUT]` and `[STATUS]: done`

## Task Execution — Todo Checklist Mandatory

Any task with more than one step MUST be broken into a visible Todo checklist and worked through item by item (one item in progress at a time; check each off immediately after finishing it — never batch completions at the end).

## Subagent Model — Fast Default, Opus for Architecture/Review

When invoking subagents:
- Use `flash` / `sonnet` (lighter/faster models) for focused research, file lookup, test writing, and mechanical edits.
- Use `pro` / `opus` (or `inherit`) for architectural design, security/code review, or genuinely complex debugging.

## Project Overview

**Fajr-Alarm** is an open-source, serverless, Local-First / BYOK Flutter mobile alarm app for Fajr prayer wake-up. The alarm enforces Proof-of-Action (standing POV photo of feet on a prayer rug verified via user-supplied Gemini Vision API, with offline barcode/typing fallbacks).

- **Target Platforms (`v1.0`):** Android 10+ (`minSdk 29`, `targetSdk 35`) and iOS 26+ (`AlarmKit`). `iOS 15–25` is out of scope for `v1.0`.
- **Canonical Spec / Wayfinder Map:** [`SRS-Fajr-alarm.md`](SRS-Fajr-alarm.md) and GitHub Issue `#1` (`wayfinder:map`).
- **Domain & Agent Docs:** [`docs/agents/issue-tracker.md`](docs/agents/issue-tracker.md), [`docs/agents/triage-labels.md`](docs/agents/triage-labels.md), [`docs/agents/domain.md`](docs/agents/domain.md).

## Development Commands

```bash
# Dependencies & codegen
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

# Static analysis & formatting
dart format --set-exit-if-changed .
dart analyze --fatal-infos

# Testing & coverage
flutter test
flutter test --coverage

# Release build (with obfuscation)
flutter build apk --obfuscate --split-debug-info=./debug-info/
```

## Architecture (Feature-Based Clean Architecture)

```text
lib/
├── core/                         # DI (get_it), theme, router (go_router), error/failures, constants, l10n
└── features/
    └── <feature>/
        ├── domain/
        │   ├── entities/         # Immutable pure Dart entities
        │   ├── repositories/     # Abstract repository interfaces
        │   └── usecases/         # Single-responsibility business logic returning Either<Failure, T>
        ├── data/
        │   ├── datasources/      # Local cache (hive_ce/drift), DirectBoot storage, REST, Platform Channels
        │   ├── models/           # DTOs (freezed + json_serializable) mapped to domain entities
        │   └── repositories/     # Repository implementations + caching coordination
        └── presentation/
            ├── bloc/             # Cubit / Bloc + immutable states
            ├── pages/            # Screen scaffolds
            └── widgets/          # Small private/reusable const widgets
```

- **State Management:** `flutter_bloc` (`Cubit` for simple states, `Bloc` for complex event-driven flows like the Alarm State Machine).
- **Caching:** Cache astronomical prayer schedules, user settings, and active alarm state locally (and in Android `deviceProtectedStorage` for `LOCKED_BOOT_COMPLETED`).
- **Platform Channels:**
  - Android: `USE_EXACT_ALARM` + `setAlarmClock()`, `FullScreenIntent` (`canUseFullScreenIntent()`), `ForegroundService` (`mediaPlayback`), `LOCKED_BOOT_COMPLETED`, `AudioManager.STREAM_ALARM` volume enforcement + `onKeyDown`, `startLockTask()`.
  - iOS 26+: Swift channel for `AlarmKit` (`Relentless AlarmKit Cascade` + `LiveActivityIntent`).

## Rules Reference

Copied project-local copies of all active rules live in:
- [`.claude/rules/common/`](.claude/rules/common/) — coding-style, security, testing, patterns, performance, git-workflow, code-review, development-workflow, agents, hooks
- [`.claude/rules/dart/`](.claude/rules/dart/) — coding-style, patterns, security, testing, hooks
- Machine-wide Flutter guide: `~/.gemini/FLUTTER.md`

## Recommended & Installed Skills

Project-local skills installed under `.claude/skills/` and `.agents/skills/`:
- **Flutter & Dart Official (21 skills):** `flutter-apply-architecture-best-practices`, `flutter-setup-localization`, `flutter-setup-declarative-routing`, `flutter-build-responsive-layout`, `flutter-fix-layout-issues`, `flutter-implement-json-serialization`, `flutter-use-http-package`, `flutter-add-widget-test`, `flutter-add-integration-test`, `flutter-add-widget-preview`, `dart-run-static-analysis`, `dart-add-unit-test`, `dart-collect-coverage`, `dart-generate-test-mocks`, `dart-resolve-package-conflicts`, `dart-fix-runtime-errors`, `dart-use-pattern-matching`, `dart-migrate-to-checks-package`, `dart-use-ffigen`, `dart-setup-ffi-assets`, `dart-build-cli-app`.
- **Architecture, Patterns & Review:** `dart-flutter-patterns`, `flutter-expert`, `flutter-adaptive-ui`, `flutter-dart-code-review`, `flutter-networking`, `flutter-testing`, `code-reviewer`, `clean-code-guard`, `test-guard`, `owasp-security`, `test-driven-development`, `fajr-app-pr-guard`.
- **UI/UX & Design:** `ui-ux-pro-max`, `liquid-glass-design`, `mobile-ui-enhancement`, `design-md`.
- **Workflow, Spec & Memory:** `save-session`, `sessions`, `rebuild-digest`, `speckit-*` (`constitution`, `specify`, `clarify`, `plan`, `tasks`, `taskstoissues`, `implement`, `analyze`, `checklist`), `brainstorming`, `prompt-master`, `pr-creator`.

## Session Memory System

4-layer memory across Claude Code, Antigravity, Codex, and OpenCode:
1. This file (`CLAUDE.md`) — stable architectural context.
2. `.claude/sessions/INDEX.md` — injected at session start (keep entries `<= 190` chars; `<= 30` rows).
3. `.claude/sessions/DIGEST.md` — keyword-searchable index rebuilt via `python3 .claude/scripts/rebuild_digest.py`.
4. `.claude/sessions/YYYY-MM-DD_*.md` — detailed session logs, read on demand.

- **Commands / Skills:** `/save-session` at session end (or mid-session checkpoint), `/sessions <question>` to recall history via `session-rag`, `/rebuild-digest` to rebuild `DIGEST.md`.
- **Session RAG:** Spawn `.claude/agents/session-rag.md` instead of bulk-reading session files in the main context window.
- **Shared Team Memory (`.claude/memory.md`):** Reflect durable, non-secret decisions and operational facts in `.claude/memory.md` and commit with related changes.

## Search Discipline — Anti Context-Burn

Walk the ladder in order; stop at the first rung that answers it:
1. `docs/TOPIC_INDEX.md` (when present) — conceptual map
2. `docs/SYMBOLS.json` (when present) — `jq '.SymbolName' docs/SYMBOLS.json`
3. **LSP / Dart Analyzer** — `findReferences` / `goToDefinition`
4. `graphify affected` / `graphify query` (if `graphify-out/` exists; never `Read` `graphify-out/graph.json`)
5. `rg` / `grep` — targeted fallback only

## CRITICAL RULES

1. **No Secrets on GitHub:** Never commit API keys, keystores, or `.env` files; never read `.env*` into context.
2. **Privacy & Consent:** Gemini free tier may use inputs for training; onboarding must capture explicit consent and captured photos must stay in RAM and be purged immediately (`< 500ms`).
3. **No Hardcoded UI Strings:** All copy via `.arb` (`ar`/`en`); Arabic responses always formatted RTL (`<div dir="rtl">`).
4. **Never Push Directly to `main`:** Enforced by `.claude/hooks/block-push-to-main.sh`.
5. **Proof-of-Execution:** Real `[STDOUT]` required before `[STATUS]: done` (enforced by `.claude/hooks/proof-of-execution.sh`).

