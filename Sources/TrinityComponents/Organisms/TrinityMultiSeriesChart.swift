import SwiftUI
import Charts
import TrinityTokens
import TrinityTheme

// MARK: - Data types

/// A single date-value point used by `TrinityMultiSeriesChart` and `TrinityChartSeries`.
public struct TrinityDataPoint: Identifiable {
    public var id: Date { date }
    public let date: Date
    public let value: Double

    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}

/// One named series of data points for use in `TrinityMultiSeriesChart`.
public struct TrinityChartSeries: Identifiable {
    public var id: String { name }
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
    public let baseline: Double?
    /// `nil` = auto: legend shown when `series.count > 1`.
    /// `false` = always hidden. `true` = always shown.
    public let showLegend: Bool?
    public let yAxisLabel: String
    public let yRange: ClosedRange<Double>?

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
                    // sub-token geometry: no xxxs step in TrinitySpacing
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
        var candidates = [values.min() ?? 0, values.max() ?? 1]
        if let b = baseline { candidates.append(b) }
        let minVal = (candidates.min()! * 0.9)
        let maxVal = (candidates.max()! * 1.1)
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

private struct _MultiSeriesLegendPreview: View {
    @Environment(\.theme) private var theme
    var body: some View {
        TrinityChartCard(title: "Training Load") {
            TrinityMultiSeriesChart(
                series: [
                    .init(name: "CTL", points: makeDemoPoints(count: 28, base: 55, variance: 5), color: theme.accent),
                    .init(name: "ATL", points: makeDemoPoints(count: 28, base: 62, variance: 8), color: theme.chartSecondary),
                ],
                baseline: 50,
                yAxisLabel: "TSS"
            )
            .frame(height: 150)
        }
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
    }
}

#Preview("Multi-series with legend") {
    _MultiSeriesLegendPreview()
}
#endif
