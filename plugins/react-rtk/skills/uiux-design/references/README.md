# Design Token References

This directory is populated by `/rx:design init`.

## Files generated:

- **design-tokens.json** — Normalized token file extracted from your project's Tailwind config, CSS variables, theme files, or Figma exports
- **component-inventory.md** — Discovered UI components and their variants
- **token-mapping.md** — How your project tokens map to semantic names
- **gaps.md** — Missing tokens and inconsistencies found

## Manual setup:

If you prefer to set up tokens manually instead of running init:

1. Copy your design tokens into `design-tokens.json` following the schema in the `/rx:design` command
2. All agents (uiux-designer, iron-law-judge, react-architect) will use your tokens automatically

## Supported sources:

- Tailwind config (`tailwind.config.ts`)
- CSS custom properties (`:root { --color-* }`)
- Theme files (`src/theme/`, `src/styles/theme.ts`)
- shadcn/ui config (`components.json`)
- Style Dictionary / Figma Tokens (`tokens.json`)
