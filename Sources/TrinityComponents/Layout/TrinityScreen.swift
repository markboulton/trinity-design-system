import SwiftUI
import TrinityTokens
import TrinityTheme

/// Standard screen container for Trinity-consuming apps.
///
/// Applies horizontal `sectionPadding` and provides a vertical scroll view with
/// optional pull-to-refresh. Use this on every primary screen instead of
/// hardcoding `.padding(.horizontal, 20)` and a manual `ScrollView`.
private struct TrinityScreenModifier: ViewModifier {
    let refreshAction: (() async -> Void)?

    func body(content: Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, TrinitySpacing.sectionPadding)
        }
        .modifier(RefreshModifier(action: refreshAction))
    }
}

/// Conditional `.refreshable` — only attaches the modifier when an action is supplied.
private struct RefreshModifier: ViewModifier {
    let action: (() async -> Void)?

    func body(content: Content) -> some View {
        if let action {
            content.refreshable { await action() }
        } else {
            content
        }
    }
}

public extension View {
    /// Wrap a screen body in the standard Trinity screen container.
    /// - Parameter refreshable: optional async action invoked by pull-to-refresh.
    func trinityScreen(refreshable: (() async -> Void)? = nil) -> some View {
        modifier(TrinityScreenModifier(refreshAction: refreshable))
    }
}

#if canImport(UIKit)
#Preview("Demo screen") {
    VStack(spacing: TrinitySpacing.cardSpacing) {
        Text("Header").font(TrinityTypography.titleLarge)
        ForEach(0..<5, id: \.self) { i in
            Text("Card \(i)")
                .frame(maxWidth: .infinity)
                .padding(TrinitySpacing.cardPadding)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: TrinitySpacing.cardCornerRadius, style: .continuous))
        }
    }
    .trinityScreen()
    .theme(DemoTRTTheme())
}
#endif
