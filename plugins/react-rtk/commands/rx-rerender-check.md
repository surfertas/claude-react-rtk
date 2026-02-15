---
name: rx:rerender-check
description: Detect unnecessary re-render patterns — the React equivalent of N+1 queries. Finds components that re-render when they shouldn't.
---

## What It Checks

- **Selector over-selection**: useSelector returning more state than component uses
- **Missing memoization**: inline objects/functions/computations creating new refs
- **Context over-consumption**: useContext reading fields the component doesn't use
- **Prop drilling triggers**: parent creating new refs that cascade re-renders to children

## Arguments

- No args: scan all components
- `{path}`: scan a specific file or directory
- `--fix`: auto-apply safe fixes (React.memo, extract selectors, useMemo/useCallback)

## Severity

- **CRITICAL**: causes cascade re-renders (parent → multiple children)
- **WARNING**: individual component waste
