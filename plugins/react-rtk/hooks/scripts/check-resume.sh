#!/usr/bin/env bash
# SessionStart hook: Detect plans with remaining tasks
FOUND_PLAN=false
for dir in .claude/plans/*/; do
  [ -d "$dir" ] || continue
  for plan_file in "spec.md" "plan.md"; do
    [ -f "${dir}${plan_file}" ] || continue
    UNCHECKED=$(grep -c '^\- \[ \]' "${dir}${plan_file}" 2>/dev/null || echo 0)
    CHECKED=$(grep -c '^\- \[x\]' "${dir}${plan_file}" 2>/dev/null || echo 0)
    if [ "$UNCHECKED" -gt 0 ]; then
      SLUG="$(basename "$dir")"
      echo "Resumable: '${SLUG}' has ${UNCHECKED} remaining tasks (${CHECKED} done). Resume with: /rx:work .claude/plans/${SLUG}/${plan_file}"
      FOUND_PLAN=true
      break
    fi
  done
done
