# Trinity Design System — Phase 0 Addendum Design

**Brainstorm date:** 2026-05-15
**Scope:** 8 new Trinity components identified from cross-app audit of VeloReady, GymReady, and TRT Companion. These extend Phase 0 (tasks 40–47) before Phase 1 VeloReady migration begins.

---

## Context

Phase 0 (tasks 1–39) established the core Trinity component set. This addendum adds components identified during a full audit of VeloReady's design patterns, validated against GymReady and TRT Companion.

**Extraction criterion:** Cross-app plausible — exists in VeloReady today, and GymReady or a future app would clearly benefit, even if it doesn't exist there yet.

**Canonical source:** TRT Companion throughout. It is the newest, most intentional app in the family. Each task begins with reading TC's implementation before writing the Trinity equivalent.

---

## Component Inventory

### Atoms

| Component | What it does | Canonical source |
|-----------|-------------|-----------------|
| `TrinityProgressBar` | Horizontal track + fill, 0–1 value, optional tint. For dose adherence, habit tracking, zone distributions. Score rings (`TrinityProgressRing`) are unchanged and remain the VeloReady core UI pattern. | TRT Companion |
| `TrinitySegmentedFilter` | Horizontal pill segment picker. Generic `[SegmentOption]` array, mutually exclusive selection. | TRT Companion |
| `TrinityTextField` (+ inputs) | Styled text input with label, border, focus treatment. Additional input types (numeric, secure) determined by TC audit. | TRT Companion |

### Molecules

| Component | What it does | Canonical source |
|-----------|-------------|-----------------|
| `TrinityCardHeader` | Prescriptive slots: leading icon, title, subtitle, trailing action. Standard card header across all apps. | TRT Companion |
| `TrinityMetricCard` | Category label + large numeric value + unit + optional trend badge + optional sparkline slot. | TRT Companion |
| `TrinityEmptyState` | Icon + title + subtitle + optional CTA button. Shown when a card or screen has no data. | TRT Companion |
| `TrinityErrorState` | Error icon + message + retry button. Shown when a load fails. | TRT Companion |

### Organisms

| Component | What it does | Canonical source |
|-----------|-------------|-----------------|
| `TrinityDataChart` | Multi-series line chart. `TrinityChartSeries` type, optional baseline RuleMark, auto legend when `series.count > 1`. Apps own domain concerns (colours, period selection); Trinity owns rendering and theming. | TRT Companion |

---

## Architecture

### TrinityDataChart — public API

```swift
public struct TrinityChartSeries {
    public let name: String
    public let values: [(date: Date, value: Double)]
    public let color: Color
}

public struct TrinityDataChart: View {
    public let series: [TrinityChartSeries]
    public var baseline: Double? = nil       // dashed RuleMark
    public var showLegend: Bool? = nil       // nil = auto (shows when series.count > 1), false = always hidden, true = always shown
}
```

Apps configure which series to show, colours, and period selection. Trinity owns axis treatment, interpolation, theming.

### TrinityMetricCard — slot composition

```swift
public struct TrinityMetricCard<Sparkline: View>: View {
    public let category: String
    public let value: String
    public var unit: String? = nil
    public var trend: TrinityTrend? = nil    // optional "+8%" badge
    @ViewBuilder public var sparkline: () -> Sparkline
}
```

The sparkline slot accepts any View — typically `TrinityLineSparkline` or `TrinityBarSparkline`, which already exist in Trinity.

### TrinityTrend type

```swift
public struct TrinityTrend {
    public let value: String     // e.g. "+8%"
    public let direction: TrinityTrendDirection
}

public enum TrinityTrendDirection {
    case up, down, neutral
}
```

Direction controls badge colour: up → green, down → rose, neutral → muted.

### No TrinityToast

Transient floating notifications are explicitly out of scope. `TrinityInfoBanner` handles inline confirmations. Apps should favour inline state changes over toasts.

### Gallery coverage

Every new component gets a section in the appropriate Gallery page (AtomsPage / MoleculesPage / OrganismsPage) with light and dark preview. ThemeComparisonPage is updated where the component is theme-sensitive. This is required for every task, not optional.

---

## Task Sequencing (Tasks 40–47)

Dependencies flow atom → molecule → organism.

| Task | Component | Layer | Key dependency |
|------|-----------|-------|----------------|
| 40 | `TrinityProgressBar` | Atom | None |
| 41 | `TrinitySegmentedFilter` | Atom | None |
| 42 | `TrinityTextField` (+ inputs) | Atom | TC audit determines full input set |
| 43 | `TrinityCardHeader` | Molecule | None beyond existing Trinity |
| 44 | `TrinityEmptyState` | Molecule | `TrinityButton` (exists) |
| 45 | `TrinityErrorState` | Molecule | `TrinityButton` (exists), visual language from Task 44 |
| 46 | `TrinityMetricCard` | Molecule | `TrinityLineSparkline`, `TrinityBarSparkline` (exist); `TrinityTrend` defined in this task |
| 47 | `TrinityDataChart` | Organism | Swift Charts; most complex — audit TC carefully before implementing |

Each task follows the same structure:
1. Read TC canonical source
2. Implement Trinity component
3. Add Gallery page section
4. Commit

---

## Out of Scope

- **TrinityToast** — explicitly rejected. InfoBanner handles inline confirmations.
- **VeloReady score rings replacement** — `TrinityProgressRing` remains unchanged. Score rings (Recovery, Sleep, Strain) are VeloReady core UI and are not replaced by `TrinityProgressBar`.
- **Domain-specific chart variants** — CTL/ATL/TSB triple-series chart, hormone protocol charts. Apps build these on top of `TrinityDataChart`.
- **VR composable card system** — `CardHeader`/`CardFooter`/`CardMetric`/`CardContainer` are VeloReady-specific debt. Not extracted into Trinity; replaced by `TrinityCardHeader` + `TrinityCard` composition during Phase 1 migration.
