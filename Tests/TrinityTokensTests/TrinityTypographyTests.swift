import Testing
@testable import TrinityTokens

@Suite("TrinityTypography")
struct TrinityTypographyTests {

    @Test("fontFamily is InterVariable")
    func fontFamilyName() {
        #expect(TrinityTypography.fontFamily == "InterVariable")
    }

    @Test("Mono family PostScript names are the registered IBM Plex Mono faces")
    func monoFamilyNames() {
        #expect(TrinityTypography.monoRegular == "IBMPlexMono-Regular")
        #expect(TrinityTypography.monoMedium == "IBMPlexMono-Medium")
        #expect(TrinityTypography.monoBold == "IBMPlexMono-Bold")
    }

    @Test("Numeric tokens differ from their proportional Inter equivalents")
    func numericTokensAreMonospaced() {
        #expect(TrinityTypography.numericLarge != TrinityTypography.displayLarge)
        #expect(TrinityTypography.numericMedium != TrinityTypography.titleLarge)
        #expect(TrinityTypography.numericSmall != TrinityTypography.body)
    }

    @Test("metricLarge is an alias of numericLarge")
    func metricLargeAlias() {
        #expect(TrinityTypography.metricLarge == TrinityTypography.numericLarge)
    }

    @Test("Hero and chart numeric tokens are distinct from each other")
    func heroAndChartTokensAreDistinct() {
        #expect(TrinityTypography.heroMetric != TrinityTypography.heroNumeric)
        #expect(TrinityTypography.heroNumeric != TrinityTypography.heroNumericSmall)
        #expect(TrinityTypography.chartLabel != TrinityTypography.chartValue)
        #expect(TrinityTypography.sectionLabel != TrinityTypography.captionSmall)
    }
}
