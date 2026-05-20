//
//  PublicAPISnapshot.swift
//  TrinityComponentsTests
//
//  COMPILE-AS-TEST PUBLIC API SNAPSHOT
//  -----------------------------------
//
//  This file exists to catch *source-breaking changes* to Trinity's public API
//  before they reach VeloReady, GymReady, or TRT Companion. It exercises every
//  public type, initializer, nested enum case, token, and View extension that
//  consumer apps can reach.
//
//  HOW IT WORKS
//
//  The test passes if this file *compiles*. Each `@Test` references a closure
//  that constructs instances. Behaviour is not asserted — the test target's
//  ability to type-check is the assertion. If anything is renamed, removed,
//  or has its signature changed without an `@available(*, deprecated, ...)`
//  shim, this file stops compiling and `swift test` fails.
//
//  HOW TO MAINTAIN
//
//  - Adding a new public component: add a stanza here in the same PR.
//  - Renaming or removing: follow the deprecate-then-remove process documented
//    in PRINCIPLES.md and CLAUDE.md. Update this file in step 1 (add new alongside
//    deprecated), update again in step 3 (remove deprecated).
//  - Do NOT delete entries here to "make the build pass". That defeats the guard.
//
//  Coverage is by-construction, not by-assertion. Reading the source of a type
//  is the way to verify what it does; this file only verifies what it offers.
//

import Testing
import SwiftUI
@testable import TrinityComponents
import TrinityTokens
import TrinityTheme

/// Local stub Theme used by tests that need a Theme instance but cannot
/// rely on the Demo themes (which are `#if canImport(UIKit)`-gated and
/// therefore unavailable when `swift test` runs on a macOS host without
/// UIKit). Mirrors the StubTheme pattern in ThemeConformanceTests.
private struct _StubTheme: Theme {
    var cardBackground: Color { .gray }
    var surfaceElevated: Color { .gray }
    var backgroundTertiary: Color { .gray }
    var labelPrimary: Color { .primary }
    var labelSecondary: Color { .secondary }
    var labelTertiary: Color { .secondary }
    var labelMuted: Color { .secondary }
    var labelOnFill: Color { .white }
    var borderSubtle: Color { .gray }
    var divider: Color { .gray }
    var accent: Color { .blue }
    var accentSubtle: Color { .blue.opacity(0.2) }
    var insightAccent: Color { .purple }
    var insightAccentSubtle: Color { .purple.opacity(0.2) }
    var chartPrimary: Color { .blue }
    var chartSecondary: Color { .orange }
    var chartGrid: Color { .gray }
    var chartAxis: Color { .gray }
    func categoryColor(_ category: TrinityCategoryToken) -> Color { .blue }
    func categorySubtle(_ category: TrinityCategoryToken) -> Color { .blue.opacity(0.2) }
}

// MARK: - Tokens

@Suite("Token namespaces remain reachable")
struct TokenSurfaceTests {

    @Test func spacing() {
        _ = TrinitySpacing.hairline
        _ = TrinitySpacing.xs
        _ = TrinitySpacing.sm
        _ = TrinitySpacing.md
        _ = TrinitySpacing.lg
        _ = TrinitySpacing.xl
        _ = TrinitySpacing.xxl
        _ = TrinitySpacing.huge
        _ = TrinitySpacing.touch
        _ = TrinitySpacing.cardPadding
        _ = TrinitySpacing.cardSpacing
        _ = TrinitySpacing.sectionSpacing
        _ = TrinitySpacing.sectionPadding
        _ = TrinitySpacing.cardContentSpacing
        _ = TrinitySpacing.cardCornerRadius
        _ = TrinitySpacing.buttonCornerRadius
    }

    @Test func typography() {
        _ = TrinityTypography.fontFamily
        _ = TrinityTypography.monoRegular
        _ = TrinityTypography.monoMedium
        _ = TrinityTypography.monoBold
        _ = TrinityTypography.displayLarge
        _ = TrinityTypography.displayMedium
        _ = TrinityTypography.titleLarge
        _ = TrinityTypography.titleLargeEmphasis
        _ = TrinityTypography.titleMedium
        _ = TrinityTypography.titleSmall
        _ = TrinityTypography.headline
        _ = TrinityTypography.body
        _ = TrinityTypography.bodyEmphasis
        _ = TrinityTypography.callout
        _ = TrinityTypography.subheadline
        _ = TrinityTypography.subheadlineEmphasis
        _ = TrinityTypography.footnote
        _ = TrinityTypography.caption
        _ = TrinityTypography.captionEmphasis
        _ = TrinityTypography.caption2
        _ = TrinityTypography.caption2Emphasis
        _ = TrinityTypography.captionBold
        _ = TrinityTypography.captionSmall
        _ = TrinityTypography.captionSmallEmphasis
        _ = TrinityTypography.unitLabel
        _ = TrinityTypography.unitLabelSmall
        _ = TrinityTypography.navigationLargeTitle
        _ = TrinityTypography.navigationTitle
        _ = TrinityTypography.numericLarge
        _ = TrinityTypography.numericMedium
        _ = TrinityTypography.numericSmall
        _ = TrinityTypography.numericCaption
        _ = TrinityTypography.metricLarge
        _ = TrinityTypography.heroMetric
        _ = TrinityTypography.heroNumeric
        _ = TrinityTypography.heroNumericSmall
        _ = TrinityTypography.chartLabel
        _ = TrinityTypography.chartValue
        _ = TrinityTypography.sectionLabel
        _ = TrinityTypography.sectionEyebrowTracking
    }

    @Test func icons() {
        _ = TrinityIcons.Size.small
        _ = TrinityIcons.Size.medium
        _ = TrinityIcons.Size.large
        _ = TrinityIcons.Size.xlarge
        // Spot-check the full name set — any rename here cascades.
        _ = TrinityIcons.chevronRight
        _ = TrinityIcons.chevronDown
        _ = TrinityIcons.chevronUp
        _ = TrinityIcons.xmark
        _ = TrinityIcons.arrowClockwise
        _ = TrinityIcons.checkmark
        _ = TrinityIcons.checkmarkCircle
        _ = TrinityIcons.exclamationTriangle
        _ = TrinityIcons.infoCircle
        _ = TrinityIcons.heart
        _ = TrinityIcons.bed
        _ = TrinityIcons.bolt
        _ = TrinityIcons.figure
        _ = TrinityIcons.flame
        _ = TrinityIcons.lungs
        _ = TrinityIcons.plus
        _ = TrinityIcons.pencil
        _ = TrinityIcons.trash
        _ = TrinityIcons.ellipsis
        _ = TrinityIcons.gear
        _ = TrinityIcons.link
        _ = TrinityIcons.cloud
        _ = TrinityIcons.arrowTriangle2Circlepath
        _ = TrinityIcons.wifi
        _ = TrinityIcons.trayFull
        _ = TrinityIcons.questionMarkCircle
    }

    @Test func radii() {
        _ = TrinityRadii.card
        _ = TrinityRadii.button
        _ = TrinityRadii.pill
        _ = TrinityRadii.sheet
    }

    @Test func opacity() {
        _ = TrinityOpacity.disabled
        _ = TrinityOpacity.subtle
        _ = TrinityOpacity.overlay
        _ = TrinityOpacity.tonalFill
        _ = TrinityOpacity.border
    }

    @Test func borderWidth() {
        _ = TrinityBorderWidth.hairline
        _ = TrinityBorderWidth.thin
        _ = TrinityBorderWidth.medium
    }

    @Test func statusColors() {
        _ = TrinityStatusColors.success
        _ = TrinityStatusColors.warning
        _ = TrinityStatusColors.error
        _ = TrinityStatusColors.wellnessGreen
        _ = TrinityStatusColors.wellnessAmber
        _ = TrinityStatusColors.wellnessRed
        _ = TrinityStatusColors.markerInRange
        _ = TrinityStatusColors.markerOutOfRange
    }

    @Test func brandColors() {
        _ = TrinityBrandColors.gradientStart
        _ = TrinityBrandColors.gradientMid
        _ = TrinityBrandColors.gradientEnd
    }

    @Test func macroColors() {
        _ = TrinityMacroColors.macroProtein
        _ = TrinityMacroColors.macroProteinLabel
        _ = TrinityMacroColors.macroCarbs
        _ = TrinityMacroColors.macroCarbsLabel
        _ = TrinityMacroColors.macroFat
        _ = TrinityMacroColors.macroFatLabel
        _ = TrinityMacroColors.dataVerified
        _ = TrinityMacroColors.dataPartial
        _ = TrinityMacroColors.dataCommunity
    }
}

// MARK: - Theme

@Suite("Theme protocol and demo themes remain reachable")
struct ThemeSurfaceTests {

    @Test func categoryTokens() {
        // All cases must remain — removal breaks app theme implementations.
        for category in TrinityCategoryToken.allCases {
            _ = category.rawValue
        }
    }

    @Test func themeProtocolRequirements() {
        let theme: any Theme = _StubTheme()
        _ = theme.cardBackground
        _ = theme.surfaceElevated
        _ = theme.backgroundTertiary
        _ = theme.labelPrimary
        _ = theme.labelSecondary
        _ = theme.labelTertiary
        _ = theme.labelMuted
        _ = theme.labelOnFill
        _ = theme.borderSubtle
        _ = theme.divider
        _ = theme.accent
        _ = theme.accentSubtle
        _ = theme.insightAccent
        _ = theme.insightAccentSubtle
        _ = theme.chartPrimary
        _ = theme.chartSecondary
        _ = theme.chartGrid
        _ = theme.chartAxis
        _ = theme.categoryColor(.heart)
        _ = theme.categorySubtle(.heart)
    }

    #if canImport(UIKit)
    // Demo themes are UIKit-only; they exist for the Gallery app and theme
    // switching. Apps ship their own real Theme conformance — so these are
    // surface-checked on iOS builds only, but tested above against _StubTheme.
    @Test func demoThemes() {
        _ = DemoTRTTheme()
        _ = DemoVRTheme()
        _ = DemoGRTheme()
    }
    #endif

    @Test func themeEnvironmentModifier() {
        // The .theme(_:) View extension is how apps install their theme.
        _ = EmptyView().theme(_StubTheme())
    }
}

// MARK: - Atoms

@Suite("Atom public initializers remain reachable")
struct AtomSurfaceTests {

    @Test func badge() {
        _ = TrinityBadge(text: "B")
        _ = TrinityBadge(text: "B", size: .small)
        _ = TrinityBadge(text: "B", size: .regular)
    }

    @Test func barSparkline() {
        _ = TrinityBarSparkline(values: [1, 2, 3], tint: .blue)
    }

    @Test func button() {
        _ = TrinityButton("Tap", action: {})
        _ = TrinityButton("Tap", icon: "plus", style: .primary, isLoading: false, isDisabled: false, action: {})
        _ = TrinityButton("Tap", style: .secondary, action: {})
        _ = TrinityButton("Tap", style: .destructive, action: {})
        _ = TrinityButton("Tap", style: .tertiary, action: {})
        _ = TrinityButtonLabel("Tap")
        _ = TrinityButtonLabel("Tap", icon: "plus", style: .primary, isLoading: false)
    }

    @Test func dateNavigator() {
        _ = TrinityDateNavigator(
            title: "Today",
            canGoBack: true,
            canGoForward: true,
            onBack: {},
            onForward: {}
        )
    }

    @Test func flowLayout() {
        _ = TrinityFlowLayout()
        _ = TrinityFlowLayout(spacing: 8)
    }

    @Test func healthKitSyncIndicator() {
        _ = TrinityHealthKitSyncIndicator(state: .idle)
        _ = TrinityHealthKitSyncIndicator(state: .syncing(), isAnalysing: true)
        _ = TrinityHealthKitSyncIndicator(state: .syncing("Custom"), isAnalysing: false)
        _ = TrinityHealthKitSyncIndicator(state: .synced(nil))
        _ = TrinityHealthKitSyncIndicator(state: .synced(Date()))
    }

    @Test func lineSparkline() {
        _ = TrinityLineSparkline(values: [1, 2, 3], tint: .blue)
    }

    @Test func progressBar() {
        _ = TrinityProgressBar(currentStep: 1, totalSteps: 3)
    }

    @Test func progressRing() {
        _ = TrinityProgressRing(value: 0.5)
        _ = TrinityProgressRing(value: 0.5, tint: .blue, centreLabel: "50%", captionLabel: "RANGE", size: 80, lineWidth: 6)
    }

    @Test func pulseLoader() {
        _ = TrinityPulseLoader()
        _ = TrinityPulseLoader(size: 60, lineWidth: 4)
    }

    @Test func scaleSelector() {
        @State var value = 3
        _ = TrinityScaleSelector(label: "Mood", value: $value, sourceLabel: "Manual", isInverted: false)
    }

    @Test func segmentedFilter() {
        @State var selection = "A"
        _ = TrinitySegmentedFilter(
            selection: $selection,
            options: ["A", "B", "C"],
            label: { $0 }
        )
    }

    @Test func skeletonView() {
        _ = TrinitySkeletonView()
        _ = TrinitySkeletonView(height: 50, cornerRadius: 4)
    }

    @Test func stepBar() {
        _ = TrinityStepBar(totalSteps: 3, completedSteps: 1)
    }

    @Test func text() {
        _ = TrinityText("hello")
        _ = TrinityText("hello", style: .body, color: .red)
        // All public styles
        _ = TrinityText("x", style: .displayLarge)
        _ = TrinityText("x", style: .displayMedium)
        _ = TrinityText("x", style: .titleLarge)
        _ = TrinityText("x", style: .titleMedium)
        _ = TrinityText("x", style: .titleSmall)
        _ = TrinityText("x", style: .headline)
        _ = TrinityText("x", style: .body)
        _ = TrinityText("x", style: .bodyEmphasis)
        _ = TrinityText("x", style: .subheadline)
        _ = TrinityText("x", style: .subheadlineEmphasis)
        _ = TrinityText("x", style: .caption)
        _ = TrinityText("x", style: .captionEmphasis)
        _ = TrinityText("x", style: .captionSmall)
        _ = TrinityText("x", style: .captionSmallEmphasis)
        _ = TrinityText("x", style: .numericLarge)
        _ = TrinityText("x", style: .numericMedium)
        _ = TrinityText("x", style: .numericSmall)
        _ = TrinityText("x", style: .sectionEyebrow)
    }

    @Test func textField() {
        @State var text = ""
        _ = TrinityTextField(label: "Name", text: $text)
        _ = TrinityTextField(label: "Name", text: $text, placeholder: "Type", errorMessage: "Bad")
    }

    @Test func toggleChip() {
        @State var on = true
        @State var sev = 1
        _ = TrinityToggleChip(label: "L", isOn: $on)
        _ = TrinityToggleChip(label: "L", isOn: $on, severity: $sev)
    }
}

// MARK: - Molecules

@Suite("Molecule public initializers remain reachable")
struct MoleculeSurfaceTests {

    @Test func card() {
        _ = TrinityCard { Text("inner") }
        _ = TrinityCard(title: "T", icon: "heart", headerColor: .red, showChevron: true) { Text("inner") }
    }

    @Test func cardHeader() {
        _ = TrinityCardHeader(title: "T")
        _ = TrinityCardHeader(
            title: "T",
            subtitle: "S",
            icon: "drop.fill",
            iconColor: .red,
            trailingAction: .init(label: "See all") {}
        )
        // Nested Action initializer.
        _ = TrinityCardHeader.Action(label: "x") {}
    }

    @Test func chartCard() {
        _ = TrinityChartCard { Text("c") }
        _ = TrinityChartCard(title: "T", disclaimer: "D") { Text("c") }
    }

    @Test func countdownArc() {
        _ = TrinityCountdownArc(daysRemaining: 3, totalDays: 7, label: "Until")
    }

    @Test func emptyState() {
        _ = TrinityEmptyState(icon: "tray.fill", title: "T", description: "D")
        _ = TrinityEmptyState(
            icon: "tray.fill",
            title: "T",
            description: "D",
            primaryAction: (label: "P", action: {}),
            secondaryAction: (label: "S", action: {})
        )
    }

    @Test func errorState() {
        _ = TrinityErrorState(title: "T", description: "D", retryAction: {})
        _ = TrinityErrorState(
            title: "T",
            description: "D",
            retryAction: {},
            secondaryAction: (label: "Back", action: {})
        )
    }

    @Test func infoBanner() {
        _ = TrinityInfoBanner(title: "T")
        _ = TrinityInfoBanner(
            severity: .info, title: "T", message: "M",
            actionTitle: "A", action: {}, dismissAction: {}
        )
        _ = TrinityInfoBanner(severity: .warning, title: "T")
        _ = TrinityInfoBanner(severity: .error, title: "T")
        _ = TrinityInfoBanner(severity: .success, title: "T")
    }

    @Test func markerBarAndRow() {
        _ = TrinityMarkerBar(value: 5, rangeLow: 0, rangeHigh: 10, unit: "u")
        _ = TrinityMarkerRow(name: "n", value: 5, unit: "u")
        _ = TrinityMarkerRow(name: "n", value: 5, unit: "u", rangeLow: 0, rangeHigh: 10)
    }

    @Test func metricCard() {
        _ = TrinityMetricCard(category: "C", value: "82")
        _ = TrinityMetricCard(category: "C", value: "82", unit: "/100")
        _ = TrinityMetricCard(
            category: "C", value: "82", unit: "/100",
            trend: .init(displayText: "+6", direction: .up)
        )
        _ = TrinityMetricCard(category: "C", value: "82") {
            TrinityBarSparkline(values: [1, 2, 3], tint: .blue).frame(height: 32)
        }
        // Trend value types
        _ = TrinityTrend(displayText: "+1", direction: .up)
        _ = TrinityTrend(displayText: "−1", direction: .down)
        _ = TrinityTrend(displayText: "→", direction: .neutral)
        for d in TrinityTrendDirection.allCases { _ = d }
    }

    @Test func metricInsightSection() {
        _ = TrinityMetricInsightSection(headline: "H")
        _ = TrinityMetricInsightSection(headline: "H", category: "Watch", iconName: "exclamationmark.triangle.fill", accent: .red)
    }

    @Test func metricRow() {
        _ = TrinityMetricRow(label: "L", value: "V")
        _ = TrinityMetricRow(label: "L", value: "V", unit: "u", trend: .up, trendValue: "+1")
        // All Trend cases.
        _ = TrinityMetricRow.Trend.up
        _ = TrinityMetricRow.Trend.down
        _ = TrinityMetricRow.Trend.stable
        _ = TrinityMetricRow.Trend.none
    }

    @Test func rangeChart() {
        let bucket = TrinityRangeChart.Bucket(date: Date(), low: 0, high: 10)
        _ = TrinityRangeChart(buckets: [bucket], tint: .red)
        _ = TrinityRangeChart(
            buckets: [bucket],
            bucketUnit: .day,
            tint: .red,
            baseline: 5,
            baselineLabel: "B",
            annotateExtremes: true
        )
    }

    @Test func sectionHeader() {
        _ = TrinitySectionHeader(title: "T")
        _ = TrinitySectionHeader(title: "T", trailingAction: .init(label: "x") {})
        _ = TrinitySectionHeader.Action(label: "x") {}
    }

    @Test func weekdayPicker() {
        @State var sel: Set<Int> = [1, 3]
        _ = TrinityWeekdayPicker(selection: $sel)
    }

    @Test func wellnessDot() {
        _ = TrinityWellnessDot(status: .good)
        _ = TrinityWellnessDot(status: .caution)
        _ = TrinityWellnessDot(status: .concerning)
        _ = TrinityWellnessDot(status: .none)
    }

    @Test func severityEnum() {
        for s in [TrinitySeverity.info, .warning, .error, .success] { _ = s }
    }
}

// MARK: - Organisms

@Suite("Organism public initializers remain reachable")
struct OrganismSurfaceTests {

    @Test func compoundMetricCard() {
        _ = TrinityCompoundMetricCard(label: "L", value: "V", unit: "u")
        _ = TrinityCompoundMetricCard(
            label: "L", value: "V", unit: "u",
            rows: [.init(label: "r", value: "1", unit: "u")],
            trailingContent: { EmptyView() },
            bottomContent: { EmptyView() }
        )
    }

    @Test func pendingMetricCard() {
        _ = TrinityPendingMetricCard(label: "L")
        _ = TrinityPendingMetricCard(label: "L", unit: "u", valueShape: .single, rowLabels: ["r1"])
        _ = TrinityPendingMetricCard(label: "L", unit: "u", valueShape: .pair, rowLabels: ["r1", "r2"])
    }

    @Test func trendChart() {
        let dp = TrinityTrendChart.DataPoint(date: Date(), value: 1)
        let om = TrinityTrendChart.OverlayMarker(date: Date(), label: "m")
        let band = TrinityTrendChart.ThresholdBand(low: 0, high: 10, color: .green)
        _ = TrinityTrendChart(
            title: "T",
            data: [dp],
            overlayMarkers: [om],
            thresholdBands: [band],
            yAxisLabel: "y",
            yRange: 0...10,
            showOverlayMarkers: true,
            showGridLines: true,
            showAxisLabels: true,
            showAreaFill: false,
            areaFillColor: nil,
            showDashedProjection: false,
            projectionData: [],
            showPoints: true
        )
    }

    @Test func multiSeriesChart() {
        let dp = TrinityDataPoint(date: Date(), value: 1)
        let series = TrinityChartSeries(name: "S", points: [dp], color: .blue)
        _ = TrinityMultiSeriesChart(series: [series])
        _ = TrinityMultiSeriesChart(
            series: [series],
            baseline: 5,
            showLegend: true,
            yAxisLabel: "y",
            yRange: 0...10
        )
    }

    @Test func detailPage() {
        // Full signature
        _ = TrinityDetailPage(
            title: "T",
            subtitle: "S",
            filter: { EmptyView() },
            chart: { EmptyView() },
            supplementary: { EmptyView() }
        )
        // Chart-only convenience
        _ = TrinityDetailPage(title: "T", chart: { EmptyView() })
        // No-supplementary convenience
        _ = TrinityDetailPage(
            title: "T",
            filter: { EmptyView() },
            chart: { EmptyView() }
        )
        // Row + DeepLink nested types remain reachable
        _ = TrinityDetailPage<EmptyView, EmptyView, EmptyView>.Row(label: "l", value: "v")
        _ = TrinityDetailPage<EmptyView, EmptyView, EmptyView>.DeepLink(label: "l", destination: AnyView(EmptyView()))
    }
}

// MARK: - Layout

@Suite("Layout extensions and wrappers remain reachable")
struct LayoutSurfaceTests {

    @Test func screen() {
        _ = EmptyView().trinityScreen()
        _ = EmptyView().trinityScreen(refreshable: { })
    }

    @Test func cardStack() {
        _ = TrinityCardStack { Text("inner") }
    }

    @Test func section() {
        _ = TrinitySection { Text("inner") }
        _ = TrinitySection("Title") { Text("inner") }
    }

    @Test func push() {
        _ = TrinityPush(
            destination: { Text("dest") },
            label: { Text("label") }
        )
    }

    @Test func sheet() {
        @State var presented = false
        _ = EmptyView().trinitySheet(isPresented: $presented) { Text("sheet content") }
    }
}
