import Testing
@testable import TrinityTokens

@Suite("TrinitySpacing")
struct TrinitySpacingTests {

    @Test("Base units have expected values")
    func baseUnits() {
        #expect(TrinitySpacing.hairline == 2)
        #expect(TrinitySpacing.xxs == 4)
        #expect(TrinitySpacing.xs == 6)
        #expect(TrinitySpacing.sm == 8)
        #expect(TrinitySpacing.md == 12)
        #expect(TrinitySpacing.lg == 16)
        #expect(TrinitySpacing.xl == 20)
        #expect(TrinitySpacing.xxl == 24)
        #expect(TrinitySpacing.huge == 32)
        #expect(TrinitySpacing.touch == 44)
    }

    @Test("Semantic aliases resolve to base units")
    func semanticAliases() {
        #expect(TrinitySpacing.cardPadding == TrinitySpacing.lg)
        #expect(TrinitySpacing.cardSpacing == TrinitySpacing.md)
        #expect(TrinitySpacing.sectionSpacing == TrinitySpacing.xl)
        #expect(TrinitySpacing.sectionPadding == TrinitySpacing.xl)
        #expect(TrinitySpacing.cardContentSpacing == TrinitySpacing.md)
        #expect(TrinitySpacing.cardCornerRadius == 10)
        #expect(TrinitySpacing.buttonCornerRadius == 8)
    }
}
