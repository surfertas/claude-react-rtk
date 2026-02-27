#!/usr/bin/env bash
# SessionStart hook: Create core workflow directories
mkdir -p .claude/plans .claude/reviews .claude/solutions .claude/traces .claude/adrs 2>/dev/null || true
