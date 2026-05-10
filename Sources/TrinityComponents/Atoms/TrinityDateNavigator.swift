import SwiftUI
import TrinityTokens
import TrinityTheme

/// Centred date/period title flanked by previous/next chevron buttons.
///
/// Use above charts and detail surfaces to step through time periods.
/// Disabled chevrons render in tertiary colour and don't respond to taps.
///
/// Usage:
/// ```swift
/// TrinityDateNavigator(
///     title: "Apr 2026",
///     canGoBack: true,
///     canGoForward: false,
///     onBack: { viewModel.previousMonth() },
///     onForward: {}
/// )
/// ```
public struct TrinityDateNavigator: View {

    @Environment(\.theme) private var theme

    public let title: String
    public let canGoBack: Bool
    public let canGoForward: Bool
    public let onBack: () -> Void
    public let onForward: () -> Void

    public init(
        title: String,
        canGoBack: Bool,
        canGoForward: Bool,
        onBack: @escaping () -> Void,
        onForward: @escaping () -> Void
    ) {
        self.title = title
        self.canGoBack = canGoBack
        self.canGoForward = canGoForward
        self.onBack = onBack
        self.onForward = onForward
    }

    public var body: some View {
        HStack {
            chevronButton(systemName: "chevron.left", enabled: canGoBack, action: onBack)
            Spacer()
            Text(title)
                .font(TrinityTypography.headline)
                .foregroundStyle(theme.labelPrimary)
            Spacer()
            chevronButton(systemName: "chevron.right", enabled: canGoForward, action: onForward)
        }
    }

    private func chevronButton(
        systemName: String,
        enabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(TrinityTypography.caption.weight(.semibold))
                .foregroundStyle(
                    enabled
                        ? theme.labelPrimary
                        : theme.labelTertiary
                )
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .stroke(theme.labelSecondary.opacity(0.25), lineWidth: 0.5)
                )
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }
}

#if canImport(UIKit)
#Preview("Both arrows enabled") {
    TrinityDateNavigator(
        title: "April 2026",
        canGoBack: true,
        canGoForward: true,
        onBack: {},
        onForward: {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Only back enabled") {
    TrinityDateNavigator(
        title: "April 2026",
        canGoBack: true,
        canGoForward: false,
        onBack: {},
        onForward: {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Only forward enabled") {
    TrinityDateNavigator(
        title: "April 2026",
        canGoBack: false,
        canGoForward: true,
        onBack: {},
        onForward: {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
