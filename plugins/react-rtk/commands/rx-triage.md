---
name: rx:triage
description: Interactive triage of review findings — prioritize, group, and assign severity. Converts raw review output into an actionable fix plan.
---

## Triage Workflow

1. **Load review findings** from `.claude/plans/{slug}/summaries/review-consolidated.md` or `.claude/reviews/latest.md`
2. **Group by severity**: blocker → warning → suggestion
3. **Interactive walk-through**: For each finding, ask:
   - Fix now? (add to immediate fix plan)
   - Defer? (add to tech debt backlog)
   - Dismiss? (mark as acceptable with rationale)
4. **Output**: `.claude/plans/{slug}/triage.md` with categorized action items

## Arguments

- No args: triage most recent review
- `{plan-slug}`: triage a specific plan's review
- `--auto`: skip interactive mode, auto-prioritize by severity

## Triage Rules

- **Blockers** cannot be dismissed without explicit rationale written to scratchpad
- **Security findings** are always blockers regardless of original severity
- **Iron Law violations** are always blockers — no deferral allowed
- Group related findings (e.g., three missing error boundaries → one task)
- Estimate fix effort: quick (<5min), medium (<30min), significant (>30min)

After triage, suggest: `/rx:work .claude/plans/{slug}/triage.md` to execute fixes.
