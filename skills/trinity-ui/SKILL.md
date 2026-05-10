---
name: trinity-ui
description: Use when working on SwiftUI views or any UI in VeloReady, GymReady, or TRT Companion. Enforces Trinity design system conventions — layout modifiers (trinityScreen, TrinityCardStack, TrinitySection), navigation patterns (push vs sheet vs cover), state components (TrinityEmptyState, TrinityErrorState), typography roles, and drift-prevention rules. Activates on edits to .swift files in those apps and on any UI/layout/spacing/navigation/component question.
---

# Trinity UI Skill

You are working in a Trinity-consuming app (VeloReady, GymReady, or TRT
Companion). Trinity is a shared Swift Package for the three apps' design
system. This skill enforces consistent UI rules across all three.

## Authoritative reference

Always defer to `PRINCIPLES.md` in the trinity-design-system repo for the
specific rules. This skill provides the proactive nudges; the doc has the
exhaustive list.

## Hard rules (non-negotiable)

When you see any of these patterns, STOP and propose the Trinity replacement
before continuing:

| You see | You should propose |
|---|---|
| `.padding(.horizontal, <number>)` at screen level | `.trinityScreen()` |
| `VStack(spacing: <number>) { ... cards ... }` | `TrinityCardStack { ... }` |
| `Color(red:green:blue:)` in a view file | A theme property or `TrinityStatusColors` |
| `.font(.system(size:))` | A `TrinityTypography.*` token |
| `Color(.label)` / `Color(.systemBackground)` in a view | `theme.labelPrimary` / `theme.cardBackground` |
| `NavigationStack` inside another `NavigationStack` | Single parent NavigationStack with `navigationDestination(for:)` |
| Inline "No data" or "No results" Text | `TrinityEmptyState` |
| Toast or inline red text for errors | `TrinityErrorState` |
| Card with `.padding(...)` applied externally | Move padding inside the card; the stack owns external spacing |

## Decision trees

### Push vs sheet vs cover

```
Is the new screen part of a hierarchical navigation flow (drill-down)?
├─ Yes → trinityPush / NavigationLink with navigationDestination(for:)
└─ No
   └─ Is it a contextual action (edit, more, menu, share)?
      ├─ Yes → trinitySheet(isPresented:)
      └─ No → fullScreenCover (onboarding, paywall, auth only)
```

### Loading state

```
Do you know the layout of the loaded content?
├─ Yes → skeleton view with the same shape
└─ No → ProgressView (sparingly)
```

### Empty state

```
Is there no data to show?
├─ Permanent (user has 0 entries) → TrinityEmptyState with primaryAction
├─ Temporary (loading) → skeleton, not empty state
└─ Filter result is empty → TrinityEmptyState with "Clear filters" primaryAction
```

## When asked to scaffold a new screen

Follow `checklists/new-screen.md`.

## When making layout changes

1. Read `references/layout.md` first.
2. Check if a Trinity modifier already covers it.
3. If yes — use the modifier.
4. If no — propose a new modifier in Trinity rather than ad-hoc layout in the app.

## When picking a component

Read `references/components.md`. If no Trinity component fits, before building
ad-hoc UI, ask: should this be a new Trinity component? Consider whether other
apps would benefit.

## When unsure

Read `PRINCIPLES.md`. If still unsure, ask the user. Don't bypass the rules
silently — make the deviation visible.
