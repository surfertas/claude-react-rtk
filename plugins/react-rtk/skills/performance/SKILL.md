---
name: performance
description: React performance patterns — memoization, code splitting, RTK Query cache tuning, Core Web Vitals. Use when working with React.memo, useMemo, useCallback, lazy loading, or optimizing render performance.
---

## Quick Reference

### Memoization Rules
- NEVER memoize without profiling evidence
- `React.memo`: only when component receives same props but parent re-renders
- `useMemo`: only for expensive computations (>1ms) with stable deps
- `useCallback`: only when passed as prop to memoized child component
- If you can't explain WHY it needs memoization, remove it

### Code Splitting
```typescript
// Route-level splitting (always do this)
const Dashboard = React.lazy(() => import('./pages/Dashboard'));
// Next.js
const Chart = dynamic(() => import('./components/Chart'), { ssr: false });
```

### RTK Query Performance
```typescript
// ✅ selectFromResult — only re-render when YOUR data changes
const { user } = useGetUsersQuery(undefined, {
  selectFromResult: ({ data }) => ({ user: data?.find(u => u.id === id) }),
});

// ✅ Appropriate cache times
keepUnusedDataFor: 300,     // 5 min for stable data
pollingInterval: 30000,     // 30s for live data
refetchOnMountOrArgChange: 60, // re-fetch if >60s stale
```

### Barrel Imports
```typescript
// BAD: imports entire library (200-800ms in dev)
import { Check, X, ChevronDown } from 'lucide-react';
// GOOD: direct imports
import Check from 'lucide-react/dist/esm/icons/check';
// GOOD: Next.js optimizePackageImports
// next.config.js: experimental: { optimizePackageImports: ['lucide-react'] }
```

Known barrel-heavy libraries: `lucide-react`, `@mui/material`, `lodash`, `date-fns`, `react-icons`.

### React Compiler
If React Compiler is enabled (`babel-plugin-react-compiler` or `react-compiler-runtime` in deps), `memo()`, `useMemo()`, `useCallback()` are handled automatically. Remove manual memoization to reduce noise.

### Core Web Vitals Targets
- LCP < 2.5s | INP < 200ms | CLS < 0.1

For detailed patterns, see `references/` directory.
