---
name: rx:compound
description: Capture solved problem as reusable knowledge in .claude/solutions/. Makes patterns available for future sessions.
---

# /rx:compound — Capture Knowledge

## Usage

```
/rx:compound
```

Runs after a feature is complete. Extracts:
- What pattern was used and why
- What didn't work (dead-ends from scratchpad)
- Reusable code patterns (hooks, components, RTK Query patterns)
- Iron Law violations found and fixed

Writes to `.claude/solutions/{topic}.md`

---
name: rx:learn
description: Quick lesson capture — add a mistake or insight to the knowledge base.
---

# /rx:learn — Capture Lesson

## Usage

```
/rx:learn Always use selectFromResult with RTK Query hooks to prevent unnecessary re-renders
/rx:learn ErrorBoundary must wrap Suspense, not the other way around
/rx:learn Never use useLayoutEffect in server components — causes hydration mismatch
```

Appends to `.claude/solutions/common-mistakes.md` for future sessions.
