import SwiftUI
import TrinityTokens
import TrinityTheme

/// An open arc stroke whose fill fraction is animatable.
struct OpenArc: Shape {
    var fraction: Double
    var sweepDegrees: Double

    var animatableData: Double {
        get { fraction }
        set { fraction = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let start = TrinityArcGeometry.startAngleDegrees(sweepDegrees: sweepDegrees)
        let end = TrinityArcGeometry.fillEndAngleDegrees(fraction: fraction, sweepDegrees: sweepDegrees)
        var path = Path()
        path.addArc(
            center: centre,
            radius: radius,
            startAngle: .degrees(start),
            endAngle: .degrees(end),
            clockwise: false
        )
        return path
    }
}

/// Animatable fill that re-evaluates its colour from the *current animated fraction*
/// every frame — this is what lets the Readiness fill cycle colour as it sweeps
/// (faithfully retaining VeloReady's `AnimatableReadinessRing` behaviour). Used only
/// when a `tintForFraction` closure is supplied; otherwise the static-tint fill is used.
struct AnimatableArcFill: View, Animatable {
    var fraction: Double
    var sweepDegrees: Double
    var lineWidth: CGFloat
    var colorForFraction: (Double) -> Color

    var animatableData: Double {
        get { fraction }
        set { fraction = newValue }
    }

    var body: some View {
        OpenArc(fraction: fraction, sweepDegrees: sweepDegrees)
            .stroke(colorForFraction(fraction), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

/// SpaceX-telemetry-style open-bottom arc gauge: an open ~270° arc with a
/// caps label / value / unit stack centred inside, and an optional baseline arc.
public struct TrinityOpenArcGauge: View {
    // Match VeloReady's existing compact ring exactly: 100pt diameter, 5pt stroke
    // (ComponentSizes.ringDiameterSmall / ringWidthSmall). Retained per requirement.
    // @usableFromInline is required because these back default arguments on the public init.
    @usableFromInline static let defaultSize: CGFloat = 100
    @usableFromInline static let defaultLineWidth: CGFloat = 5

    @Environment(\.theme) private var theme

    public let value: Double
    public let minValue: Double
    public let maxValue: Double
    /// Caps definition label shown ABOVE the value, inside the arc (e.g. "READINESS").
    public let label: String
    /// Large numeral shown in the centre (e.g. "84" or "268").
    public let displayText: String
    /// Opacity of the centre numeral, for an independent fade-in. Default 1.
    public let numberOpacity: Double
    /// Optional unit shown below the value (e.g. "W"). Pass nil for none.
    public let unit: String?
    /// Fill colour. Pass nil to use the theme accent. Ignored if `tintForFraction` is set.
    public let tint: Color?
    /// Optional colour-by-fraction mapping. When supplied, the fill cycles colour as it
    /// animates (retains VeloReady's status-colour-by-progress ring behaviour).
    public let tintForFraction: ((Double) -> Color)?
    /// Optional reference level drawn as a faint arc under the fill (e.g. Readiness baseline).
    public let baseline: Double?
    public let size: CGFloat
    public let lineWidth: CGFloat
    public let sweepDegrees: Double

    public init(
        value: Double,
        minValue: Double,
        maxValue: Double,
        label: String,
        displayText: String,
        numberOpacity: Double = 1,
        unit: String? = nil,
        tint: Color? = nil,
        tintForFraction: ((Double) -> Color)? = nil,
        baseline: Double? = nil,
        size: CGFloat = defaultSize,
        lineWidth: CGFloat = defaultLineWidth,
        sweepDegrees: Double = TrinityArcGeometry.defaultSweepDegrees
    ) {
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.label = label
        self.displayText = displayText
        self.numberOpacity = numberOpacity
        self.unit = unit
        self.tint = tint
        self.tintForFraction = tintForFraction
        self.baseline = baseline
        self.size = size
        self.lineWidth = lineWidth
        self.sweepDegrees = sweepDegrees
    }

    private var fraction: Double {
        TrinityArcGeometry.fraction(value: value, min: minValue, max: maxValue)
    }

    private var baselineFraction: Double? {
        baseline.map { TrinityArcGeometry.fraction(value: $0, min: minValue, max: maxValue) }
    }

    private var stroke: StrokeStyle { StrokeStyle(lineWidth: lineWidth, lineCap: .round) }

    /// Metric (numeral) centre relative to the dial centre — slightly low for optical alignment.
    private var metricCentreY: CGFloat { size * 0.05 }
    /// Distance of the caps label above the metric (and the unit below it).
    private var titleGap: CGFloat { size * 0.13 }

    public var body: some View {
        ZStack {
            // Track (full sweep, faint)
            OpenArc(fraction: 1, sweepDegrees: sweepDegrees)
                .stroke(theme.labelSecondary.opacity(TrinityOpacity.tonalFill), style: stroke)

            // Optional baseline arc (under the fill) — a lighter tint of the FOREGROUND
            // colour (the fill's colour at the baseline level), not the theme accent.
            if let baselineFraction {
                // 0.3 matches the original ring's faded-recovery baseline opacity.
                OpenArc(fraction: baselineFraction, sweepDegrees: sweepDegrees)
                    .stroke((tintForFraction?(baselineFraction) ?? tint ?? theme.accent).opacity(0.3), style: stroke)
            }

            // Fill — colour-cycling when tintForFraction is supplied, else static tint.
            if let tintForFraction {
                AnimatableArcFill(
                    fraction: fraction,
                    sweepDegrees: sweepDegrees,
                    lineWidth: lineWidth,
                    colorForFraction: tintForFraction
                )
            } else {
                OpenArc(fraction: fraction, sweepDegrees: sweepDegrees)
                    .stroke(tint ?? theme.accent, style: stroke)
            }

            // Centre content: the metric sits just below the dial centre (optical alignment
            // with the open-bottom arc); the caps label a short fixed distance above it; the
            // optional unit the same distance below. Independent offsets keep the title↔metric
            // gap tight regardless of element sizes.
            ZStack {
                Text(displayText)
                    .font(TrinityTypography.numericLarge)
                    .foregroundStyle(theme.labelPrimary)
                    .opacity(numberOpacity)
                    .offset(y: metricCentreY)

                Text(label.uppercased())
                    .font(TrinityTypography.captionSmall)
                    .foregroundStyle(theme.labelSecondary)
                    .offset(y: metricCentreY - titleGap)

                if let unit {
                    Text(unit.uppercased())
                        .font(TrinityTypography.captionSmall)
                        .foregroundStyle(theme.labelTertiary)
                        .offset(y: metricCentreY + titleGap)
                }
            }
        }
        .frame(width: size - lineWidth, height: size - lineWidth)  // shapes see inset rect → no clip
        .frame(width: size, height: size)                          // external footprint unchanged
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(unit != nil ? "\(displayText) \(unit!)" : displayText)
    }
}

#if canImport(UIKit)
#Preview("Open arc gauges") {
    HStack(spacing: TrinitySpacing.xl) {
        TrinityOpenArcGauge(value: 84, minValue: 0, maxValue: 100, label: "Readiness",
                            displayText: "84", tint: TrinityStatusColors.success, baseline: 90)
        TrinityOpenArcGauge(value: 62, minValue: 0, maxValue: 100, label: "Load",
                            displayText: "62", tint: TrinityStatusColors.caution)
        TrinityOpenArcGauge(value: 268, minValue: 150, maxValue: 350, label: "Fitness",
                            displayText: "268", unit: "W")
    }
    .padding(TrinitySpacing.xxl)
    .theme(DemoVRTheme())
}
#endif
