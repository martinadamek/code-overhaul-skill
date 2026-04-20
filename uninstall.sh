#!/bin/bash
set -e

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

echo "Removing code-overhaul from $CLAUDE_DIR ..."

if [ -L "$CLAUDE_DIR/skills/code-overhaul" ]; then
    rm "$CLAUDE_DIR/skills/code-overhaul"
    echo "  skill removed"
else
    echo "  skill symlink not found, skipping"
fi

if [ -L "$CLAUDE_DIR/commands/code-overhaul.md" ]; then
    rm "$CLAUDE_DIR/commands/code-overhaul.md"
    echo "  command removed"
else
    echo "  command symlink not found, skipping"
fi

echo "Done."
