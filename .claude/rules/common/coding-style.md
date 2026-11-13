# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) → changes original in-place
CORRECT: update(original, field, value) → returns new copy with change
```

Rationale: Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

## Comments — Write Sparingly

WRITE CODE THAT EXPLAINS ITSELF; COMMENT ONLY WHEN THE CODE CANNOT.

Default to NO comment. Add one only when a reader who understands the language still cannot tell *why* the code does what it does — and the comment carries information the code itself cannot.

WRITE a comment when:
- The *why* is non-obvious: a business rule, a workaround, an edge case, a deliberate deviation, or a "looks wrong but is correct" choice.
- A subtle gotcha would bite the next reader (ordering dependency, off-by-one boundary, race condition, magic value mandated by an external system).
- A public API/function needs a contract (params, return, throws) — use the language's doc-comment convention (PHPDoc, JSDoc/TSDoc, docstring).
- A `TODO`/`FIXME` records real, actionable follow-up.

DO NOT write a comment when:
- It restates the code (`// increment i`, `// loop over users`, `// set name to name`).
- It narrates the obvious or labels sections a reader can already see.
- A clearer name (variable, function, constant) would remove the need for it — rename instead of annotating.
- It is commented-out dead code — delete it; git remembers.
- It would just decorate boilerplate, getters/setters, or framework-standard structure.

The test: if deleting the comment loses no information a competent reader needs, delete it. Comments are a cost (they drift, they lie when code changes) — earn each one.

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side
- Never silently swallow errors

## Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values (use constants or config)
- [ ] No mutation (immutable patterns used)
