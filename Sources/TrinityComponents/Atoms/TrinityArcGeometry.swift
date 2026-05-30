import Foundation

/// Pure geometry for an open-bottom arc gauge (SpaceX-telemetry style).
/// SwiftUI angle space: 0° = 3 o'clock, 90° = 6 o'clock (bottom), increasing clockwise.
/// A 270° sweep leaves a 90° gap centred on the bottom: the track runs from
/// 135° (bottom-left) clockwise to 405°/45° (bottom-right).
public enum TrinityArcGeometry {

    /// Default arc sweep in degrees (270° → 90° bottom gap).
    public static let defaultSweepDegrees: Double = 270

    /// Start angle (bottom-left), degrees. Gap = 360 − sweep, centred at the bottom (90°).
    public static func startAngleDegrees(sweepDegrees: Double = defaultSweepDegrees) -> Double {
        let gap = 360 - sweepDegrees
        return 90 + gap / 2
    }

    /// End angle (bottom-right), degrees. May exceed 360 (caller draws clockwise from start).
    public static func endAngleDegrees(sweepDegrees: Double = defaultSweepDegrees) -> Double {
        startAngleDegrees(sweepDegrees: sweepDegrees) + sweepDegrees
    }

    /// Absolute angle (degrees) of the fill's leading edge for a 0...1 fraction.
    public static func fillEndAngleDegrees(fraction: Double, sweepDegrees: Double = defaultSweepDegrees) -> Double {
        let clamped = max(0, min(1, fraction))
        return startAngleDegrees(sweepDegrees: sweepDegrees) + clamped * sweepDegrees
    }

    /// Map a value in [min, max] onto 0...1, clamped. Degenerate range → 0.
    public static func fraction(value: Double, min minValue: Double, max maxValue: Double) -> Double {
        guard maxValue > minValue else { return 0 }
        let f = (value - minValue) / (maxValue - minValue)
        return Swift.max(0, Swift.min(1, f))
    }
}
