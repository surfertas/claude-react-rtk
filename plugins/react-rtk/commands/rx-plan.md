---
name: rx:plan
description: Create sprint-based implementation spec with parallel research, Iron Law pre-checks, demoable outcomes per sprint, and approval gate. Replaces separate spec/plan workflows.
---

# /rx:plan — Feature Spec

Spawn parallel research agents to analyze the codebase, then produce a sprint-based implementation spec where every sprint results in demoable software.

## Usage

```
/rx:plan Add real-time notifications with WebSocket
/rx:plan Refactor auth flow to use RTK Query
/rx:plan --existing                    # Enhance existing spec with deeper research
/rx:plan --depth deep Add OAuth login  # Extra research agents (4+)
```

## What Happens

1. Parallel research agents scan your codebase (2-8 agents based on feature)
2. Research compressed into summary (you never see the raw output)
3. Iron Law pre-check flags risky approaches BEFORE writing tasks
4. Sprint spec written with demoable outcomes and atomic tasks
5. Review sub-agent validates completeness, sizing, accessibility
6. Presented to you for approval — nothing proceeds until you say go

## Output

Creates `.claude/plans/{slug}/spec.md` — a self-contained sprint spec with:
- Overview and technical approach (informed by research)
- Sprints with demoable outcomes
- Atomic tasks with files, Iron Laws, validation, dependencies
- Success criteria

Research preserved in `.claude/plans/{slug}/research/`

## Agents Spawned

Always: `codebase-analyst`
Conditional: `react-architect`, `redux-rtk-specialist`, `uiux-designer`, `state-architect`, `security-analyzer`, `performance-optimizer`, `accessibility-specialist`, `web-researcher`
