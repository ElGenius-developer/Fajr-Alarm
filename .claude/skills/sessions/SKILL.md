---
name: sessions
description: Retrieve historical context from past Fajr-Alarm sessions via the session-rag agent. Use when recalling prior decisions, bugs, or session history.
---

Spawn the **session-rag** agent to answer a question about previous work sessions, then relay its compressed answer.

## What to do

1. If no question was provided, ask the user what they want to recall — do not spawn the agent with an empty question.
2. Otherwise, spawn the read-only retrieval agent (`session-rag` defined in `.claude/agents/session-rag.md`) to search `.claude/sessions/DIGEST.md`, `.claude/sessions/INDEX.md`, and `.claude/sessions/INDEX-archive.md`.
3. The agent greps `DIGEST.md` / `INDEX.md` / `INDEX-archive.md` for the question's terms, reads only the matching blocks and 2-4 session files, and returns a compressed (≤400 token) answer with `(source: YYYY-MM-DD_slug.md)` citations.
4. Relay the agent's answer to the user verbatim. Add a one-line follow-up only if directly relevant.

## Rules

- The session-rag agent is **read-only** — it must not write, edit, or run git.
- Do not read session files yourself in the main thread; delegate to the agent to keep context clean.
- If the agent reports "No prior session history found for this topic.", relay that honestly.

