#!/usr/bin/env bash
# Stop hook: Warn about plans with uncompleted tasks
# Guard against infinite loops per Claude Code docs
INPUT=$(cat)
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active' 2>/dev/null)" = "true" ]; then
  exit 0
fi

PENDING=0
for dir in .claude/plans/*/; do
  [ -d "$dir" ] || continue
  for plan_file in "spec.md" "plan.md"; do
    if [ -f "${dir}${plan_file}" ] && grep -q '\[ \]' "${dir}${plan_file}" 2>/dev/null; then
      PENDING=$((PENDING + 1))
      break
    fi
  done
done

if [ "$PENDING" -gt 0 ]; then
  echo "Warning: $PENDING plan(s) have uncompleted tasks"
fi
