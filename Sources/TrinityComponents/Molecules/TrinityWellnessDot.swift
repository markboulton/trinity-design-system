import SwiftUI
import TrinityTokens
import TrinityTheme

/// Green/amber/red calendar dot used to indicate daily wellness status.
///
/// Maps a `Status` value to the Trinity wellness RAG colour scale.
/// Renders as a filled circle sized for use inside calendar or list cells.
public struct TrinityWellnessDot: View {

    /// Wellness RAG status.
    public enum Status {
        case good
        case caution
        case concerning
        case none
    }

    public let status: Status

    public init(status: Status) {
        self.status = status
    }

    private static let dotSize: CGFloat = 8

    private var color: Color {
        switch status {
        case .good:       TrinityStatusColors.wellnessGreen
        case .caution:    TrinityStatusColors.wellnessAmber
        case .concerning: TrinityStatusColors.wellnessRed
        case .none:       Color.clear
        }
    }

    public var body: some View {
        Circle()
            .fill(color)
            .frame(width: Self.dotSize, height: Self.dotSize)
    }
}

#if canImport(UIKit)
#Preview {
    HStack(spacing: TrinitySpacing.md) {
        TrinityWellnessDot(status: .good)
        TrinityWellnessDot(status: .caution)
        TrinityWellnessDot(status: .concerning)
        TrinityWellnessDot(status: .none)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
