import SwiftUI
import TrinityTokens
import TrinityTheme

/// Generic empty-state molecule. Use when a feature has no data yet
/// and the user needs guidance on what to do next.
public struct TrinityEmptyState: View {

    @Environment(\.theme) private var theme

    public let icon: String
    public let title: String
    public let description: String
    public var primaryAction: (label: String, action: () -> Void)?
    public var secondaryAction: (label: String, action: () -> Void)?

    public init(
        icon: String,
        title: String,
        description: String,
        primaryAction: (label: String, action: () -> Void)? = nil,
        secondaryAction: (label: String, action: () -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: TrinitySpacing.lg) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 44)) // no TrinityTypography icon-display token at this size
                .foregroundStyle(theme.accent)
            VStack(spacing: TrinitySpacing.xs) {
                Text(title)
                    .font(TrinityTypography.headline)
                    .foregroundStyle(theme.labelPrimary)
                    .multilineTextAlignment(.center)
                Text(description)
                    .font(TrinityTypography.body)
                    .foregroundStyle(theme.labelSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, TrinitySpacing.sm)
            }
            if let primary = primaryAction {
                VStack(spacing: TrinitySpacing.sm) {
                    TrinityButton(primary.label, style: .primary, action: primary.action)
                    if let secondary = secondaryAction {
                        TrinityButton(secondary.label, style: .secondary, action: secondary.action)
                    }
                }
                .padding(.horizontal, TrinitySpacing.xl)
            }
            Spacer()
        }
        .padding(TrinitySpacing.lg)
        .frame(maxWidth: .infinity)
    }
}

#if canImport(UIKit)
#Preview {
    TrinityEmptyState(
        icon: "drop",
        title: "No Blood Work",
        description: "Add your lab results to track marker trends over time.",
        primaryAction: ("Add Blood Work", {}),
        secondaryAction: ("Import PDF", {})
    )
    .theme(DemoTRTTheme())
}
#endif
