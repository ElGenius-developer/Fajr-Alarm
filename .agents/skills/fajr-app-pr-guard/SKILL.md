---
name: fajr-app-pr-guard
description: Fajr-Alarm (Flutter) project layer over the generic pr-guard skill - reviews a GitHub PR through security/code/clean-code/test lenses PLUS the Fajr-Alarm Constitution gates (Pure-Dart domain isolation, Feature-Based Clean Architecture, zero secrets / BYOK FlutterSecureStorage, ephemeral RAM-only photos, arb/RTL i18n, 80%+ test coverage, dart analyze --fatal-infos, dart format), verifies with real flutter analyze/test runs, then squash-merges only after Ahmed's explicit approval.
---

# Fajr-Alarm PR Guard — Flutter layer over `pr-guard`

**Follow the generic `pr-guard` workflow** (invoke the `pr-guard` skill if its body is not already loaded). This file only adds the `Fajr-Alarm` project deltas. Do not re-derive phase logic here.

Repo: `ElGenius-developer/Fajr-Alarm` · base branch `main` · Flutter/Dart + Android/iOS native channels.

## Phase 0 delta — no PR, no review

If no PR exists for the current branch, **stop and say so**. Never push directly to `main`; open a feature branch and PR first.

## Lens implementations (Phase 1)

| Lens | Implementation |
|---|---|
| Security & Secrets | `owasp-security` / `security-review` skill + `security-reviewer` subagent when the diff touches BYOK key storage, Gemini REST calls, camera/image buffers, `AndroidManifest.xml`, `Info.plist`, or platform channels |
| Code review | `flutter-dart-code-review` skill / `flutter-reviewer` subagent (Flutter/Dart idioms, Clean Architecture boundaries, BLoC/Cubit lifecycle, native channels) |
| Clean code | `clean-code-guard` skill |
| Test quality | `test-guard` skill when the diff contains files under `test/` or `integration_test/` |
| Secret scan | Generic pr-guard secret patterns + Dart/Gradle/Plist patterns in [references/constitution-gates.md](references/constitution-gates.md) §Secrets |

## Project gates (Phase 2)

Run every gate in [references/constitution-gates.md](references/constitution-gates.md) against the diff. Severities feed the standard merge policy (CRITICAL/HIGH block). Authority on any conflict: `.claude/CONSTITUTION.md`.

## Verification commands (Phase 3)

Run from the repo root. Paste real output into the report.

```bash
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
flutter test --coverage
```

## Report + merge (Phases 4–5)

- Report path: `.claude/PRPs/reviews/pr-<N>-review.md` — create the directory if missing.
- Merge style: **squash** via `gh pr merge <N> --squash`, only after Ahmed's explicit approval in-session. Direct push to `main` is a CRITICAL violation.
- Close with the Proof-of-Execution block enforced by `.claude/hooks/proof-of-execution.sh`: real `[STDOUT]` and `[STATUS]: done`.
