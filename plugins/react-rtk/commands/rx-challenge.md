---
name: rx:challenge
description: Adversarial review — stress-test with edge cases, race conditions, accessibility failures, performance bottlenecks. The "grill me" mode.
---

## Challenge Tracks

### 1. Edge case assault
Empty arrays, null values, 10k items, long strings, Unicode, RTL, API 500/429/timeout.

### 2. Race condition hunt
Rapid mount/unmount, navigate away mid-request, concurrent mutations, stale closures.

### 3. Accessibility destruction
Keyboard-only navigation, CSS off, 400% zoom, screen reader mental model, aria-live regions.

### 4. Performance stress
Slow 3G, 1000 list items, React Profiler, bundle size impact.

## Arguments

- No args: all tracks on staged changes
- `{component}`: challenge a specific component
- `--track {edge|race|a11y|perf}`: run a single track

## Severity

- **BROKEN**: will fail in production under realistic conditions
- **FRAGILE**: works now but breaks under load/edge cases
- **WEAK**: suboptimal but functional

The agent asks you to defend each BROKEN finding before dismissing.
