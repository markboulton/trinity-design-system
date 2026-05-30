import Testing
@testable import TrinityComponents

@Suite("TrinityArcGeometry — open-bottom arc maths")
struct TrinityArcGeometryTests {

    @Test func defaultSweepLeavesNinetyDegreeBottomGap() {
        // 270° sweep → 90° gap centred on the bottom (90° in SwiftUI angle space).
        #expect(TrinityArcGeometry.startAngleDegrees() == 135)   // bottom-left
        #expect(TrinityArcGeometry.endAngleDegrees() == 405)     // bottom-right (45° + 360)
    }

    @Test func fractionMapsValueIntoUnitInterval() {
        #expect(TrinityArcGeometry.fraction(value: 250, min: 200, max: 300) == 0.5)
        #expect(TrinityArcGeometry.fraction(value: 150, min: 200, max: 300) == 0)
        #expect(TrinityArcGeometry.fraction(value: 350, min: 200, max: 300) == 1)
    }

    @Test func fractionWithDegenerateRangeIsZero() {
        #expect(TrinityArcGeometry.fraction(value: 250, min: 250, max: 250) == 0)
    }

    @Test func fillEndAngleClampsAndInterpolates() {
        // Half-full → halfway along the 270° sweep from the 135° start = 270°.
        #expect(TrinityArcGeometry.fillEndAngleDegrees(fraction: 0.5) == 270)
        #expect(TrinityArcGeometry.fillEndAngleDegrees(fraction: 0) == 135)
        #expect(TrinityArcGeometry.fillEndAngleDegrees(fraction: 1) == 405)
        #expect(TrinityArcGeometry.fillEndAngleDegrees(fraction: 2) == 405) // clamped
    }
}
