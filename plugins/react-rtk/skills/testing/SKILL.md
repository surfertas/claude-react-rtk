---
name: testing
description: React Testing Library, MSW, and component/hook testing patterns. Use when editing test files (.test.tsx, .test.ts, .spec.tsx), test utilities, or MSW handlers.
---

## Quick Reference

### Test File Structure
```typescript
import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { renderWithProviders } from '@/test-utils';

describe('ComponentName', () => {
  it('renders initial state correctly', () => { /* ... */ });
  it('handles user interaction', async () => { /* ... */ });
  it('displays loading state', () => { /* ... */ });
  it('handles error gracefully', async () => { /* ... */ });
  it('meets accessibility requirements', () => { /* ... */ });
});
```

### renderWithProviders Helper
```typescript
// test-utils.tsx
import { render } from '@testing-library/react';
import { Provider } from 'react-redux';
import { setupStore } from '@/store/store';

export function renderWithProviders(
  ui: React.ReactElement,
  { preloadedState = {}, store = setupStore(preloadedState), ...options } = {}
) {
  function Wrapper({ children }: { children: React.ReactNode }) {
    return <Provider store={store}>{children}</Provider>;
  }
  return { store, ...render(ui, { wrapper: Wrapper, ...options }) };
}
```

### MSW Handler Pattern
```typescript
// msw/handlers.ts
import { http, HttpResponse } from 'msw';

export const handlers = [
  http.get('/api/users', () => HttpResponse.json(mockUsers)),
  http.get('/api/users/:id', ({ params }) => {
    const user = mockUsers.find(u => u.id === params.id);
    return user ? HttpResponse.json(user) : new HttpResponse(null, { status: 404 });
  }),
  http.post('/api/users', async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({ id: 'new-id', ...body }, { status: 201 });
  }),
];
```

### Query Priority
1. `getByRole` 2. `getByLabelText` 3. `getByPlaceholderText` 4. `getByText`
5. `getByDisplayValue` 6. `getByAltText` 7. `getByTitle` 8. `getByTestId` (LAST RESORT)

### Async: `findBy*` not `waitFor` + `getBy*`

For detailed patterns, see `references/` directory.
