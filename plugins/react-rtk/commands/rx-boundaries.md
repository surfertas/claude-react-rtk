---
name: rx:boundaries
description: Analyze module boundaries — circular imports, feature coupling, barrel file bloat, dead exports. Maps the actual dependency graph.
---

## Analysis Checks

- **Circular imports**: detect cycles, classify within-feature (warning) vs cross-feature (blocker)
- **Feature coupling**: flag imports reaching into another feature's internals
- **Layer violations**: enforce components → hooks → store → utils (one direction)
- **Barrel file analysis**: flag barrels with >20 re-exports (tree-shaking issues)
- **Dead exports**: find exported items never imported anywhere

## Arguments

- No args: full analysis
- `--feature {name}`: analyze a single feature
- `--circular-only`: only check circular imports
- `--depth {n}`: limit import chain depth (default: 10)

## Agent

Delegates to **import-analyzer** agent (haiku).
