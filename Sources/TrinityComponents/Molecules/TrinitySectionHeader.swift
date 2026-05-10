import SwiftUI
import TrinityTokens
import TrinityTheme

/// Page-level section header with optional trailing action pill.
///
/// Standardised heading style used above grouped content sections.
/// The trailing action renders as a capsule-bordered pill button.
///
/// Usage:
/// ```swift
/// TrinitySectionHeader(title: "Insights")
/// TrinitySectionHeader(title: "Blood Work", trailingAction: .init(label: "See all") { ... })
/// ```
public struct TrinitySectionHeader: View {

    @Environment(\.theme) private var theme

    public let title: String
    public let trailingAction: Action?

    public struct Action {
        public let label: String
        public let handler: () -> Void

        public init(label: String, handler: @escaping () -> Void) {
            self.label = label
            self.handler = handler
        }
    }

    public init(title: String, trailingAction: Action? = nil) {
        self.title = title
        self.trailingAction = trailingAction
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(TrinityTypography.titleMedium)
                .foregroundStyle(theme.labelPrimary)
            Spacer()
            if let action = trailingAction {
                Button(action: action.handler) {
                    Text(action.label)
                        .font(TrinityTypography.subheadlineEmphasis)
                        .foregroundStyle(theme.labelPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, TrinitySpacing.xs)
                        .overlay(
                            Capsule()
                                .stroke(
                                    theme.labelSecondary.opacity(TrinityOpacity.border),
                                    lineWidth: TrinityBorderWidth.hairline
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if canImport(UIKit)
#Preview("With action") {
    TrinitySectionHeader(
        title: "Insights",
        trailingAction: .init(label: "See all") {}
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Without action") {
    TrinitySectionHeader(title: "Blood Work")
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}
#endif
