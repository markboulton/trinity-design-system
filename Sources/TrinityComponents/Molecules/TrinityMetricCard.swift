import SwiftUI
import TrinityTokens
import TrinityTheme

// MARK: - Trend types

/// Directional indicator for a `TrinityMetricCard` trend badge.
public enum TrinityTrendDirection {
    case up, down, neutral
}

/// A trend badge value shown on a `TrinityMetricCard`.
public struct TrinityTrend {
    public let displayText: String       // e.g. "+8%" or "↑ 3"
    public let direction: TrinityTrendDirection

    public init(displayText: String, direction: TrinityTrendDirection) {
        self.displayText = displayText
        self.direction = direction
    }
}

// MARK: - TrinityMetricCard

/// Lightweight metric display molecule: category eyebrow, large numeric value,
/// optional unit, optional directional trend badge, and an optional sparkline slot.
///
/// Unlike `TrinityCompoundMetricCard` (a self-contained organism with card chrome
/// and supplementary rows), this molecule is meant to be embedded inside any
/// container — a `TrinityCard`, a custom layout, or a full-bleed section.
///
/// Usage — no sparkline:
/// ```swift
/// TrinityMetricCard(category: "Recovery", value: "82", unit: "/100",
///                   trend: .init(displayText: "+6", direction: .up))
/// ```
///
/// Usage — with sparkline:
/// ```swift
/// TrinityMetricCard(category: "Volume", value: "14,200", unit: "kg",
///                   trend: .init(displayText: "+8%", direction: .up)) {
///     TrinityBarSparkline(values: weeklyVolume, tint: theme.accent)
///         .frame(height: 32)
/// }
/// ```
public struct TrinityMetricCard<Sparkline: View>: View {

    @Environment(\.theme) private var theme

    public let category: String
    public let value: String
    public var unit: String?
    public var trend: TrinityTrend?
    @ViewBuilder public var sparkline: () -> Sparkline

    public init(
        category: String,
        value: String,
        unit: String? = nil,
        trend: TrinityTrend? = nil,
        @ViewBuilder sparkline: @escaping () -> Sparkline
    ) {
        self.category = category
        self.value = value
        self.unit = unit
        self.trend = trend
        self.sparkline = sparkline
    }

    private var trendColor: Color {
        guard let trend else { return theme.labelMuted }
        switch trend.direction {
        case .up:      return TrinityStatusColors.success
        case .down:    return TrinityStatusColors.error
        case .neutral: return theme.labelMuted
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            // Eyebrow
            Text(category)
                .font(TrinityTypography.captionSmallEmphasis)
                .textCase(.uppercase)
                .tracking(TrinityTypography.sectionEyebrowTracking)
                .foregroundStyle(theme.labelSecondary)

            // Value row
            HStack(alignment: .firstTextBaseline, spacing: TrinitySpacing.xxs) {
                Text(value)
                    .font(TrinityTypography.numericLarge)
                    .foregroundStyle(theme.labelPrimary)

                if let unit {
                    Text(unit)
                        .font(TrinityTypography.subheadline)
                        .foregroundStyle(theme.labelSecondary)
                }

                Spacer()

                if let trend {
                    Text(trend.displayText)
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(trendColor)
                        .padding(.horizontal, TrinitySpacing.xs)
                        .padding(.vertical, 2)
                        .background(trendColor.opacity(TrinityOpacity.tonalFill))
                        .clipShape(RoundedRectangle(cornerRadius: TrinityRadii.button))
                }
            }

            // Sparkline slot
            sparkline()
        }
    }
}

// MARK: - No-sparkline convenience init

extension TrinityMetricCard where Sparkline == EmptyView {
    public init(
        category: String,
        value: String,
        unit: String? = nil,
        trend: TrinityTrend? = nil
    ) {
        self.init(
            category: category,
            value: value,
            unit: unit,
            trend: trend,
            sparkline: { EmptyView() }
        )
    }
}

// MARK: - Previews

#if canImport(UIKit)
#Preview("No sparkline, no trend") {
    TrinityMetricCard(category: "Recovery", value: "82", unit: "/100")
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
}

#Preview("With trend badges") {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityMetricCard(
            category: "Recovery",
            value: "82",
            unit: "/100",
            trend: .init(displayText: "+6", direction: .up)
        )
        TrinityMetricCard(
            category: "Strain",
            value: "67",
            unit: "/100",
            trend: .init(displayText: "−4", direction: .down)
        )
        TrinityMetricCard(
            category: "Readiness",
            value: "75",
            unit: "/100",
            trend: .init(displayText: "→", direction: .neutral)
        )
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

private struct _MetricCardSparklinePreview: View {
    @Environment(\.theme) private var theme
    private let bars: [Double] = [3200, 5100, 4800, 6200, 7100, 3900, 5500]
    var body: some View {
        TrinityMetricCard(
            category: "Volume",
            value: "14,200",
            unit: "kg",
            trend: .init(displayText: "+8%", direction: .up)
        ) {
            TrinityBarSparkline(values: bars, tint: theme.accent)
                .frame(height: 32)
        }
        .padding(TrinitySpacing.lg)
        .theme(DemoTRTTheme())
    }
}

#Preview("With bar sparkline") {
    _MetricCardSparklinePreview()
}
#endif
