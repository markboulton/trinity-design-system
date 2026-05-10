import SwiftUI
import TrinityTokens
import TrinityTheme

/// Dark card wrapper for charts. Provides an elevated surface with optional
/// title and disclaimer text.
public struct TrinityChartCard<Content: View>: View {

    @Environment(\.theme) private var theme

    public let title: String?
    public let disclaimer: String?
    @ViewBuilder public let content: () -> Content

    public init(
        title: String? = nil,
        disclaimer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.disclaimer = disclaimer
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            if let title {
                Text(title)
                    .font(TrinityTypography.headline)
                    .foregroundStyle(theme.labelPrimary)
            }

            content()

            if let disclaimer {
                Text(disclaimer)
                    .font(TrinityTypography.caption)
                    .foregroundStyle(theme.labelSecondary)
            }
        }
        .padding(TrinitySpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: TrinitySpacing.cardCornerRadius)
                .fill(theme.cardBackground)
        )
    }
}

#if canImport(UIKit)
#Preview {
    TrinityChartCard(
        title: "Sample Weeks",
        disclaimer: "Estimates based on averages, not measurements."
    ) {
        RoundedRectangle(cornerRadius: TrinityRadii.button)
            .fill(Color.gray.opacity(TrinityOpacity.tonalFill))
            .frame(height: 150)
    }
    .padding(TrinitySpacing.cardPadding)
    .theme(DemoTRTTheme())
}
#endif
