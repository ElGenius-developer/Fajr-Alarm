#!/usr/bin/env bash
# PreToolUse(Bash): block any `git push` that would land on a protected branch.
# Changes reach those branches only through a reviewed PR. Exit 2 = block the tool call.
# Each `git push` segment is parsed on its own, so `git push origin feat; gh pr create --base main`
# is allowed — scanning the whole command line would wrongly read `--base main` as a push target.
PROTECTED="{{PROTECTED_BRANCHES}}"
case "$PROTECTED" in ''|*'{{'*) PROTECTED="main master" ;; esac

CURRENT="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"

PROTECTED="$PROTECTED" CURRENT="$CURRENT" python3 -c '
import json, os, re, shlex, sys
try:
    cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
except Exception:
    sys.exit(0)
protected = set(os.environ["PROTECTED"].split())
current = os.environ["CURRENT"]
for seg in re.split(r"&&|\|\||[;|\n]", cmd):
    try:
        words = shlex.split(seg)
    except ValueError:
        words = seg.split()
    i = 0
    while i < len(words) and re.match(r"[A-Za-z_][A-Za-z0-9_]*=", words[i]):
        i += 1
    if i >= len(words) or words[i] != "git":
        continue
    i += 1
    while i < len(words) and words[i].startswith("-"):
        i += 2 if words[i] in ("-C", "-c") else 1
    if i >= len(words) or words[i] != "push":
        continue
    args = [w for w in words[i + 1:] if not w.startswith("-") and not re.match(r"\d*>", w)]
    refspecs = args[1:]
    targets = [r.lstrip("+").split(":")[-1] for r in refspecs] or [current]
    targets = [current if t == "HEAD" else t.removeprefix("refs/heads/") for t in targets]
    hit = sorted(protected.intersection(targets))
    if hit:
        print(f"[push-guard] BLOCKED: pushing to {hit[0]!r} is not allowed; protected branches reach it only via a reviewed PR.", file=sys.stderr)
        print("[push-guard] Push a feature branch instead: git push -u origin <branch>, then gh pr create.", file=sys.stderr)
        sys.exit(2)
'
