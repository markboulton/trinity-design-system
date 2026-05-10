import Testing
@testable import TrinityTokens

@Suite("TrinityTypography")
struct TrinityTypographyTests {

    @Test("fontFamily is InterVariable")
    func fontFamilyName() {
        #expect(TrinityTypography.fontFamily == "InterVariable")
    }

    @Test("Numeric tokens differ from their proportional equivalents")
    func numericTokensAreMonospaced() {
        #expect(TrinityTypography.numericLarge != TrinityTypography.displayLarge)
        #expect(TrinityTypography.numericMedium != TrinityTypography.titleLarge)
    }
}
