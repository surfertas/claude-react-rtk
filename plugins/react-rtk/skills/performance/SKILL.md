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

### Core Web Vitals Targets
- LCP < 2.5s | INP < 200ms | CLS < 0.1

For detailed patterns, see `references/` directory.
