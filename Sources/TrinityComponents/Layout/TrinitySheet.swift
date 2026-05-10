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
            if #available(iOS 16.4, macOS 13.3, *) {
                sheetContent()
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(TrinityRadii.sheet)
                    .presentationDragIndicator(.visible)
            } else {
                sheetContent()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
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
