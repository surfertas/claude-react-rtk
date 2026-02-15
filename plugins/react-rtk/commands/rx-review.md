---
name: rx:review
description: 4-agent parallel code review — idioms, security, tests, verification. Produces consolidated report with blocker/warning/suggestion severity.
---

# /rx:review — Parallel Code Review

## Usage

```
/rx:review                    # Review current git diff
/rx:review --focus security   # Deep dive single track
/rx:review --staged           # Review only staged changes
```

## Agents (parallel)

1. `react-reviewer` — Idioms, patterns, component quality
2. `security-analyzer` — XSS, auth, secrets, dependencies
3. `testing-reviewer` — Coverage, test quality, MSW patterns
4. `verification-runner` — TypeScript, ESLint, tests, build

## Output

Consolidated report with severity levels:
- **BLOCKER** — Must fix (Iron Law violations, security issues)
- **WARNING** — Should fix (performance, maintainability)
- **SUGGESTION** — Consider (improvements, alternatives)

If blockers found, offers: Replan fixes | Fix directly | Handle myself
