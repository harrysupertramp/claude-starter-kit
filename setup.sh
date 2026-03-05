#!/bin/bash
set -euo pipefail

# Claude Code Starter Kit — Setup Script
# Copies template files to ~/.claude/ and personalizes them.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code Starter Kit ==="
echo ""

# Check prerequisites
command -v claude >/dev/null 2>&1 || { echo "Error: claude CLI not found. Install it first: https://docs.anthropic.com/en/docs/claude-code"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "Error: python3 not found"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Error: git not found"; exit 1; }

# Check if ~/.claude already exists with config
if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
    echo "Warning: ~/.claude/settings.json already exists."
    read -p "Overwrite? This will replace your current config. (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

# Collect user info
echo "Let's personalize your assistant."
echo ""
read -p "Your first name: " USER_NAME
read -p "One-line bio (e.g., 'Python dev, building SaaS tools'): " USER_BIO

if [[ -z "$USER_NAME" ]]; then
    echo "Error: name is required"
    exit 1
fi

echo ""
echo "Setting up ~/.claude/ ..."

# Create directory structure
mkdir -p "$CLAUDE_DIR"/{rules,scripts,knowledge/sessions,skills}

# Copy scripts
cp "$SCRIPT_DIR/scripts/global-guard.py" "$CLAUDE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/pre-compact.sh" "$CLAUDE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/session-save-reminder.sh" "$CLAUDE_DIR/scripts/"
chmod +x "$CLAUDE_DIR/scripts/"*.sh

# Copy rules
cp "$SCRIPT_DIR/rules/sessions.md" "$CLAUDE_DIR/rules/"
cp "$SCRIPT_DIR/rules/workflow.md" "$CLAUDE_DIR/rules/"

# Copy statusline
cp "$SCRIPT_DIR/statusline.sh" "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR/statusline.sh"

# Copy settings.json
cp "$SCRIPT_DIR/templates/settings.json" "$CLAUDE_DIR/settings.json"

# Copy .gitignore
cp "$SCRIPT_DIR/templates/gitignore" "$CLAUDE_DIR/.gitignore"

# Generate CLAUDE.md from template
sed -e "s/{{USER_NAME}}/$USER_NAME/g" \
    -e "s/{{USER_BIO}}/$USER_BIO/g" \
    "$SCRIPT_DIR/templates/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md"

# Initialize git repo if not already one
if [[ ! -d "$CLAUDE_DIR/.git" ]]; then
    cd "$CLAUDE_DIR"
    git init
    git add -A
    git commit -m "initial setup from claude-starter-kit"
    echo ""
    echo "Git repo initialized at ~/.claude/"
    echo "To back up your config, add a remote:"
    echo "  cd ~/.claude && git remote add origin git@github.com:YOUR_USERNAME/claude-config.git && git push -u origin main"
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Your Claude Code assistant is ready. Start it with:"
echo "  claude"
echo ""
echo "First session tip: paste this to kick things off:"
echo '  "Read ~/.claude/CLAUDE.md and rules/. Create knowledge/user/profile.md'
echo '   about me. Ask questions to fill gaps — what I work on, tools I use,'
echo '   what matters to me. Save everything to files."'
echo ""
