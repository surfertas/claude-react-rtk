# React/Redux Toolkit Plugin for Claude Code

## Overview

Agentic workflow orchestration for React/Redux Toolkit/TypeScript development.
21 specialist agents, Iron Laws enforcement, UI/UX design system integration.

Plan → Work → Review → Compound lifecycle with parallel agent coordination.

## Architecture

```
                    ┌──────────────────────────────┐
                    │  Orchestrators (opus model)   │
                    │  Coordinate phases, spawn     │
                    │  specialists, manage flow     │
                    └──────────┬───────────────────┘
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐  ┌───────────────────┐  ┌────────────────────┐
│ workflow-     │  │ planning-         │  │ parallel-          │
│ orchestrator  │  │ orchestrator      │  │ reviewer           │
│ (full cycle)  │  │ (research phase)  │  │ (review phase)     │
└───────────────┘  └───────────────────┘  └────────────────────┘
                               │                      │
                    ┌──────────┼──────────┐    ┌──────┼──────┐
                    ▼          ▼          ▼    ▼      ▼      ▼
             ┌──────────┐ ┌────────┐ ┌──────┐ ... 5 specialist
             │ react    │ │ redux  │ │ uiux │     review agents
             │ architect│ │ rtk    │ │ dsgn │
             └──────────┘ └────────┘ └──────┘
                               │
                    ┌──────────┴──────────┐
                    ▼                     ▼
             ┌────────────┐      ┌──────────────┐
             │  context-  │      │ Orchestrator  │
             │ supervisor │ ───► │ reads ONLY    │
             │  (haiku)   │      │ the summary   │
             └────────────┘      └──────────────┘
```

## Iron Laws (Non-Negotiable)

These rules BLOCK the pipeline. Code violating them does not proceed.

### React Iron Laws

1. **No useEffect for derived state.** If it can be computed from props/state, compute it during render. useEffect is for synchronizing with external systems ONLY.
2. **No index as key in dynamic lists.** Keys must be stable, unique identifiers. Index keys break reconciliation on reorder/insert/delete.
3. **No nested interactive elements.** Never put `<button>` inside `<a>`, or `<a>` inside `<button>`. Violates HTML spec and breaks assistive tech.
4. **No direct DOM manipulation in components.** Use refs for measurement only. Never `document.querySelector` inside React components.
5. **No state updates in render.** setState calls during render cause infinite loops. Move to useEffect or event handlers.
6. **No async in useEffect without cleanup.** Every async operation in useEffect must handle the unmounted case. Use AbortController or boolean flag.
7. **ErrorBoundary for every route.** Each route-level component must be wrapped. Uncaught errors should never crash the full app.
8. **No mutating array methods on state or props.** `.sort()`, `.reverse()`, `.splice()` mutate in place, breaking React's immutability contract. Use `.toSorted()`, `.toReversed()`, `.toSpliced()`, or spread-then-mutate.
9. **No `&&` rendering with numeric or falsy values.** `{count && <Badge/>}` renders `0` as visible text when count is 0. Use explicit ternary or `> 0` check.
10. **App-wide initialization must be idempotent.** `useEffect([], ...)` runs twice in Strict Mode. Use a module-level guard or run initialization outside components.

### Redux/RTK Iron Laws

11. **No non-serializable values in store.** No functions, classes, Promises, Symbols, Maps, Sets in Redux state. Store must be JSON-serializable.
12. **No raw async in reducers.** All async logic goes through createAsyncThunk or RTK Query. Reducers are pure synchronous functions.
13. **No component/UI state in Redux.** Modal open/close, form input values, hover states, scroll position — these are local state (useState). Redux is for server cache and cross-component shared state.
14. **Always use createSelector for derived data.** Selectors that compute/filter/transform must use createSelector (reselect). Prevents unnecessary re-renders.
15. **RTK Query over manual fetching.** If RTK Query is in the project, ALL server state goes through RTK Query. No useEffect + fetch patterns alongside it.
16. **Never spread entire slice into component.** `useSelector(state => state.users)` pulls the entire slice. Select only the specific fields needed.

### UI/UX Iron Laws

17. **Semantic HTML before ARIA.** Use `<button>`, `<nav>`, `<main>`, `<dialog>` before reaching for `role=""` or `aria-*`. Native elements have built-in keyboard and screen reader support.
18. **No color as sole indicator.** Every state communicated by color must also use icon, text, or pattern. 8% of men have color vision deficiency.
19. **Touch targets minimum 44×44px.** Interactive elements must meet WCAG 2.5.5 (AAA) / Apple HIG. WCAG 2.5.8 (AA) requires 24×24px minimum. No 16px icon buttons without expanded hit area.
20. **No layout shift on load.** Reserve dimensions for images, embeds, dynamic content. CLS > 0.1 is a failure.

### Security Iron Laws

21. **No dangerouslySetInnerHTML with untrusted content.** If the string comes from user input, API, or URL params, it MUST be sanitized with DOMPurify first. No exceptions.
22. **No secrets in client bundle.** API keys, tokens, credentials never go in React code. Use server-side API routes or environment variables that aren't prefixed with NEXT_PUBLIC_/VITE_.
23. **Sanitize all URL parameters used in state.** Any value from useSearchParams, useParams, or window.location that enters state or renders must be validated.
24. **Every Server Action must verify authentication.** `"use server"` functions are public HTTP endpoints. Never rely solely on middleware or layout guards.

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
| `/rx:learn <lesson>` | Capture lessons learned into common-mistakes.md |

### Utility

| Command | Description |
|---------|-------------|
| `/rx:intro` | Interactive plugin tutorial (~3 min) |
| `/rx:quick <task>` | Fast implementation, skip ceremony |
| `/rx:investigate <bug>` | 4-track parallel bug debugging (state, render, network, env) |
| `/rx:research <topic>` | Web research for React/frontend topics and libraries |
| `/rx:verify` | Run full verification (TypeScript, ESLint, Prettier, tests, build) |
| `/rx:trace <component>` | Build render trees, trace prop flow and state subscriptions |
| `/rx:boundaries` | Analyze import graph — circular deps, feature coupling, dead exports |
| `/rx:design` | Design system initialization, audit, token management |

### Analysis

| Command | Description |
|---------|-------------|
| `/rx:rerender-check` | Detect unnecessary re-render patterns (React's N+1) |
| `/rx:props-audit <file>` | Audit props, state location, effect dependencies, ref usage |
| `/rx:techdebt` | Find tech debt — deprecated patterns, TODOs, outdated deps |
| `/rx:audit` | Full project health audit with 5 parallel agents |
| `/rx:challenge` | Adversarial review — stress-test with edge cases and race conditions |

## Agents (21)

| Agent | Model | Memory | Role |
|-------|-------|--------|------|
| **workflow-orchestrator** | opus | project | Full cycle coordination (plan, work, review) |
| **planning-orchestrator** | opus | project | Parallel research agent coordination |
| **parallel-reviewer** | opus | — | 5-agent parallel code review |
| **deep-bug-investigator** | opus | — | 4-track parallel bug investigation |
| **render-tracer** | opus | — | Component render path and prop flow tracing |
| **security-analyzer** | opus | — | OWASP vulnerability scanning, XSS/CSRF detection |
| **context-supervisor** | haiku | — | Multi-agent output compression |
| **verification-runner** | haiku | — | TypeScript, ESLint, Prettier, tests, build |
| **iron-law-judge** | haiku | — | Pattern-based Iron Law detection |
| **import-analyzer** | haiku | — | Circular deps, feature coupling, dead exports |
| **npm-researcher** | haiku | — | npm package evaluation and comparison |
| **react-architect** | sonnet | — | Component structure, hooks, composition patterns |
| **redux-rtk-specialist** | sonnet | project | Store shape, RTK Query, selectors, middleware |
| **state-architect** | sonnet | — | State location decisions (local vs Redux vs Context) |
| **uiux-designer** | sonnet | project | Design system, tokens, spacing, accessibility |
| **react-reviewer** | sonnet | — | JSX idioms, patterns, conventions |
| **testing-reviewer** | sonnet | — | RTL, MSW, component/hook testing patterns |
| **performance-optimizer** | sonnet | — | Bundle size, lazy loading, memoization, virtualization |
| **accessibility-specialist** | sonnet | — | WCAG compliance, keyboard nav, screen reader support |
| **codebase-analyst** | sonnet | project | File patterns, import graph, dead code |
| **web-researcher** | sonnet | — | npm, MDN, GitHub, Stack Overflow research |

Agents with `project` memory persist knowledge in `.claude/agent-memory/<agent-name>/`.
Orchestrators remember architectural decisions; codebase-analyst skips redundant discovery.

## Development Conventions

### File Organization

```
src/
├── app/                    # Route pages (Next.js App Router) or entry
├── components/
│   ├── ui/                 # Design system primitives (Button, Input, Card)
│   ├── layout/             # Layout components (Header, Sidebar, Footer)
│   ├── features/           # Feature-specific composed components
│   └── providers/          # Context providers, theme, auth wrappers
├── hooks/                  # Custom hooks (useDebounce, useMediaQuery)
├── store/
│   ├── slices/             # RTK slices (one file per domain)
│   ├── api/                # RTK Query API definitions
│   ├── middleware/          # Custom middleware
│   ├── selectors/          # Cross-slice selectors
│   └── store.ts            # Store configuration
├── types/                  # Shared TypeScript types/interfaces
├── utils/                  # Pure utility functions
├── lib/                    # Third-party integrations, SDK wrappers
├── styles/                 # Global styles, theme tokens, CSS modules
└── __tests__/              # Test utilities, MSW handlers, fixtures
```

### Naming Conventions

- Components: PascalCase (`UserProfile.tsx`)
- Hooks: camelCase with `use` prefix (`useAuth.ts`)
- Slices: camelCase with `Slice` suffix (`userSlice.ts`)
- API definitions: camelCase with `Api` suffix (`usersApi.ts`)
- Types: PascalCase, no `I` prefix (`UserProfile`, not `IUserProfile`)
- Test files: same name + `.test.tsx` (`UserProfile.test.tsx`)
- CSS modules: same name + `.module.css` (`UserProfile.module.css`)

### Component Patterns

```typescript
// ✅ Correct: Props interface, default export, explicit return type
interface UserCardProps {
  user: User;
  onSelect?: (id: string) => void;
  variant?: 'compact' | 'full';
}

export default function UserCard({ user, onSelect, variant = 'compact' }: UserCardProps) {
  // derived state computed in render — no useEffect
  const displayName = user.firstName && user.lastName
    ? `${user.firstName} ${user.lastName}`
    : user.email;

  return (/* ... */);
}
```

### Redux/RTK Patterns

```typescript
// ✅ Correct: RTK Query API definition
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

export const usersApi = createApi({
  reducerPath: 'usersApi',
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  tagTypes: ['User'],
  endpoints: (builder) => ({
    getUsers: builder.query<User[], void>({
      query: () => 'users',
      providesTags: ['User'],
    }),
    updateUser: builder.mutation<User, Partial<User> & Pick<User, 'id'>>({
      query: ({ id, ...patch }) => ({
        url: `users/${id}`,
        method: 'PATCH',
        body: patch,
      }),
      invalidatesTags: ['User'],
    }),
  }),
});
```

### Testing Patterns

```typescript
// ✅ Correct: RTL + MSW + store wrapper
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';
import { renderWithProviders } from '../test-utils';

const server = setupServer(
  http.get('/api/users', () => HttpResponse.json([mockUser]))
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test('displays user name after loading', async () => {
  renderWithProviders(<UserList />);
  expect(await screen.findByText('Jane Doe')).toBeInTheDocument();
});
```

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

## Agent Memory

Agents with `project` memory persist knowledge in `.claude/agent-memory/<agent-name>/`.

- `planning-orchestrator`: architectural decisions, feature history
- `redux-rtk-specialist`: store shape, normalization patterns, API contracts
- `uiux-designer`: design tokens, spacing scale, color decisions
- `codebase-analyst`: file patterns, import graph, dead code

## Plan Namespace

```
.claude/
├── plans/{slug}/
│   ├── plan.md              # The plan (checkboxes = progress state)
│   ├── research/
│   │   └── *.md             # Agent research output
│   ├── reviews/             # Review track findings
│   ├── summaries/           # Compressed multi-agent output
│   ├── progress.md          # Session log
│   └── scratchpad.md        # Iron Law adjustments, dead-ends, decisions
├── reviews/                 # Ad-hoc reviews (no plan context)
├── solutions/               # Compound knowledge (reusable across plans)
├── traces/                  # Render trace output
└── adrs/                    # Architecture Decision Records
```

## Session Analysis

For plugin improvement, analyze your own Claude Code sessions to find friction
points, repeated mistakes, and missing automation.

**Setup:**

1. Clone the plugin repo
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

Each analysis report includes a **Plugin Improvement Opportunities** section
identifying manual workflows that could be automated, code patterns that caused
bugs but the plugin doesn't catch, and auto-loading gaps where skills should
trigger but don't.
