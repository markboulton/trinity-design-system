import SwiftUI
import TrinityTokens
import TrinityTheme

public struct TrinityMetricInsightSection: View {
    @Environment(\.theme) private var theme

    public let headline: String
    public let category: String
    public let iconName: String
    public let accent: Color?

    public init(
        headline: String,
        category: String = "Insight",
        iconName: String = "sparkles",
        accent: Color? = nil
    ) {
        self.headline = headline
        self.category = category
        self.iconName = iconName
        self.accent = accent
    }

    private var resolvedAccent: Color { accent ?? theme.insightAccent }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            HStack(spacing: TrinitySpacing.xs) {
                Image(systemName: iconName)
                    .font(TrinityTypography.caption)
                    .foregroundStyle(resolvedAccent)
                Text(category.uppercased())
                    .font(TrinityTypography.captionEmphasis)
                    .tracking(TrinityTypography.sectionEyebrowTracking)
                    .foregroundStyle(resolvedAccent)
                Spacer()
            }
            Text(headline)
                .font(TrinityTypography.subheadlineEmphasis)
                .foregroundStyle(theme.labelPrimary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(category): \(headline)")
    }
}

#if canImport(UIKit)
#Preview {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityMetricInsightSection(
            headline: "FTP up 4W in the last 30 days. Push your tempo intervals."
        )
        TrinityMetricInsightSection(
            headline: "Recovery low — pull back intensity tomorrow.",
            category: "Watch",
            iconName: "exclamationmark.triangle.fill",
            accent: TrinityStatusColors.warning
        )
    }
    .padding(TrinitySpacing.cardPadding)
    .background(DemoTRTTheme().cardBackground)
    .theme(DemoTRTTheme())
}
#endif
