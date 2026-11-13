---
description: Cross-agent rules loader for Fajr-Alarm
alwaysApply: true
---

# AI Agent Guidelines — Fajr-Alarm

Applies to Codex, OpenCode, Cursor, Antigravity, and any CLI agent. Keep this loader short; full details live in [`CLAUDE.md`](./CLAUDE.md) and [`.claude/CONSTITUTION.md`](./.claude/CONSTITUTION.md). On conflict: Constitution > `CLAUDE.md` > this file.

## 0. First Action
1. Read [`CLAUDE.md`](./CLAUDE.md) and [`.claude/CONSTITUTION.md`](./.claude/CONSTITUTION.md).
2. Read `.claude/rules/common/*.md`, `.claude/rules/dart/*.md`, and `~/.gemini/FLUTTER.md`.
3. Check `.claude/sessions/INDEX.md` (and `.claude/memory.md`) for prior decisions.
4. For multi-step tasks, render a visible Todo checklist and work item-by-item.

## 1. Critical Rules
- **Clean Architecture:** Feature-based (`lib/features/<feature>/{domain,data,presentation}`) + `lib/core/`. Pure Dart `domain/` only; `flutter_bloc`, `get_it`, `freezed`, `fpdart` (`Either`). Cache locally (`hive_ce`/`drift` + Android `deviceProtectedStorage`) where needed.
- **Platform Scope (`v1.0`):** Android 10+ (`minSdk 29`, `targetSdk 35`) + iOS 26+ (`AlarmKit` Cascade). `iOS 15–25` is deferred past `v1.0`.
- **Zero Secrets:** Open-source repo. Never commit or log secrets or `.env*` files. BYOK Gemini key stays in `FlutterSecureStorage`.
- **Privacy:** Require explicit onboarding consent for Gemini free tier; keep captured photos in RAM only and delete immediately (`< 500ms`).
- **Localization:** Zero hardcoded user-visible strings; all UI copy via `.arb` (`ar` + `en`) and RTL-safe.
- **Arabic Responses:** Always wrap Arabic output in `<div dir="rtl">`, keeping code blocks/commands/paths in standard LTR blocks.
- **Testing & Quality:** TDD, **80%+ coverage**, `dart analyze --fatal-infos`, `dart format --set-exit-if-changed .`.
- **Git:** Never push directly to `main`. Branch + PR only.

## 2. Proof-of-Execution
Before coding state `[DEFINITION OF DONE]`; after coding include real `[STDOUT]` and end with `[STATUS]: done` (or `implemented-pending-verification`). Fabricated stdout is a CRITICAL violation.

## 3. Shared Session Memory
Use `/save-session` (`.claude/skills/save-session/SKILL.md` / `.agents/skills/save-session/SKILL.md`) to save sessions to `.claude/sessions/`, rebuild `DIGEST.md` with `python3 .claude/scripts/rebuild_digest.py`, and update `.claude/sessions/INDEX.md`. Use `/sessions <question>` (via `.claude/agents/session-rag.md`) to recall past sessions.

