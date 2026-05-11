import SwiftUI
import TrinityTokens
import TrinityTheme

public enum TrinitySeverity {
    case info
    case success
    case warning
    case error
}

public struct TrinityInfoBanner: View {
    @Environment(\.theme) private var theme

    public let severity: TrinitySeverity
    public let title: String
    public let message: String?
    public let actionTitle: String?
    public let action: (() -> Void)?
    public let dismissAction: (() -> Void)?

    public init(
        severity: TrinitySeverity = .info,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        dismissAction: (() -> Void)? = nil
    ) {
        self.severity = severity
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
        self.dismissAction = dismissAction
    }

    private var tint: Color {
        switch severity {
        case .info:    return theme.accent
        case .success: return TrinityStatusColors.success
        case .warning: return TrinityStatusColors.warning
        case .error:   return TrinityStatusColors.error
        }
    }

    private var icon: String {
        switch severity {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: TrinitySpacing.md) {
            Image(systemName: icon)
                .font(TrinityTypography.headline)
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
                Text(title)
                    .font(TrinityTypography.subheadlineEmphasis)
                    .foregroundStyle(theme.labelPrimary)

                if let message {
                    Text(message)
                        .font(TrinityTypography.subheadline)
                        .foregroundStyle(theme.labelSecondary)
                }

                if let actionTitle, let action {
                    Button(action: action) {
                        Text(actionTitle)
                            .font(TrinityTypography.captionEmphasis)
                            .foregroundStyle(tint)
                    }
                }
            }

            Spacer()

            if let dismissAction {
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(theme.labelSecondary)
                }
                .accessibilityLabel("Dismiss")
            }
        }
        .padding(TrinitySpacing.cardPadding)
        .background(tint.opacity(TrinityOpacity.tonalFill))
        .clipShape(RoundedRectangle(cornerRadius: TrinityRadii.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#if canImport(UIKit)
#Preview {
    VStack(spacing: TrinitySpacing.md) {
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
    .padding(TrinitySpacing.sectionPadding)
    .theme(DemoTRTTheme())
}
#endif
