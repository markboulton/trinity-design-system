import SwiftUI
import TrinityTokens
import TrinityTheme

// File-private constants used as default parameter values in TrinityProgressRing.init.
// Public-facing aliases are exposed as static properties on the struct below.
private let _progressRingDefaultSize: CGFloat = 80
private let _progressRingDefaultLineWidth: CGFloat = 8

/// Circular progress arc with optional centre and caption labels.
///
/// Value is clamped to `0...1` — pass fractional progress directly.
/// The tint defaults to `theme.accent`; pass a custom `Color` to override.
///
/// Usage:
/// ```swift
/// TrinityProgressRing(value: 0.72, centreLabel: "7,234", captionLabel: "STEPS")
/// TrinityProgressRing(value: 0.5, tint: TrinityStatusColors.success, size: 60, lineWidth: 6)
/// ```
public struct TrinityProgressRing: View {

    /// Default ring diameter (80pt).
    public static let defaultSize: CGFloat = _progressRingDefaultSize
    /// Default stroke width (8pt).
    public static let defaultLineWidth: CGFloat = _progressRingDefaultLineWidth

    @Environment(\.theme) private var theme

    public let value: Double           // 0...1, clamped on init
    public let tint: Color?
    public let centreLabel: String?
    public let captionLabel: String?
    public let size: CGFloat
    public let lineWidth: CGFloat

    public init(
        value: Double,
        tint: Color? = nil,
        centreLabel: String? = nil,
        captionLabel: String? = nil,
        size: CGFloat = _progressRingDefaultSize,
        lineWidth: CGFloat = _progressRingDefaultLineWidth
    ) {
        self.value = min(1, max(0, value))
        self.tint = tint
        self.centreLabel = centreLabel
        self.captionLabel = captionLabel
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(theme.labelSecondary.opacity(TrinityOpacity.tonalFill), lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: value)
                .stroke(tint ?? theme.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Centre labels
            VStack(spacing: TrinitySpacing.hairline) {
                if let centreLabel {
                    Text(centreLabel)
                        .font(TrinityTypography.numericSmall)
                        .foregroundStyle(theme.labelPrimary)
                }
                if let captionLabel {
                    Text(captionLabel)
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(theme.labelSecondary)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

#if canImport(UIKit)
#Preview("Small — 25%") {
    HStack(spacing: TrinitySpacing.xl) {
        TrinityProgressRing(value: 0.25, size: 60, lineWidth: 6)
        TrinityProgressRing(value: 0.25, centreLabel: "25%", size: 60, lineWidth: 6)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Medium — 72% with labels") {
    TrinityProgressRing(
        value: 0.72,
        centreLabel: "7,234",
        captionLabel: "STEPS",
        size: 80,
        lineWidth: 8
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Large — full ring (100%)") {
    TrinityProgressRing(
        value: 1.0,
        tint: TrinityStatusColors.success,
        centreLabel: "100%",
        captionLabel: "GOAL",
        size: 100,
        lineWidth: 10
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
