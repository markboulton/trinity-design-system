import SwiftUI
import TrinityTokens
import TrinityTheme

public struct TrinityPulseLoader: View {
    @Environment(\.theme) private var theme
    @State private var outerScale: CGFloat = 1.0
    @State private var innerScale: CGFloat = 0.0

    public let size: CGFloat
    public let lineWidth: CGFloat

    public init(size: CGFloat = 80, lineWidth: CGFloat = 5) {
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(theme.labelPrimary, lineWidth: lineWidth)
                .frame(width: size, height: size)
                .scaleEffect(outerScale)
            Circle()
                .stroke(theme.labelMuted, lineWidth: lineWidth)
                .frame(width: size, height: size)
                .scaleEffect(innerScale)
        }
        .task {
            while true {
                try? await Task.sleep(for: .seconds(0.6))
                guard !Task.isCancelled else { return }
                withAnimation(.linear(duration: 0.2)) { outerScale = 1.2 }
                try? await Task.sleep(for: .seconds(0.2))
                guard !Task.isCancelled else { return }
                withAnimation(.linear(duration: 0.2)) { outerScale = 1.0 }
                try? await Task.sleep(for: .seconds(0.2))
                guard !Task.isCancelled else { return }
            }
        }
        .task {
            while true {
                withAnimation(.linear(duration: 0.6)) { innerScale = 0.0 }
                try? await Task.sleep(for: .seconds(0.6))
                guard !Task.isCancelled else { return }
                withAnimation(.linear(duration: 0.4)) { innerScale = 1.0 }
                try? await Task.sleep(for: .seconds(0.4))
                guard !Task.isCancelled else { return }
            }
        }
    }
}

private struct TrinityLoadingOverlayModifier: ViewModifier {
    @Environment(\.theme) private var theme
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                theme.cardBackground
                    .ignoresSafeArea()
                TrinityPulseLoader()
            }
        }
    }
}

public extension View {
    func trinityLoadingOverlay(_ isLoading: Bool) -> some View {
        modifier(TrinityLoadingOverlayModifier(isLoading: isLoading))
    }
}

#if canImport(UIKit)
#Preview {
    TrinityPulseLoader()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DemoTRTTheme().cardBackground)
        .theme(DemoTRTTheme())
}
#endif
