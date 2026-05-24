import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct MoleculesPage: View {

    @Environment(\.theme) private var theme

    private let metricBars: [Double] = [3200, 5100, 4800, 6200, 7100, 3900, 5500]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                sectionHeaderSection
                cardHeaderSection
                metricCardSection
                cardSection
                metricRowSection
                emptyStateSection
                errorStateSection
                chartCardSection
                wellnessDotSection
                metricInsightSection
                infoBannerSection
                countdownArcSection
                markerBarSection
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Molecules")
    }

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

    private var cardSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityCard").font(TrinityTypography.titleMedium)
            TrinityCard(title: "Recovery", icon: "heart.fill", headerColor: theme.accent, showChevron: true) {
                Text("Today's recovery score looks good. HRV is above average.")
                    .font(TrinityTypography.body)
                    .foregroundStyle(theme.labelSecondary)
                    .padding(TrinitySpacing.cardPadding)
            }
        }
    }

    private var metricRowSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityMetricRow").font(TrinityTypography.titleMedium)
            TrinityCard {
                VStack(spacing: 0) {
                    TrinityMetricRow(label: "Testosterone", value: "24.6", unit: "nmol/L", trend: .up, trendValue: "+1.2")
                        .padding(TrinitySpacing.cardPadding)
                    Divider()
                    TrinityMetricRow(label: "SHBG", value: "32", unit: "nmol/L", trend: .stable)
                        .padding(TrinitySpacing.cardPadding)
                    Divider()
                    TrinityMetricRow(label: "Haematocrit", value: "47.3", unit: "%", trend: .down, trendValue: "-0.8")
                        .padding(TrinitySpacing.cardPadding)
                }
            }
        }
    }

    private var emptyStateSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityEmptyState").font(TrinityTypography.titleMedium)
            TrinityEmptyState(
                icon: TrinityIcons.trayFull,
                title: "No activities yet",
                description: "Connect Strava to import your rides.",
                primaryAction: (label: "Connect Strava", action: {}),
                secondaryAction: (label: "Enter manually", action: {})
            )
            .frame(height: 300)
        }
    }

    private var errorStateSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityErrorState").font(TrinityTypography.titleMedium)
            TrinityErrorState(
                title: "Couldn't load activities",
                description: "Network unavailable. Check your connection and try again.",
                retryAction: {},
                secondaryAction: nil
            )
            .frame(height: 260)
        }
    }

    private var chartCardSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityChartCard").font(TrinityTypography.titleMedium)
            TrinityChartCard(title: "Training Load", disclaimer: "Estimated from Strava activities.") {
                RoundedRectangle(cornerRadius: TrinityRadii.button)
                    .fill(theme.accent.opacity(TrinityOpacity.tonalFill))
                    .frame(height: 120)
            }
        }
    }

    private var metricInsightSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityMetricInsightSection").font(TrinityTypography.titleMedium)
            TrinityCard {
                VStack(alignment: .leading, spacing: TrinitySpacing.md) {
                    TrinityMetricInsightSection(
                        headline: "FTP up 4W in the last 30 days."
                    )
                    Divider()
                    TrinityMetricInsightSection(
                        headline: "Recovery low — pull back tomorrow.",
                        category: "Watch",
                        iconName: "exclamationmark.triangle.fill",
                        accent: TrinityStatusColors.warning
                    )
                }
                .padding(TrinitySpacing.cardPadding)
            }
        }
    }

    private var infoBannerSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityInfoBanner").font(TrinityTypography.titleMedium)
            TrinityInfoBanner(severity: .info, title: "Tip",
                message: "Connect more data sources for better insights.")
            TrinityInfoBanner(severity: .warning, title: "Missing Sleep Data",
                message: "Recovery score may be less accurate.",
                actionTitle: "Grant Access", action: {}, dismissAction: {})
            TrinityInfoBanner(severity: .error, title: "Connection Failed",
                message: "Could not reach Intervals.icu")
            TrinityInfoBanner(severity: .success, title: "Connected",
                message: "Strava data is now syncing.")
        }
    }

    private var sectionHeaderSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinitySectionHeader").font(TrinityTypography.titleMedium)
            TrinitySectionHeader(title: "Blood Work")
            TrinitySectionHeader(
                title: "Insights",
                trailingAction: .init(label: "See all") {}
            )
        }
    }

    private var countdownArcSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityCountdownArc").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.xl) {
                TrinityCountdownArc(daysRemaining: 3, totalDays: 7, label: "Test Cyp")
                TrinityCountdownArc(daysRemaining: 1, totalDays: 7, label: "HCG")
                TrinityCountdownArc(daysRemaining: 0, totalDays: 7, label: "Inject Today")
            }
        }
    }

    private var markerBarSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityMarkerRow").font(TrinityTypography.titleMedium)
            TrinityCard {
                VStack(spacing: 0) {
                    TrinityMarkerRow(
                        name: "Total Testosterone",
                        value: 24.6,
                        unit: "nmol/L",
                        rangeLow: 8.6,
                        rangeHigh: 29.0
                    )
                    .padding(.horizontal, TrinitySpacing.cardPadding)
                    Divider()
                        .padding(.horizontal, TrinitySpacing.cardPadding)
                    TrinityMarkerRow(
                        name: "Haematocrit",
                        value: 51.2,
                        unit: "%",
                        rangeLow: 38.0,
                        rangeHigh: 50.0
                    )
                    .padding(.horizontal, TrinitySpacing.cardPadding)
                    Divider()
                        .padding(.horizontal, TrinitySpacing.cardPadding)
                    TrinityMarkerRow(
                        name: "HDL Cholesterol",
                        value: 59.0,
                        unit: "mg/dL"
                    )
                    .padding(.horizontal, TrinitySpacing.cardPadding)
                }
            }
        }
    }

    private var wellnessDotSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityWellnessDot").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.lg) {
                VStack(spacing: TrinitySpacing.xs) {
                    TrinityWellnessDot(status: .good)
                    Text("Good").font(TrinityTypography.captionSmall).foregroundStyle(theme.labelSecondary)
                }
                VStack(spacing: TrinitySpacing.xs) {
                    TrinityWellnessDot(status: .caution)
                    Text("Caution").font(TrinityTypography.captionSmall).foregroundStyle(theme.labelSecondary)
                }
                VStack(spacing: TrinitySpacing.xs) {
                    TrinityWellnessDot(status: .concerning)
                    Text("Concerning").font(TrinityTypography.captionSmall).foregroundStyle(theme.labelSecondary)
                }
                VStack(spacing: TrinitySpacing.xs) {
                    TrinityWellnessDot(status: .none)
                    Text("None").font(TrinityTypography.captionSmall).foregroundStyle(theme.labelSecondary)
                }
            }
        }
    }
}
