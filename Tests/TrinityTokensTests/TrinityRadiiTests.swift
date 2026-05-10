import Testing
@testable import TrinityTokens

@Suite("TrinityRadii")
struct TrinityRadiiTests {
    @Test("Radii have expected values")
    func values() {
        #expect(TrinityRadii.button == 8)
        #expect(TrinityRadii.card == 10)
        #expect(TrinityRadii.sheet == 16)
        #expect(TrinityRadii.pill == 999)
    }
}
