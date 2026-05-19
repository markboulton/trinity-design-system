import SwiftUI
import TrinityTokens
import TrinityTheme

/// Segmented step-progress bar.
///
/// Renders `totalSteps` rounded-rectangle segments filling `completedSteps`
/// of them with the theme accent. Animates when `completedSteps` changes.
///
/// Ported from the GymReady mesocycle-builder step indicator.
///
/// Usage:
/// ```swift
/// TrinityStepBar(totalSteps: 6, completedSteps: 3)
/// ```
public struct TrinityStepBar: View {

    @Environment(\.theme) private var theme

    public let totalSteps: Int
    public let completedSteps: Int

    public init(totalSteps: Int, completedSteps: Int) {
        self.totalSteps = totalSteps
        self.completedSteps = completedSteps
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<max(totalSteps, 0), id: \.self) { index in
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(index < completedSteps ? theme.accent : theme.borderSubtle)
                    .frame(height: 3)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: completedSteps)
    }
}

#if canImport(UIKit)
#Preview("Step bar") {
    VStack(spacing: TrinitySpacing.xl) {
        TrinityStepBar(totalSteps: 6, completedSteps: 0)
        TrinityStepBar(totalSteps: 6, completedSteps: 3)
        TrinityStepBar(totalSteps: 6, completedSteps: 6)
        TrinityStepBar(totalSteps: 7, completedSteps: 4)
    }
    .padding(TrinitySpacing.xxl)
    .theme(DemoTRTTheme())
}
#endif
