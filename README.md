# Trinity Design System

Shared design tokens, components, and governance for VeloReady, GymReady, and TRT Companion.

## Status

Phase 0 (Bootstrap) — in progress.

## Modules

- `TrinityTokens` — spacing, typography, icons, status colours, opacity, radii (static)
- `TrinityTheme` — `Theme` protocol, environment plumbing, category enum, demo themes
- `TrinityComponents` — atoms, molecules, organisms, layout modifiers

Apps import `TrinityComponents` and get the rest transitively.

## Consuming the package

Add to `Package.swift` or Xcode SPM dependency:

```swift
.package(url: "https://github.com/markboulton/trinity-design-system.git", branch: "main")
```

Track `main` for auto-propagation. Pin to a tag (`exact: "v0.1.0"`) only as an emergency rollback.

## Local development

Open this repo in Xcode and run the `Gallery` app to develop components. To verify changes in a real consumer app:

```bash
# In the consumer app's repo:
swift package edit Trinity --path ../trinity-design-system
# ... edit and test ...
swift package unedit Trinity
```

## Governance

See `PRINCIPLES.md` for the design rules. The `trinity-ui` Claude skill in `skills/trinity-ui/` enforces them automatically when symlinked into a consuming app's `.claude/skills/`.
