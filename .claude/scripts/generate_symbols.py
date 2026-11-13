#!/usr/bin/env python3
"""
Generate docs/SYMBOLS.json — a definition-only symbol index for rung 2 of the search ladder.

    { "SymbolName": [ { "file": "...", "line": N, "kind": "..." } ] }

Files come from `git ls-files --cached --others --exclude-standard`, so .gitignore
(build output, caches) is respected, plus a fixed dependency-dir guard for trees that
were committed by mistake.
`--others` matters: a fresh repo with nothing committed yet would otherwise index nothing.

Method bodies are skipped on purpose — the index stays small enough to `jq` cheaply.

Run from anywhere inside the repo:
    python3 .claude/scripts/generate_symbols.py
"""

import json
import re
import subprocess
import sys
from pathlib import Path

IDENT = r"([A-Za-z_][A-Za-z0-9_]*)"

PHP = [
    (re.compile(rf"^\s*(?:final\s+|abstract\s+|readonly\s+)*class\s+{IDENT}"), "class"),
    (re.compile(rf"^\s*trait\s+{IDENT}"), "trait"),
    (re.compile(rf"^\s*interface\s+{IDENT}"), "interface"),
    (re.compile(rf"^\s*enum\s+{IDENT}"), "enum"),
]

TS = [
    (re.compile(rf"^\s*export\s+(?:default\s+)?(?:async\s+)?function\s*\*?\s*{IDENT}"), "function"),
    (re.compile(rf"^\s*export\s+(?:default\s+)?(?:abstract\s+)?class\s+{IDENT}"), "class"),
    (re.compile(rf"^\s*export\s+(?:default\s+)?interface\s+{IDENT}"), "interface"),
    (re.compile(rf"^\s*export\s+(?:default\s+)?type\s+{IDENT}"), "type"),
    (re.compile(rf"^\s*export\s+(?:default\s+)?(?:const\s+)?enum\s+{IDENT}"), "enum"),
    (re.compile(rf"^\s*export\s+const\s+{IDENT}\s*[:=]"), "const"),
    (re.compile(r"^\s*export\s+default\s+([A-Z][A-Za-z0-9_]*)\s*[;\(]"), "default-export"),
]

PY = [
    (re.compile(rf"^class\s+{IDENT}"), "class"),
    (re.compile(rf"^(?:async\s+)?def\s+{IDENT}"), "function"),
]

GO = [
    (re.compile(rf"^type\s+{IDENT}\s+(?:struct|interface)"), "type"),
    (re.compile(rf"^func\s+(?:\([^)]*\)\s*)?{IDENT}"), "function"),
]

RUST = [
    (re.compile(rf"^\s*pub(?:\([^)]*\))?\s+(?:async\s+)?fn\s+{IDENT}"), "function"),
    (re.compile(rf"^\s*pub(?:\([^)]*\))?\s+(struct|enum|trait)\s+{IDENT}"), None),
]

DART = [
    (re.compile(rf"^\s*(?:abstract\s+|sealed\s+|final\s+|base\s+)*class\s+{IDENT}"), "class"),
    (re.compile(rf"^\s*mixin\s+{IDENT}"), "mixin"),
    (re.compile(rf"^\s*enum\s+{IDENT}"), "enum"),
    (re.compile(rf"^\s*extension\s+{IDENT}\s+on"), "extension"),
]

PATTERNS_BY_EXT = {
    ".php": PHP,
    ".ts": TS, ".tsx": TS, ".js": TS, ".jsx": TS, ".mjs": TS,
    ".py": PY,
    ".go": GO,
    ".rs": RUST,
    ".dart": DART,
}

JS_EXTS = {".ts", ".tsx", ".js", ".jsx", ".mjs"}

# .gitignore only hides untracked files. A dependency tree that was committed by mistake
# (seen in the wild: a Composer vendor/ checked in under a frontend folder) still comes
# back from ls-files and floods the index with thousands of third-party classes.
DEPENDENCY_DIRS = {"vendor", "node_modules", "bower_components", ".venv", "site-packages"}


def repo_root() -> Path:
    out = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True)
    return Path(out.stdout.strip())


def tracked_files(root: Path) -> list[str]:
    out = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=root, capture_output=True, text=True, check=True,
    )
    return [
        p for p in out.stdout.split("\0")
        if p and Path(p).suffix in PATTERNS_BY_EXT and not DEPENDENCY_DIRS.intersection(Path(p).parts)
    ]


def classify_js_const(name: str) -> str:
    if name.startswith("use") and len(name) > 3 and name[3].isupper():
        return "hook"
    return "component" if name[0].isupper() else "const"


def match_line(line: str, patterns, is_js: bool):
    for pattern, kind in patterns:
        m = pattern.match(line)
        if not m:
            continue
        if kind is None:  # Rust struct/enum/trait: kind is captured, name is the second group
            return m.group(2), m.group(1)
        name = m.group(1)
        if is_js and kind == "const":
            kind = classify_js_const(name)
        return name, kind
    return None


def index_file(root: Path, rel: str, symbols: dict) -> int:
    ext = Path(rel).suffix
    try:
        text = (root / rel).read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return 0
    count = 0
    for lineno, line in enumerate(text.splitlines(), 1):
        hit = match_line(line, PATTERNS_BY_EXT[ext], ext in JS_EXTS)
        if hit:
            name, kind = hit
            symbols.setdefault(name, []).append({"file": rel, "line": lineno, "kind": kind})
            count += 1
    return count


def main() -> int:
    root = repo_root()
    out_file = root / "docs" / "SYMBOLS.json"
    symbols: dict = {}
    files = tracked_files(root)
    entries = sum(index_file(root, rel, symbols) for rel in files)

    for locations in symbols.values():
        locations.sort(key=lambda x: (x["file"], x["line"]))

    out_file.parent.mkdir(parents=True, exist_ok=True)
    out_file.write_text(json.dumps(symbols, indent=2, ensure_ascii=False, sort_keys=True), encoding="utf-8")
    print(f"Indexed {len(symbols)} unique symbols ({entries} entries from {len(files)} files) → docs/SYMBOLS.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
