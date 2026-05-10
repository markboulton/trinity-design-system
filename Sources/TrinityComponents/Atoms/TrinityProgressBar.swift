import SwiftUI
import TrinityTokens
import TrinityTheme

/// Horizontal progress bar for onboarding flows and step indicators.
///
/// Shows current progress as a filled accent portion of a subtle track.
/// Animates when `currentStep` changes.
///
/// Usage:
/// ```swift
/// TrinityProgressBar(currentStep: 3, totalSteps: 10)
/// ```
public struct TrinityProgressBar: View {

    @Environment(\.theme) private var theme

    public let currentStep: Int
    public let totalSteps: Int

    public init(currentStep: Int, totalSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }

    private var progress: CGFloat {
        guard totalSteps > 0 else { return 0 }
        return CGFloat(currentStep) / CGFloat(totalSteps)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(theme.borderSubtle)
                    .frame(height: 4)

                // Fill
                RoundedRectangle(cornerRadius: 2)
                    .fill(theme.accent)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .frame(height: 4)
    }
}

#if canImport(UIKit)
#Preview("Progress steps") {
    VStack(spacing: TrinitySpacing.xxl) {
        TrinityProgressBar(currentStep: 1, totalSteps: 10)
        TrinityProgressBar(currentStep: 5, totalSteps: 10)
        TrinityProgressBar(currentStep: 9, totalSteps: 10)
    }
    .padding(TrinitySpacing.xxl)
    .theme(DemoTRTTheme())
}
#endif
