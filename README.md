# React RTK Plugin for Claude Code

> **Early Stage** — This plugin is under active development. Features may change, and rough edges are expected.

A Claude Code plugin for React/Redux Toolkit/TypeScript development with **agentic workflow orchestration**, 21 specialist agents, and Iron Laws enforcement.

Instead of a single AI assistant doing everything in one context window,
this plugin coordinates specialist agents that work in parallel — each
with its own fresh context, domain expertise, and focused task. The result:
deeper analysis, fewer hallucinations, and no context exhaustion on large features.

## Installation

### From GitHub (recommended)

```
# In Claude Code, add the marketplace
/plugin marketplace add surfertas/claude-react-rtk

# Install the plugin
/plugin install react-rtk
```

### From Local Path (for development)

```
git clone https://github.com/surfertas/claude-react-rtk.git

# Option A: Add as local marketplace
/plugin marketplace add ./claude-react-rtk
/plugin install react-rtk

# Option B: Test plugin directly
claude --plugin-dir ./claude-react-rtk/plugins/react-rtk
```

## Getting Started

New to the plugin? Run the interactive tutorial:

```
/rx:intro
```

It walks through the workflow, commands, and features in 4 short sections (~3 min).

## Quick Examples

```
# Just describe what you need — the plugin detects complexity and suggests the right approach
> Fix the re-render loop in the user dashboard

# Plan a feature with parallel research agents, then execute
/rx:plan Add real-time notifications with WebSocket
/rx:work .claude/plans/real-time-notifications/plan.md

# Full autonomous mode — plan, implement, review, capture learnings
/rx:full Add user profile avatars with S3 upload

# 5-agent parallel code review (idioms, security, tests, verification, design)
/rx:review

# Quick implementation — skip ceremony, just code
/rx:quick Add pagination to the users list

# Structured bug investigation with 4 parallel tracks
/rx:investigate Stale data showing after mutation in checkout

# Project health audit across 5 categories
/rx:audit

# Trace component render paths to find re-render cascades
/rx:trace UserDashboard

# Detect unnecessary re-renders (React's N+1)
/rx:rerender-check

# Analyze import graph for circular deps and feature coupling
/rx:boundaries
```

The plugin auto-loads domain knowledge based on what files you're editing
(React patterns for `.tsx`, RTK patterns for store files, accessibility rules for form code)
and enforces [Iron Laws](#iron-laws-non-negotiable-rules) that prevent common React/RTK mistakes.

## Lifecycle Hooks

The plugin includes **lifecycle hooks** that run automatically — no configuration needed:

**On session start:**
- Detects incomplete plans and suggests resuming (`/rx:work ...`)
- Warns if your branch is behind `origin/main`
- Shows scratchpad notes from previous sessions
- Checks for running dev server (ports 3000, 5173, 8080)

**On every file edit:**
- Checks Prettier formatting (warn-only, never auto-fixes)
- Injects Security Iron Laws (#21-24) when editing auth/token/credential files
- Logs file modifications to active plan's `progress.md`
- Blocks auto-implementation after plan creation (forces user approval)

**Before context compaction:**
- Re-injects active plan context and phase-specific rules so they survive compaction
- Preserves plan slug, intent, and workflow discipline across long sessions

**On session exit:**
- Warns about plans with uncompleted tasks

## How It Works

### The Lifecycle

The plugin implements a **Plan, Work, Review, Compound** lifecycle. Each phase produces artifacts in a namespaced directory:

```
/rx:plan → /rx:work → /rx:review → /rx:compound
     │           │            │              │
     ↓           ↓            ↓              ↓
plans/{slug}/  (in namespace) (in namespace) solutions/
```

- **Plan** — Research agents analyze your codebase in parallel, then synthesize a structured implementation plan
- **Work** — Execute the plan task-by-task with automatic verification after each change
- **Review** — Five specialist agents audit your code in parallel (idioms, security, tests, build verification, design)
- **Compound** — Capture what you learned as reusable knowledge for future sessions

### Key Concepts

- **Filesystem is the state machine.** Each phase reads from the previous phase's output. No hidden state.
- **Plan namespaces.** Each plan owns all its artifacts in `.claude/plans/{slug}/` — plan, research, reviews, progress, scratchpad.
- **Plan checkboxes track progress.** `[x]` = done, `[ ]` = pending. `/rx:work` finds the first unchecked task and continues.
- **One plan = one work unit.** Large features get split into multiple plans. Each is self-contained.
- **Agents are automatic.** The plugin spawns specialist agents behind the scenes. You don't manage them directly.

### Plan Namespaces

Every plan gets its own directory with all related artifacts:

```
.claude/
├── plans/{slug}/          # Everything for ONE plan
│   ├── plan.md            # The plan itself (checkboxes = state)
│   ├── research/          # Research agent output
│   ├── reviews/           # Review findings (individual tracks)
│   ├── summaries/         # Compressed multi-agent output
│   ├── progress.md        # Session progress log
│   └── scratchpad.md      # Auto-written decisions, dead-ends, handoffs
├── reviews/               # Ad-hoc reviews (no plan context)
├── solutions/             # Compound knowledge (reusable across plans)
├── traces/                # Render trace output (/rx:trace)
└── adrs/                  # Architecture Decision Records (/rx:document --adr)
```

### How Planning Works

When you run `/rx:plan Add real-time notifications`:

```
1. planning-orchestrator analyzes your request
   │
2. Spawns specialists IN PARALLEL based on feature needs:
   ├── codebase-analyst        (always — scans your project)
   ├── react-architect         (if component structure needed)
   ├── redux-rtk-specialist    (if state management involved)
   ├── state-architect         (if state location decisions needed)
   ├── security-analyzer       (if auth/user data involved)
   ├── web-researcher          (if unfamiliar technology)
   └── ... up to 8 agents
   │
3. Each agent writes to plans/{slug}/research/{topic}.md
   │
4. context-supervisor compresses all research into one summary
   │
5. Orchestrator reads the summary + synthesizes the plan
   │
6. Output: plans/{slug}/plan.md with checkboxes
```

### How Review Works

When you run `/rx:review`:

```
1. parallel-reviewer collects your git diff
   │
2. Delegates to 5 EXISTING specialist agents:
   ├── react-reviewer       → Idioms, patterns, hooks usage
   ├── security-analyzer    → XSS, secrets in bundle, URL param injection
   ├── testing-reviewer     → Test coverage, RTL patterns, MSW usage
   ├── verification-runner  → tsc, eslint, prettier, vitest/jest
   └── uiux-designer        → Design tokens, states, spacing, contrast
   │
3. Each writes to plans/{slug}/reviews/{track}.md
   │
4. context-supervisor deduplicates + consolidates
   │
5. Output: plans/{slug}/summaries/review-consolidated.md
```

### The Context Supervisor Pattern

When an orchestrator spawns 4-8 research agents, their combined output can exceed 50k tokens — flooding the parent's context window. The **context-supervisor** solves this using an OTP-inspired pattern:

```
┌────────────────────────────────────────────────────────┐
│  Orchestrator (thin coordinator, ~10k context)         │
│  Only reads: summaries/consolidated.md                 │
└──────────────────┬─────────────────────────────────────┘
                   │ spawns AFTER workers finish
┌──────────────────▼─────────────────────────────────────┐
│  context-supervisor (haiku, fresh 200k context)        │
│  Reads: all worker output files                        │
│  Applies: compression strategy based on size           │
│  Validates: every input file represented               │
│  Writes: summaries/consolidated.md                     │
└──────────────────┬─────────────────────────────────────┘
                   │ reads from
     ┌─────────────┼─────────────┐
     ▼             ▼             ▼
  worker 1      worker 2      worker N
  research/     research/     research/
  patterns.md   security.md   state.md
```

**Compression thresholds:**

| Total Output | Strategy | Compression | What's Kept |
|---|---|---|---|
| Under 8k tokens | Index | ~100% | Full content with file list |
| 8k - 30k tokens | Compress | ~40% | Key findings, decisions, risks |
| Over 30k tokens | Aggressive | ~20% | Only critical items |

## Usage Guide

### Quick tasks (bug fixes, small changes)

Just describe what you need. The plugin auto-detects complexity:

```
> Fix the N+1 selector in the dashboard

Claude: This is a simple fix (score: 2). I'll handle it directly.
```

Or use `/rx:quick` to skip ceremony:

```
/rx:quick Add pagination to the users list
```

### Medium tasks (new features, refactors)

Use `/rx:plan` then `/rx:work`:

```
/rx:plan Add email notifications for new comments
```

For 5+ task plans, start `/rx:work` in a **fresh session** — the plan file is self-contained:

```
# In a new Claude Code session:
/rx:work .claude/plans/email-notifications/plan.md
```

### Large tasks (new domains, complex features)

Use deep research planning:

```
/rx:plan Add OAuth login with Google and GitHub --depth deep
```

Or use `/rx:full` for fully autonomous development:

```
/rx:full Add user profile avatars with S3 upload
```

### Fixing review issues

After implementing, run a review:

```
/rx:review
```

If blockers are found, triage them:

```
/rx:triage
```

This walks through each finding interactively — fix now, defer, or dismiss with rationale.

### Performance analysis

```
/rx:rerender-check              # Find unnecessary re-renders
/rx:trace UserDashboard         # Trace render paths and prop flow
/rx:props-audit src/Dashboard   # Audit state location and effect deps
```

### Codebase health

```
/rx:audit                       # Full 5-category health check
/rx:boundaries                  # Import graph analysis
/rx:techdebt                    # Find debt, outdated deps, abandoned TODOs
/rx:challenge                   # Adversarial "grill me" mode
```

### Learning from mistakes

After fixing a bug or receiving a correction:

```
/rx:learn Fixed stale closure — useCallback deps must include all referenced state
```

This updates `.claude/solutions/common-mistakes.md` so the same mistake is prevented in future sessions.

## Iron Laws (Non-Negotiable Rules)

The plugin enforces critical rules and **stops with an explanation** if code would violate them:

**React:** No useEffect for derived state. No index as key. ErrorBoundary for every route. No async in useEffect without cleanup. No mutating array methods on state/props. No `&&` rendering with falsy values. Idempotent app initialization.

**Redux/RTK:** No non-serializable values in store. RTK Query over manual fetching. Always createSelector for derived data. Never spread entire slice.

**UI/UX:** Semantic HTML before ARIA. No color as sole indicator. Touch targets minimum 44×44px. No layout shift on load.

**Security:** No dangerouslySetInnerHTML with untrusted content. No secrets in client bundle. Sanitize all URL parameters used in state. Every Server Action must verify authentication.

See [CLAUDE.md](CLAUDE.md) for the full list with explanations.

## Commands Reference

### Workflow

| Command | Description |
|---------|-------------|
| `/rx:full <feature>` | Full autonomous cycle (plan, work, review, compound) |
| `/rx:plan <input>` | Create implementation plan with specialist agents |
| `/rx:plan --existing` | Enhance existing plan with deeper research |
| `/rx:work <plan-file>` | Execute plan tasks with verification |
| `/rx:review [focus]` | Multi-agent code review (5 parallel agents) |
| `/rx:compound` | Capture solved problem as reusable knowledge |
| `/rx:triage` | Interactive triage of review findings |
| `/rx:document` | Generate JSDoc/TSDoc, README, ADRs, Storybook stories |
| `/rx:learn <lesson>` | Capture lessons learned |

### Utility

| Command | Description |
|---------|-------------|
| `/rx:intro` | Interactive plugin tutorial (4 sections, ~3 min) |
| `/rx:quick <task>` | Fast implementation, skip ceremony |
| `/rx:investigate <bug>` | Systematic bug debugging (4 parallel tracks) |
| `/rx:research <topic>` | Research React/frontend topics on the web |
| `/rx:verify` | Run full verification (tsc, eslint, prettier, test, build) |
| `/rx:trace <component>` | Build render trees to trace prop and state flow |
| `/rx:boundaries` | Analyze import graph for circular deps and coupling |
| `/rx:design` | Design system initialization, audit, token management |

### Analysis

| Command | Description |
|---------|-------------|
| `/rx:rerender-check` | Detect unnecessary re-render patterns |
| `/rx:props-audit <file>` | Audit props, state, effects, refs |
| `/rx:techdebt` | Find technical debt and refactoring opportunities |
| `/rx:audit` | Full project health audit with 5 parallel agents |
| `/rx:challenge` | Adversarial review — stress-test ("grill me") |

## Agents (21)

| Agent | Model | Memory | Role |
|-------|-------|--------|------|
| **workflow-orchestrator** | opus | project | Full cycle coordination (plan, work, review) |
| **planning-orchestrator** | opus | project | Parallel research agent coordination |
| **parallel-reviewer** | opus | — | 5-agent parallel code review |
| **deep-bug-investigator** | opus | — | 4-track parallel bug investigation |
| **render-tracer** | opus | — | Component render path and prop flow tracing |
| **security-analyzer** | opus | — | OWASP vulnerability scanning |
| **context-supervisor** | haiku | — | Multi-agent output compression |
| **verification-runner** | haiku | — | tsc, eslint, prettier, test, build |
| **iron-law-judge** | haiku | — | Pattern-based Iron Law detection |
| **import-analyzer** | haiku | — | Module dependency and circular import analysis |
| **npm-researcher** | haiku | — | npm package evaluation |
| **react-architect** | sonnet | — | Component structure, hooks, composition |
| **redux-rtk-specialist** | sonnet | project | Store shape, RTK Query, selectors |
| **state-architect** | sonnet | — | State location decisions (local vs Redux vs Context) |
| **uiux-designer** | sonnet | project | Design tokens, spacing, color, responsive |
| **react-reviewer** | sonnet | — | JSX idioms, patterns, conventions |
| **testing-reviewer** | sonnet | — | RTL, MSW, component/hook test patterns |
| **performance-optimizer** | sonnet | — | Bundle, lazy load, memo, virtualization |
| **accessibility-specialist** | sonnet | — | WCAG, keyboard nav, screen reader |
| **codebase-analyst** | sonnet | project | File patterns, import graph, dead code |
| **web-researcher** | sonnet | — | npm, MDN, GitHub, Stack Overflow |

Agents with `project` memory build up knowledge across sessions
in `.claude/agent-memory/<agent-name>/`. Orchestrators remember
architectural decisions; codebase-analyst skips redundant discovery.

## Reference Skills (Auto-Loaded)

These load automatically based on file context — no commands needed:

| Skill | Triggers On |
|-------|-------------|
| `react-patterns` | Any `.tsx`/`.jsx` file |
| `redux-rtk` | Store files, slices, `createApi`, `useSelector` |
| `uiux-design` | Component files, style files, design tokens |
| `testing` | `*.test.tsx` files, MSW handlers |
| `performance` | Large components, list renders, memo usage |
| `accessibility` | ARIA attributes, form elements, interactive elements |
| `intent-detection` | Session start — routes natural language to `/rx:` commands |

## Requirements

- Claude Code CLI
- React/TypeScript project

### Optional

- **[ccrider](https://github.com/neilberkman/ccrider)** for session analysis (see Contributing)

## Contributing

PRs welcome! See [CLAUDE.md](CLAUDE.md) for development conventions.

### Development rules

- Skills: ~100 lines SKILL.md + `references/` for details
- Agents: under 300 lines, `disallowedTools` for reviewers
- All markdown passes `npm run lint`

### Analyze your sessions to improve the plugin

The plugin includes session analysis tools that help identify improvement opportunities.

**Setup:**

1. Clone this repo
2. Install [ccrider MCP](https://github.com/neilberkman/ccrider): `claude mcp add ccrider -- npx @neilberkman/ccrider`

**Available tools** (dev-only, not shipped with the plugin):

```
# Browse and search your sessions
/find-sessions
/find-sessions "React performance"
/find-sessions --project myapp

# Analyze a specific session
/analyze-session abc12345
/analyze-session --last

# Full pipeline: search + analyze + synthesize
/session-insights "all my React RTK sessions"
/session-insights --project myapp
/session-insights "debugging sessions" --after 2026-01-15
```

### What session analysis finds

- **Friction points** — where you got stuck, repeated commands, abandoned approaches
- **Workflow patterns** — how you work (planning vs diving in, tool usage)
- **Plugin improvement opportunities** — missing automation, skills, or Iron Laws

Each report includes a **Plugin Improvement Opportunities** section identifying
manual workflows that could be automated, code patterns that caused bugs but the
plugin doesn't catch (Iron Law candidates), and auto-loading gaps.

## Acknowledgments

This plugin's architecture — the agentic workflow orchestration, context supervisor pattern, Iron Laws enforcement, plan namespace structure, and multi-agent review pipeline — is directly inspired by [claude-elixir-phoenix](https://github.com/oliver-kriska/claude-elixir-phoenix) by [Oliver Kriska](https://github.com/oliver-kriska). That project demonstrated how Claude Code plugins could coordinate specialist agents at scale, and this plugin adapts those patterns for the React/Redux Toolkit ecosystem.

### Other sources of inspiration

- [agent-skills](https://github.com/vercel-labs/agent-skills) — Vercel's React best practices rules (Iron Laws 8-10, 24, skill enrichments)
- [ccrider](https://github.com/neilberkman/ccrider) — Session analysis MCP
- [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
- [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
- [Claude Code](https://github.com/anthropics/claude-code)
- [Shape Up](https://basecamp.com/shapeup)

## License

MIT
