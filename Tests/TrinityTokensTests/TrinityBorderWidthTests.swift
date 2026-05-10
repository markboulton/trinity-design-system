import Testing
@testable import TrinityTokens

@Suite("TrinityBorderWidth")
struct TrinityBorderWidthTests {
    @Test("Border width tokens have expected values")
    func values() {
        #expect(TrinityBorderWidth.hairline == 0.5)
        #expect(TrinityBorderWidth.thin == 1.0)
        #expect(TrinityBorderWidth.medium == 1.5)
    }
}
