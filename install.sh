#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Error: Claude Code config directory not found at $CLAUDE_DIR"
    echo "Install Claude Code first, or export CLAUDE_DIR to your config path."
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/skills/code-overhaul" ]; then
    echo "Error: skills/code-overhaul not found. Are you running from the right directory?"
    exit 1
fi

echo "Installing code-overhaul to $CLAUDE_DIR ..."

mkdir -p "$CLAUDE_DIR/skills"
rm -f "$CLAUDE_DIR/skills/code-overhaul"
ln -s "$SCRIPT_DIR/skills/code-overhaul" "$CLAUDE_DIR/skills/code-overhaul"
if [ ! -L "$CLAUDE_DIR/skills/code-overhaul" ]; then
    echo "Error: failed to create skill symlink"
    exit 1
fi
echo "  skill linked"

mkdir -p "$CLAUDE_DIR/commands"
rm -f "$CLAUDE_DIR/commands/code-overhaul.md"
ln -s "$SCRIPT_DIR/commands/code-overhaul.md" "$CLAUDE_DIR/commands/code-overhaul.md"
if [ ! -L "$CLAUDE_DIR/commands/code-overhaul.md" ]; then
    echo "Error: failed to create command symlink"
    exit 1
fi
echo "  command linked"

echo ""
echo "Done. Usage:"
echo "  /code-overhaul"
echo "  /code-overhaul ~/path/to/project"
