---
name: rx:props-audit
description: Audit component props and state — oversized props, missing defaults, state that should live elsewhere, effect dependency issues.
---

## What It Checks

- **State location**: is this useState server data (→ RTK Query)? derivable (→ useMemo)? cross-component (→ Redux)?
- **Props health**: >8 fields, missing defaults, `any` types, always-together groups
- **Ref audit**: correct DOM measurement vs mutable state escape hatch
- **Effect dependencies**: missing deps, unstable refs, missing cleanup

## Arguments

- `{file}`: audit a specific component
- No args: audit all components in src/components/
- `--state-only`: only check state location
- `--effects-only`: only check useEffect dependencies
