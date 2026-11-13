# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase. This repo is **single-context**: a Flutter/Dart mobile app (`lib/`) with native Android/iOS platform channels.

## Before exploring, read these

- **`GLOSSARY.md`** at the repo root, when it exists: canonical domain vocabulary (alarm states, verification modes, challenge flow, override semantics).
- **`docs/adr/`** at the repo root: architectural decision records.
- **`SRS-Fajr-alarm.md`** at the repo root and the Wayfinder map (`#1` on GitHub) while the spec is being finalized.

If `GLOSSARY.md` or `docs/adr/` doesn't exist yet, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The `/domain-modeling` skill creates them lazily when terms or decisions actually get resolved.

## File structure

```text
/
├── GLOSSARY.md       ← canonical domain vocabulary
└── docs/
    └── adr/          ← architectural decisions
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a spec, a test name, or Dart code), use the term as defined in `GLOSSARY.md`. Don't drift to synonyms the glossary explicitly avoids.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts docs/adr/0001 (...), but worth reopening because…_

