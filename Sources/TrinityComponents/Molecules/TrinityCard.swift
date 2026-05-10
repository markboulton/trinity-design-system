import SwiftUI
import TrinityTokens
import TrinityTheme

/// Borderless card with optional coloured header (icon + title + chevron).
/// Depth comes from background contrast, not borders. Cards have NO external
/// padding — parent controls spacing.
public struct TrinityCard<Content: View>: View {

    @Environment(\.theme) private var theme

    public let title: String?
    public let icon: String?
    public let headerColor: Color?
    public let showChevron: Bool
    @ViewBuilder public let content: () -> Content

    public init(
        title: String? = nil,
        icon: String? = nil,
        headerColor: Color? = nil,
        showChevron: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.headerColor = headerColor
        self.showChevron = showChevron
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.cardContentSpacing) {
            if let title {
                HStack {
                    if let icon {
                        Image(systemName: icon)
                            .font(TrinityTypography.subheadline)
                            .foregroundStyle(headerColor ?? theme.labelPrimary)
                    }
                    Text(title)
                        .font(TrinityTypography.headline)
                        .foregroundStyle(headerColor ?? theme.labelPrimary)
                    Spacer()
                    if showChevron {
                        Image(systemName: TrinityIcons.chevronRight)
                            .frame(width: TrinityIcons.Size.small, height: TrinityIcons.Size.small)
                            .font(TrinityTypography.caption)
                            .foregroundStyle(theme.labelTertiary)
                    }
                }
            }

            content()
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
    VStack(spacing: TrinitySpacing.cardSpacing) {
        TrinityCard(title: "Protocol", icon: "syringe.fill", showChevron: true) {
            Text("Testosterone Cypionate 75mg E3.5D SubQ")
                .font(TrinityTypography.body)
        }

        TrinityCard(title: "Wellness", icon: "heart.text.square.fill") {
            Text("Today's score: 4.2/5")
                .font(TrinityTypography.body)
        }

        TrinityCard {
            Text("Card without header")
                .font(TrinityTypography.body)
        }
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
