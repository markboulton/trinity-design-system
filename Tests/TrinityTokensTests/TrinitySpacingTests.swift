import XCTest
@testable import TrinityTokens

final class TrinitySpacingTests: XCTestCase {

    func test_baseUnits_haveExpectedValues() {
        XCTAssertEqual(TrinitySpacing.hairline, 2)
        XCTAssertEqual(TrinitySpacing.xxs, 6)
        XCTAssertEqual(TrinitySpacing.xs, 4)
        XCTAssertEqual(TrinitySpacing.sm, 8)
        XCTAssertEqual(TrinitySpacing.md, 12)
        XCTAssertEqual(TrinitySpacing.lg, 16)
        XCTAssertEqual(TrinitySpacing.xl, 20)
        XCTAssertEqual(TrinitySpacing.xxl, 24)
        XCTAssertEqual(TrinitySpacing.huge, 32)
        XCTAssertEqual(TrinitySpacing.touch, 44)
    }

    func test_semanticAliases_resolveToBaseUnits() {
        XCTAssertEqual(TrinitySpacing.cardPadding, TrinitySpacing.lg)        // 16
        XCTAssertEqual(TrinitySpacing.cardSpacing, TrinitySpacing.md)        // 12
        XCTAssertEqual(TrinitySpacing.sectionSpacing, TrinitySpacing.xl)     // 20
        XCTAssertEqual(TrinitySpacing.sectionPadding, TrinitySpacing.xl)     // 20
        XCTAssertEqual(TrinitySpacing.cardContentSpacing, TrinitySpacing.md) // 12
        XCTAssertEqual(TrinitySpacing.cardCornerRadius, 10)
        XCTAssertEqual(TrinitySpacing.buttonCornerRadius, 8)
    }
}
