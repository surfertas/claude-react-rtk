---
name: rx:audit
description: Project health audit across 5 categories with parallel specialist agents. Scores architecture, performance, security, tests, accessibility.
---

# /rx:audit — Project Health Audit

## Usage

```
/rx:audit                        # Full audit
/rx:audit --quick                # 2-3 minute pulse check
/rx:audit --focus=performance    # Deep dive single area
/rx:audit --since HEAD~10        # Audit recent changes only
```

## Categories (scored 1-10)

1. **Architecture** — Component structure, state management, file organization
2. **Performance** — Bundle size, rendering, Core Web Vitals, caching
3. **Security** — XSS vectors, auth, secrets, dependencies
4. **Testing** — Coverage, test quality, integration tests
5. **Accessibility** — WCAG compliance, keyboard nav, screen reader

## Output

Actionable report with specific files, lines, and fix recommendations.
