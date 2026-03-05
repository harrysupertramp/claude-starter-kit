# Global Standards

Global instructions for all projects. Project-specific CLAUDE.md files override these defaults.

## Philosophy

- **No speculative features** — Don't add features, flags, or configuration unless actively needed
- **Clarity over cleverness** — Prefer explicit, readable code over dense one-liners
- **Bias toward action** — Decide and move for anything easily reversed; ask before committing to interfaces, data models, or destructive operations
- **Finish the job** — Handle edge cases you can see. Clean up what you touched. But don't invent new scope.

## Communication Style

- Be concise — skip preamble and get to the point
- Use tables and structured formats for data-heavy responses
- Include specific numbers and dates, not vague descriptions
- No emoji unless requested
- No marketing language, hype, or superlatives

## User Context

**{{USER_NAME}}** — {{USER_BIO}}

## Knowledge System

- Knowledge files live in `~/.claude/knowledge/` — read on demand, don't preload
- Session notes go in `knowledge/sessions/` — every session gets a note
- MEMORY.md is the cross-session index — keep it under 200 lines
- Each fact lives in ONE place, referenced from others
