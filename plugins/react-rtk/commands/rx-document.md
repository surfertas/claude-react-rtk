---
name: rx:document
description: Generate documentation — JSDoc/TSDoc for components, README sections, ADRs, Storybook stories. Reads existing code and produces missing docs.
---

## Documentation Modes

### Default: scan and fill gaps
Find all exported components/hooks/utils/slices, check for existing docs, generate missing.

### `--component {path}`: TSDoc + @example + Storybook story
### `--hook {path}`: TSDoc with @param, @returns, @throws, edge case notes
### `--api {path}`: RTK Query endpoint docs + cache invalidation flow diagram
### `--adr {title}`: Architecture Decision Record in `.claude/adrs/`
### `--readme`: Update README from actual package.json and codebase structure

## Rules

- Never overwrite existing JSDoc — only fill gaps
- Match existing documentation style in the project
- TSDoc over JSDoc when TypeScript is detected
- Props interfaces are self-documenting — add JSDoc only when behavior isn't obvious from types
