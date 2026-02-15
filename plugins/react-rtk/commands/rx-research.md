---
name: rx:research
description: Research React/frontend topics using web search — library comparison, API patterns, migration guides. Produces structured findings.
---

## Arguments

- `{topic}`: free-form research topic
- `--compare {lib1} {lib2}`: compare two libraries head-to-head
- `--migrate {from} {to}`: research migration path
- `--output {path}`: write to specific path (default: plan namespace)

## Agent

Delegates to **web-researcher** agent (sonnet model) with web search tool enabled.

## Rules

- Always check npm download counts and last publish date
- Flag libraries with <1000 weekly downloads or no updates in 6+ months
- Cross-reference with project's existing package.json
- Research output goes to plan namespace if active, otherwise `.claude/research/`
