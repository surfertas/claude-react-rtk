---
name: redux-rtk
description: Redux Toolkit and RTK Query patterns. Use when editing slice files, API definitions, store configuration, selectors, or any file importing from @reduxjs/toolkit.
---

## Quick Reference

### RTK Query Setup
```typescript
// store/api/baseApi.ts — ONE base API per backend
export const baseApi = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({
    baseUrl: '/api',
    prepareHeaders: (headers, { getState }) => {
      const token = (getState() as RootState).auth.token;
      if (token) headers.set('Authorization', `Bearer ${token}`);
      return headers;
    },
  }),
  tagTypes: ['User', 'Post', 'Comment'], // ALL tag types here
  endpoints: () => ({}), // Injected from feature files
});

// store/api/usersApi.ts — inject endpoints per feature
export const usersApi = baseApi.injectEndpoints({
  endpoints: (builder) => ({
    getUsers: builder.query<User[], { role?: string }>({
      query: (params) => ({ url: 'users', params }),
      providesTags: (result) =>
        result
          ? [...result.map(({ id }) => ({ type: 'User' as const, id })), 'User']
          : ['User'],
    }),
  }),
});
export const { useGetUsersQuery } = usersApi;
```

### Slice Pattern
```typescript
// store/slices/uiSlice.ts
interface UiState {
  sidebarCollapsed: boolean;
  theme: 'light' | 'dark' | 'system';
}

const uiSlice = createSlice({
  name: 'ui',
  initialState: { sidebarCollapsed: false, theme: 'system' } as UiState,
  reducers: {
    toggleSidebar: (state) => { state.sidebarCollapsed = !state.sidebarCollapsed; },
    setTheme: (state, action: PayloadAction<UiState['theme']>) => { state.theme = action.payload; },
  },
});
```

### Selector Pattern
```typescript
// store/selectors/userSelectors.ts
import { createSelector } from '@reduxjs/toolkit';

const selectUsersState = (state: RootState) => state.users;

export const selectActiveUsers = createSelector(
  selectUsersState,
  (users) => users.ids.filter(id => users.entities[id]?.status === 'active')
);
```

### Typed Hooks
```typescript
// store/hooks.ts — USE THESE, not raw useDispatch/useSelector
export const useAppDispatch = useDispatch.withTypes<AppDispatch>();
export const useAppSelector = useSelector.withTypes<RootState>();
```

For detailed patterns, see `references/` directory.
