---
name: intent-detection
description: Detect user intent from their first message and suggest the appropriate /rx: workflow command. Loaded automatically on session start.
user-invocable: false
---

# Intent Detection -- Workflow Routing

When user describes work WITHOUT specifying a `/rx:` command, analyze their intent and suggest the appropriate workflow BEFORE starting work.

## Routing Table

| Signal | Detected Intent | Suggest |
|--------|----------------|---------|
| "bug", "error", "crash", "failing", "broken", stack trace | Bug investigation | `/rx:investigate` |
| "add", "implement", "build", "create" + multi-step | New feature | `/rx:plan` |
| "review", "check", "audit" code | Code review | `/rx:review` |
| "fix" + small/specific scope | Quick fix | handle directly or `/rx:quick` |
| "refactor", "clean up", "improve" | Refactoring | `/rx:plan` (needs scope) |
| "research", "how to", "what's the best" | Research | `/rx:research` |
| "evaluate", "compare", "library", "should we use" | Library evaluation | `/rx:research` |
| "test", "spec", "coverage" | Testing | handle directly or `/rx:plan` |
| Describes 1-2 file changes, < 50 lines | Small task | handle directly |
| "performance", "slow", "re-render", "bundle size" | Performance | `/rx:rerender-check` or `/rx:audit` |
| "design", "tokens", "spacing", "colors", "theme" | Design system | `/rx:design` |
| "trace", "render tree", "prop flow", "why re-renders" | Component tracing | `/rx:trace` |
| "circular", "import", "dead code", "coupling" | Boundary analysis | `/rx:boundaries` |
| "tech debt", "TODO", "outdated", "deprecated" | Tech debt | `/rx:techdebt` |
| "document", "jsdoc", "readme", "adr" | Documentation | `/rx:document` |
| "challenge", "stress test", "edge case" | Adversarial review | `/rx:challenge` |
| "that worked", "fixed it", "problem solved" | Knowledge capture | `/rx:compound` |
| "enhance plan", "more detail", "deepen" | Plan enhancement | `/rx:plan --existing` |
| "triage", "which findings", "prioritize fixes" | Finding triage | `/rx:triage` |
| "props audit", "state location", "effect deps" | Props audit | `/rx:props-audit` |
| "deploy", "release", "production" | Pre-deploy | `/rx:verify` |

## Behavior

1. Read user's first message
2. Match against routing table (use keyword + context signals, not exact match)
3. If match found with multi-step workflow: "This looks like [intent]. I'd suggest `[command]` -- want me to run it, or should I just dive in?"
4. If trivial task (typo, single-line fix, config change): skip suggestion, just do it
5. If user already specified a `/rx:` command: follow it, do not re-suggest
6. **NEVER block the user** -- suggestion only, not mandatory

## Confidence Signals

High confidence (suggest immediately):

- Stack trace or error message pasted -> `/rx:investigate`
- "Add [feature] with [multiple components]" -> `/rx:plan`
- "Review my changes" or "check this code" -> `/rx:review`
- "Why does [component] re-render" -> `/rx:trace`
- "Set up design tokens" or "initialize design system" -> `/rx:design init`

Medium confidence (suggest with caveat):

- "Fix [thing]" -- could be quick or complex, suggest based on scope description
- "Update [thing]" -- could be small edit or refactor
- "Improve performance" -- could be `/rx:rerender-check` or `/rx:audit`

Low confidence (just do it):

- Single file mentioned, clear change
- "Change X to Y"
- Configuration or dependency updates

## Complexity Signals

When a task matches a workflow command, check complexity before suggesting:

**Trivial signals** (suggest `/rx:quick` or handle directly):

- Single file mentioned explicitly
- "exclude X from Y", "add X to config", "rename", "change X to Y"
- Problem + solution both stated ("X is wrong, change to Y")
- One-line fix described

**Complex signals** (suggest `/rx:plan` or `/rx:investigate`):

- 3+ modules or files mentioned
- "intermittent", "race condition", "sometimes", "random"
- Stack trace with 5+ frames
- "across", "all", "every" (scope indicators)
- Multiple state domains involved (auth + API + UI)

**Override rule**: If user invokes `/rx:full` but task matches trivial signals:
"This looks like a quick fix. Want `/rx:quick` instead, or stick with the full cycle?"

## Iron Laws

1. **NEVER block on suggestion** -- If user starts explaining, just do the work
2. **One suggestion max** -- Do not re-suggest if user ignores first suggestion
3. **Commands are shortcuts, not gates** -- All work can be done without commands

## Integration

This skill is consulted at session start. It works alongside:

- SessionStart hooks (show plugin loaded message, check for resumable work)
- CLAUDE.md routing instructions (passive reference)
- Individual workflow skills (activated by commands)
