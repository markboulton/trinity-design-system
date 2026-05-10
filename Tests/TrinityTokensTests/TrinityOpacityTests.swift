import Testing
@testable import TrinityTokens

@Suite("TrinityOpacity")
struct TrinityOpacityTests {
    @Test("Opacity tokens have expected values")
    func values() {
        #expect(TrinityOpacity.tonalFill == 0.15)
        #expect(TrinityOpacity.disabled == 0.5)
        #expect(TrinityOpacity.subtle == 0.6)
        #expect(TrinityOpacity.overlay == 0.8)
    }
}
