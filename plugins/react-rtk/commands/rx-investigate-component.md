---
name: rx:investigate
description: Structured bug debugging with parallel investigation tracks — state, rendering, network, and environment.
---

# /rx:investigate — Bug Investigation

## Usage

```
/rx:investigate Users list shows stale data after mutation
/rx:investigate Component re-renders infinitely on this page
/rx:investigate Form submission fails silently
```

## Parallel Tracks

1. **State track** — Redux DevTools timeline, selector output, cache state
2. **Render track** — Component tree, re-render count, prop changes
3. **Network track** — API calls, response data, cache invalidation
4. **Environment track** — Console errors, dependency versions, browser compat

---
name: rx:component
description: Generate a new component with proper structure — types, tests, stories, accessibility.
---

# /rx:component — Generate Component

## Usage

```
/rx:component UserCard --variant compact,full --interactive
/rx:component DataTable --generic --with-pagination
/rx:component Modal --accessible --with-focus-trap
```

## Generates

- `{Name}.tsx` — Component with typed props, all visual states
- `{Name}.test.tsx` — RTL tests for render + interaction + accessibility
- `{Name}.module.css` — Styles using design tokens (or Tailwind classes)
- Types exported from component file

## Flags

- `--variant` — Generate variant prop with specified options
- `--generic` — TypeScript generic component
- `--interactive` — Include keyboard handlers and ARIA
- `--accessible` — Extra accessibility audit
- `--with-*` — Include specific sub-features (pagination, focus-trap, etc.)
