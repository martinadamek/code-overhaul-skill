#!/bin/bash
set -e

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

echo "Removing code-overhaul-review from $CLAUDE_DIR ..."

if [ -L "$CLAUDE_DIR/skills/code-overhaul-review" ]; then
    rm "$CLAUDE_DIR/skills/code-overhaul-review"
    echo "  skill removed"
else
    echo "  skill symlink not found, skipping"
fi

if [ -L "$CLAUDE_DIR/commands/code-overhaul-review.md" ]; then
    rm "$CLAUDE_DIR/commands/code-overhaul-review.md"
    echo "  command removed"
else
    echo "  command symlink not found, skipping"
fi

echo "Done."
