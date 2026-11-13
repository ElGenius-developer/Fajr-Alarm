'use strict';
// Idempotently merge a hooks snippet into a Claude Code settings.json.
// Usage: node merge-hooks.js <settings.json-path> <snippet.json-path>
// - Never clobbers existing hooks; appends only entries not already present.
// - Aborts (exit 1) without writing if the target exists but is not valid JSON.
const fs = require('fs');

/** Stable identity key for a hook entry: matcher + sorted inner command strings. */
function entryKey(entry) {
  const matcher = entry && entry.matcher ? String(entry.matcher) : '';
  const cmds = (entry && Array.isArray(entry.hooks) ? entry.hooks : [])
    .map((h) => (h && h.command ? String(h.command) : ''))
    .sort();
  return `${matcher}|${cmds.join(' ')}`;
}

/** Union string arrays under permissions.{allow,deny,ask}, preserving existing order. */
function mergePermissions(merged, snippet, added, skipped) {
  const incoming = (snippet && snippet.permissions) || {};
  const buckets = Object.keys(incoming).filter((b) => Array.isArray(incoming[b]));
  if (buckets.length === 0) {
    return;
  }
  if (!merged.permissions || typeof merged.permissions !== 'object' || Array.isArray(merged.permissions)) {
    merged.permissions = {};
  }
  for (const bucket of buckets) {
    if (!Array.isArray(merged.permissions[bucket])) {
      merged.permissions[bucket] = [];
    }
    for (const rule of incoming[bucket]) {
      if (merged.permissions[bucket].includes(rule)) {
        skipped.push(`permissions.${bucket}:${rule}`);
      } else {
        merged.permissions[bucket].push(rule);
        added.push(`permissions.${bucket}:${rule}`);
      }
    }
  }
}

/**
 * @param {object} target  parsed existing settings (may be {})
 * @param {object} snippet parsed snippet: { hooks: { Event: [entry,...] }, permissions?: { deny?: string[], allow?: string[] } }
 * @returns {{merged: object, added: string[], skipped: string[]}}
 */
function mergeHooks(target, snippet) {
  const merged = JSON.parse(JSON.stringify(target || {}));
  const added = [];
  const skipped = [];
  const snippetHooks = (snippet && snippet.hooks) || {};
  if (!merged.hooks || typeof merged.hooks !== 'object' || Array.isArray(merged.hooks)) {
    merged.hooks = {};
  }
  for (const event of Object.keys(snippetHooks)) {
    const incoming = Array.isArray(snippetHooks[event]) ? snippetHooks[event] : [];
    if (!Array.isArray(merged.hooks[event])) {
      merged.hooks[event] = [];
    }
    for (const entry of incoming) {
      const key = entryKey(entry);
      const exists = merged.hooks[event].some((e) => entryKey(e) === key);
      if (exists) {
        skipped.push(`${event}:${key}`);
      } else {
        merged.hooks[event].push(entry);
        added.push(`${event}:${key}`);
      }
    }
  }
  mergePermissions(merged, snippet, added, skipped);
  return { merged, added, skipped };
}

function main(argv) {
  const [targetPath, snippetPath] = argv;
  if (!targetPath || !snippetPath) {
    console.error('usage: node merge-hooks.js <settings.json> <snippet.json>');
    process.exit(2);
  }
  let target = {};
  if (fs.existsSync(targetPath)) {
    const raw = fs.readFileSync(targetPath, 'utf8');
    if (raw.trim() !== '') {
      try {
        target = JSON.parse(raw);
      } catch (e) {
        console.error(`ABORT: ${targetPath} is not valid JSON — refusing to overwrite. (${e.message})`);
        process.exit(1);
      }
    }
  }
  const snippet = JSON.parse(fs.readFileSync(snippetPath, 'utf8'));
  const { merged, added, skipped } = mergeHooks(target, snippet);
  fs.writeFileSync(targetPath, JSON.stringify(merged, null, 2) + '\n', 'utf8');
  console.log(`merged ${added.length} entr(ies), skipped ${skipped.length} duplicate(s)`);
  for (const a of added) console.log(`  + ${a}`);
  for (const s of skipped) console.log(`  = ${s}`);
}

if (require.main === module) {
  main(process.argv.slice(2));
}

module.exports = { mergeHooks, mergePermissions, entryKey };
