import Testing
import SwiftUI
@testable import TrinityTokens

@Suite struct TrinityMacroColorsTests {

    @Test func macroBarColoursAreDistinct() {
        // Colours are distinct SwiftUI Color values built from different RGB components.
        let protein = TrinityMacroColors.macroProtein
        let carbs   = TrinityMacroColors.macroCarbs
        let fat     = TrinityMacroColors.macroFat
        #expect(protein != carbs)
        #expect(carbs != fat)
        #expect(protein != fat)
    }

    @Test func dataQualityAliasesReuseTheMacroPalette() {
        #expect(TrinityMacroColors.dataPartial   == TrinityMacroColors.macroCarbs)
        #expect(TrinityMacroColors.dataCommunity == TrinityMacroColors.macroFat)
    }
}
