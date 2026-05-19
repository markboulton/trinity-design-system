import SwiftUI
import TrinityTokens
import TrinityTheme

/// Card-level header with optional leading icon, title, optional subtitle,
/// and optional trailing text action. Use this standalone molecule wherever
/// a header row is needed independently from a TrinityCard container —
/// e.g. above a chart, inside a custom layout, or as a section label with
/// an action pill.
///
/// Usage:
/// ```swift
/// TrinityCardHeader(title: "Recovery")
/// TrinityCardHeader(
///     title: "Blood Work",
///     subtitle: "Last updated 3 days ago",
///     icon: "drop.fill",
///     iconColor: TrinityStatusColors.error,
///     trailingAction: .init(label: "See all") { ... }
/// )
/// ```
public struct TrinityCardHeader: View {

    @Environment(\.theme) private var theme

    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let iconColor: Color?

    public struct Action {
        public let label: String
        public let handler: () -> Void

        public init(label: String, handler: @escaping () -> Void) {
            self.label = label
            self.handler = handler
        }
    }

    public let trailingAction: Action?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color? = nil,
        trailingAction: Action? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.trailingAction = trailingAction
    }

    public var body: some View {
        HStack(alignment: .top, spacing: TrinitySpacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(iconColor ?? theme.accent)
                    .frame(minWidth: TrinityIcons.Size.small)
            }

            VStack(alignment: .leading, spacing: TrinitySpacing.xxs) {
                Text(title)
                    .font(TrinityTypography.headline)
                    .foregroundStyle(theme.labelPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(TrinityTypography.subheadline)
                        .foregroundStyle(theme.labelSecondary)
                }
            }

            Spacer()

            if let action = trailingAction {
                Button(action: action.handler) {
                    Text(action.label)
                        .font(TrinityTypography.subheadlineEmphasis)
                        .foregroundStyle(theme.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if canImport(UIKit)
#Preview("Title only") {
    TrinityCardHeader(title: "Recovery")
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("With icon and subtitle") {
    TrinityCardHeader(
        title: "Blood Work",
        subtitle: "Last updated 3 days ago",
        icon: "drop.fill",
        iconColor: TrinityStatusColors.error
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("With trailing action") {
    TrinityCardHeader(
        title: "Insights",
        icon: "lightbulb.fill",
        trailingAction: .init(label: "See all") {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
