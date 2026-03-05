# Session Rules

## Session End Protocol (MANDATORY)
Do ALL of these before `/clear`, `/compact`, session exit, or when context is getting large:
1. **Update MEMORY.md** — "Next Up" with current state, any changed project status
2. **Update knowledge files** — edit any file in `~/.claude/knowledge/` that has stale info
3. **Create session note** — per format below
4. **Commit and push** `~/.claude` repo if knowledge files changed

## Session Notes
Location: `knowledge/sessions/YYYY-MM-DD-<slug>.md`

```yaml
---
title: "Session: <descriptive title>"
date: YYYY-MM-DD
tags: [claude-session, <topic-tags>]
---
```

### Sections
- **Summary** — 2-3 sentences: what was the session about, what was accomplished
- **Decisions Made** — choices, preferences, directions agreed on
- **Files Created/Modified** — paths and one-line descriptions
- **Key Findings** — important discoveries or insights
- **Open Items** — things not finished, for next session

Keep session notes factual and concise. They're for the next Claude instance, not for humans.
