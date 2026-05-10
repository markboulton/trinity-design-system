import SwiftUI
import TrinityTokens

/// Standard vertical card stack with `cardSpacing` (12pt) between children.
///
/// Use as the direct child of `trinityScreen()` when the screen is a list of cards.
/// Cards inside the stack must NOT add their own external padding — the stack
/// owns the spacing between them.
public struct TrinityCardStack<Content: View>: View {
    public let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: TrinitySpacing.cardSpacing) {
            content()
        }
    }
}

#if canImport(UIKit)
#Preview("Card stack") {
    TrinityCardStack {
        ForEach(0..<5, id: \.self) { i in
            Text("Card \(i)")
                .frame(maxWidth: .infinity)
                .padding(TrinitySpacing.cardPadding)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(TrinitySpacing.cardCornerRadius)
        }
    }
    .padding(TrinitySpacing.sectionPadding)
}
#endif
