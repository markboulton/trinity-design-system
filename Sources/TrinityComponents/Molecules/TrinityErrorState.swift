import SwiftUI
import TrinityTokens
import TrinityTheme

/// Generic error-state molecule. Use when something went wrong and the user
/// needs a way to recover. Retry is always the primary action.
public struct TrinityErrorState: View {

    @Environment(\.theme) private var theme

    public let title: String
    public let description: String
    public let retryAction: () -> Void
    public var secondaryAction: (label: String, action: () -> Void)?

    public init(
        title: String,
        description: String,
        retryAction: @escaping () -> Void,
        secondaryAction: (label: String, action: () -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.retryAction = retryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: TrinitySpacing.lg) {
            Spacer()
            Image(systemName: TrinityIcons.exclamationTriangle)
                .frame(width: TrinitySpacing.touch, height: TrinitySpacing.touch)
                .font(.system(size: 44)) // no TrinityTypography icon-display token at this size
                .foregroundStyle(TrinityStatusColors.warning)
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
            VStack(spacing: TrinitySpacing.sm) {
                TrinityButton("Retry", style: .primary, action: retryAction)
                if let secondary = secondaryAction {
                    TrinityButton(secondary.label, style: .secondary, action: secondary.action)
                }
            }
            .padding(.horizontal, TrinitySpacing.xl)
            Spacer()
        }
        .padding(TrinitySpacing.lg)
        .frame(maxWidth: .infinity)
    }
}

#if canImport(UIKit)
#Preview {
    TrinityErrorState(
        title: "Import Failed",
        description: "Couldn't read this report. Try a clearer photo or enter manually.",
        retryAction: {},
        secondaryAction: ("Enter Manually", {})
    )
    .theme(DemoTRTTheme())
}
#endif
