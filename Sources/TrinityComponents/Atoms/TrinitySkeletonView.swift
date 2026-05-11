import SwiftUI
import TrinityTokens
import TrinityTheme

public struct TrinitySkeletonView: View {
    @Environment(\.theme) private var theme
    @State private var isAnimating = false

    public let height: CGFloat
    public let cornerRadius: CGFloat

    public init(height: CGFloat = 100, cornerRadius: CGFloat = TrinityRadii.card) {
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        theme.backgroundTertiary
            .frame(height: height)
            .overlay(
                LinearGradient(
                    colors: [.clear, theme.labelMuted.opacity(0.15), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(90))
                .offset(x: isAnimating ? 400 : -400)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

#if canImport(UIKit)
#Preview {
    VStack(spacing: TrinitySpacing.md) {
        TrinitySkeletonView(height: 60)
        TrinitySkeletonView(height: 100)
        TrinitySkeletonView(height: 40, cornerRadius: 4)
    }
    .padding(TrinitySpacing.sectionPadding)
    .background(DemoTRTTheme().cardBackground)
    .theme(DemoTRTTheme())
}
#endif
