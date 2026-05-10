import SwiftUI
import TrinityTokens
import TrinityTheme

private let countdownArcSize: CGFloat = 100
private let countdownArcLineWidth: CGFloat = 8

/// Countdown ring showing days remaining until the next event.
///
/// Adapts ring colour to urgency: accent when plenty of time remains,
/// warning when one day away, error when overdue.
public struct TrinityCountdownArc: View {

    @Environment(\.theme) private var theme

    public let daysRemaining: Int
    public let totalDays: Int
    public let label: String

    public init(daysRemaining: Int, totalDays: Int, label: String) {
        self.daysRemaining = daysRemaining
        self.totalDays = totalDays
        self.label = label
    }

    private var progress: Double {
        guard totalDays > 0 else { return 0 }
        return 1.0 - (Double(daysRemaining) / Double(totalDays))
    }

    private var ringColor: Color {
        if daysRemaining <= 0 { return TrinityStatusColors.error }
        if daysRemaining == 1 { return TrinityStatusColors.warning }
        return theme.accent
    }

    public var body: some View {
        VStack(spacing: TrinitySpacing.sm) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        theme.labelSecondary.opacity(TrinityOpacity.tonalFill),
                        lineWidth: countdownArcLineWidth
                    )

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        ringColor,
                        style: StrokeStyle(lineWidth: countdownArcLineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: progress)

                // Centre content
                VStack(spacing: 2) {
                    if daysRemaining <= 0 {
                        Text("NOW")
                            .font(TrinityTypography.numericMedium)
                            .foregroundStyle(TrinityStatusColors.error)
                    } else {
                        Text("\(daysRemaining)")
                            .font(TrinityTypography.numericLarge)
                            .foregroundStyle(ringColor)
                        Text(daysRemaining == 1 ? "day" : "days")
                            .font(TrinityTypography.caption)
                            .foregroundStyle(theme.labelTertiary)
                    }
                }
            }
            .frame(width: countdownArcSize, height: countdownArcSize)

            Text(label)
                .font(TrinityTypography.caption)
                .foregroundStyle(theme.labelSecondary)
                .lineLimit(1)
        }
    }
}

#if canImport(UIKit)
#Preview {
    HStack(spacing: TrinitySpacing.xl) {
        TrinityCountdownArc(daysRemaining: 2, totalDays: 4, label: "Test Cyp")
        TrinityCountdownArc(daysRemaining: 0, totalDays: 4, label: "Inject Today")
        TrinityCountdownArc(daysRemaining: 1, totalDays: 7, label: "HCG")
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
