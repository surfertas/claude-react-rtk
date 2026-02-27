#!/usr/bin/env bash
# PreCompact hook: Re-inject critical workflow rules before context compaction.
# Iron Laws from CLAUDE.md survive compaction (system prompt), so we only
# re-inject rules from loaded skills that live in conversation context.

FULL_MODE=false
ACTIVE_PLAN=false
ACTIVE_WORK=false

for dir in .claude/plans/*/; do
  [ -d "$dir" ] || continue

  # Check for /rx:full autonomous mode
  if [ -f "${dir}progress.md" ] && grep -q '\*\*State\*\*:' "${dir}progress.md" 2>/dev/null; then
    FULL_MODE=true
    continue
  fi

  # Research exists but no spec/plan yet = mid /rx:plan
  if [ -d "${dir}research" ] && [ ! -f "${dir}spec.md" ] && [ ! -f "${dir}plan.md" ]; then
    ACTIVE_PLAN=true
  fi

  # Spec/plan exists with PENDING status or unchecked tasks
  for plan_file in "spec.md" "plan.md"; do
    if [ -f "${dir}${plan_file}" ]; then
      if grep -q 'Status.*PENDING' "${dir}${plan_file}" 2>/dev/null; then
        ACTIVE_PLAN=true
      elif grep -q '^\- \[ \]' "${dir}${plan_file}" 2>/dev/null; then
        ACTIVE_WORK=true
      fi
    fi
  done
done

# Extract slug + intent from the active plan for context preservation
PLAN_SLUG=""
PLAN_INTENT=""
for dir in .claude/plans/*/; do
  for plan_file in "spec.md" "plan.md"; do
    [ -f "${dir}${plan_file}" ] || continue
    PLAN_SLUG="$(basename "$dir")"
    PLAN_INTENT="$(head -5 "${dir}${plan_file}" | grep '^#' | head -1 | sed 's/^#* *//')"
    break 2
  done
done

# Output rules based on active phase
if [ "$ACTIVE_PLAN" = true ] && [ "$FULL_MODE" = false ]; then
  echo "PRESERVE ACROSS COMPACTION -- active /rx:plan session:"
  echo ""
  if [ -n "$PLAN_SLUG" ]; then
    echo "- Active plan: ${PLAN_SLUG} -- ${PLAN_INTENT}"
    echo "- Plan file: .claude/plans/${PLAN_SLUG}/spec.md"
    echo ""
  fi
  echo "CRITICAL: After writing spec.md, you MUST STOP."
  echo "Do NOT proceed to implementation or /rx:work."
  echo "Present the plan summary and use AskUserQuestion with options:"
  echo "  - Start in fresh session (recommended)"
  echo "  - Start here"
  echo "  - Review the plan"
  echo "  - Adjust the plan"
  echo "Wait for user response."
fi

if [ "$ACTIVE_WORK" = true ] && [ "$FULL_MODE" = false ]; then
  echo "PRESERVE ACROSS COMPACTION -- active /rx:work session:"
  echo ""
  if [ -n "$PLAN_SLUG" ]; then
    echo "- Active plan: ${PLAN_SLUG} -- ${PLAN_INTENT}"
    echo "- Plan file: .claude/plans/${PLAN_SLUG}/spec.md"
    echo ""
  fi
  echo "- Run iron-law-judge after EVERY task"
  echo "- Run verification-runner after EVERY task (TypeScript, ESLint, tests)"
  echo "- Max 3 retries per task, then mark BLOCKER"
  echo "- At end of each sprint: confirm demo criteria met"
  echo "- NEVER auto-start /rx:review -- ask user what to do next"
  echo "- Re-read spec.md for current state (checkboxes are the source of truth)"
fi

if [ "$FULL_MODE" = true ]; then
  echo "PRESERVE ACROSS COMPACTION -- /rx:full autonomous mode:"
  echo ""
  if [ -n "$PLAN_SLUG" ]; then
    echo "- Active plan: ${PLAN_SLUG} -- ${PLAN_INTENT}"
    echo "- Plan file: .claude/plans/${PLAN_SLUG}/spec.md"
    echo ""
  fi
  echo "- Continue autonomous plan -> work -> review cycle"
  echo "- Re-read progress.md for current state and cycle count"
  echo "- Re-read spec.md for task checkboxes"
  echo "- Max cycles, retries, and blocker limits still apply"
  echo "- Iron Law violations BLOCK the pipeline -- do not proceed"
fi
