# Workflow Rules

## Git Discipline
- Check `git status` before committing — verify no sensitive files are staged
- Commit with descriptive messages in imperative mood
- Never force-push without explicit user approval
- Prefer feature branches over direct commits to main

## Task Completion
- Never claim a task is done without verifying the output
- If a task fails or blocks, fix it or provide an alternative immediately
- For async/background tasks: wait for completion or explicitly say it's running

## File Management
- ISO dates in filenames: `YYYY-MM-DD-<kebab-slug>.md`
- Prefer kebab-case for file slugs
- YAML frontmatter on knowledge files (tags, date, type)

## Self-Improvement Loop
When you notice a correction, preference, or pattern:
1. Write it to the appropriate file immediately (don't defer to "end of session")
2. If the same correction happens twice, promote it to a rule in `rules/`
3. If a knowledge file grows past ~80 lines, split it

| What You Noticed | Where It Goes |
|---|---|
| User corrected your approach | `rules/` or knowledge file |
| User stated a preference | CLAUDE.md or rules file |
| Project state changed | MEMORY.md |
| Session ended | `knowledge/sessions/` |
