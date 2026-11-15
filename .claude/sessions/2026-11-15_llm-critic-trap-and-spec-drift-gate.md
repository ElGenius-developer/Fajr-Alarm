### Topic
Analyzed why the AI-agent setup avoids the "LLM critic trap" (endless contradictory refactor/review loops). Fixed the one live gap found: tilt-range drift between code and SRS/memory. Added a Spec Drift review gate. Reviewed and merged PR #15 (`a5fb694`).

### Context
Agent governance and docs, no app code changed.
- Analysis covered: `CLAUDE.md`, `AGENTS.md`, `.claude/CONSTITUTION.md`, `.claude/settings.json` hooks, `.claude/hooks/*.sh`, `fajr-app-pr-guard` + generic `~/.claude/skills/pr-guard`, `clean-code-guard`, `GLOSSARY.md`, `.claude/memory.md`, `docs/SRS-Fajr-alarm.md`, `docs/agents/domain.md`.
- Fix touched: SRS FR-3.2 / FR-4.2, `.claude/memory.md` §Threat Model, `constitution-gates.md` (both `.claude/` and `.agents/` copies).

### What WORKED (with evidence)
- **Tilt range in SRS/memory now matches code (`-15°`..`25°`)** — confirmed by: `tilt_angle_reading.dart` `minValidPitchDegrees = -15.0` / `maxValidPitchDegrees = 25.0`; grep shows no remaining `-45°` requirement in SRS/memory (only "changed from" notes).
- **"Phone pointing down" wording still correct** — confirmed by: `tilt_sensor_datasource.dart:25` pitch = `-atan2(y, z)`, so 0° = phone flat face-up, back camera facing the floor.
- **PR #15 passes all project gates** — confirmed by: `dart format` (146 files, 0 changed), `dart analyze --fatal-infos` (`No issues found!`), `flutter test --no-pub` (`+250: All tests passed!`).
- **PR #15 merged clean** — confirmed by: `gh pr view 15` → `MERGED a5fb694990697e56afca51795943f22c81391909`; `git log -1 --format=%B | grep -ciE 'co-authored|claude'` → `0`.

### Problems & Solutions
- **Problem:** Shell output broke with `(eval):1: === not found` when separating file dumps with `echo ====`.
  - **Root cause:** zsh treats a word starting with `=` as `=cmd` path expansion.
  - **Attempts:**
    - `echo ====` — **outcome:** failed (zsh expansion error, exit 1).
    - `echo '-----'` (quoted, dashes) — **outcome:** worked.
  - **Final solution:** quote separators or use dashes in zsh.
- **Problem:** `grep -rn ... --include=*.dart` failed with `no matches found: --include=*.dart`.
  - **Root cause:** zsh `nomatch` globs the unquoted `*.dart`.
  - **Attempts:** Unquoted `--include=*.dart` — **outcome:** failed. Grepping the exact file paths instead — **outcome:** worked.
  - **Final solution:** quote the glob (`--include='*.dart'`) or target files directly.
- **Problem:** Auto mode refused a Bash call ("a hook changed this call's input after auto mode reviewed it").
  - **Root cause:** the RTK hook rewrites `cat` to `rtk read`, so the classifier's review no longer matched.
  - **Attempts:** Re-issued the exact rewritten command once, as instructed — **outcome:** worked.
  - **Final solution:** re-send the hook-produced input verbatim.
- **Problem:** PR #15 showed `mergeStateStatus: BLOCKED` even though `main` has no classic branch protection (`gh api .../branches/main/protection` → 404).
  - **Root cause:** a repository ruleset on `main` (`deletion`, `non_fast_forward`, `pull_request`) requires 1 approving review. The PR author cannot self-approve.
  - **Attempts:** Checked classic protection — **outcome:** 404, not the cause. Checked `gh api repos/.../rules/branches/main` — **outcome:** found `required_approving_review_count: 1`.
  - **Final solution:** `gh pr merge 15 --squash --admin --delete-branch` with explicit `--subject`/`--body`, after Ahmed approved `--admin` at the merge gate (same as PR #14).

### Decisions Made
- **Main anti-loop mechanisms are kept as they are:** (1) the architecture is fixed by the Constitution, so layer and interface debates stay closed; (2) a finding blocks only if it has a concrete failure scenario, and only CRITICAL/HIGH block; (3) the Sleepy-Self threat model and the SRS Out-of-Scope table bound security and feature scope. — reason: these are what prevent over-engineering vs YAGNI oscillation; weakening any reopens the loop.
- **Spec Drift gate added to `constitution-gates.md`:** changing a value that the SRS or `memory.md` documents without updating that doc in the same PR is HIGH. When existing code contradicts the SRS, the reviewer checks `DIGEST.md` first. A recorded decision means the doc is stale (MEDIUM, fix the doc). No recorded decision means ask Ahmed. The code is never reverted on the reviewer's own call. — reason: decisions made during device testing were landing only in session logs, so a reviewer reading the SRS would "fix" correct code back to a broken value.
- **No `docs/adr/` yet** — reason: `DIGEST.md` already carries decisions; create ADRs lazily when a real architectural decision needs one (per `docs/agents/domain.md`).

### Files Touched
- `docs/SRS-Fajr-alarm.md` — FR-3.2 and FR-4.2 tilt range set to `-15°`..`25°`, with the reason (merged in #15).
- `.claude/memory.md` — tilt range, reason, and source-of-truth constant (merged in #15).
- `.claude/skills/fajr-app-pr-guard/references/constitution-gates.md` — new Spec Drift section (merged in #15).
- `.agents/skills/fajr-app-pr-guard/references/constitution-gates.md` — same, kept identical (merged in #15).
- `.claude/PRPs/reviews/pr-15-review.md` — review report, APPROVE-WITH-COMMENTS (created, not committed yet).
- `.claude/sessions/2026-11-15_llm-critic-trap-and-spec-drift-gate.md` — this file.

### Open Questions / Blockers
- **Not committed yet:** `pr-15-review.md`, this session file, `DIGEST.md` and `INDEX.md`. A direct push to `main` is blocked by the hook, so they need a branch + PR.
- **LOW-1 follow-up:** the `.claude/` and `.agents/` copies of `fajr-app-pr-guard` are separate files, not symlinks, so they can drift. Consider symlinking `.agents/skills/fajr-app-pr-guard` → `.claude/skills/fajr-app-pr-guard`.
- **No CI** (`.github/` absent). The format/analyze/test and 80% coverage gates run only when an agent runs them locally.
- **`proof-of-execution.sh` checks format only.** It passes if `[STATUS]: done` is never written, and it cannot tell real stdout from made-up stdout.
- **Review history gets overwritten:** re-reviews reuse `pr-<N>-review.md`, so the baseline review is lost (seen with PR #11).

### Exact Next Step
Open a `chore/session-2026-11-15-pr15` branch. Commit `.claude/PRPs/reviews/pr-15-review.md`, this session file, `.claude/sessions/DIGEST.md` and `.claude/sessions/INDEX.md`. Open a PR to `main`.
