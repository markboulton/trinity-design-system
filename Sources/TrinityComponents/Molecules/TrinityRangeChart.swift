import SwiftUI
import Charts
import TrinityTokens
import TrinityTheme

public struct TrinityRangeChart: View {
    public struct Bucket: Identifiable {
        public let id = UUID()
        public let date: Date
        public let low: Double
        public let high: Double

        public init(date: Date, low: Double, high: Double) {
            self.date = date
            self.low = low
            self.high = high
        }
    }

    @Environment(\.theme) private var theme

    public let buckets: [Bucket]
    public let bucketUnit: Calendar.Component
    public let tint: Color
    public let baseline: Double?
    public let baselineLabel: String?
    public let annotateExtremes: Bool

    public init(
        buckets: [Bucket],
        bucketUnit: Calendar.Component = .day,
        tint: Color,
        baseline: Double? = nil,
        baselineLabel: String? = nil,
        annotateExtremes: Bool = true
    ) {
        self.buckets = buckets
        self.bucketUnit = bucketUnit
        self.tint = tint
        self.baseline = baseline
        self.baselineLabel = baselineLabel
        self.annotateExtremes = annotateExtremes
    }

    private var yDomain: ClosedRange<Double> {
        let lows = buckets.map(\.low)
        let highs = buckets.map(\.high)
        guard let minY = lows.min(), let maxY = highs.max() else { return 40...120 }
        let candidates = [minY, maxY, baseline ?? minY]
        let dataMin = candidates.min() ?? minY
        let dataMax = candidates.max() ?? maxY
        let range = dataMax - dataMin
        guard range > 0 else { return (dataMin - 5)...(dataMax + 5) }
        let pad = range * 0.15
        return (dataMin - pad)...(dataMax + pad)
    }

    private var showAnnotations: Bool { annotateExtremes && buckets.count <= 14 }

    public var body: some View {
        if buckets.count < 2 {
            VStack {
                Spacer()
                Text("Not enough data yet")
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(theme.labelSecondary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        } else {
            Chart {
                ForEach(buckets) { bucket in
                    BarMark(
                        x: .value("Date", bucket.date, unit: bucketUnit),
                        yStart: .value("Low", bucket.low),
                        yEnd: .value("High", bucket.high)
                    )
                    .foregroundStyle(tint.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 2))

                    PointMark(
                        x: .value("Date", bucket.date, unit: bucketUnit),
                        y: .value("Low", bucket.low)
                    )
                    .foregroundStyle(tint)
                    .symbolSize(28)
                    .annotation(position: .bottom) {
                        if showAnnotations, bucket.low != bucket.high {
                            Text("\(Int(bucket.low.rounded()))")
                                .font(TrinityTypography.captionSmall)
                                .foregroundStyle(theme.labelSecondary)
                        }
                    }

                    PointMark(
                        x: .value("Date", bucket.date, unit: bucketUnit),
                        y: .value("High", bucket.high)
                    )
                    .foregroundStyle(tint)
                    .symbolSize(28)
                    .annotation(position: .top) {
                        if showAnnotations, bucket.low != bucket.high {
                            Text("\(Int(bucket.high.rounded()))")
                                .font(TrinityTypography.captionSmall)
                                .foregroundStyle(theme.labelSecondary)
                        }
                    }
                }

                if let baseline {
                    RuleMark(y: .value("Baseline", baseline))
                        .foregroundStyle(theme.labelMuted.opacity(0.6))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .annotation(position: .top, alignment: .leading) {
                            if let baselineLabel {
                                Text(baselineLabel)
                                    .font(TrinityTypography.captionSmall)
                                    .foregroundStyle(theme.labelMuted)
                            }
                        }
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(theme.chartGrid)
                    AxisValueLabel()
                        .font(TrinityTypography.captionSmall)
                        .foregroundStyle(theme.chartAxis)
                }
            }
            .chartXAxis(.hidden)
            .chartYScale(domain: yDomain)
            .allowsHitTesting(false)
        }
    }
}

#if canImport(UIKit)
private func sampleRangeBuckets() -> [TrinityRangeChart.Bucket] {
    (0..<7).map { i in
        let date = Calendar.current.date(byAdding: .day, value: -(6 - i), to: Date()) ?? Date()
        let mid = 55.0 + sin(Double(i) / 2.0) * 4
        return TrinityRangeChart.Bucket(date: date, low: mid - 3, high: mid + 4)
    }
}

#Preview {
    TrinityRangeChart(
        buckets: sampleRangeBuckets(),
        tint: TrinityStatusColors.error,
        baseline: 55,
        baselineLabel: "Baseline"
    )
    .frame(height: 200)
    .padding()
    .background(DemoTRTTheme().cardBackground)
    .theme(DemoTRTTheme())
}
#endif
