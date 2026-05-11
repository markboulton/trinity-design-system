import SwiftUI
import Charts
import TrinityTokens
import TrinityTheme

public struct TrinityLineSparkline: View {
    public let values: [Double]
    public let tint: Color

    public init(values: [Double], tint: Color) {
        self.values = values
        self.tint = tint
    }

    public var body: some View {
        if values.count < 2 {
            Color.clear
        } else {
            let minY = values.min() ?? 0
            let maxY = values.max() ?? 0
            let padding = max((maxY - minY) * 0.2, 0.5)
            Chart(Array(values.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("x", index),
                    y: .value("y", value)
                )
                .foregroundStyle(tint)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 1.5, lineCap: .round))

                if values.count <= 30 {
                    PointMark(
                        x: .value("x", index),
                        y: .value("y", value)
                    )
                    .foregroundStyle(tint)
                    .symbolSize(35)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartYScale(domain: (minY - padding)...(maxY + padding))
            .allowsHitTesting(false)
        }
    }
}

#if canImport(UIKit)
#Preview {
    TrinityLineSparkline(
        values: [240, 242, 245, 243, 248, 246, 250, 248],
        tint: Color(red: 0.145, green: 0.388, blue: 0.922)
    )
    .frame(width: 140, height: 48)
    .padding()
    .background(DemoTRTTheme().cardBackground)
    .theme(DemoTRTTheme())
}
#endif
