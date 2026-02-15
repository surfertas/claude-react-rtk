---
name: uiux-design
description: UI/UX design system patterns — spacing scale, typography, color tokens, component states, responsive breakpoints, z-index, motion. Use when editing CSS modules, styled components, style directories, theme files, design tokens, tailwind config, or UI primitives.
---

## Quick Reference

### Spacing Scale (4px base)
```
xs=4  sm=8  md=16  lg=24  xl=32  2xl=48  3xl=64  4xl=80  5xl=96
```
Use ONLY these values. No magic numbers (13px, 27px, etc.)

### Typography Scale
```
caption:  12/16  regular
bodySmall: 14/20  regular
body:     16/24  regular
h3:       20/28  semibold
h2:       24/32  semibold
h1:       30/38  bold
display:  36/44  bold
```

### Color System
ALWAYS use semantic tokens, never primitives:
```
text.primary / text.secondary / text.disabled / text.inverse
surface.default / surface.raised / surface.overlay / surface.sunken
border.default / border.focus / border.error
action.primary / action.primaryHover / action.secondary / action.danger
feedback.success / feedback.warning / feedback.error / feedback.info
```

### Component States (design ALL of these)
```
default → hover → focus → active → disabled
loading (skeleton / spinner)
error (inline message)
empty (illustration + CTA)
```

### Responsive Breakpoints
```
sm: 640px    (phone landscape)
md: 768px    (tablet)
lg: 1024px   (laptop)
xl: 1280px   (desktop)
2xl: 1536px  (wide)
```
Design mobile-first. Stack at sm, side-by-side at md+.

### Z-Index Scale
```
base: 0    dropdown: 100    sticky: 200    modal: 300    toast: 400    tooltip: 500
```
NEVER use arbitrary z-index values (z-index: 9999).

### Motion
```
fast: 150ms    (micro-interactions: toggle, checkbox)
normal: 250ms  (panels, dropdowns)
slow: 400ms    (page transitions, modals)
easing: cubic-bezier(0.4, 0, 0.2, 1)
```
Respect `prefers-reduced-motion: reduce` — disable non-essential animation.

### Contrast Requirements
- Normal text (< 18px): 4.5:1 minimum
- Large text (≥ 18px bold or ≥ 24px): 3:1 minimum
- UI components (borders, icons, focus rings): 3:1 minimum

For detailed patterns, see `references/` directory.
