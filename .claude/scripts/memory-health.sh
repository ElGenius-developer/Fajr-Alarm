#!/usr/bin/env bash
# Silent when healthy; prints at most a few `memory-health:` lines. Never fails the session.
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
S=.claude/sessions

if [ -f "$S/INDEX.md" ]; then
  n=$(grep -c '^- 20' "$S/INDEX.md")
  [ "$n" -gt 30 ] && echo "memory-health: INDEX.md has $n entries (limit 30) — move the oldest to INDEX-archive.md"
fi

mem="$HOME/.claude/projects/$(pwd | sed 's#[/.]#-#g')/memory/MEMORY.md"
if [ -f "$mem" ]; then
  n=$(wc -l < "$mem" | tr -d ' ')
  if [ "$n" -ge 180 ]; then
    echo "memory-health: MEMORY.md is $n lines — lines after 200 are truncated; consolidate entries into hub files now"
  elif [ "$n" -ge 150 ]; then
    echo "memory-health: MEMORY.md is $n lines (truncates at 200) — consolidate soon"
  fi
fi

if [ -f "$S/DIGEST.md" ]; then
  empty=$(grep -c '^keywords: *$' "$S/DIGEST.md")
  entries=$(grep -c '^## ' "$S/DIGEST.md")
  files=$(ls "$S" | grep -cE '^[0-9]{4}-[0-9]{2}-[0-9]{2}_.+\.md$')
  if [ "$empty" -gt 0 ] || [ "$entries" -ne "$files" ]; then
    echo "memory-health: DIGEST.md stale ($entries entries / $files sessions, $empty without keywords) — run python3 .claude/scripts/rebuild_digest.py"
  fi
fi

[ -n "$(find graphify-out/GRAPH_REPORT.md -mtime +14 2>/dev/null)" ] && echo "memory-health: knowledge graph is over 14 days old — run graphify update ."
exit 0
