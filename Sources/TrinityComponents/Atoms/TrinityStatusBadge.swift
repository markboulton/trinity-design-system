import SwiftUI
import TrinityTokens
import TrinityTheme

/// Semantic status badge — a tonal-fill capsule for success / warning /
/// error / info / neutral states, with an optional leading icon.
///
/// Distinct from `TrinityBadge`, which is the gradient-bordered "Pro"
/// subscription pill. Use `TrinityStatusBadge` for state indicators
/// (recovery status, sync state, range flags); use `TrinityBadge` for
/// subscription / branding prompts.
///
/// Usage:
/// ```swift
/// TrinityStatusBadge("OPTIMAL", style: .success)
/// TrinityStatusBadge("HIGH", style: .warning, weight: .subtle)
/// TrinityStatusBadge("NEW", style: .info, icon: "sparkles")
/// ```
public struct TrinityStatusBadge: View {

    @Environment(\.theme) private var theme

    /// Semantic colour role for the badge.
    public enum Style: Sendable {
        case success
        case warning
        case error
        case info
        case neutral
    }

    /// Controls fill and text opacity. `.standard` for novel / important
    /// badges; `.subtle` for repeating chrome that shouldn't compete for
    /// attention.
    public enum Weight: Sendable {
        /// Full-strength fill + text.
        case standard
        /// Low-contrast fill + dimmed text.
        case subtle
    }

    public let text: String
    public let style: Style
    public let weight: Weight
    public let icon: String?

    public init(
        _ text: String,
        style: Style = .neutral,
        weight: Weight = .standard,
        icon: String? = nil
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.icon = icon
    }

    private var baseColor: Color {
        switch style {
        case .success: return TrinityStatusColors.success
        case .warning: return TrinityStatusColors.warning
        case .error:   return TrinityStatusColors.error
        case .info:    return theme.accent
        case .neutral: return theme.labelMuted
        }
    }

    // Fill / dim ratios. These specific values (0.2 / 0.1 / 0.7) have no
    // exact TrinityOpacity token; they are the established badge ratios
    // ported verbatim from VeloReady's VRBadge so consuming wrappers
    // render identically.
    private var backgroundColor: Color {
        switch weight {
        case .standard: return baseColor.opacity(0.2)
        case .subtle:   return baseColor.opacity(0.1)
        }
    }

    private var foregroundColor: Color {
        switch weight {
        case .standard: return baseColor
        case .subtle:   return baseColor.opacity(0.7)
        }
    }

    public var body: some View {
        HStack(spacing: TrinitySpacing.xs) {
            if let icon {
                Image(systemName: icon)
                    .font(TrinityTypography.caption2Emphasis)
                    .foregroundStyle(foregroundColor)
            }
            Text(text)
                .font(TrinityTypography.caption2Emphasis)
                .foregroundStyle(foregroundColor)
        }
        .padding(.horizontal, TrinitySpacing.sm)
        .padding(.vertical, TrinitySpacing.xxs)
        .background(
            Capsule().fill(backgroundColor)
        )
    }
}

#if canImport(UIKit)
#Preview("Standard weight") {
    VStack(spacing: TrinitySpacing.md) {
        HStack(spacing: TrinitySpacing.sm) {
            TrinityStatusBadge("OPTIMAL", style: .success)
            TrinityStatusBadge("HIGH", style: .warning)
            TrinityStatusBadge("POOR", style: .error)
        }
        HStack(spacing: TrinitySpacing.sm) {
            TrinityStatusBadge("INFO", style: .info)
            TrinityStatusBadge("NEUTRAL", style: .neutral)
        }
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Subtle weight") {
    HStack(spacing: TrinitySpacing.sm) {
        TrinityStatusBadge("SYNCED", style: .success, weight: .subtle)
        TrinityStatusBadge("WARNING", style: .warning, weight: .subtle)
        TrinityStatusBadge("INFO", style: .info, weight: .subtle)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("With icon") {
    HStack(spacing: TrinitySpacing.sm) {
        TrinityStatusBadge("NEW", style: .info, icon: "sparkles")
        TrinityStatusBadge("HIGH", style: .warning, icon: "exclamationmark.triangle")
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
