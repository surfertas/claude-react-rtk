---
name: accessibility
description: WCAG accessibility patterns — semantic HTML, ARIA, focus management, keyboard navigation. Use when working with aria attributes, role attributes, dialog/nav elements, form elements, or focus management code.
---

## Quick Reference

### Semantic HTML Mapping
```
clickable action     → <button>          NOT <div onClick>
navigation link      → <a href>          NOT <span onClick>
navigation section   → <nav>             NOT <div class="nav">
main content         → <main>            NOT <div class="content">
modal/dialog         → <dialog>          NOT <div class="modal">
list of items        → <ul>/<ol>/<li>    NOT <div> repeated
section heading      → <h1>-<h6>         NOT <div class="title">
form field           → <input> + <label> NOT unlabeled input
```

### Focus Management Patterns
```typescript
// Modal: trap focus, restore on close
const previousFocus = useRef<HTMLElement>(null);
const openModal = () => {
  previousFocus.current = document.activeElement as HTMLElement;
  // focus first focusable in modal
};
const closeModal = () => {
  previousFocus.current?.focus();
};

// Route change: focus main heading
useEffect(() => {
  document.querySelector('h1')?.focus();
}, [pathname]);
```

### Required ARIA for Custom Components
- Tabs: `role="tablist"`, `role="tab"`, `aria-selected`, `aria-controls`
- Accordion: `aria-expanded`, `aria-controls`, button trigger
- Dropdown: `aria-haspopup`, `aria-expanded`, `aria-activedescendant`
- Toast: `role="status"`, `aria-live="polite"`
- Alert: `role="alert"`, `aria-live="assertive"`
- Loading: `aria-busy="true"`, `role="status"` with text

### Minimum Touch Target: 44×44px

For detailed patterns, see `references/` directory.
