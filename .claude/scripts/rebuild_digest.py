#!/usr/bin/env python3
import os
import re
import glob
import sys

def extract_keywords(topic, context, files_touched):
    """
    Extracts 8-15 significant technical terms from Topic, Context, and Files Touched.
    Picks terms that are tech-specific (backticks, snake_case, PascalCase, file names, etc.).
    """
    text = f"{topic}\n{context}\n{files_touched}"
    
    # Heuristics for technical terms:
    # 1. Any words inside backticks
    backtick_terms = re.findall(r'`([^`]+)`', text)
    
    # 2. File paths and names (e.g. UserController.php, useDataLoader.js, formatDate.js, web.php, etc.)
    file_terms = re.findall(r'\b[A-Za-z0-9_-]+\.(?:php|js|jsx|ts|tsx|sql|css|md|json|html)\b', text)
    
    # 3. CamelCase / PascalCase / snake_case terms or terms with hyphens (e.g. getUserDetails, queue_id, rebuild-digest, sp-details)
    patterns = [
        r'\b[a-z]+[A-Z][a-zA-Z0-9]+\b',  # camelCase
        r'\b[A-Z][a-z]+[A-Z][a-zA-Z0-9]+\b',  # PascalCase
        r'\b[A-Za-z0-9]+_[A-Za-z0-9_]+\b',  # snake_case
        r'\b[A-Za-z0-9]+-[A-Za-z0-9_-]+\b',  # kebab-case / words with dashes
    ]
    code_terms = []
    for pattern in patterns:
        code_terms.extend(re.findall(pattern, text))
        
    # 4. Standard acronyms (RAG, EMR, FIFO, DDL, SP, RLS, DTO, RHF, ICD-10, JWT)
    acronyms = re.findall(r'\b[A-Z]{3,5}\b', text)
    
    # Combine and clean all found terms
    raw_terms = backtick_terms + file_terms + code_terms + acronyms
    
    # Clean terms: strip leading/trailing punctuation, lower-case comparison for deduplication but keep original case
    seen_lower = set()
    cleaned_terms = []
    
    # Pre-populate stop words (common generic words to ignore)
    stop_words = {
        'this', 'that', 'with', 'from', 'have', 'been', 'were', 'what', 'worked', 'evidence',
        'decision', 'made', 'files', 'touched', 'open', 'questions', 'blockers', 'exact', 'next',
        'step', 'topic', 'context', 'session', 'file', 'code', 'bug', 'fix', 'update', 'add',
        'create', 'delete', 'modify', 'remove', 'run', 'test', 'error', 'issue', 'page', 'screen',
        'button', 'view', 'modal', 'popup', 'dialog', 'table', 'column', 'row', 'field', 'data',
        'user', 'tenant', 'branch', 'database', 'backend', 'frontend',
        'api', 'route', 'endpoint', 'controller', 'model', 'migration', 'seeder', 'factory', 'test',
        'unit', 'feature', 'integration', 'logic', 'business', 'ui', 'ux', 'style', 'class', 'method',
        'function', 'variable', 'object', 'array', 'string', 'number', 'boolean', 'null', 'undefined',
        'complete', 'in-progress', 'progress', 'blocker', 'block', 'active', 'none', 'work'
    }
    
    for term in raw_terms:
        # Strip trailing/leading non-alphanumeric chars (like quotes, dots, dashes, brackets, etc.)
        t = re.sub(r'^[^a-zA-Z0-9`#]+|[^a-zA-Z0-9`#]+$', '', term)
        if not t or len(t) < 3:
            continue
        
        # Avoid pure numbers
        if t.isdigit():
            continue
            
        t_low = t.lower()
        if t_low in stop_words:
            continue
            
        if t_low not in seen_lower:
            seen_lower.add(t_low)
            cleaned_terms.append(t)
            
    # If we need more terms, extract capitalized nouns from text that aren't stop words
    if len(cleaned_terms) < 8:
        # Match capitalised words that are not at the start of sentences
        capitalized = re.findall(r'(?<!^[.!?]\s)\b[A-Z][a-z]+\b', text)
        for term in capitalized:
            t = re.sub(r'^[^a-zA-Z0-9]+|[^a-zA-Z0-9]+$', '', term)
            if not t or len(t) < 3:
                continue
            t_low = t.lower()
            if t_low in stop_words:
                continue
            if t_low not in seen_lower:
                seen_lower.add(t_low)
                cleaned_terms.append(t)
                if len(cleaned_terms) >= 12:
                    break

    # Keep only 8-15 keywords
    return cleaned_terms[:15]

SECTION_ALIASES = {
    'issue addressed': 'context',
    'session summary': 'context',
    'summary': 'context',
    'tasks': 'context',
    'files modified': 'files touched',
    'decisions': 'decisions made',
}
SECTION_HEADER_RE = re.compile(
    r'^(?:#+\s+)?(Topic|Context|What WORKED.*|Problems\s*&\s*Solutions|Decisions Made|Files Touched|Open Questions.*|Exact Next Step|'
    + '|'.join(map(re.escape, SECTION_ALIASES)) + r')\b',
    re.IGNORECASE,
)
SESSION_FILE_RE = re.compile(r'^\d{4}-\d{2}-\d{2}_.+\.md$')

def store_section(sections, name, lines):
    sections[name] = (sections.get(name, '') + '\n' + '\n'.join(lines)).strip()

def parse_session_file(filepath):
    """
    Parses a session markdown file to extract its topic, context, decisions, files touched, and blockers.
    """
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    filename = os.path.basename(filepath)
    # Extract date and slug from filename YYYY-MM-DD_slug.md
    match = re.match(r'^(\d{4}-\d{2}-\d{2})_(.+)\.md$', filename)
    if not match:
        raise ValueError(f"Filename does not match standard pattern: {filename}")
        
    date_str = match.group(1)
    slug = match.group(2)
    
    # Parse sections
    # Split content by markdown headers
    sections = {}
    current_section = None
    section_content = []
    
    lines = content.splitlines()
    for line in lines:
        header_match = SECTION_HEADER_RE.match(line)
        if header_match:
            if current_section:
                store_section(sections, current_section, section_content)
            sec_name = header_match.group(1).lower()
            if sec_name in SECTION_ALIASES:
                current_section = SECTION_ALIASES[sec_name]
            elif 'worked' in sec_name:
                current_section = 'worked'
            elif 'questions' in sec_name or 'blockers' in sec_name:
                current_section = 'blockers'
            else:
                current_section = sec_name
            section_content = []
        else:
            if current_section:
                section_content.append(line)
                
    if current_section:
        store_section(sections, current_section, section_content)
        
    topic = sections.get('topic', '')
    context = sections.get('context', '')
    decisions_text = sections.get('decisions made', '')
    files_touched = sections.get('files touched', '')
    blockers = sections.get('blockers', '')
    
    # 1. Extract keywords
    keywords = extract_keywords(topic, context, files_touched)
    if not keywords:
        h1 = next((l[2:] for l in lines if l.startswith('# ')), '')
        keywords = extract_keywords(h1, '\n'.join(lines[:60]), '')
    
    # 2. Extract decisions
    decisions = []
    if decisions_text and "no major decisions" not in decisions_text.lower():
        # Parse list items
        for line in decisions_text.splitlines():
            line = line.strip()
            if line.startswith(('-', '*')):
                # Try to extract bold text or clean description
                bold_match = re.match(r'^[-*]\s*\*\*([^*]+)\*\*(?:\s*[-—]\s*reason:\s*(.+))?$', line)
                if bold_match:
                    dec = bold_match.group(1).strip()
                    reason = bold_match.group(2)
                    if reason:
                        # Clean reason slightly to keep it compact
                        reason_clean = re.sub(r'[\r\n\t]+', ' ', reason).strip()
                        # Shorten if too long
                        if len(reason_clean) > 80:
                            reason_clean = reason_clean[:77] + "..."
                        decisions.append(f"{dec} — {reason_clean}")
                    else:
                        decisions.append(dec)
                else:
                    # Fallback to plain list item without leading dash
                    dec = re.sub(r'^[-*]\s*', '', line).strip()
                    dec = re.sub(r'\*\*|\*', '', dec) # remove bold/italics
                    decisions.append(dec)
                    
    # 3. Extract files touched (basenames only)
    files = []
    if files_touched:
        for line in files_touched.splitlines():
            line = line.strip()
            if line.startswith(('-', '*')):
                # Strip leading bullet and spaces
                clean_line = re.sub(r'^[-*\s]+', '', line)
                # Find backtick enclosed file path
                file_match = re.search(r'`([^`]+)`', clean_line)
                if file_match:
                    file_path = file_match.group(1).strip()
                    # Keep only the first word in case of formatting issues
                    file_path = file_path.split()[0]
                    basename = os.path.basename(file_path)
                    if '.' in basename and not basename.endswith('.'):
                        files.append(basename)
                else:
                    # Fallback to matching standard file-like patterns without backticks
                    word_match = re.search(r'\b[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+\b', clean_line)
                    if word_match:
                        file_path = word_match.group(0).strip()
                        basename = os.path.basename(file_path)
                        if '.' in basename and not basename.endswith('.'):
                            files.append(basename)
                        
    # Deduplicate files and limit to top 5-8
    seen_files = set()
    unique_files = []
    for f in files:
        if f not in seen_files:
            seen_files.add(f)
            unique_files.append(f)
    files = unique_files[:8]
    
    # 4. Determine status
    status = 'complete'
    if blockers:
        blockers_lower = blockers.lower()
        if "no active blockers" not in blockers_lower and "no blockers" not in blockers_lower:
            # Check if there are active bullet points
            lines = [l.strip() for l in blockers.splitlines() if l.strip()]
            has_bullets = any(l.startswith(('-', '*', '1.', '2.', '3.')) for l in lines)
            if has_bullets:
                status = 'in-progress'
                # Exception: if it's minor stuff (contains low priority, minor, future pass, etc.) and no major blockers
                if all(any(term in l.lower() for term in ("low priority", "future", "minor", "unresolved but", "deferred", "no blocker")) for l in lines if l.startswith(('-', '*'))):
                    status = 'complete'
                
    return {
        'date': date_str,
        'slug': slug,
        'keywords': keywords,
        'decisions': decisions,
        'files': files,
        'status': status
    }

def main():
    sessions_dir = '.claude/sessions/'
    if not os.path.isdir(sessions_dir):
        print(f"Error: Sessions directory '{sessions_dir}' not found.")
        sys.exit(1)
        
    # Glob all session files
    pattern = os.path.join(sessions_dir, '*.md')
    all_files = glob.glob(pattern)
    
    # Filter out INDEX.md, INDEX-archive.md, DIGEST.md
    exclude_files = {'index.md', 'index-archive.md', 'digest.md'}
    session_files = [f for f in all_files if os.path.basename(f).lower() not in exclude_files
                     and SESSION_FILE_RE.match(os.path.basename(f))]
    
    # Sort descending based on filename YYYY-MM-DD prefix
    session_files.sort(key=lambda x: os.path.basename(x), reverse=True)
    
    total_indexed = 0
    parsed_entries = []
    failed_files = []
    
    for filepath in session_files:
        try:
            entry = parse_session_file(filepath)
            parsed_entries.append(entry)
            total_indexed += 1
        except Exception as e:
            failed_files.append((filepath, str(e)))
            
    # Write DIGEST.md
    digest_path = os.path.join(sessions_dir, 'DIGEST.md')
    
    with open(digest_path, 'w', encoding='utf-8') as f:
        f.write("# Session Digest\n\n")
        f.write("<!-- Auto-generated search index for session-rag agent. -->\n")
        f.write("<!-- Do not edit manually. Rebuilt via /rebuild-digest. -->\n")
        f.write("<!-- Updated automatically by /save-session (Step 2.5). -->\n\n")
        
        for entry in parsed_entries:
            f.write(f"## {entry['date']} | {entry['slug']}\n")
            f.write(f"keywords: {', '.join(entry['keywords'])}\n")
            if entry['decisions']:
                f.write(f"decisions: {' | '.join(entry['decisions'])}\n")
            f.write(f"files: {', '.join(entry['files'])}\n")
            f.write(f"status: {entry['status']}\n")
            f.write("---\n\n")
            
    # Calculate line count
    with open(digest_path, 'r', encoding='utf-8') as f:
        line_count = len(f.readlines())
        
    print(f"SUCCESS")
    print(f"Total sessions indexed: {total_indexed}")
    print(f"DIGEST.md total line count: {line_count}")
    if failed_files:
        print("\nFailed to parse some session files:")
        for fp, err in failed_files:
            print(f"- {fp}: {err}")
            
if __name__ == '__main__':
    main()
