---
name: rx:design
description: Design system initialization, audit, and management. Scans project for existing design tokens and generates references for the uiux-designer agent.
---

# /rx:design — Design System Tools

## Subcommands

### /rx:design init

Scans your project for existing design token sources and generates `skills/uiux-design/references/` files that all agents use.

**What it scans for (in priority order):**

1. **Tailwind config** — `tailwind.config.ts`, `tailwind.config.js`
   - Extracts: colors, spacing, fontSize, fontFamily, borderRadius, boxShadow, screens (breakpoints)
   - Maps to semantic tokens where possible (e.g., `colors.primary` → `action.primary`)

2. **CSS custom properties** — `src/styles/`, `src/app/globals.css`, `:root` blocks
   - Extracts: `--color-*`, `--spacing-*`, `--font-*`, `--radius-*`, `--shadow-*`
   - Parses both light and dark theme definitions

3. **Theme files** — `src/theme/`, `src/styles/theme.ts`, `src/lib/theme.ts`
   - Extracts: exported theme objects (styled-components, MUI, Chakra, Mantine)
   - Maps to token structure

4. **shadcn/ui config** — `components.json`, `src/components/ui/`
   - Extracts: CSS variables from shadcn's globals, component inventory
   - Maps shadcn's naming to semantic tokens

5. **Style Dictionary / Figma Tokens** — `tokens.json`, `design-tokens.json`, `*.tokens.json`
   - Direct import — these are already in token format

6. **Package.json** — Checks for design system dependencies
   - `@radix-ui/*`, `@headlessui/*`, `@mui/*`, `@chakra-ui/*`, `@mantine/*`, `shadcn`

**What it generates:**

```
plugins/react-rtk/skills/uiux-design/references/
├── design-tokens.json         # Normalized token file
├── component-inventory.md     # Discovered UI components + variants
├── token-mapping.md           # How project tokens map to semantic names
└── gaps.md                    # Missing tokens / inconsistencies found
```

**Implementation steps (for the agent executing this command):**

```bash
# Step 1: Detect token sources
echo "Scanning for design token sources..."

# Check for Tailwind
TAILWIND_CONFIG=$(find . -maxdepth 2 -name "tailwind.config.*" -not -path "*/node_modules/*" | head -1)

# Check for CSS custom properties
CSS_VARS=$(grep -rl "--color\|--spacing\|--font\|--radius" src/ --include="*.css" 2>/dev/null | head -5)

# Check for theme files
THEME_FILES=$(find src/ -maxdepth 3 -name "theme.*" -o -name "tokens.*" -not -path "*/node_modules/*" 2>/dev/null)

# Check for shadcn
SHADCN_CONFIG=$(find . -maxdepth 1 -name "components.json" | head -1)

# Check for token JSON files
TOKEN_JSON=$(find . -maxdepth 3 -name "*tokens*.json" -not -path "*/node_modules/*" 2>/dev/null | head -3)

# Check for design system packages
DESIGN_DEPS=$(cat package.json | grep -oE '"@(radix-ui|headlessui|mui|chakra-ui|mantine)[^"]*"' 2>/dev/null)
```

```bash
# Step 2: Read each source and extract tokens
# For each source found, read the file and extract:
# - Color palette (primitives + semantic mappings)
# - Spacing scale (list all values used)
# - Typography scale (font sizes, line heights, font weights, font families)
# - Border radius values
# - Shadow definitions
# - Breakpoints / screen sizes
# - Z-index values in use
# - Animation/transition values
```

```bash
# Step 3: Normalize into design-tokens.json
# Structure:
{
  "source": "tailwind.config.ts",  // or "css-variables", "theme.ts", etc.
  "scannedAt": "2026-02-14T00:00:00Z",
  "tokens": {
    "color": {
      "semantic": {
        "text": { "primary": "#...", "secondary": "#...", "disabled": "#..." },
        "surface": { "default": "#...", "raised": "#...", "overlay": "#..." },
        "border": { "default": "#...", "focus": "#...", "error": "#..." },
        "action": { "primary": "#...", "primaryHover": "#...", "danger": "#..." },
        "feedback": { "success": "#...", "warning": "#...", "error": "#...", "info": "#..." }
      },
      "primitive": {
        // Raw palette values mapped from source
      }
    },
    "spacing": {
      "scale": [4, 8, 12, 16, 20, 24, 32, 40, 48, 64],
      "unit": "px",
      "source_mapping": {
        // e.g., "1": "4px", "2": "8px" for Tailwind
      }
    },
    "typography": {
      "fontFamily": { "sans": "...", "mono": "..." },
      "scale": {
        "display": { "fontSize": 36, "lineHeight": 44, "fontWeight": 700 },
        "h1": { "fontSize": 30, "lineHeight": 38, "fontWeight": 700 }
        // ...
      }
    },
    "radius": { "sm": 4, "md": 8, "lg": 12, "xl": 16, "full": 9999 },
    "shadow": { "sm": "...", "md": "...", "lg": "...", "focus": "..." },
    "breakpoints": { "sm": 640, "md": 768, "lg": 1024, "xl": 1280 },
    "zIndex": { "dropdown": 100, "sticky": 200, "modal": 300, "toast": 400 },
    "motion": {
      "duration": { "fast": "150ms", "normal": "250ms", "slow": "400ms" },
      "easing": { "default": "cubic-bezier(0.4, 0, 0.2, 1)" }
    }
  }
}
```

```bash
# Step 4: Generate component inventory
# Scan src/components/ui/ (or equivalent) and list:
# - Component name
# - Props interface (variants, sizes)
# - File path
# - Whether it has tests
# - Whether it has accessibility attributes
```

```bash
# Step 5: Generate gaps report
# Compare discovered tokens against the full semantic token structure.
# Flag:
# - Missing semantic mappings (have primitives but no semantic names)
# - Inconsistent spacing (values that don't fit the scale)
# - Missing dark mode tokens
# - Components without all required states (hover, focus, disabled, loading, error, empty)
# - Accessibility gaps (missing focus styles, contrast issues)
```

**After running:**

The uiux-designer agent, iron-law-judge, and all other agents will read
`references/design-tokens.json` instead of using generic defaults. The
iron-law-judge will flag violations against YOUR specific tokens.

### /rx:design audit

Scans all component files for token violations:
- Magic color values not in tokens
- Spacing values not on the scale
- Inconsistent radius/shadow usage
- Missing component states
- Contrast ratio failures

### /rx:design tokens

Prints current token inventory from `references/design-tokens.json`:
- Color palette with semantic mappings
- Spacing scale
- Typography scale
- All other token categories

### /rx:design states <ComponentName>

Generates all required visual states for a component:
- default, hover, focus, active, disabled
- loading (skeleton variant)
- error (inline message variant)
- empty (illustration + CTA variant)

### /rx:design responsive <ComponentName>

Analyzes component's responsive behavior across breakpoints and flags issues.

### /rx:design sync

Re-scans project sources and updates `references/design-tokens.json` if the
source files have changed since last init.
