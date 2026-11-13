Review and optionally squash-merge GitHub PR #$ARGUMENTS for Fajr-Alarm using the `fajr-app-pr-guard` skill (`.claude/skills/fajr-app-pr-guard/SKILL.md`).

If `$ARGUMENTS` is empty, detect the PR for the current branch (`gh pr view --json number -q .number`) or stop and report if no PR exists yet.
