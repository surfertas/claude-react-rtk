---
name: react-patterns
description: React component patterns, hooks rules, composition patterns. Use when editing .tsx/.jsx files, working in components/ or hooks/ directories, or creating new React components.
---

## Quick Reference

### Component Patterns
- Functional components ONLY (no class components in new code)
- Props interface above component (not inline)
- Default export for page components, named exports for everything else
- Destructure props in function signature
- Early returns for conditional rendering (not nested ternaries)

### Hook Rules
- Only call hooks at top level (never inside conditions, loops, callbacks)
- Custom hooks: `use` prefix, return typed tuple or object
- `useEffect` cleanup: always clean up subscriptions, timers, AbortControllers
- `useEffect` deps: include ALL values from component scope that change over time
- `useState` vs `useReducer`: 3+ related state values → useReducer

### Common Patterns

```typescript
// ✅ Compound component
<Tabs defaultValue="profile">
  <Tabs.List>
    <Tabs.Trigger value="profile">Profile</Tabs.Trigger>
    <Tabs.Trigger value="settings">Settings</Tabs.Trigger>
  </Tabs.List>
  <Tabs.Content value="profile">...</Tabs.Content>
  <Tabs.Content value="settings">...</Tabs.Content>
</Tabs>

// ✅ Render prop for flexibility
<DataFetcher url="/api/users">
  {({ data, loading, error }) => (
    loading ? <Skeleton /> : <UserList users={data} />
  )}
</DataFetcher>

// ✅ Custom hook extraction
function useUsers(filters: UserFilters) {
  const { data, isLoading, error } = useGetUsersQuery(filters);
  const sortedUsers = useMemo(() =>
    data ? [...data].sort(sortByName) : [],
    [data]
  );
  return { users: sortedUsers, isLoading, error };
}

// ✅ Lazy state initialization
// BAD: runs JSON.parse every render
const [config] = useState(JSON.parse(localStorage.getItem('config') ?? '{}'));
// GOOD: function form runs only once
const [config] = useState(() => JSON.parse(localStorage.getItem('config') ?? '{}'));

// ✅ Derived state inline (not in useEffect)
// BAD: useEffect to sync derived value
const [fullName, setFullName] = useState('');
useEffect(() => { setFullName(`${first} ${last}`) }, [first, last]);
// GOOD: compute during render
const fullName = `${first} ${last}`;

// ✅ Move effects to event handlers
// BAD: effect reacts to state change
const [submitted, setSubmitted] = useState(false);
useEffect(() => { if (submitted) sendForm(data) }, [submitted]);
// GOOD: logic in handler
const handleSubmit = () => { sendForm(data) };

// ✅ Functional setState (avoids stale closures)
// BAD: stale closure risk
const add = useCallback(() => setItems([...items, newItem]), [items, newItem]);
// GOOD: stable callback
const add = useCallback(() => setItems(prev => [...prev, newItem]), [newItem]);
```

### Composition Patterns

```typescript
// architecture-avoid-boolean-props: DON'T add boolean variant props
// BAD: boolean props accumulate and create implicit coupling
<Card isCompact isAdmin isHighlighted />
// GOOD: explicit composition
<CompactCard>
  <AdminBadge />
  <HighlightedContent>...</HighlightedContent>
</CompactCard>

// architecture-compound-components: shared context for multi-part UI
// Use for Tabs, Accordion, Menu, Combobox, etc.
const TabsContext = createContext<TabsState | null>(null);

function Tabs({ defaultValue, children }: TabsProps) {
  const [active, setActive] = useState(defaultValue);
  return (
    <TabsContext value={{ active, setActive }}>
      {children}
    </TabsContext>
  );
}
Tabs.List = TabsList;
Tabs.Trigger = TabsTrigger;
Tabs.Content = TabsContent;

// state-context-interface: generic context shape for DI-friendly providers
interface ContextValue<T> {
  state: T;
  actions: Record<string, (...args: any[]) => void>;
  meta: { loading: boolean; error: Error | null };
}

// state-lift-state: siblings share state → lift to provider, not prop drill
// BAD: prop drilling through intermediate components
<Parent data={data} onUpdate={onUpdate}>
  <MiddleLayer data={data} onUpdate={onUpdate}>
    <ChildA data={data} />
    <ChildB onUpdate={onUpdate} />
// GOOD: context provider eliminates drilling
<DataProvider>
  <MiddleLayer>
    <ChildA />   {/* reads from context */}
    <ChildB />   {/* dispatches via context */}
```

### React 19 APIs

```typescript
// react19-no-forwardref: ref is a regular prop in React 19+
// BAD (React 18): forwardRef wrapper
const Input = forwardRef<HTMLInputElement, InputProps>((props, ref) => (
  <input ref={ref} {...props} />
));
// GOOD (React 19+): ref as regular prop
function Input({ ref, ...props }: InputProps & { ref?: React.Ref<HTMLInputElement> }) {
  return <input ref={ref} {...props} />;
}

// use() replaces useContext()
// BAD (React 18)
const theme = useContext(ThemeContext);
// GOOD (React 19+) — works in conditionals and loops
const theme = use(ThemeContext);
```

### Re-render Optimization

```typescript
// rerender-defer-reads: don't subscribe to state only used in callbacks
// BAD: component re-renders on every count change
function Logger() {
  const count = useAppSelector(state => state.counter.value);
  const handleClick = () => console.log(count);
  return <button onClick={handleClick}>Log</button>;
}
// GOOD: read inside callback — no subscription, no re-render
function Logger() {
  const store = useStore();
  const handleClick = () => console.log(store.getState().counter.value);
  return <button onClick={handleClick}>Log</button>;
}

// rerender-derived-state: subscribe to derived booleans, not raw objects
// BAD: re-renders whenever ANY user field changes
const user = useAppSelector(state => state.auth.user);
if (user?.role === 'admin') { /* ... */ }
// GOOD: re-renders only when admin status actually changes
const isAdmin = useAppSelector(state => state.auth.user?.role === 'admin');

// rerender-memo-with-default-value: hoist non-primitive defaults
// BAD: new array every render → breaks memo/effect deps
function List({ items = [] }: { items?: Item[] }) { /* ... */ }
// GOOD: stable reference
const EMPTY_ITEMS: Item[] = [];
function List({ items = EMPTY_ITEMS }: { items?: Item[] }) { /* ... */ }

// rerender-transitions: non-urgent updates → startTransition
import { startTransition } from 'react';
const handleSearch = (query: string) => {
  setQuery(query);                           // urgent: update input
  startTransition(() => {
    setFilteredResults(filterItems(query));   // non-urgent: can defer
  });
};

// rerender-use-ref-transient-values: frequently-changing non-render values
// BAD: setState for every mouse move → re-render storm
const [mousePos, setMousePos] = useState({ x: 0, y: 0 });
// GOOD: ref for values not used in render output
const mousePosRef = useRef({ x: 0, y: 0 });
useEffect(() => {
  const handler = (e: MouseEvent) => {
    mousePosRef.current = { x: e.clientX, y: e.clientY };
  };
  window.addEventListener('mousemove', handler);
  return () => window.removeEventListener('mousemove', handler);
}, []);
```

For detailed patterns, see `references/` directory.
