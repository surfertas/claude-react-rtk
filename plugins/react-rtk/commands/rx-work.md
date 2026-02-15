---
name: rx:work
description: Execute spec sprint-by-sprint, task-by-task with Iron Law checks and verification after each task. Finds first incomplete task and continues.
---

# /rx:work — Execute Spec

## Usage

```
/rx:work .claude/plans/notifications/spec.md
/rx:work                                       # Auto-find most recent spec
```

## Behavior

1. Read spec file, find first incomplete task (no `✅` prefix)
2. Implement task following the description, files, and Iron Law notes
3. Run iron-law-judge on changes
4. Run verification-runner (TypeScript, ESLint, tests)
5. If pass: mark task complete, update progress.md, move to next task
6. If fail: stop, report issue, ask user how to proceed
7. At end of each sprint: confirm demo criteria met before starting next sprint
8. After all sprints complete: recommend `/rx:review`

## Tips

- For specs with 3+ sprints, start each sprint in a fresh session (spec is self-contained)
- Scratchpad auto-updated with decisions and dead-ends
- Session interrupted? Just run `/rx:work` again — it finds the first incomplete task
- Sprint boundaries are natural pause points — review demo criteria before continuing
