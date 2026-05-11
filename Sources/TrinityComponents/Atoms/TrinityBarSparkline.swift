import SwiftUI
import TrinityTokens
import TrinityTheme

public struct TrinityBarSparkline: View {
    public let values: [Double]
    public let tint: Color

    public init(values: [Double], tint: Color) {
        self.values = values
        self.tint = tint
    }

    public var body: some View {
        GeometryReader { geometry in
            let maxValue = values.max() ?? 1
            let barCount = CGFloat(values.count)
            let barSpacing: CGFloat = 2
            let totalSpacing = barSpacing * max(barCount - 1, 0)
            let barWidth = max((geometry.size.width - totalSpacing) / barCount, 1)

            HStack(alignment: .bottom, spacing: barSpacing) {
                ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                    let normalised = maxValue > 0 ? value / maxValue : 0
                    RoundedRectangle(cornerRadius: 2)
                        .fill(tint)
                        .frame(
                            width: barWidth,
                            height: max(geometry.size.height * normalised, 2)
                        )
                }
            }
        }
    }
}

#if canImport(UIKit)
#Preview {
    TrinityBarSparkline(
        values: [3200, 5100, 4800, 6200, 7100, 3900, 5500, 6800, 4200, 7234],
        tint: TrinityStatusColors.success
    )
    .frame(width: 140, height: 48)
    .padding()
    .background(DemoTRTTheme().cardBackground)
    .theme(DemoTRTTheme())
}
#endif
