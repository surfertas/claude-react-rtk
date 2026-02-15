---
name: rx:learn
description: Capture a lesson learned as a reusable rule. Updates common-mistakes.md so the same mistake is prevented in future sessions.
---

## Usage

```
/rx:learn Fixed N+1 selector — always use createSelector for computed data
/rx:learn useEffect cleanup was missing — AbortController needed for every fetch
```

## What It Does

1. Parse lesson into **trigger pattern** and **correct action**
2. Append to `.claude/solutions/common-mistakes.md`
3. Optionally create Iron Law if severe enough

## Arguments

- `{lesson}`: free-form description
- `--iron-law`: also create a new Iron Law entry
- `--from-review`: extract lessons from most recent review automatically
