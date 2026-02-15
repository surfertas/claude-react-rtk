---
name: rx:trace
description: Trace component render paths, prop drilling chains, and state flow. Builds visual dependency trees to find unnecessary re-renders and tight coupling.
---

## Trace Modes

### `{component}`: trace a single component
Walk up (find all parents), walk down (find all children), map every prop to its origin.

### `--state {slice}`: trace Redux state consumers
Find every useSelector reading from this slice, map selector → component → render tree.

### `--context {provider}`: trace Context consumers
Find Provider and all useContext consumers, identify wasted re-renders.

### `--event {handler}`: trace event handler effects
Follow: dispatch → reducer → state change → selector → re-render. Map side effects.

## Agent

Delegates to **render-tracer** agent (opus) for multi-file analysis.

## Rules

- Flag every inline arrow function passed as prop (new reference = child re-render)
- Flag every useSelector that selects more than it needs
- Flag every Context consumer that uses <50% of context value fields
- Suggest: React.memo, useMemo, useCallback, selector narrowing, context splitting
