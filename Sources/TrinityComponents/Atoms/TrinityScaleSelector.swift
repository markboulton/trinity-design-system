import SwiftUI
import TrinityTokens
import TrinityTheme

/// Horizontal 1–5 scale picker with numbered circles.
///
/// Each level is tappable and highlights the selected value with a colour fill.
/// Use `isInverted: true` for negative symptoms (e.g. anxiety, irritability) where
/// 1 = good and 5 = bad; the default scale treats 5 as the best.
///
/// Usage:
/// ```swift
/// TrinityScaleSelector(label: "Energy", value: $energy)
/// TrinityScaleSelector(label: "Anxiety", value: $anxiety, isInverted: true)
/// TrinityScaleSelector(label: "Sleep", value: $sleep, sourceLabel: "From Watch")
/// ```
public struct TrinityScaleSelector: View {

    @Environment(\.theme) private var theme

    public let label: String
    @Binding public var value: Int
    public let sourceLabel: String?
    public let isInverted: Bool

    private var scaleLabels: [String] {
        isInverted
            ? ["None", "Mild", "Moderate", "High", "Severe"]
            : ["Awful", "Low", "Okay", "Good", "Great"]
    }

    public init(
        label: String,
        value: Binding<Int>,
        sourceLabel: String? = nil,
        isInverted: Bool = false
    ) {
        self.label = label
        self._value = value
        self.sourceLabel = sourceLabel
        self.isInverted = isInverted
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            HStack {
                Text(label)
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(theme.labelPrimary)

                Spacer()

                if let sourceLabel {
                    Text(sourceLabel)
                        .font(TrinityTypography.caption)
                        .foregroundStyle(theme.accent)
                }
            }

            HStack(spacing: TrinitySpacing.sm) {
                ForEach(1...5, id: \.self) { level in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            value = level
                        }
                    } label: {
                        VStack(spacing: TrinitySpacing.xs) {
                            ZStack {
                                Circle()
                                    .fill(value == level ? colorForLevel(level) : Color.clear)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                value == level ? colorForLevel(level) : theme.borderSubtle,
                                                lineWidth: 1.5
                                            )
                                    )
                                    .frame(width: 36, height: 36)

                                Text("\(level)")
                                    .font(TrinityTypography.numericSmall)
                                    .foregroundStyle(value == level ? theme.labelOnFill : theme.labelSecondary)
                            }

                            Text(scaleLabels[level - 1])
                                .font(TrinityTypography.captionSmall)
                                .foregroundStyle(
                                    value == level ? colorForLevel(level) : theme.labelTertiary
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(label): \(level), \(scaleLabels[level - 1])")
                }
            }
        }
    }

    private func colorForLevel(_ level: Int) -> Color {
        if isInverted {
            switch level {
            case 1: TrinityStatusColors.wellnessGreen
            case 2: TrinityStatusColors.success
            case 3: TrinityStatusColors.wellnessAmber
            case 4: TrinityStatusColors.warning
            case 5: TrinityStatusColors.wellnessRed
            default: theme.borderSubtle
            }
        } else {
            switch level {
            case 1: TrinityStatusColors.wellnessRed
            case 2: TrinityStatusColors.warning
            case 3: TrinityStatusColors.wellnessAmber
            case 4: TrinityStatusColors.success
            case 5: TrinityStatusColors.wellnessGreen
            default: theme.borderSubtle
            }
        }
    }
}

#if canImport(UIKit)
#Preview("Scale selectors") {
    VStack(spacing: TrinitySpacing.xl) {
        TrinityScaleSelector(label: "Energy", value: .constant(4))
        TrinityScaleSelector(label: "Sleep", value: .constant(2), sourceLabel: "From Apple Watch")
        TrinityScaleSelector(label: "Mood", value: .constant(0))
        TrinityScaleSelector(label: "Anxiety", value: .constant(3), isInverted: true)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
