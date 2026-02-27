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

### Waterfall Elimination

Sequential awaits are the #1 server performance killer. Independent async operations must run in parallel.

```typescript
// BAD: sequential — total time = a + b + c
const users = await getUsers();
const posts = await getPosts();
const comments = await getComments();

// GOOD (async-parallel): parallel — total time = max(a, b, c), 2-10x faster
const [users, posts, comments] = await Promise.all([
  getUsers(),
  getPosts(),
  getComments(),
]);

// GOOD (async-dependencies): start early, await late
const usersPromise = getUsers();       // starts immediately
const config = await getConfig();       // needed first
const users = await usersPromise;       // already in flight

// GOOD (async-api-routes): kick off fetches before unrelated work
export async function GET(request: Request) {
  const dataPromise = fetchExternalData();  // start fetch
  const session = await getSession();       // do auth meanwhile
  if (!session) return unauthorized();
  const data = await dataPromise;           // fetch likely done already
  return Response.json(data);
}

// GOOD (async-defer-await): await only in branches that need the value
const resultPromise = expensiveComputation();
if (condition) {
  return quickPath();                       // never awaits
}
const result = await resultPromise;         // only awaited when needed
```

**`async-suspense-boundaries`**: Wrap async Server Components in `<Suspense>` to stream progressively. Without boundaries, the entire page blocks on the slowest component.

```tsx
// BAD: entire page waits for slowest component
export default async function Page() {
  return (
    <div>
      <SlowChart />    {/* 3s — blocks everything */}
      <FastSidebar />  {/* 100ms — waits for chart */}
    </div>
  );
}

// GOOD: fast parts stream immediately, slow parts show fallback
export default function Page() {
  return (
    <div>
      <Suspense fallback={<ChartSkeleton />}>
        <SlowChart />
      </Suspense>
      <FastSidebar />  {/* renders immediately */}
    </div>
  );
}
```

### Bundle Optimization

```typescript
// bundle-conditional: dynamic import inside event handler / feature flag
const handleExport = async () => {
  const { exportToPDF } = await import('./exportToPDF');
  exportToPDF(data);
};

// bundle-defer-third-party: load analytics AFTER hydration
useEffect(() => {
  import('./analytics').then(({ init }) => init());
}, []);
// Or Next.js: <Script src="analytics.js" strategy="afterInteractive" />

// bundle-preload: preload on hover for perceived instant navigation
<Link
  href="/dashboard"
  prefetch={true}                    // Next.js built-in
  onMouseEnter={() => import('./pages/Dashboard')}  // manual preload
>
  Dashboard
</Link>
```

### Rendering Performance

```css
/* rendering-content-visibility: skip rendering of off-screen sections */
.long-list-item {
  content-visibility: auto;
  contain-intrinsic-size: auto 200px;  /* estimated height */
}
```

**`rendering-hydration-no-flicker`**: Inline a small `<script>` for client-only data (theme, auth state) to prevent FOUC. The script runs before React hydrates.

```html
<!-- In <head> or before React root -->
<script>
  // Prevents theme flash — runs before paint
  document.documentElement.dataset.theme =
    localStorage.getItem('theme') || 'system';
</script>
```

For detailed patterns, see `references/` directory.
