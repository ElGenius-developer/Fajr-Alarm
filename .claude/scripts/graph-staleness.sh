#!/usr/bin/env bash
# Reports whether the graphify knowledge graph is behind HEAD.
# Advisory only: always exits 0 so it can never block SessionStart.
# No `set -e` — every failure path below must still fall through to exit 0.

# `set -f` disables pathname expansion so the globs below stay literal strings for git to
# match, even if onboarding substituted them unquoted. Must precede the assignment.
set -f

# Source-file globs for this repo, filled at onboarding from the detected stack.
# Fallback covers common languages when no substitution was made.
CODE_GLOBS=('*.dart')
# An unsubstituted placeholder survives as a literal element, so test for it explicitly
# rather than for an empty array.
case "${CODE_GLOBS[0]:-}" in
  ''|*'{{'*) CODE_GLOBS=('*.php' '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.go' '*.rs' '*.dart' '*.rb' '*.java' '*.kt' '*.cs' '*.swift') ;;
esac

MAX_FILES=20

ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$ROOT" ]; then
  echo "graph-staleness: not a git repo — skipped."
  exit 0
fi
cd "$ROOT" || exit 0

REPORT="${1:-graphify-out/GRAPH_REPORT.md}"
if [ ! -f "$REPORT" ]; then
  echo "graph-staleness: $REPORT not found — run 'graphify update .' before trusting graphify."
  exit 0
fi

# `head` first: GRAPH_REPORT.md can be hundreds of KB and its community dumps contain
# literal 'git commit -am ...' strings that an unanchored grep would match instead.
GRAPH_REF=$(head -40 "$REPORT" | grep -m1 '^- Built from commit:' | awk -F'`' '{print $2}')
if [ -z "$GRAPH_REF" ]; then
  echo "graph-staleness: no 'Built from commit:' line in $REPORT — cannot tell if the graph is stale."
  exit 0
fi

HEAD_SHA=$(git rev-parse HEAD 2>/dev/null)
[ -n "$HEAD_SHA" ] || exit 0

# The report stores an abbreviated hash; resolve both sides to full SHAs before comparing.
GRAPH_SHA=$(git rev-parse --verify --quiet "${GRAPH_REF}^{commit}")
if [ -z "$GRAPH_SHA" ]; then
  echo "graph-staleness: graph commit ${GRAPH_REF} is unreachable (rebased or pruned) — treat graphify answers as STALE."
  exit 0
fi

if [ "$GRAPH_SHA" = "$HEAD_SHA" ]; then
  echo "Graph is current."
  exit 0
fi

echo "graph-staleness: STALE — graph=${GRAPH_REF}  HEAD=$(git rev-parse --short=8 "$HEAD_SHA")"

CHANGED=$(git diff --name-only "${GRAPH_SHA}..${HEAD_SHA}" -- "${CODE_GLOBS[@]}" 2>/dev/null)
if [ -z "$CHANGED" ]; then
  echo "No source files changed since the graph was built."
  exit 0
fi

COUNT=$(printf '%s\n' "$CHANGED" | wc -l | tr -d ' ')
printf '%s\n' "$CHANGED" | head -n "$MAX_FILES"
if [ "$COUNT" -gt "$MAX_FILES" ]; then
  echo "... and $((COUNT - MAX_FILES)) more (${COUNT} total)"
fi
echo "These files are newer than the graph — use LSP/grep for them, not graphify."
exit 0
