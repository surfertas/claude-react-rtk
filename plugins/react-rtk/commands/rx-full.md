---
name: rx:full
description: Full autonomous cycle — plan with parallel research, implement with verification, review with 4 parallel agents, capture learnings. Use for medium-to-large features.
---

# /rx:full — Full Lifecycle

Run the complete Plan → Work → Review → Compound cycle for a feature.

## Usage

```
/rx:full Add user dashboard with profile editing and notification preferences
/rx:full Implement shopping cart with RTK Query and optimistic updates
```

## Behavior

1. **Assess complexity** (workflow-orchestrator scores 1-5)
2. **Spec** (planning-orchestrator: parallel research → sprint-based spec)
3. **Confirm** spec with user (or auto-proceed if --auto flag)
4. **Work** sprint by sprint, task by task, verification after each
5. **Review** 4 parallel agents check everything
6. **Fix** if review finds blockers, update spec and fix
7. **Compound** capture lessons learned

## Flags

- `--auto` — Skip plan confirmation, proceed automatically
- `--depth deep` — Spawn 4+ research agents (default: 2-3)
- `--skip-review` — Skip review phase (not recommended)
