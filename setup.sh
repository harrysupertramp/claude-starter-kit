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
mkdir -p "$CLAUDE_DIR"/{rules,scripts,knowledge/sessions,knowledge/self,knowledge/user,knowledge/problems,skills/onboard,state}

# --- Copy scripts ---
cp "$SCRIPT_DIR/scripts/global-guard.py" "$CLAUDE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/pre-compact.sh" "$CLAUDE_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/session-save-reminder.sh" "$CLAUDE_DIR/scripts/"
chmod +x "$CLAUDE_DIR/scripts/"*.sh

# --- Copy rules ---
for rule in "$SCRIPT_DIR"/rules/*.md; do
    cp "$rule" "$CLAUDE_DIR/rules/"
done

# --- Copy skills ---
cp "$SCRIPT_DIR/skills/onboard/SKILL.md" "$CLAUDE_DIR/skills/onboard/"

# --- Copy statusline ---
cp "$SCRIPT_DIR/statusline.sh" "$CLAUDE_DIR/"
chmod +x "$CLAUDE_DIR/statusline.sh"

# --- Copy settings.json ---
cp "$SCRIPT_DIR/templates/settings.json" "$CLAUDE_DIR/settings.json"

# --- Copy .gitignore ---
cp "$SCRIPT_DIR/templates/gitignore" "$CLAUDE_DIR/.gitignore"

# --- Generate CLAUDE.md from template ---
sed -e "s/{{USER_NAME}}/$USER_NAME/g" \
    -e "s|{{USER_BIO}}|$USER_BIO|g" \
    "$SCRIPT_DIR/templates/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md"

# --- Initialize git repo if not already one ---
if [[ ! -d "$CLAUDE_DIR/.git" ]]; then
    cd "$CLAUDE_DIR"
    git init
    git add -A
    git commit -m "initial setup from claude-starter-kit"
    echo ""
    echo "Git repo initialized at ~/.claude/"
    echo "To back up your config, create a private repo and run:"
    echo "  cd ~/.claude && git remote add origin git@github.com:YOUR_USERNAME/claude-config.git && git push -u origin main"
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Files installed:"
echo "  ~/.claude/CLAUDE.md          — global instructions"
echo "  ~/.claude/settings.json      — hooks + security"
echo "  ~/.claude/rules/             — session, workflow, handoff rules"
echo "  ~/.claude/scripts/           — security guard, pre-compact, reminders"
echo "  ~/.claude/skills/onboard/    — guided first-session setup"
echo "  ~/.claude/knowledge/         — your assistant's growing brain"
echo "  ~/.claude/statusline.sh      — context/cost display"
echo ""
echo "=== Next: Start your first session ==="
echo ""
echo "  cd ~/.claude"
echo "  claude"
echo ""
echo "Then type:"
echo "  /onboard"
echo ""
echo "This will walk you through a 20-30 minute guided setup:"
echo "  1. Build your user profile"
echo "  2. Define your 12 Favorite Problems (Feynman method)"
echo "  3. Set your end goal and subgoals"
echo "  4. Create initial tasks"
echo "  5. Set up the AI's self-knowledge"
echo ""
echo "You can pause anytime and resume later with: /onboard resume"
echo ""
