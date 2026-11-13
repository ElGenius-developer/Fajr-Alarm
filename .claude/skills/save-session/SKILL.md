---
name: save-session
description: Save the current session as a structured markdown file in .claude/sessions/, update DIGEST.md via rebuild_digest.py, and update INDEX.md. Use at session end or whenever the user runs /save-session.
---

Save the current session as a structured markdown file in `.claude/sessions/`,
then update the index.

## Step 1: Determine the filename

Format: `YYYY-MM-DD_<short-topic-slug>.md`

- Use today's date.
- Slug = 2-5 kebab-case words describing the session topic.
- If a file with the same name already exists, append `-2`, `-3`, etc.

## Step 2: Write the session file

The file MUST contain these sections, in this order. Do NOT add other top-level sections.

### Topic
One-line summary of what this session was about.

### Context
Which part of the project this touched (module, feature, bug, area). Include relevant file paths.

### What WORKED (with evidence)
Only confirmed-working items. For each: WHY you know it works (test passed, query returned
expected rows, build ran clean, etc.). Without evidence, move it to "Open Questions" instead.
- **<thing that works>** — confirmed by: <specific evidence>

### Problems & Solutions
Every notable problem encountered this session, the attempts made to solve it, and whether
each attempt worked. Failed attempts are AS IMPORTANT as successful ones — they save future
sessions from repeating dead ends. Be specific: include error messages, commands, root causes.

For each problem:
- **Problem:** <one-line description of the symptom + where it appeared (file/endpoint/query)>
  - **Root cause:** <what actually caused it, once known — or "unknown" if still unresolved>
  - **Attempts:**
    - <attempt 1: what was tried> — **outcome:** worked / failed because <specific reason>
    - <attempt 2: what was tried> — **outcome:** worked / failed because <specific reason>
  - **Final solution:** <what ultimately fixed it, with file:line or command — or "unresolved, see Open Questions">

If none: "No notable troubleshooting this session."

### Decisions Made
Architectural or design decisions that should NOT be relitigated next session.
- **<decision>** — reason: <why this over alternatives>

If none: "No major decisions this session."

### Files Touched
Bulleted list of files created, modified, or deleted with one-line purpose each.

### Open Questions / Blockers
Anything unresolved, external dependencies, things to investigate next.

If none: "No active blockers."

### Exact Next Step
The single most important thing to do when resuming. Be precise enough that resuming
requires zero thinking about where to start.

## Step 2.5: Update DIGEST.md

After writing the session file, regenerate `.claude/sessions/DIGEST.md` by running:

```bash
python3 .claude/scripts/rebuild_digest.py
```

## Step 3: Update `.claude/sessions/INDEX.md`

1. If `INDEX.md` does NOT exist, create it with this header:
```
# Fajr-Alarm Session History

<!-- Newest entries on top. Format: - YYYY-MM-DD: <topic> → <filename> -->
```

2. Insert a new line at the TOP of the entry list (newest first):
   `- YYYY-MM-DD: <one-line topic> → <filename>`

   **Hard cap: the whole line MUST be ≤ 190 characters.** INDEX.md is injected verbatim
   into every session's context by the SessionStart hook, so a paragraph-length entry is
   paid for on every future session. The index points; the session file explains.

3. If INDEX.md has more than 30 entries, move the oldest entries to
   `.claude/sessions/INDEX-archive.md` (creating it with a `# Archived Sessions` header).
   Keep INDEX.md ≤ 30 entries.

## Step 4: Confirm

After saving, output to the user: the full path of the session file, the new INDEX.md
entry line, and ask: "Session saved. Anything to correct or add?" Wait for confirmation;
apply any requested edits and re-confirm.

## Rules

- If invoked mid-session, save what's known so far and mark in-progress items in "Open Questions".
- Never include secrets, credentials, API keys, connection strings, or sensitive data.
- Never include full file contents — only paths and one-line purposes.
- Keep "What WORKED" honest. Unverified claims go to "Open Questions".
- Keep "Problems & Solutions" honest about failed attempts. Do NOT omit or sanitize failed approaches — recording dead ends is the primary value of this section. If you tried 3 things and only 1 worked, list all 3.

