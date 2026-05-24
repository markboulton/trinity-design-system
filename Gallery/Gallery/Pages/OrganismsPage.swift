import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct OrganismsPage: View {

    @Environment(\.theme) private var theme

    private static let sampleData: [TrinityTrendChart.DataPoint] = {
        let cal = Calendar.current
        let today = Date()
        return (0..<14).map { offset in
            TrinityTrendChart.DataPoint(
                date: cal.date(byAdding: .day, value: -offset, to: today)!,
                value: Double.random(in: 55...75)
            )
        }
        .reversed()
    }()

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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                compoundMetricSection
                pendingMetricSection
                trendChartSection
                multiSeriesChartSection
                rangeChartSection
                detailPageSection
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Organisms")
    }

    private var compoundMetricSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityCompoundMetricCard").font(TrinityTypography.titleMedium)
            TrinityCompoundMetricCard(
                label: "Total Testosterone",
                value: "24.6",
                unit: "nmol/L",
                rows: [
                    .init(label: "Free T", value: "0.48", unit: "nmol/L"),
                    .init(label: "SHBG", value: "32", unit: "nmol/L")
                ],
                trailingContent: {
                    TrinityProgressRing(value: 0.72, centreLabel: "72%", captionLabel: "RANGE")
                },
                bottomContent: { EmptyView() }
            )
        }
    }

    private var pendingMetricSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityPendingMetricCard").font(TrinityTypography.titleMedium)
            TrinityPendingMetricCard(
                label: "Haematocrit",
                unit: "%",
                valueShape: .single,
                rowLabels: ["Red cell count", "Haemoglobin"]
            )
        }
    }

    private var trendChartSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityTrendChart").font(TrinityTypography.titleMedium)
            TrinityChartCard(title: "Resting HR (14 days)") {
                TrinityTrendChart(
                    title: "",
                    data: Self.sampleData,
                    thresholdBands: [
                        .init(low: 55, high: 65, color: TrinityStatusColors.success.opacity(TrinityOpacity.tonalFill))
                    ],
                    yAxisLabel: "bpm",
                    yRange: 45...85,
                    showAreaFill: true
                )
                .frame(height: 160)
            }
        }
    }

    private var multiSeriesChartSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityMultiSeriesChart").font(TrinityTypography.titleMedium)
            TrinityChartCard(title: "Training Load (21 days)") {
                TrinityMultiSeriesChart(
                    series: [
                        .init(name: "CTL",
                              points: Self.sampleCTL,
                              color: theme.accent),
                        .init(name: "ATL",
                              points: Self.sampleATL,
                              color: theme.chartSecondary)
                    ],
                    baseline: 50,
                    yAxisLabel: "TSS"
                )
                .frame(height: 160)
            }
        }
    }

    private var rangeChartSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityRangeChart").font(TrinityTypography.titleMedium)
            TrinityChartCard(title: "Resting HR — 7 day range") {
                TrinityRangeChart(
                    buckets: (0..<7).map { i -> TrinityRangeChart.Bucket in
                        let date = Calendar.current.date(
                            byAdding: .day, value: -(6 - i), to: Date()
                        ) ?? Date()
                        let mid = 55.0 + sin(Double(i) / 2.0) * 4
                        return TrinityRangeChart.Bucket(date: date, low: mid - 3, high: mid + 4)
                    },
                    tint: TrinityStatusColors.error,
                    baseline: 55,
                    baselineLabel: "Baseline"
                )
                .frame(height: 160)
            }
        }
    }

    private var detailPageSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityDetailPage").font(TrinityTypography.titleMedium)
            NavigationLink("Open Detail Page →") {
                TrinityDetailPage(
                    title: "Resting Heart Rate",
                    subtitle: "7-day average: 58 bpm",
                    chart: {
                        RoundedRectangle(cornerRadius: TrinityRadii.card)
                            .fill(theme.accent.opacity(TrinityOpacity.tonalFill))
                    },
                    narrativeTitle: "What this means",
                    narrative: "Your resting heart rate has trended downward over the past 4 weeks, suggesting improved cardiovascular fitness and recovery.",
                    evidence: [
                        .init(label: "Sample size", value: "28 days"),
                        .init(label: "Lowest reading", value: "52 bpm"),
                        .init(label: "7-day avg", value: "58 bpm")
                    ],
                    disclaimer: "Data read from Apple Health. Not for clinical use."
                )
                .navigationTitle("Heart Rate")
            }
            .font(TrinityTypography.subheadlineEmphasis)
            .foregroundStyle(theme.accent)
        }
    }
}
