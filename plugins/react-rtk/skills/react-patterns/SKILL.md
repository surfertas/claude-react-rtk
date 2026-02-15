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
```

For detailed patterns, see `references/` directory.
