# Trinity Design Principles

The rules of use for Trinity components. Components alone don't prevent drift —
the layer above them (when to use what, with what spacing, with what behaviour)
is where most drift happens. This document is the canonical source of truth.

This file is loaded by the `trinity-ui` Claude skill and referenced from each
consuming app's `CLAUDE.md`. Treat it as authoritative; if a rule is wrong,
fix it here.

## Layout

### Screen padding

- Every primary screen wraps its content in `trinityScreen()`.
- `trinityScreen()` applies `TrinitySpacing.sectionPadding` (20pt) horizontally.
- **Never hardcode `.padding(.horizontal, 20)` or any horizontal padding value.**

### Card stacking

- Stacks of cards use `TrinityCardStack { ... }`.
- Card stacks use `TrinitySpacing.cardSpacing` (12pt) — Apple Health rhythm.
- **Cards must NOT have external padding.** The stack owns the spacing between
  them. Cards are flush to the screen edges (modulo screen padding).

### Section spacing

- Use `TrinitySection("Title") { ... }` to break a screen into named sections.
- Sections separate via `TrinitySpacing.sectionSpacing` (20pt).
- Section title uses `TrinityTypography.titleMedium`.

### Touch targets

- Every interactive element has a minimum 44pt tap target (`TrinitySpacing.touch`).
- TrinityButton enforces this on `.primary`/`.secondary`/`.destructive` styles.

### Hairlines

- 1pt rules and dividers use `TrinitySpacing.hairline` (2pt rendered = 1pt @2x).

## Navigation

### Push vs. sheet vs. cover

- **Tap a card or row → push detail** via `TrinityPush(to:)` or `NavigationLink` with `navigationDestination(for:)`.
- **"More" / menu / contextual edit → sheet** via `trinitySheet(...)`.
- **Onboarding / paywall / auth → fullscreen cover** via `.fullScreenCover(...)`.

### NavigationStack

- Use a single parent `NavigationStack` per scene.
- Use `navigationDestination(for:)` for routing — never nest a `NavigationStack`
  inside another.
- The `swiftlint-trinity_no_nested_navigation_stack` rule flags violations.

### Back buttons

- Never add a custom back button. The system back button is the only sanctioned one.

## States

### Loading

- Prefer skeleton loaders to spinners when the layout is known.
- Spinners only when content is fundamentally unknown (e.g., free-text query result).
- Never block UI with a full-screen loading spinner unless the action is destructive.

### Empty

- Use `TrinityEmptyState` — never inline "no data" text.
- API: `TrinityEmptyState(icon:, title:, description:, primaryAction: (label, action)?, secondaryAction: (label, action)?)`.

### Error

- Use `TrinityErrorState` — never a toast or inline red text.
- API: `TrinityErrorState(title:, description:, retryAction:, secondaryAction: (label, action)?)`.

### Refresh

- Pull-to-refresh on primary screens via `trinityScreen(refreshable: { await ... })`.
- Explicit refresh buttons only in detail/debug contexts.

## Animation

- Use `withAnimation { ... }` for state-and-value-same-frame changes — `.animation(_, value:)` is unreliable when the trigger and value change in the same frame.
- Standard spring: `.spring(response: 0.3, dampingFraction: 0.85)`.
- Avoid layered animations on data-driven views — they fight each other and
  cause visual glitches.

## Typography

| Role | Token | Usage |
|---|---|---|
| Screen title (large nav) | `navigationLargeTitle` | iOS 17+ large title |
| Section header | `titleMedium` | Inside `TrinitySection` |
| Card title | `headline` | Top of a card |
| Card subtitle | `subheadline` | Under card title |
| Eyebrow label | `captionSmall` (uppercased) | Above a value |
| Metric value | `numericLarge` / `numericMedium` | Tabular figures |
| Body text | `body` | Paragraphs |
| Secondary text | `subheadline` w/ `theme.labelSecondary` | Annotations |

## Colours

### Theme-driven (per-app brand)

- Accent → `@Environment(\.theme).accent`
- Card background → `theme.cardBackground`
- Text → `theme.labelPrimary` / `labelSecondary` / `labelMuted`
- Categories → `theme.categoryColor(.heart)` etc.

### Static (universal)

- Status → `TrinityStatusColors.success` / `.warning` / `.error`
- Markers → `TrinityStatusColors.markerInRange` / `.markerOutOfRange`

### Drift prevention

- **Never use `Color(red:green:blue:)` directly in app code.** Define it in the theme or use a token.
- **Never use system colours (`.label`, `.systemBackground`) directly** — go through the theme.
- The `swiftlint-trinity_no_hardcoded_color` rule catches violations.

## Accessibility

- Every interactive element has `.accessibilityLabel`.
- VoiceOver navigation order matches visual order.
- Dynamic Type: use `Font.custom(_:size:relativeTo:)` (already done in `TrinityTypography`).
- Hit targets meet 44pt minimum.

## Drift prevention rules (summary)

- **Layout:** use `trinityScreen()`, `TrinityCardStack`, `TrinitySection` — never hardcode padding/spacing.
- **Colours:** use theme or static tokens — never raw `Color(red:green:blue:)` or system colours.
- **Typography:** use `TrinityTypography.*` — never `.font(.system(size:))` outside the package.
- **Cards:** never apply external padding to a card.
- **Navigation:** use a single parent NavigationStack with `navigationDestination(for:)`.
- **States:** use `TrinityEmptyState` / `TrinityErrorState` — never inline text or toasts for these states.

## Breaking changes (producer-side)

These rules apply when you are *changing Trinity itself*, not consuming it.

### The invariant

`origin/main` must always compile for VeloReady, GymReady, and TRT Companion.
Apps track `branch: "main"` via SPM. The moment a developer in any app clicks
"Update to Latest Package Versions", whatever is on `origin/main` lands in
their build. There is no version range, no semver gate. The discipline below
is the gate.

### What counts as breaking

Source-breaking for consumers — must go through the deprecate-then-remove
cycle:

- Renaming a public type, property, function, enum case, or extension member.
- Removing any public symbol.
- Changing a function signature (parameter labels, types, order, count, or
  defaults callers relied on).
- Changing a public property's type.
- Removing or adding a case to a non-`@frozen` public enum (additions break
  exhaustive switches in consumers).
- Tightening generic constraints on a public type.
- Narrowing visibility (`public` → `internal` / `package` / `private`).
- Adding, renaming, or removing a `Theme` protocol requirement.

Not breaking — safe to commit straight to `main`:

- Adding a brand-new public symbol.
- Adding optional initializer parameters with default values.
- Adding a protocol requirement that ships with a default implementation in
  an extension.
- Internal/private changes; documentation; formatting.

### The deprecate-then-remove process

1. **Trinity PR 1** — add the new API alongside the old, mark the old
   `@available(*, deprecated, message: "Use X instead.")`. Update
   `PublicAPISnapshot.swift` to reference both. Build + tests green. Merge.
2. **Per-consumer PRs** — each of VR / GR / TC runs `swift package update`,
   migrates call sites away from the deprecation warning, commits
   `Package.resolved`, ships on its own cadence.
3. **Trinity PR 2** — remove the deprecated symbol and its snapshot entry.
   Build + tests green. Merge.

Never skip step 2. Never delete a symbol any consumer still references.

### Machine enforcement

`Tests/TrinityComponentsTests/PublicAPISnapshot.swift` constructs every
public Trinity type, every public init signature, every nested enum case,
every token, and every `View` extension. It is compile-as-test: the test
passes if the file compiles. A rename or removal without a deprecation
shim makes the snapshot stop compiling, which fails `swift test`.

The discipline:

- New public symbol → add a snapshot entry in the same PR.
- Snapshot fails to compile because of your change → that is the test
  working. Do not delete lines to make it pass. Restore the symbol, or
  move it through the deprecation cycle.

Run `swift build && swift test` before every push.

## Escape hatches

These rules are guidance, not handcuffs. If a Trinity modifier doesn't cover
your case:

1. Compose primitives directly (`VStack`, `HStack`) using Trinity tokens.
2. Document the gap in the relevant component's source file.
3. Open an issue against Trinity to evolve the modifier API.

Never bypass the rules silently — make the deviation visible so it can be
folded back into the system.
