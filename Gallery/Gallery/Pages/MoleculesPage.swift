import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct MoleculesPage: View {

    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                cardHeaderSection
                cardSection
                metricRowSection
                emptyStateSection
                errorStateSection
                chartCardSection
                wellnessDotSection
                metricInsightSection
                infoBannerSection
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
