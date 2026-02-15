---
name: rx:quick
description: Fast implementation — skip planning ceremony. For small tasks that don't need parallel research.
---

# /rx:quick — Quick Implementation

## Usage

```
/rx:quick Add pagination to user list
/rx:quick Fix the loading state on profile page
/rx:quick Extract useDebounce hook from search component
```

## Behavior

1. Assess complexity (must be score 1-2)
2. If score 3+: suggest `/rx:plan` instead
3. Implement directly
4. Run iron-law-judge
5. Run verification-runner
6. Report results
