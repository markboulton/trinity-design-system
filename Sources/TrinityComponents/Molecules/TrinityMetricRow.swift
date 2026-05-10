import SwiftUI
import TrinityTokens
import TrinityTheme

/// Label + current value + trend arrow, used in dashboard and summaries.
public struct TrinityMetricRow: View {

    @Environment(\.theme) private var theme

    public enum Trend {
        case up
        case down
        case stable
        case none
    }

    public let label: String
    public let value: String
    public let unit: String
    public let trend: Trend
    public let trendValue: String?

    public init(
        label: String,
        value: String,
        unit: String = "",
        trend: Trend = .none,
        trendValue: String? = nil
    ) {
        self.label = label
        self.value = value
        self.unit = unit
        self.trend = trend
        self.trendValue = trendValue
    }

    public var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(label)
                .font(TrinityTypography.subheadline)
                .foregroundStyle(theme.labelTertiary)

            Spacer()

            HStack(alignment: .lastTextBaseline, spacing: TrinitySpacing.md) {
                if let trendValue, trend != .none {
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Image(systemName: trendIcon)
                            .font(TrinityTypography.caption)
                        Text(trendValue)
                            .font(TrinityTypography.caption)
                    }
                    .foregroundStyle(trendColor)
                }

                HStack(alignment: .lastTextBaseline, spacing: TrinitySpacing.xs) {
                    Text(value)
                        .font(TrinityTypography.numericSmall)
                        .foregroundStyle(theme.labelPrimary)

                    if !unit.isEmpty {
                        Text(unit)
                            .font(TrinityTypography.caption)
                            .foregroundStyle(theme.labelTertiary)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value) \(unit)")
    }

    private var trendIcon: String {
        switch trend {
        case .up:     "arrow.up.right"
        case .down:   "arrow.down.right"
        case .stable: "arrow.right"
        case .none:   ""
        }
    }

    private var trendColor: Color {
        switch trend {
        case .up:     TrinityStatusColors.success
        case .down:   TrinityStatusColors.error
        case .stable: theme.labelTertiary
        case .none:   .clear
        }
    }
}

#if canImport(UIKit)
#Preview {
    TrinityCard(title: "This Week") {
        VStack(spacing: TrinitySpacing.md) {
            TrinityMetricRow(label: "Energy", value: "4.2", unit: "/5", trend: .up, trendValue: "+0.3")
            Divider()
            TrinityMetricRow(label: "Mood", value: "3.8", unit: "/5", trend: .stable, trendValue: "0.0")
            Divider()
            TrinityMetricRow(label: "Hematocrit", value: "47.2", unit: "%", trend: .down, trendValue: "-1.1")
            Divider()
            TrinityMetricRow(label: "Weight", value: "82.5", unit: "kg")
        }
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
