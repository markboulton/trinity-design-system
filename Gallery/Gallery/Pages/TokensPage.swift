import SwiftUI
import TrinityTokens
import TrinityTheme

struct TokensPage: View {

    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                spacingSection
                typographySection
                colourSection
                statusSection
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Tokens")
    }

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("Spacing").font(TrinityTypography.titleMedium).foregroundStyle(theme.labelPrimary)
            spacingRow("hairline", TrinitySpacing.hairline)
            spacingRow("xxs", TrinitySpacing.xxs)
            spacingRow("xs", TrinitySpacing.xs)
            spacingRow("sm", TrinitySpacing.sm)
            spacingRow("md", TrinitySpacing.md)
            spacingRow("lg", TrinitySpacing.lg)
            spacingRow("xl", TrinitySpacing.xl)
            spacingRow("xxl", TrinitySpacing.xxl)
            spacingRow("huge", TrinitySpacing.huge)
            spacingRow("touch", TrinitySpacing.touch)
        }
    }

    private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
        HStack {
            Text(name).font(TrinityTypography.subheadline).foregroundStyle(theme.labelPrimary).frame(width: 80, alignment: .leading)
            Rectangle().fill(theme.accent).frame(width: value, height: 16)
            Text("\(Int(value))pt").font(TrinityTypography.caption).foregroundStyle(theme.labelSecondary)
        }
    }

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("Typography").font(TrinityTypography.titleMedium).foregroundStyle(theme.labelPrimary)
            typographyRow("displayLarge", font: TrinityTypography.displayLarge)
            typographyRow("displayMedium", font: TrinityTypography.displayMedium)
            typographyRow("titleLarge", font: TrinityTypography.titleLarge)
            typographyRow("titleMedium", font: TrinityTypography.titleMedium)
            typographyRow("headline", font: TrinityTypography.headline)
            typographyRow("body", font: TrinityTypography.body)
            typographyRow("subheadline", font: TrinityTypography.subheadline)
            typographyRow("caption", font: TrinityTypography.caption)
            typographyRow("captionSmall", font: TrinityTypography.captionSmall)
        }
    }

    private func typographyRow(_ name: String, font: Font) -> some View {
        Text(name).font(font).foregroundStyle(theme.labelPrimary)
    }

    private var colourSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("Theme colours").font(TrinityTypography.titleMedium).foregroundStyle(theme.labelPrimary)
            colourRow("accent", theme.accent)
            colourRow("accentSubtle", theme.accentSubtle)
            colourRow("insightAccent", theme.insightAccent)
            colourRow("cardBackground", theme.cardBackground)
            colourRow("surfaceElevated", theme.surfaceElevated)
            colourRow("borderSubtle", theme.borderSubtle)
            colourRow("labelPrimary", theme.labelPrimary)
            colourRow("labelSecondary", theme.labelSecondary)
            colourRow("labelMuted", theme.labelMuted)
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("Status (universal)").font(TrinityTypography.titleMedium).foregroundStyle(theme.labelPrimary)
            colourRow("success", TrinityStatusColors.success)
            colourRow("warning", TrinityStatusColors.warning)
            colourRow("error", TrinityStatusColors.error)
            colourRow("markerInRange", TrinityStatusColors.markerInRange)
            colourRow("markerOutOfRange", TrinityStatusColors.markerOutOfRange)
            colourRow("wellnessGreen", TrinityStatusColors.wellnessGreen)
            colourRow("wellnessAmber", TrinityStatusColors.wellnessAmber)
            colourRow("wellnessRed", TrinityStatusColors.wellnessRed)
        }
    }

    private func colourRow(_ name: String, _ colour: Color) -> some View {
        HStack {
            Text(name).font(TrinityTypography.subheadline).foregroundStyle(theme.labelPrimary).frame(width: 160, alignment: .leading)
            RoundedRectangle(cornerRadius: 4).fill(colour).frame(width: 60, height: 24)
        }
    }
}
