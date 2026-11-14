---
name: fajr-alarm-context
description: Query the fajr_alarm knowledge graph (graphify-out/) to understand the codebase before writing code. Use PROACTIVELY for "how does X work?", "where is Y defined?", "what calls Z?", "how does A relate to B?", and BEFORE writing any new feature to find reusable code. Returns a scoped subgraph instead of grepping thousands of files.
---

# fajr_alarm Project Context

A queryable knowledge graph of the repo lives at `graphify-out/`. **For live node/edge/community
counts and the commit the graph was built from, read the header of
`graphify-out/GRAPH_REPORT.md`** — it is the only accurate source and it moves with every
`graphify update .`. Do not restate those numbers anywhere else; they rot.

## Decision ladder

Walk in order; stop at the first rung that answers the question.

| # | Tool | Answers | Cost |
|---|---|---|---|
| 1 | **`docs/TOPIC_INDEX.md`** | "Show me concept Y" · "How does X load its data?" (*Request / Data Flows*) | one `Read` |
| 2 | **`docs/SYMBOLS.json`** | "Where is X defined?" (exact name known) | `jq '.X' docs/SYMBOLS.json` |
| 3 | **LSP** (dart language-server) | "What calls X?" · "What is X?" | `findReferences` / `goToDefinition` |
| 4 | **`graphify affected`** | "If I change X, what breaks?" (blast radius) | one CLI call |
| 5 | **`graphify explain` / `path`** | "What is this node?" · "How is A connected to B?" | one CLI call |
| 6 | **`graphify query`** | Structural exploration only — read the warning under *The commands* first | one CLI call, default budget |
| 7 | **`grep -rn`** | Last resort — text patterns nothing above can express | shell call |

**Rung 3 is not optional for "what calls X?".** The LSP resolves the language's own symbol table,
so `findReferences` catches **inherited, interface, trait/mixin, and re-exported** usages that a
purely structural graph does not model and that `grep` cannot express — `grep` matches text, so it
finds the declaration line but never the inherited callsites, and it misses aliased or namespaced
references. **Do not answer "what calls X?" with `grep`.**

> **Two ways rung 3 under-reports — both look like a valid answer:**
>
> 1. **Cold index.** The first `findReferences` after a session starts can return a near-empty
>    result while the language server is still indexing. **If a count looks implausibly low, run
>    it once more before believing it** — a cold-index answer is worse than grep, because it looks
>    correct.
> 2. **Dynamic dispatch the server cannot resolve** (facades, magic methods, reflection, runtime
>    DI via `get_it`). If the editor reports "undefined type" on a symbol the code plainly uses, the server
>    cannot see it — **confirm those with `grep`.**

**Hard rule:** 3 search calls with no answer → stop and re-read `docs/TOPIC_INDEX.md`.

## The commands

All operate on `graphify-out/graph.json` **in the current working directory** — `cd` to the repo
root first, or graphify errors out looking for `<cwd>/graphify-out/graph.json`.

- `graphify query "<question>"` — BFS subgraph with source citations. `--dfs` to trace one chain, `--budget N` to cap output. **Not the default** — see below.
- `graphify path "<NodeA>" "<NodeB>"` — shortest path between two named entities.
- `graphify explain "<Node>"` — single-node profile and neighbors.
- `graphify affected "<Node>" --depth N` — reverse traversal: **who breaks if I change this?** `--depth` defaults to `2`; `--relation R` is repeatable to narrow which edge kinds are walked.
- `graphify diagnose multigraph` — graph health; reports whether distinct edges are collapsing onto the same endpoint pair (which silently degrades `query` and `affected`). `same_endpoint_collapsed_edges: 0` means a weak answer is a labelling problem, not a collapse problem.

> **`query` is structural, not conceptual.** It anchors on literal name tokens from your question.
> If the graph is AST-only, every document is a file node whose content was never read, so a
> conceptual question anchors on generic labels and returns a flat dump of neighbours. Check which
> you have from the header of `graphify-out/GRAPH_REPORT.md` (not from `cost.json`): AST-only — route conceptual questions to rung 1.
>
> Even with a semantic layer, `query` reaches it only when the question names a **domain concept**
> (prayer schedule, challenge verification, alarm cascade). A question that names a **file, screen or symbol** anchors on
> code nodes and gets the same flat dump — that is rung 1, 2 or 3. Do not raise `--budget` to
> compensate for a thin answer: a conceptual miss returns more neighbours, not a better answer.
> "How does screen X load its data?" → the *Request / Data Flows* section of the topic index.

> **`affected` blind spot:** the extractor may record a node's outbound edges without the inbound
> `use`/instantiation edges (spot-check in this repo: `graphify affected "AlarmKitManager"` returned
> `No affected nodes found.` for `AlarmKitManager.swift`, and `AlarmRingingBloc` returned
> `No unique node match`). **Treat an empty `affected` as *no data*, never as *no callers*** —
> confirm with LSP `findReferences` or `flutter_dart-mcp-server`.

## Cheatsheets
- [references/god-nodes.md](references/god-nodes.md) — most-connected nodes (core abstractions).
- [references/domains.md](references/domains.md) — subsystems with sample queries.
- [references/recipes.md](references/recipes.md) — copy-paste query templates per task.

## Keep fresh
After meaningful changes: `graphify update .` (wired to git post-commit/post-checkout via
`graphify hook install`; `.git/hooks/` is not committed, so re-run it per clone).
`.claude/scripts/graph-staleness.sh` reports drift at SessionStart — files it lists *might* be newer
than the graph, so answer questions about them with LSP or grep, not graphify.

> **The staleness list over-reports.** When a commit changes no graph *topology*, the post-commit
> hook leaves the outputs untouched and **does not restamp the build commit** in the report header.
> The recorded commit drifts behind `HEAD` while the graph stays current, and every file touched
> since that stamp gets listed. A long list is normal; treat it as "might be newer", not as drift.

> 🔴 **`.graphifyignore` REPLACES `.gitignore`, it does not extend it.** graphify falls back to
> `.gitignore` only when `.graphifyignore` is absent, and its built-in skip list does not cover
> `vendor/`. Read the header of `.graphifyignore` before editing it, and compare the detected
> code-file count before and after.

**Never `Read` `graphify-out/graph.json`** — it can be tens of MB and will blow the context
window. Query it through the CLI. It is `deny`-listed in `.claude/settings.json`.
