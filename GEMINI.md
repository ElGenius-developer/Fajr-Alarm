# Agent Rules — Fajr-Alarm (Gemini / Antigravity / agy)

Applies to Gemini CLI, Antigravity IDE, and `agy`. Mirrors [`CLAUDE.md`](./CLAUDE.md) and [`AGENTS.md`](./AGENTS.md) while staying concise to avoid silent truncation. On conflict: [`.claude/CONSTITUTION.md`](./.claude/CONSTITUTION.md) > `CLAUDE.md` > this file.

## 0. First Action
1. Read [`CLAUDE.md`](./CLAUDE.md) and [`.claude/CONSTITUTION.md`](./.claude/CONSTITUTION.md).
2. Read `~/.gemini/FLUTTER.md`, `.claude/rules/common/*.md`, and `.claude/rules/dart/*.md`.
3. Check `.claude/sessions/INDEX.md` and `.claude/memory.md` for prior context.
4. For any non-trivial task, present a short plan and wait for approval before editing files, and maintain a visible Todo checklist.

## 1. Critical Rules
- **Architecture:** Feature-Based Clean Architecture (`lib/core/` + `lib/features/<feature>/{domain,data,presentation}`) with `flutter_bloc`, `get_it`, `freezed`, `fpdart`, and local caching (`hive_ce`/`drift` + Android `deviceProtectedStorage`). Pure Dart `domain/` only.
- **Platform Scope (`v1.0`):** Android 10+ (`minSdk 29`, `targetSdk 35`) and iOS 26+ (`AlarmKit` Relentless Cascade).
- **Zero Secrets:** Never commit secrets or read `.env*` files. BYOK Gemini key resides solely in `FlutterSecureStorage`.
- **Privacy:** Explicit onboarding consent for Gemini free tier; photos processed in RAM and purged (`< 500ms`).
- **Localization:** Zero hardcoded UI strings (`.arb` `ar`/`en` only, RTL-safe).
- **Arabic Output (MANDATORY):** Wrap all Arabic responses in `<div dir="rtl">`, keeping code blocks, terminal commands, and file paths in LTR.
- **Testing & Static Checks:** TDD, **80%+ coverage**, `dart format --set-exit-if-changed .`, `dart analyze --fatal-infos`, `flutter test --coverage`.
- **Git:** Never push directly to `main`; use branches and PRs.

## 2. Proof-of-Execution & Session Memory
- Include `[DEFINITION OF DONE]`, real `[STDOUT]`, and `[STATUS]: done` on completion.
- Save sessions using `.agents/skills/save-session/SKILL.md` (`/save-session`) into `.claude/sessions/`, rebuild `DIGEST.md` via `python3 .claude/scripts/rebuild_digest.py`, and update `.claude/sessions/INDEX.md`.

