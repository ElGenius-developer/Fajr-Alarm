Rebuild the session digest index from all existing session files.

This command reads every session file in `.claude/sessions/` and generates a searchable
`DIGEST.md` index for the session-rag agent.

## When to use

- First time setup (no DIGEST.md exists yet)
- Recovery (DIGEST.md was deleted or corrupted)
- Periodic refresh to ensure completeness

## Process

Run `python3 .claude/scripts/rebuild_digest.py`. The script:

1. Globs all `.md` files in `.claude/sessions/`, excluding `INDEX.md`,
   `INDEX-archive.md`, `DIGEST.md`.
2. Sorts by `YYYY-MM-DD` filename prefix, newest first.
3. For each session file extracts: keywords (8-15 technical terms), decisions,
   files touched (basenames), and a `complete` / `in-progress` status.
4. Writes `.claude/sessions/DIGEST.md`.

If `python3` is unavailable, perform the same extraction manually and write DIGEST.md
in the format below.

## DIGEST.md format

```
# Session Digest

<!-- Auto-generated search index for session-rag agent. -->
<!-- Do not edit manually. Rebuilt via /rebuild-digest. -->
<!-- Updated automatically by /save-session (Step 2.5). -->

## YYYY-MM-DD | filename-slug
keywords: term1, term2, term3, ...
decisions: decision1 | decision2 | ...
files: file1, file2, ...
status: complete
---
```

## Rules

- Never modify or delete session files — read only.
- Never include secrets, credentials, or sensitive data in the digest.
