# Claude Code Starter Kit

Turn Claude Code into a personal AI assistant that remembers you across sessions.

Out of the box, Claude Code forgets everything when a session ends. This kit gives it persistent memory, security guardrails, and a self-improvement loop — so every session builds on the last.

## What You Get

| Component | What It Does |
|---|---|
| **Session persistence** | Pre-compact hook saves state before context compression. Session notes protocol ensures nothing is lost. |
| **Security guard** | Blocks secrets access, force-push, writes outside `$HOME`, and destructive `rm -rf`. |
| **Knowledge system** | Structured `knowledge/` directory where Claude accumulates what it learns about you and your projects. |
| **Session reminders** | After 10 minutes, Claude gets reminded to save state before ending. |
| **Self-improvement loop** | Corrections and preferences are externalized to files, not forgotten. |

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and working
- Git
- Python 3.10+ (for the security guard script)
- jq (for the status line — `brew install jq` on macOS)

## Setup (5 minutes)

```bash
# 1. Clone this repo
git clone https://github.com/YOUR_USERNAME/claude-starter-kit.git
cd claude-starter-kit

# 2. Run setup
./setup.sh

# 3. Start Claude Code in any project
cd ~/your-project
claude
```

The setup script copies files to `~/.claude/`, makes scripts executable, and initializes a git repo for your config. It will ask for your name and a short bio to personalize the assistant.

## What Goes Where

After setup, your `~/.claude/` looks like this:

```
~/.claude/
├── CLAUDE.md              # Global instructions (loads every session, every project)
├── settings.json          # Hooks, permissions, security config
├── .gitignore             # Keeps transient files out of git
├── rules/
│   ├── sessions.md        # Session logging protocol
│   └── workflow.md        # Git discipline, task completion
├── scripts/
│   ├── global-guard.py    # Security: path boundaries, secrets blocking
│   ├── pre-compact.sh     # Saves state before context compression
│   └── session-save-reminder.sh  # Reminds to save before ending
├── knowledge/             # Claude reads these on demand
│   └── sessions/          # Session logs accumulate here
└── statusline.sh          # Context usage, cost, branch info
```

## How It Works

### The Memory Problem

Claude Code has no memory between sessions. It reads certain files at startup (`CLAUDE.md`, `rules/*.md`, `MEMORY.md`) — everything else is gone. This kit uses those loading points to maintain continuity:

1. **MEMORY.md** (auto-memory) — First 200 lines load automatically. Claude uses it as a cross-session index. Keep it concise.
2. **Rules** — Always-loaded behavioral instructions. Session protocol, git discipline.
3. **Knowledge files** — Read on demand. Claude accumulates project knowledge, user preferences, session history here.
4. **Hooks** — Shell scripts that fire on events. Pre-compact saves state. Session reminders ensure nothing is forgotten.

### The Self-Improvement Loop

```
Session work → Claude notices correction/preference → Writes to knowledge file → Commits
Next session → Claude reads the file → Doesn't repeat the mistake
```

This only works if Claude actually writes things down. The session protocol and reminders enforce this.

### Security

The guard script (`scripts/global-guard.py`) runs on every tool call and blocks:
- Reading/writing outside `$HOME` and `/tmp`
- Accessing `.env`, `.key`, `.pem`, `.secret` files
- `git push --force`
- `git add` on secrets files
- `rm -rf` (use `trash` instead)

## First Session

After setup, start Claude Code and paste this:

> Read ~/.claude/CLAUDE.md and the files in ~/.claude/rules/. Then create a knowledge/user/profile.md with what you know about me so far. Ask me questions to fill in gaps — what I work on, what tools I use, what matters to me. Save everything to files.

This kicks off the "getting to know you" process. Claude will ask questions, write knowledge files, and from the next session onward it remembers.

## Growing the System

The starter kit is minimal on purpose. As you use it, the system grows:

- **Claude creates knowledge files** as it learns about your projects, preferences, tools
- **Session notes accumulate** in `knowledge/sessions/`, creating searchable history
- **Rules evolve** — if you correct Claude on the same thing twice, it should become a rule
- **New skills** can be added to `skills/` as you develop workflows worth repeating

The `knowledge/` directory is your assistant's brain. Commit and push it regularly.

## Customization

### Adding project-specific rules

Create `.claude/rules/my-rule.md` in any project directory. It loads only for that project.

### Adding deny rules

Edit `~/.claude/settings.json` → `permissions.deny` to block specific tools/commands globally.

### Adjusting the session reminder

Edit `scripts/session-save-reminder.sh` — change `600` (seconds) to adjust the reminder threshold.

## Credits

Built from patterns developed by [Mattia Papa](https://mattiapapa.dev) over months of daily Claude Code usage. Inspired by community patterns from the Claude Code ecosystem.
