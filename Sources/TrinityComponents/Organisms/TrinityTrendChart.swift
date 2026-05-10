import SwiftUI
import Charts
import TrinityTokens
import TrinityTheme

/// Reusable line chart using Swift Charts. Shows a metric over time with
/// optional overlay markers (vertical rule lines) and threshold bands.
///
/// Usage:
/// ```swift
/// TrinityTrendChart(
///     title: "Resting HR",
///     data: points,
///     thresholdBands: [.init(low: 50, high: 65, color: TrinityStatusColors.success)],
///     yAxisLabel: "bpm",
///     yRange: 40...90
/// )
/// ```
public struct TrinityTrendChart: View {

    // MARK: - Types

    public struct DataPoint: Identifiable {
        public let id = UUID()
        public let date: Date
        public let value: Double

        public init(date: Date, value: Double) {
            self.date = date
            self.value = value
        }
    }

    public struct OverlayMarker: Identifiable {
        public let id = UUID()
        public let date: Date
        public let label: String?

        public init(date: Date, label: String? = nil) {
            self.date = date
            self.label = label
        }
    }

    public struct ThresholdBand {
        public let low: Double
        public let high: Double
        public let color: Color

        public init(low: Double, high: Double, color: Color) {
            self.low = low
            self.high = high
            self.color = color
        }
    }

    // MARK: - Properties

    @Environment(\.theme) private var theme

    public let title: String
    public let data: [DataPoint]
    public let overlayMarkers: [OverlayMarker]
    public let thresholdBands: [ThresholdBand]
    public let yAxisLabel: String
    public let yRange: ClosedRange<Double>?
    public let showOverlayMarkers: Bool
    public let showGridLines: Bool
    public let showAxisLabels: Bool
    public let showAreaFill: Bool
    public let areaFillColor: Color?
    public let showDashedProjection: Bool
    public let projectionData: [DataPoint]
    public let showPoints: Bool

    // MARK: - Init

    public init(
        title: String,
        data: [DataPoint],
        overlayMarkers: [OverlayMarker] = [],
        thresholdBands: [ThresholdBand] = [],
        yAxisLabel: String = "",
        yRange: ClosedRange<Double>? = nil,
        showOverlayMarkers: Bool = true,
        showGridLines: Bool = true,
        showAxisLabels: Bool = true,
        showAreaFill: Bool = false,
        areaFillColor: Color? = nil,
        showDashedProjection: Bool = false,
        projectionData: [DataPoint] = [],
        showPoints: Bool = true
    ) {
        self.title = title
        self.data = data
        self.overlayMarkers = overlayMarkers
        self.thresholdBands = thresholdBands
        self.yAxisLabel = yAxisLabel
        self.yRange = yRange
        self.showOverlayMarkers = showOverlayMarkers
        self.showGridLines = showGridLines
        self.showAxisLabels = showAxisLabels
        self.showAreaFill = showAreaFill
        self.areaFillColor = areaFillColor
        self.showDashedProjection = showDashedProjection
        self.projectionData = projectionData
        self.showPoints = showPoints
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            Text(title)
                .font(TrinityTypography.subheadline)
                .foregroundStyle(theme.labelSecondary)

            if data.isEmpty {
                Text("No data")
                    .font(TrinityTypography.caption)
                    .foregroundStyle(theme.labelTertiary)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    // Threshold bands
                    ForEach(Array(thresholdBands.enumerated()), id: \.offset) { _, band in
                        RectangleMark(
                            xStart: .value("Start", data.first?.date ?? Date()),
                            xEnd: .value("End", data.last?.date ?? Date()),
                            yStart: .value("Low", band.low),
                            yEnd: .value("High", band.high)
                        )
                        .foregroundStyle(band.color.opacity(TrinityOpacity.tonalFill))
                    }

                    // Overlay markers
                    if showOverlayMarkers {
                        ForEach(overlayMarkers) { marker in
                            RuleMark(x: .value("Date", marker.date))
                                .foregroundStyle(theme.accent.opacity(TrinityOpacity.subtle))
                                .lineStyle(StrokeStyle(lineWidth: TrinityBorderWidth.thin, dash: [4, 4]))
                                .annotation(position: .top, alignment: .center) {
                                    if let label = marker.label {
                                        Text(label)
                                            .font(TrinityTypography.captionSmall)
                                            .foregroundStyle(theme.accent)
                                    }
                                }
                        }
                    }

                    // Area fill
                    if showAreaFill {
                        ForEach(data) { point in
                            AreaMark(
                                x: .value("Date", point.date),
                                y: .value(yAxisLabel, point.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        (areaFillColor ?? theme.accent).opacity(0.4),
                                        (areaFillColor ?? theme.accent).opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                        }
                    }

                    // Line
                    ForEach(data) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value(yAxisLabel, point.value)
                        )
                        .foregroundStyle(areaFillColor ?? theme.chartPrimary)
                        .interpolationMethod(.catmullRom)
                    }

                    // Points
                    if showPoints {
                        ForEach(data) { point in
                            PointMark(
                                x: .value("Date", point.date),
                                y: .value(yAxisLabel, point.value)
                            )
                            .foregroundStyle(areaFillColor ?? theme.chartPrimary)
                            .symbolSize(20)
                        }
                    }

                    // Dashed projection line
                    if showDashedProjection {
                        ForEach(projectionData) { point in
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value(yAxisLabel, point.value),
                                series: .value("Series", "projection")
                            )
                            .foregroundStyle((areaFillColor ?? theme.chartPrimary).opacity(TrinityOpacity.subtle))
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: TrinityBorderWidth.medium, dash: [6, 4]))
                        }

                        ForEach(projectionData) { point in
                            AreaMark(
                                x: .value("Date", point.date),
                                y: .value(yAxisLabel, point.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        (areaFillColor ?? theme.chartPrimary).opacity(0.15),
                                        (areaFillColor ?? theme.chartPrimary).opacity(0.02)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)
                        }
                    }
                }
                .chartYScale(domain: chartYDomain)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: xAxisStride)) { _ in
                        if showGridLines {
                            AxisGridLine()
                                .foregroundStyle(theme.chartGrid)
                        }
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                            .font(TrinityTypography.captionSmall)
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        if showGridLines {
                            AxisGridLine()
                                .foregroundStyle(theme.chartGrid)
                        }
                        if showAxisLabels {
                            AxisValueLabel()
                                .font(TrinityTypography.captionSmall)
                        }
                    }
                }
                .frame(height: 150)
            }
        }
    }

    // MARK: - Helpers

    private var chartYDomain: ClosedRange<Double> {
        if let range = yRange { return range }
        let allValues = data.map(\.value) + projectionData.map(\.value)
        let minVal = (allValues.min() ?? 0) - 0.5
        let maxVal = (allValues.max() ?? 5) + 0.5
        return max(minVal, 0)...maxVal
    }

    private var xAxisStride: Int {
        let days = data.count
        if days <= 7 { return 1 }
        if days <= 14 { return 2 }
        return 5
    }
}

// MARK: - Previews

#if canImport(UIKit)
#Preview {
    VStack(spacing: TrinitySpacing.lg) {
        let dates = (0..<7).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }
        let data = dates.enumerated().map { i, d in
            TrinityTrendChart.DataPoint(date: d, value: Double.random(in: 2...5))
        }
        let markers = [
            TrinityTrendChart.OverlayMarker(date: dates[2], label: "Inject"),
            TrinityTrendChart.OverlayMarker(date: dates[5], label: "Inject")
        ]
        let bands = [
            TrinityTrendChart.ThresholdBand(low: 4, high: 5, color: TrinityStatusColors.success)
        ]

        TrinityTrendChart(
            title: "Energy (7 days)",
            data: data,
            overlayMarkers: markers,
            thresholdBands: bands,
            yAxisLabel: "Score",
            yRange: 1...5
        )
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
