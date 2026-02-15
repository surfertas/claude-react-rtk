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

For detailed patterns, see `references/` directory.
