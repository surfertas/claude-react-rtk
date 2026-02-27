#!/usr/bin/env bash
# PostToolUse hook: Check formatting after Edit/Write
# Warn-only -- does NOT modify files (prevents race condition with Claude's file state)
FILE_PATH=$(cat | jq -r '.tool_input.file_path // empty')
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check JS/TS/CSS/JSON files
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.css|*.json)
    ;;
  *)
    exit 0
    ;;
esac

# Check if prettier is available via node_modules
if [ ! -d "node_modules" ]; then
  exit 0
fi

if ! npx prettier --check "$FILE_PATH" 2>/dev/null; then
  echo "NEEDS FORMAT: $FILE_PATH -- run 'npx prettier --write' before committing"
fi
