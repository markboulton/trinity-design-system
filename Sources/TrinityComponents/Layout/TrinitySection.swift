import SwiftUI
import TrinityTokens
import TrinityTheme

/// Standard section: optional title header followed by content with proper spacing.
///
/// Use to break a screen into named sections. Title uses `titleMedium`; content
/// gets standard `cardSpacing` between section items.
public struct TrinitySection<Content: View>: View {

    @Environment(\.theme) private var theme

    public let title: String?
    public let content: () -> Content

    public init(_ title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            if let title {
                Text(title)
                    .font(TrinityTypography.titleMedium)
                    .foregroundStyle(theme.labelPrimary)
                    .accessibilityAddTraits(.isHeader)
            }
            VStack(spacing: TrinitySpacing.cardSpacing) {
                content()
            }
        }
        .padding(.bottom, TrinitySpacing.sectionSpacing)
    }
}

#if canImport(UIKit)
#Preview("Section") {
    TrinitySection("This Week") {
        Text("Item 1")
        Text("Item 2")
    }
    .padding(TrinitySpacing.sectionPadding)
    .theme(DemoTRTTheme())
}
#endif
