# Components — what to use for what

## Atoms

| Need | Use |
|---|---|
| Button (primary action) | `TrinityButton(_, style: .primary, action:)` |
| Button (secondary action) | `TrinityButton(_, style: .secondary, action:)` |
| Inline action button | `TrinityButton(_, style: .tertiary, action:)` |
| Destructive button | `TrinityButton(_, style: .destructive, action:)` |
| Status pill / tag | `TrinityBadge(text:)` |
| Filter selector | `TrinitySegmentedFilter(...)` |
| Sync indicator | `TrinityHealthKitSyncIndicator(...)` |
| Generic styled text | `TrinityText` (rarely — usually direct `Text` with a token works) |
| Ring progress | `TrinityProgressRing(value:)` |
| Bar progress | `TrinityProgressBar(value:)` |
| 1-10 scale picker | `TrinityScaleSelector(value:)` |
| Toggle chip | `TrinityToggleChip(isOn:)` |
| Text input | `TrinityTextField(...)` |
| Date picker (compact) | `TrinityDateNavigator(...)` |

## Molecules

| Need | Use |
|---|---|
| Generic card surface | `TrinityCard { content }` |
| Card title | `TrinitySectionHeader(...)` (if used outside `TrinitySection`) |
| Metric row (label + value) | `TrinityMetricRow(...)` |
| Empty state | `TrinityEmptyState(...)` |
| Error state | `TrinityErrorState(...)` |
| Card with chart | `TrinityChartCard { chartContent }` |
| Countdown timer | `TrinityCountdownArc(...)` |
| Marker indicator | `TrinityMarkerBar(...)` |
| Wellness scale dot | `TrinityWellnessDot(...)` |
| Day-of-week picker | `TrinityWeekdayPicker(...)` |

## Organisms

| Need | Use |
|---|---|
| Multi-metric card | `TrinityCompoundMetricCard(...)` |
| Detail page wrapper | `TrinityDetailPage { content }` |
| Card waiting on data | `TrinityPendingMetricCard(...)` |
| Trend chart | `TrinityTrendChart(...)` |

## When no Trinity component fits

Before building ad-hoc UI:

1. Could a Trinity component be extended to cover this case?
2. Would another app (VR/GR/TC) benefit from the same component?
3. Is this domain-specific enough that it should stay in the app?

If 1 or 2 — propose adding to Trinity. If 3 — keep it in the app, but use
Trinity tokens and modifiers for spacing/typography/layout.
