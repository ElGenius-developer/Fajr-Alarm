---
description: Retrieve historical context from past Fajr-Alarm sessions via the session-rag agent.
argument-hint: <question about previous work>
---

Spawn the **session-rag** agent to answer a question about previous work sessions, then relay its compressed answer.

The question is: **$ARGUMENTS**

## What to do

1. If `$ARGUMENTS` is empty, ask the user what they want to recall — do not spawn the agent with an empty question.
2. Otherwise, spawn the read-only retrieval agent using the Agent tool:

   ```
   Agent({
     description: "Session history lookup",
     subagent_type: "session-rag",
     prompt: "Question: $ARGUMENTS"
   })
   ```

   Use `subagent_type: "session-rag"`, not `general-purpose`: the agent's frontmatter limits it to Read/Grep/Bash on Sonnet at low effort. A `general-purpose` subagent pays ~85k tokens of startup before searching anything (measured 91.9k vs 53.4k for the same question). Do not move it to Haiku: Haiku resolved `.claude/sessions/` as `~/.claude/sessions/` even with an explicit rule against it.

3. The agent greps `DIGEST.md` / `INDEX.md` / `INDEX-archive.md` for the question's terms, reads only the matching blocks and 2-4 session files, and returns a compressed (≤400 token) answer with `(source: YYYY-MM-DD_slug.md)` citations.

4. Relay the agent's answer to the user verbatim. Add a one-line follow-up only if directly relevant.

## Rules

- The session-rag agent is **read-only** — it must not write, edit, or run git.
- Do not read session files yourself in the main thread; delegate to the agent to keep context clean.
- If the agent reports "No prior session history found for this topic.", relay that honestly.
