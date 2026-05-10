import SwiftUI
import TrinityTokens
import TrinityTheme

/// "Waiting for data" variant of `TrinityCompoundMetricCard`. Used when a
/// metric's data permission has been granted but no samples have synced yet.
///
/// The card mirrors the data-populated layout so the user can see the shape
/// of what's coming, but renders dashes in place of numbers and a
/// "Waiting for first reading" caption.
public struct TrinityPendingMetricCard: View {

    @Environment(\.theme) private var theme

    public enum ValueShape {
        /// Single metric: renders `—` in the hero slot.
        case single
        /// Pair metric (e.g. systolic / diastolic): renders `— / —`.
        case pair
    }

    public let label: String
    public let unit: String?
    public let valueShape: ValueShape
    public let rowLabels: [String]

    public init(
        label: String,
        unit: String? = nil,
        valueShape: ValueShape = .single,
        rowLabels: [String] = []
    ) {
        self.label = label
        self.unit = unit
        self.valueShape = valueShape
        self.rowLabels = rowLabels
    }

    public var body: some View {
        TrinityCompoundMetricCard(
            label: label,
            value: heroValue,
            unit: unit,
            rows: rowLabels.map {
                TrinityCompoundMetricCard.Row(label: $0, value: "—", unit: unit)
            },
            trailingContent: {
                RoundedRectangle(cornerRadius: TrinityRadii.button)
                    .fill(theme.labelSecondary.opacity(TrinityOpacity.tonalFill / 2))
                    .frame(width: 140, height: 48)
            },
            bottomContent: {
                HStack(spacing: TrinitySpacing.xs) {
                    Image(systemName: "clock")
                        .frame(width: TrinityIcons.Size.small, height: TrinityIcons.Size.small)
                        .font(TrinityTypography.caption)
                    Text("Waiting for first reading")
                        .font(TrinityTypography.caption)
                    Spacer()
                }
                .foregroundStyle(theme.labelSecondary)
            }
        )
        .opacity(TrinityOpacity.overlay)
    }

    private var heroValue: String {
        switch valueShape {
        case .single: return "—"
        case .pair:   return "— / —"
        }
    }
}

#if canImport(UIKit)
#Preview("Single value") {
    TrinityPendingMetricCard(
        label: "Resting HR",
        unit: "bpm",
        rowLabels: ["7-day avg", "Status"]
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Pair value") {
    TrinityPendingMetricCard(
        label: "Blood Pressure",
        unit: "mmHg",
        valueShape: .pair,
        rowLabels: ["7-day avg systolic", "7-day avg diastolic", "Pulse pressure"]
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
