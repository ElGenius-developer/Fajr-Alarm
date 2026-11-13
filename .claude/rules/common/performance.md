# Performance Optimization

## Model Selection Strategy

- **Haiku** — cheap, frequent worker and sub-agent tasks.
- **Sonnet** — mechanical and everyday coding work.
- **Opus** — reviews, architecture, genuinely hard reasoning.

Name the family, not a version; a project's own model rule wins.

## Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## Extended Thinking + Plan Mode

Thinking depth is set by the model's effort level in Claude Code's own settings, not by token budgets or prompt text. Ctrl+O shows thinking output.

For complex tasks requiring deep reasoning:
1. Raise the effort level
2. Enable **Plan Mode** for structured approach
3. Use multiple critique rounds for thorough analysis
4. Use split role sub-agents for diverse perspectives

## Build Troubleshooting

If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix
