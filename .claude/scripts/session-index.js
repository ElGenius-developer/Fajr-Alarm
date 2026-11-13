const fs = require('fs');
const path = require('path');

try {
  const indexPath = path.join('.claude', 'sessions', 'INDEX.md');
  const content = fs.readFileSync(indexPath, 'utf8');
  console.log('## Past Session Index\n');
  console.log(content);
  console.log('\nFull session details are in .claude/sessions/YYYY-MM-DD_*.md — read a specific file ONLY if the current task references that topic.');
} catch (e) {
  console.log('No session history yet.');
}
