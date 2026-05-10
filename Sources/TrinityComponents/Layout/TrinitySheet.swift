import SwiftUI
import TrinityTokens

/// Standard sheet presentation with Trinity-consistent detents and styling.
///
/// Use for "more"/menu actions, secondary flows, contextual edit panels.
/// For onboarding, paywalls, or auth — use `.fullScreenCover(...)` directly,
/// not this modifier.
public struct TrinitySheetModifier<SheetContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            sheetContent()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
#if os(iOS)
                .presentationCornerRadius(TrinityRadii.sheet)
#endif
        }
    }
}

public extension View {
    /// Present a Trinity-styled sheet.
    func trinitySheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(TrinitySheetModifier(isPresented: isPresented, sheetContent: content))
    }
}
