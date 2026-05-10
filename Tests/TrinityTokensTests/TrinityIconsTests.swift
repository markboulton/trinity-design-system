import Testing
@testable import TrinityTokens

@Suite("TrinityIcons")
struct TrinityIconsTests {
    @Test("Size constants have expected point values")
    func sizes() {
        #expect(TrinityIcons.Size.small == 13)
        #expect(TrinityIcons.Size.medium == 17)
        #expect(TrinityIcons.Size.large == 22)
        #expect(TrinityIcons.Size.xlarge == 28)
    }
}
