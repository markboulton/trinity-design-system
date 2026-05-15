# Trinity Design System — Phase 0 Addendum Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the 3 genuinely missing components from the Phase 0 addendum design spec: `TrinityCardHeader`, `TrinityMetricCard`, and `TrinityMultiSeriesChart`.

**Architecture:** 5 of the 8 planned addendum components (`TrinityProgressBar`, `TrinitySegmentedFilter`, `TrinityTextField`, `TrinityEmptyState`, `TrinityErrorState`) were already implemented in earlier Phase 0 work. `TrinityTrendChart` covers single-series charting — `TrinityMultiSeriesChart` adds multi-series. Each component follows established Trinity patterns: `@Environment(\.theme)` for all colour access, `TrinitySpacing`/`TrinityTypography`/`TrinityIcons` tokens throughout, `#if canImport(UIKit)` guards on `#Preview` blocks. All new components must compile under macOS 13.0 (the package minimum) and target iOS 17+.

**Tech Stack:** Swift 5.9 / SwiftUI, Swift Charts (Task 42 only), TrinityTokens, TrinityTheme, TrinityComponents

---

## Context for the implementer

The Trinity Design System is a Swift package at `/Users/markboulton/dev/trinity-design-system/` with three products:
- `TrinityTokens` — spacing, typography, colour, icons (no UIKit dependency)
- `TrinityTheme` — `Theme` protocol + demo themes (`DemoTRTTheme`, `DemoVRTheme`, `DemoGRTheme`)
- `TrinityComponents` — SwiftUI components (depends on both above)

All component files live under `Sources/TrinityComponents/`. The Gallery app at `Gallery/Gallery/` previews all components. SourceKit may report "No such module 'TrinityTokens'" — this is an IDE false positive; `swift build` is authoritative.

Key tokens used throughout (reference these — never hardcode values):
- Spacing: `TrinitySpacing.xs`, `.sm`, `.md`, `.lg`, `.xl`, `.xxl`, `.cardPadding`, `.cardCornerRadius`, `.cardContentSpacing`, `.xxs`
- Typography: `TrinityTypography.headline`, `.subheadline`, `.subheadlineEmphasis`, `.captionSmall`, `.captionSmallEmphasis`, `.captionEmphasis`, `.numericLarge`, `.sectionEyebrowTracking`
- Icons: `TrinityIcons.chevronRight`, `TrinityIcons.Size.small`
- Opacity: `TrinityOpacity.tonalFill`, `TrinityOpacity.subtle`
- Border: `TrinityBorderWidth.thin`, `TrinityBorderWidth.hairline`
- Radii: `TrinityRadii.button`
- Status colours: `TrinityStatusColors.success`, `.warning`, `.error`
- Chart: `theme.chartGrid`, `theme.chartPrimary`

Build command: `cd /Users/markboulton/dev/trinity-design-system && swift build`
Expected output: `Build complete!`

---

## File Structure

**New files:**
- `Sources/TrinityComponents/Molecules/TrinityCardHeader.swift`
- `Sources/TrinityComponents/Molecules/TrinityMetricCard.swift`
- `Sources/TrinityComponents/Organisms/TrinityMultiSeriesChart.swift`

**Modified files:**
- `Gallery/Gallery/Pages/MoleculesPage.swift` — add `cardHeaderSection` and `metricCardSection`
- `Gallery/Gallery/Pages/OrganismsPage.swift` — add `multiSeriesChartSection`

---

### Task 40: TrinityCardHeader

A standalone card-level header molecule with icon, title, optional subtitle, and optional trailing action. Distinct from `TrinitySectionHeader` (page-level) and `TrinityCard`'s baked-in header (not reusable outside a card). Use above charts, inside custom card layouts, or anywhere a header row is needed independently.

**Files:**
- Create: `Sources/TrinityComponents/Molecules/TrinityCardHeader.swift`
- Modify: `Gallery/Gallery/Pages/MoleculesPage.swift`

- [ ] **Step 1: Create `TrinityCardHeader.swift`**

```swift
import SwiftUI
import TrinityTokens
import TrinityTheme

/// Card-level header with optional leading icon, title, optional subtitle,
/// and optional trailing text action. Use this standalone molecule wherever
/// a header row is needed independently from a TrinityCard container —
/// e.g. above a chart, inside a custom layout, or as a section label with
/// an action pill.
///
/// Usage:
/// ```swift
/// TrinityCardHeader(title: "Recovery")
/// TrinityCardHeader(
///     title: "Blood Work",
///     subtitle: "Last updated 3 days ago",
///     icon: "drop.fill",
///     iconColor: TrinityStatusColors.error,
///     trailingAction: .init(label: "See all") { ... }
/// )
/// ```
public struct TrinityCardHeader: View {

    @Environment(\.theme) private var theme

    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let iconColor: Color?

    public struct Action {
        public let label: String
        public let handler: () -> Void

        public init(label: String, handler: @escaping () -> Void) {
            self.label = label
            self.handler = handler
        }
    }

    public let trailingAction: Action?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color? = nil,
        trailingAction: Action? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.trailingAction = trailingAction
    }

    public var body: some View {
        HStack(alignment: .top, spacing: TrinitySpacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(iconColor ?? theme.accent)
                    .frame(minWidth: TrinityIcons.Size.small)
            }

            VStack(alignment: .leading, spacing: TrinitySpacing.xxs) {
                Text(title)
                    .font(TrinityTypography.headline)
                    .foregroundStyle(theme.labelPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(TrinityTypography.subheadline)
                        .foregroundStyle(theme.labelSecondary)
                }
            }

            Spacer()

            if let action = trailingAction {
                Button(action: action.handler) {
                    Text(action.label)
                        .font(TrinityTypography.subheadlineEmphasis)
                        .foregroundStyle(theme.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if canImport(UIKit)
#Preview("Title only") {
    TrinityCardHeader(title: "Recovery")
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("With icon and subtitle") {
    TrinityCardHeader(
        title: "Blood Work",
        subtitle: "Last updated 3 days ago",
        icon: "drop.fill",
        iconColor: TrinityStatusColors.error
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("With trailing action") {
    TrinityCardHeader(
        title: "Insights",
        icon: "lightbulb.fill",
        trailingAction: .init(label: "See all") {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
```

- [ ] **Step 2: Build to verify it compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

If there are errors, fix them before continuing. Common issue: `TrinityIcons.Size.small` — verify it is `CGFloat`. If a token name doesn't exist, look at neighbouring component files for the correct name.

- [ ] **Step 3: Add `cardHeaderSection` to `MoleculesPage.swift`**

Open `Gallery/Gallery/Pages/MoleculesPage.swift`. Add `cardHeaderSection` to the `body`'s `VStack` **before** `cardSection` (so it appears first in the list — it's a foundational molecule):

```swift
// In body's VStack — add as first item:
cardHeaderSection
cardSection
metricRowSection
emptyStateSection
// ... rest unchanged
```

Add the section implementation at the bottom of the file, before the closing `}`:

```swift
private var cardHeaderSection: some View {
    VStack(alignment: .leading, spacing: TrinitySpacing.md) {
        Text("TrinityCardHeader").font(TrinityTypography.titleMedium)
        TrinityCardHeader(title: "Recovery")
        Divider()
        TrinityCardHeader(
            title: "Blood Work",
            subtitle: "Last updated 3 days ago",
            icon: "drop.fill",
            iconColor: TrinityStatusColors.error
        )
        Divider()
        TrinityCardHeader(
            title: "Insights",
            icon: "lightbulb.fill",
            trailingAction: .init(label: "See all") {}
        )
    }
}
```

- [ ] **Step 4: Build again to verify Gallery compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

- [ ] **Step 5: Commit**

```bash
cd /Users/markboulton/dev/trinity-design-system && git add Sources/TrinityComponents/Molecules/TrinityCardHeader.swift Gallery/Gallery/Pages/MoleculesPage.swift && git commit -m "feat(molecules): add TrinityCardHeader standalone card header molecule"
```

---

### Task 41: TrinityMetricCard

A lightweight molecule showing a category eyebrow, a large numeric value, an optional unit, an optional directional trend badge, and an optional sparkline slot. Unlike `TrinityCompoundMetricCard` (a full self-contained card organism with rows), this is an embeddable display-only molecule — the caller wraps it in whatever container they need.

Defines `TrinityTrendDirection` and `TrinityTrend` as new top-level types. Note: `TrinityMetricRow` already has a nested `TrinityMetricRow.Trend` enum (`.up`, `.down`, `.stable`, `.none`) — the new `TrinityTrendDirection` top-level enum is separate and does not conflict.

**Files:**
- Create: `Sources/TrinityComponents/Molecules/TrinityMetricCard.swift`
- Modify: `Gallery/Gallery/Pages/MoleculesPage.swift`

- [ ] **Step 1: Create `TrinityMetricCard.swift`**

```swift
import SwiftUI
import TrinityTokens
import TrinityTheme

// MARK: - Trend types

/// Directional indicator for a `TrinityMetricCard` trend badge.
public enum TrinityTrendDirection {
    case up, down, neutral
}

/// A trend badge value shown on a `TrinityMetricCard`.
public struct TrinityTrend {
    public let displayText: String       // e.g. "+8%" or "↑ 3"
    public let direction: TrinityTrendDirection

    public init(displayText: String, direction: TrinityTrendDirection) {
        self.displayText = displayText
        self.direction = direction
    }
}

// MARK: - TrinityMetricCard

/// Lightweight metric display molecule: category eyebrow, large numeric value,
/// optional unit, optional directional trend badge, and an optional sparkline slot.
///
/// Unlike `TrinityCompoundMetricCard` (a self-contained organism with card chrome
/// and supplementary rows), this molecule is meant to be embedded inside any
/// container — a `TrinityCard`, a custom layout, or a full-bleed section.
///
/// Usage — no sparkline:
/// ```swift
/// TrinityMetricCard(category: "Recovery", value: "82", unit: "/100",
///                   trend: .init(displayText: "+6", direction: .up))
/// ```
///
/// Usage — with sparkline:
/// ```swift
/// TrinityMetricCard(category: "Volume", value: "14,200", unit: "kg",
///                   trend: .init(displayText: "+8%", direction: .up)) {
///     TrinityBarSparkline(values: weeklyVolume, tint: theme.accent)
///         .frame(height: 32)
/// }
/// ```
public struct TrinityMetricCard<Sparkline: View>: View {

    @Environment(\.theme) private var theme

    public let category: String
    public let value: String
    public var unit: String?
    public var trend: TrinityTrend?
    @ViewBuilder public var sparkline: () -> Sparkline

    public init(
        category: String,
        value: String,
        unit: String? = nil,
        trend: TrinityTrend? = nil,
        @ViewBuilder sparkline: @escaping () -> Sparkline
    ) {
        self.category = category
        self.value = value
        self.unit = unit
        self.trend = trend
        self.sparkline = sparkline
    }

    private var trendColor: Color {
        guard let trend else { return theme.labelMuted }
        switch trend.direction {
        case .up:      return TrinityStatusColors.success
        case .down:    return TrinityStatusColors.error
        case .neutral: return theme.labelMuted
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            // Eyebrow
            Text(category)
                .font(TrinityTypography.captionSmallEmphasis)
                .textCase(.uppercase)
                .tracking(TrinityTypography.sectionEyebrowTracking)
                .foregroundStyle(theme.labelSecondary)

            // Value row
            HStack(alignment: .firstTextBaseline, spacing: TrinitySpacing.xxs) {
                Text(value)
                    .font(TrinityTypography.numericLarge)
                    .foregroundStyle(theme.labelPrimary)

                if let unit {
                    Text(unit)
                        .font(TrinityTypography.subheadline)
                        .foregroundStyle(theme.labelSecondary)
                }

                Spacer()

                if let trend {
                    Text(trend.displayText)
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(trendColor)
                        .padding(.horizontal, TrinitySpacing.xs)
                        .padding(.vertical, 2)
                        .background(trendColor.opacity(TrinityOpacity.tonalFill))
                        .clipShape(RoundedRectangle(cornerRadius: TrinityRadii.button))
                }
            }

            // Sparkline slot
            sparkline()
        }
    }
}

// MARK: - No-sparkline convenience init

extension TrinityMetricCard where Sparkline == EmptyView {
    public init(
        category: String,
        value: String,
        unit: String? = nil,
        trend: TrinityTrend? = nil
    ) {
        self.init(
            category: category,
            value: value,
            unit: unit,
            trend: trend,
            sparkline: { EmptyView() }
        )
    }
}

// MARK: - Previews

#if canImport(UIKit)
#Preview("No sparkline, no trend") {
    TrinityMetricCard(category: "Recovery", value: "82", unit: "/100")
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("With trend badges") {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityMetricCard(
            category: "Recovery",
            value: "82",
            unit: "/100",
            trend: .init(displayText: "+6", direction: .up)
        )
        TrinityMetricCard(
            category: "Strain",
            value: "67",
            unit: "/100",
            trend: .init(displayText: "−4", direction: .down)
        )
        TrinityMetricCard(
            category: "Readiness",
            value: "75",
            unit: "/100",
            trend: .init(displayText: "→", direction: .neutral)
        )
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

private struct _MetricCardSparklinePreview: View {
    @Environment(\.theme) private var theme
    private let bars: [Double] = [3200, 5100, 4800, 6200, 7100, 3900, 5500]
    var body: some View {
        TrinityMetricCard(
            category: "Volume",
            value: "14,200",
            unit: "kg",
            trend: .init(displayText: "+8%", direction: .up)
        ) {
            TrinityBarSparkline(values: bars, tint: theme.accent)
                .frame(height: 32)
        }
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
    }
}

#Preview("With bar sparkline") {
    _MetricCardSparklinePreview()
}
#endif
```

- [ ] **Step 2: Build to verify it compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

Common issue: if `TrinityTypography.captionEmphasis` doesn't exist, check `TrinityMetricRow.swift` for the correct small-emphasis typography token name and substitute it.

- [ ] **Step 3: Add `metricCardSection` to `MoleculesPage.swift`**

Open `Gallery/Gallery/Pages/MoleculesPage.swift`. Add `metricCardSection` to the `body`'s `VStack` after `cardHeaderSection`:

```swift
// In body's VStack:
cardHeaderSection
metricCardSection     // add this
cardSection
metricRowSection
// ... rest unchanged
```

Add a private constant for sparkline data at the top of the struct (alongside existing properties):

```swift
private let metricBars: [Double] = [3200, 5100, 4800, 6200, 7100, 3900, 5500]
```

Add the section implementation at the bottom of the file, before the closing `}`:

```swift
private var metricCardSection: some View {
    VStack(alignment: .leading, spacing: TrinitySpacing.md) {
        Text("TrinityMetricCard").font(TrinityTypography.titleMedium)
        TrinityCard {
            VStack(spacing: TrinitySpacing.cardContentSpacing) {
                TrinityMetricCard(
                    category: "Recovery",
                    value: "82",
                    unit: "/100",
                    trend: .init(displayText: "+6", direction: .up)
                )
                Divider()
                TrinityMetricCard(
                    category: "Volume",
                    value: "14,200",
                    unit: "kg",
                    trend: .init(displayText: "+8%", direction: .up)
                ) {
                    TrinityBarSparkline(values: metricBars, tint: theme.accent)
                        .frame(height: 28)
                }
            }
        }
    }
}
```

- [ ] **Step 4: Build again to verify Gallery compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

- [ ] **Step 5: Commit**

```bash
cd /Users/markboulton/dev/trinity-design-system && git add Sources/TrinityComponents/Molecules/TrinityMetricCard.swift Gallery/Gallery/Pages/MoleculesPage.swift && git commit -m "feat(molecules): add TrinityMetricCard with trend badge and sparkline slot"
```

---

### Task 42: TrinityMultiSeriesChart

A multi-series line chart organism. `TrinityTrendChart` covers single-series use cases; `TrinityMultiSeriesChart` adds support for 1–N named series with automatic legend display. Apps provide `TrinityChartSeries` values — each with a name, data points, and a colour. Trinity owns rendering, axis treatment, and theming.

Defines `TrinityDataPoint` and `TrinityChartSeries` as new top-level public types. These are standalone (not nested) so both `TrinityMultiSeriesChart` and future organisms can use them without importing a specific component.

**Files:**
- Create: `Sources/TrinityComponents/Organisms/TrinityMultiSeriesChart.swift`
- Modify: `Gallery/Gallery/Pages/OrganismsPage.swift`

- [ ] **Step 1: Create `TrinityMultiSeriesChart.swift`**

```swift
import SwiftUI
import Charts
import TrinityTokens
import TrinityTheme

// MARK: - Data types

/// A single date-value point used by `TrinityMultiSeriesChart` and `TrinityChartSeries`.
public struct TrinityDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let value: Double

    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}

/// One named series of data points for use in `TrinityMultiSeriesChart`.
public struct TrinityChartSeries: Identifiable {
    public let id = UUID()
    public let name: String
    public let points: [TrinityDataPoint]
    public let color: Color

    public init(name: String, points: [TrinityDataPoint], color: Color) {
        self.name = name
        self.points = points
        self.color = color
    }
}

// MARK: - TrinityMultiSeriesChart

/// Multi-series line chart using Swift Charts. Renders 1–N named series
/// with Catmull-Rom interpolation, optional dashed baseline RuleMark, and
/// an auto legend when `series.count > 1`.
///
/// Apps own domain concerns: which series to pass, their colours, period
/// selection, and any wrapping `TrinityChartCard`. Trinity owns rendering,
/// axis treatment, and theming.
///
/// Usage — single series:
/// ```swift
/// TrinityMultiSeriesChart(
///     series: [.init(name: "HRV", points: points, color: theme.accent)],
///     yAxisLabel: "ms",
///     yRange: 0...100
/// )
/// ```
///
/// Usage — multi-series with auto legend:
/// ```swift
/// TrinityMultiSeriesChart(
///     series: [
///         .init(name: "CTL", points: ctlPoints, color: theme.accent),
///         .init(name: "ATL", points: atlPoints, color: theme.chartSecondary),
///     ],
///     baseline: 50,
///     yAxisLabel: "TSS"
/// )
/// ```
public struct TrinityMultiSeriesChart: View {

    @Environment(\.theme) private var theme

    public let series: [TrinityChartSeries]
    /// Optional dashed horizontal baseline RuleMark.
    public var baseline: Double?
    /// `nil` = auto: legend shown when `series.count > 1`.
    /// `false` = always hidden. `true` = always shown.
    public var showLegend: Bool?
    public var yAxisLabel: String
    public var yRange: ClosedRange<Double>?

    public init(
        series: [TrinityChartSeries],
        baseline: Double? = nil,
        showLegend: Bool? = nil,
        yAxisLabel: String = "",
        yRange: ClosedRange<Double>? = nil
    ) {
        self.series = series
        self.baseline = baseline
        self.showLegend = showLegend
        self.yAxisLabel = yAxisLabel
        self.yRange = yRange
    }

    private var shouldShowLegend: Bool {
        showLegend ?? (series.count > 1)
    }

    private var allPoints: [TrinityDataPoint] {
        series.flatMap(\.points)
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            if shouldShowLegend {
                legendView
            }

            if allPoints.isEmpty {
                Text("No data")
                    .font(TrinityTypography.caption)
                    .foregroundStyle(theme.labelTertiary)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
            } else {
                chartView
                    .frame(height: 150)
            }
        }
    }

    // MARK: - Chart

    private var chartView: some View {
        Chart {
            if let baseline {
                RuleMark(y: .value("Baseline", baseline))
                    .foregroundStyle(theme.labelMuted.opacity(TrinityOpacity.subtle))
                    .lineStyle(StrokeStyle(
                        lineWidth: TrinityBorderWidth.thin,
                        dash: [4, 4]
                    ))
            }

            ForEach(series) { s in
                ForEach(s.points) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value(yAxisLabel.isEmpty ? "Value" : yAxisLabel, point.value),
                        series: .value("Series", s.name)
                    )
                    .foregroundStyle(s.color)
                    .interpolationMethod(.catmullRom)
                }
            }
        }
        .chartYScale(domain: chartYDomain)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: xAxisStride)) { _ in
                AxisGridLine()
                    .foregroundStyle(theme.chartGrid)
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    .font(TrinityTypography.captionSmall)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine()
                    .foregroundStyle(theme.chartGrid)
                AxisValueLabel()
                    .font(TrinityTypography.captionSmall)
            }
        }
    }

    // MARK: - Legend

    private var legendView: some View {
        HStack(spacing: TrinitySpacing.md) {
            ForEach(series) { s in
                HStack(spacing: TrinitySpacing.xxs) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(s.color)
                        .frame(width: 12, height: 2)
                    Text(s.name)
                        .font(TrinityTypography.captionSmall)
                        .foregroundStyle(theme.labelSecondary)
                }
            }
        }
    }

    // MARK: - Helpers

    private var chartYDomain: ClosedRange<Double> {
        if let range = yRange { return range }
        let values = allPoints.map(\.value)
        let minVal = (values.min() ?? 0) * 0.9
        let maxVal = (values.max() ?? 1) * 1.1
        return max(minVal, 0)...max(maxVal, 1)
    }

    private var xAxisStride: Int {
        let days = series.map(\.points.count).max() ?? 0
        if days <= 7  { return 1 }
        if days <= 14 { return 2 }
        return 5
    }
}

// MARK: - Previews

#if canImport(UIKit)
private func makeDemoPoints(count: Int, base: Double, variance: Double) -> [TrinityDataPoint] {
    (0..<count).map { i in
        TrinityDataPoint(
            date: Calendar.current.date(byAdding: .day, value: -(count - 1 - i), to: Date())!,
            value: base + Double.random(in: -variance...variance)
        )
    }
}

#Preview("Single series") {
    TrinityChartCard(title: "Resting HR (14 days)") {
        TrinityMultiSeriesChart(
            series: [.init(name: "HR", points: makeDemoPoints(count: 14, base: 58, variance: 4), color: TrinityStatusColors.error)],
            yAxisLabel: "bpm",
            yRange: 45...75
        )
        .frame(height: 150)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Multi-series with legend") {
    TrinityChartCard(title: "Training Load") {
        TrinityMultiSeriesChart(
            series: [
                .init(name: "CTL", points: makeDemoPoints(count: 28, base: 55, variance: 5), color: Color(red: 0.145, green: 0.388, blue: 0.922)),
                .init(name: "ATL", points: makeDemoPoints(count: 28, base: 62, variance: 8), color: Color(red: 0.976, green: 0.451, blue: 0.086)),
            ],
            baseline: 50,
            yAxisLabel: "TSS"
        )
        .frame(height: 150)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
```

- [ ] **Step 2: Build to verify it compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

Common issue: `import Charts` — Swift Charts is available on iOS 16+ / macOS 13+. The package already imports it in `TrinityTrendChart.swift`, so no Package.swift change is needed.

If the build fails with "Charts not found", look at `Package.swift` to see how TrinityTrendChart declares its Charts dependency and mirror it.

- [ ] **Step 3: Add `multiSeriesChartSection` to `OrganismsPage.swift`**

Open `Gallery/Gallery/Pages/OrganismsPage.swift`. Add a `sampleMultiSeries` static property alongside `sampleData`, and add `multiSeriesChartSection` to the `body`'s `VStack` after `trendChartSection`:

In the struct-level static properties block:

```swift
private static let sampleCTL: [TrinityDataPoint] = {
    let cal = Calendar.current
    let today = Date()
    return (0..<21).map { offset in
        TrinityDataPoint(
            date: cal.date(byAdding: .day, value: -offset, to: today)!,
            value: Double.random(in: 50...65)
        )
    }
    .reversed()
}()

private static let sampleATL: [TrinityDataPoint] = {
    let cal = Calendar.current
    let today = Date()
    return (0..<21).map { offset in
        TrinityDataPoint(
            date: cal.date(byAdding: .day, value: -offset, to: today)!,
            value: Double.random(in: 55...75)
        )
    }
    .reversed()
}()
```

In `body`'s `VStack`:

```swift
compoundMetricSection
pendingMetricSection
trendChartSection
multiSeriesChartSection   // add after trendChartSection
rangeChartSection
detailPageNote
```

Add the section implementation before the closing `}`:

```swift
private var multiSeriesChartSection: some View {
    VStack(alignment: .leading, spacing: TrinitySpacing.md) {
        Text("TrinityMultiSeriesChart").font(TrinityTypography.titleMedium)
        TrinityChartCard(title: "Training Load (21 days)") {
            TrinityMultiSeriesChart(
                series: [
                    .init(name: "CTL",
                          points: Self.sampleCTL,
                          color: Color(red: 0.145, green: 0.388, blue: 0.922)),
                    .init(name: "ATL",
                          points: Self.sampleATL,
                          color: Color(red: 0.976, green: 0.451, blue: 0.086))
                ],
                baseline: 50,
                yAxisLabel: "TSS"
            )
            .frame(height: 160)
        }
    }
}
```

- [ ] **Step 4: Build again to verify Gallery compiles**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

- [ ] **Step 5: Commit**

```bash
cd /Users/markboulton/dev/trinity-design-system && git add Sources/TrinityComponents/Organisms/TrinityMultiSeriesChart.swift Gallery/Gallery/Pages/OrganismsPage.swift && git commit -m "feat(organisms): add TrinityMultiSeriesChart with TrinityChartSeries and TrinityDataPoint"
```

---

### Task 43: Phase 0 Addendum Verification

Confirm all 8 addendum components are present and the package builds cleanly. Note: 5 were pre-existing (`TrinityProgressBar`, `TrinitySegmentedFilter`, `TrinityTextField`, `TrinityEmptyState`, `TrinityErrorState`); 3 were added by this plan (`TrinityCardHeader`, `TrinityMetricCard`, `TrinityMultiSeriesChart`).

**Files:** None created. Read-only verification.

- [ ] **Step 1: Verify all 8 addendum source files exist**

```bash
ls /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Atoms/TrinityProgressBar.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Atoms/TrinitySegmentedFilter.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Atoms/TrinityTextField.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Molecules/TrinityEmptyState.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Molecules/TrinityErrorState.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Molecules/TrinityCardHeader.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Molecules/TrinityMetricCard.swift \
   /Users/markboulton/dev/trinity-design-system/Sources/TrinityComponents/Organisms/TrinityMultiSeriesChart.swift
```

Expected: all 8 paths print with no errors.

- [ ] **Step 2: Final clean build**

```bash
cd /Users/markboulton/dev/trinity-design-system && swift build
```

Expected: `Build complete!`

- [ ] **Step 3: Verify Gallery pages reference all 3 new components**

```bash
grep -n "TrinityCardHeader\|TrinityMetricCard\|TrinityMultiSeriesChart" \
  /Users/markboulton/dev/trinity-design-system/Gallery/Gallery/Pages/MoleculesPage.swift \
  /Users/markboulton/dev/trinity-design-system/Gallery/Gallery/Pages/OrganismsPage.swift
```

Expected: at least one hit per component (2 hits in MoleculesPage, 1 in OrganismsPage).

- [ ] **Step 4: Commit verification**

```bash
cd /Users/markboulton/dev/trinity-design-system && git log --oneline -5
```

Expected: 3 feat commits from Tasks 40, 41, and 42 are visible at the top.

- [ ] **Step 5: Update the Phase 0 addendum design spec to reflect actual completion**

Open `docs/superpowers/specs/2026-05-15-trinity-phase-0-addendum-design.md`. Replace the task sequencing table with:

```markdown
## Implementation Status

| Task | Component | Status |
|------|-----------|--------|
| 40 | `TrinityProgressBar` | ✅ Pre-existing (earlier Phase 0 work) |
| 41 | `TrinitySegmentedFilter` | ✅ Pre-existing |
| 42 | `TrinityTextField` | ✅ Pre-existing |
| 43 | `TrinityEmptyState` | ✅ Pre-existing |
| 44 | `TrinityErrorState` | ✅ Pre-existing |
| 45 | `TrinityCardHeader` | ✅ Implemented (plan tasks 40–41) |
| 46 | `TrinityMetricCard` | ✅ Implemented (plan task 41) |
| 47 | `TrinityMultiSeriesChart` | ✅ Implemented (plan task 42) |
```

Then commit:

```bash
cd /Users/markboulton/dev/trinity-design-system && git add docs/superpowers/specs/2026-05-15-trinity-phase-0-addendum-design.md && git commit -m "docs: mark Phase 0 addendum components as complete"
```

---

## Phase 0 Addendum — Done

All 8 components from the design spec are present in `TrinityComponents`. Phase 0 is now complete. Next step: Phase 1 VeloReady migration.
