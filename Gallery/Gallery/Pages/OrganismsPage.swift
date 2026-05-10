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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                compoundMetricSection
                pendingMetricSection
                trendChartSection
                detailPageNote
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

    private var detailPageNote: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            Text("TrinityDetailPage").font(TrinityTypography.titleMedium)
            Text("A full-screen navigation wrapper — see VeloReady and TRT Companion for live usage.")
                .font(TrinityTypography.body)
                .foregroundStyle(theme.labelSecondary)
        }
    }
}
