import SwiftUI
import TrinityTokens
import TrinityTheme

private let markerBarHeight: CGFloat = 6
private let markerDotSize: CGFloat = 12
private let markerBarTotalHeight: CGFloat = 58

/// Range bar with tooltip callout and tick marks. Shows a numeric value
/// positioned relative to a reference range, coloured out-of-range (coral)
/// outside the range and in-range (sage) within it.
public struct TrinityMarkerBar: View {

    @Environment(\.theme) private var theme

    public let value: Double
    public let rangeLow: Double
    public let rangeHigh: Double
    public let unit: String

    public init(value: Double, rangeLow: Double, rangeHigh: Double, unit: String) {
        self.value = value
        self.rangeLow = rangeLow
        self.rangeHigh = rangeHigh
        self.unit = unit
    }

    public var body: some View {
        GeometryReader { geo in
            let barWidth = geo.size.width
            let rangeWidth = rangeHigh - rangeLow
            let bounds = displayBounds(rangeWidth: rangeWidth)
            let displayLow = bounds.low
            let displayHigh = bounds.high
            let displayRange = displayHigh - displayLow

            let greenStart = (rangeLow - displayLow) / displayRange
            let greenEnd = (rangeHigh - displayLow) / displayRange
            let greenWidth = (greenEnd - greenStart) * barWidth

            let clampedValue = min(max(value, displayLow), displayHigh)
            let dotPosition = ((clampedValue - displayLow) / displayRange) * barWidth

            VStack(spacing: 0) {
                // Tooltip callout
                ZStack {
                    tooltipView
                        .offset(x: tooltipOffset(dotPosition: dotPosition, barWidth: barWidth))
                }
                .frame(height: 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 4)

                // Bar with dot
                ZStack(alignment: .leading) {
                    // Full bar background (out-of-range)
                    Capsule()
                        .fill(TrinityStatusColors.markerOutOfRange)
                        .frame(height: markerBarHeight)

                    // In-range section
                    Capsule()
                        .fill(TrinityStatusColors.markerInRange)
                        .frame(width: max(greenWidth, 0), height: markerBarHeight)
                        .offset(x: greenStart * barWidth)

                    // Value dot
                    Circle()
                        .fill(theme.labelPrimary)
                        .frame(width: markerDotSize, height: markerDotSize)
                        .offset(x: dotPosition - markerDotSize / 2)
                }
                .frame(height: markerDotSize)

                Spacer().frame(height: 4)

                // Tick marks below
                ZStack(alignment: .leading) {
                    tickLabel(formatTick(rangeLow))
                        .offset(x: greenStart * barWidth)

                    tickLabel(formatTick(rangeHigh))
                        .offset(x: greenEnd * barWidth)
                }
                .frame(height: 14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: markerBarTotalHeight)
    }

    // MARK: - Display Bounds

    private func displayBounds(rangeWidth: Double) -> (low: Double, high: Double) {
        guard rangeWidth > 0 else { return (low: rangeLow - 1, high: rangeHigh + 1) }

        var extendLow = min(max(rangeLow * 0.4, rangeWidth * 0.3), rangeWidth * 2.0)
        let lowRatio = min(rangeLow / rangeHigh, 0.8)
        let highMultiplier = 0.35 + (1.0 - lowRatio) * 0.85
        var extendHigh = min(max(rangeHigh * highMultiplier, rangeWidth * 0.3), rangeWidth * 3.0)

        if value < rangeLow {
            extendLow = max(extendLow, (rangeLow - value) + rangeWidth * 0.15)
        }
        if value > rangeHigh {
            extendHigh = max(extendHigh, (value - rangeHigh) + rangeWidth * 0.15)
        }

        let displayLow = max(0, rangeLow - extendLow)
        let displayHigh = rangeHigh + extendHigh

        return (low: displayLow, high: displayHigh)
    }

    // MARK: - Tooltip

    private var tooltipView: some View {
        VStack(spacing: 0) {
            Text(formattedValue)
                .font(TrinityTypography.captionSmallEmphasis)
                .foregroundStyle(theme.cardBackground)
                .padding(.horizontal, TrinitySpacing.xs)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: TrinityRadii.button / 2)
                        .fill(theme.labelPrimary)
                )

            // Downward-pointing triangle arrow
            TrinityMarkerBarTriangle()
                .fill(theme.labelPrimary)
                .frame(width: TrinitySpacing.sm, height: TrinitySpacing.xxs)
        }
    }

    private func tooltipOffset(dotPosition: CGFloat, barWidth: CGFloat) -> CGFloat {
        let approxWidth = CGFloat(formattedValue.count) * 7.5 + 12
        let centered = dotPosition - approxWidth / 2
        return min(max(centered, 0), barWidth - approxWidth)
    }

    // MARK: - Tick Labels

    private func tickLabel(_ text: String) -> some View {
        Text(text)
            .font(TrinityTypography.captionSmall)
            .foregroundStyle(theme.labelTertiary)
            .fixedSize()
            .offset(x: -12)
    }

    // MARK: - Formatting

    private var formattedValue: String {
        if value == value.rounded() && value < 1000 {
            return String(format: "%.0f", value)
        } else if value < 10 {
            return String(format: "%.3f", value)
        } else if value < 100 {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }

    private func formatTick(_ v: Double) -> String {
        if v == v.rounded() {
            return String(format: "%.0f", v)
        } else if v < 10 {
            return String(format: "%.2f", v)
        } else {
            return String(format: "%.1f", v)
        }
    }
}

// MARK: - Triangle Shape

private struct TrinityMarkerBarTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - TrinityMarkerRow

/// Full marker row: name + status badge + value + range bar.
public struct TrinityMarkerRow: View {

    @Environment(\.theme) private var theme

    public let name: String
    public let value: Double
    public let unit: String
    public let rangeLow: Double?
    public let rangeHigh: Double?

    public init(
        name: String,
        value: Double,
        unit: String,
        rangeLow: Double? = nil,
        rangeHigh: Double? = nil
    ) {
        self.name = name
        self.value = value
        self.unit = unit
        self.rangeLow = rangeLow
        self.rangeHigh = rangeHigh
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            HStack(alignment: .top) {
                Text(name)
                    .font(TrinityTypography.headline)
                    .foregroundStyle(theme.labelPrimary)
                Spacer()
                if rangeLow != nil && rangeHigh != nil {
                    statusBadge
                }
            }

            HStack(spacing: TrinitySpacing.xs) {
                Text(formattedValue)
                    .font(TrinityTypography.numericSmall)
                    .foregroundStyle(statusColor)
                Text(unit)
                    .font(TrinityTypography.caption)
                    .foregroundStyle(theme.labelSecondary)
            }

            if let low = rangeLow, let high = rangeHigh {
                TrinityMarkerBar(value: value, rangeLow: low, rangeHigh: high, unit: unit)
            }
        }
        .padding(.vertical, TrinitySpacing.sm)
    }

    private var statusBadge: some View {
        let label = statusLabel
        let color: Color = isInRange ? TrinityStatusColors.markerInRange : TrinityStatusColors.markerOutOfRange

        return Text(label)
            .font(TrinityTypography.captionSmallEmphasis)
            .foregroundStyle(color)
            .padding(.horizontal, TrinitySpacing.sm)
            .padding(.vertical, 3)
            .overlay(
                RoundedRectangle(cornerRadius: TrinitySpacing.xs)
                    .strokeBorder(color, lineWidth: TrinityBorderWidth.medium)
            )
    }

    private var statusLabel: String {
        guard let low = rangeLow, let high = rangeHigh else { return "" }
        if value < low { return "Low" }
        if value > high { return "High" }
        return "Normal"
    }

    private var isInRange: Bool {
        guard let low = rangeLow, let high = rangeHigh else { return true }
        return value >= low && value <= high
    }

    private var statusColor: Color {
        guard let low = rangeLow, let high = rangeHigh else { return theme.labelPrimary }
        return (value >= low && value <= high) ? TrinityStatusColors.markerInRange : TrinityStatusColors.markerOutOfRange
    }

    private var formattedValue: String {
        if value < 10 { return String(format: "%.2f", value) }
        if value < 100 { return String(format: "%.1f", value) }
        return String(format: "%.0f", value)
    }
}

#if canImport(UIKit)
#Preview {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityMarkerRow(name: "Free Testosterone", value: 683, unit: "pmol/L", rangeLow: 200, rangeHigh: 700)
        Divider()
        TrinityMarkerRow(name: "Total Testosterone", value: 29.6, unit: "nmol/L", rangeLow: 8.6, rangeHigh: 29)
        Divider()
        TrinityMarkerRow(name: "Hematocrit", value: 48.881, unit: "%", rangeLow: 38, rangeHigh: 50)
        Divider()
        TrinityMarkerRow(name: "Hemoglobin", value: 174, unit: "g/L", rangeLow: 130, rangeHigh: 170)
        Divider()
        TrinityMarkerRow(name: "HDL Cholesterol", value: 59.165, unit: "mg/dL")
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
