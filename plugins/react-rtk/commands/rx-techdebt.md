---
name: rx:techdebt
description: Scan for technical debt — deprecated patterns, TODO/FIXME comments, outdated deps, inconsistent patterns, refactoring opportunities.
---

## Scan Categories

- **Pattern inconsistencies**: mixed data fetching, mixed state management, mixed styling
- **Code smells**: 300+ line components, 5+ useState calls, props drilling >3 levels, `any` types
- **Dependency health**: outdated packages, deprecated deps, unused deps
- **TODO archaeology**: find all TODO/FIXME/HACK, group by age via git blame
- **Test coverage gaps**: components/hooks/utils with no test file

## Arguments

- No args: full scan
- `--quick`: skip dependency check and git blame
- `--focus {category}`: scan only one category
- `--since {commit|date}`: only debt introduced after this point
