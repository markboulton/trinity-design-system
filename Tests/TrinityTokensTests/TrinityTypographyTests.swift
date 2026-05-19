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

    @Test("Inter ramp exposes all TC role tokens")
    func interRampCoverage() {
        // Compilation alone proves these tokens exist; values are visual.
        _ = TrinityTypography.displayLarge
        _ = TrinityTypography.displayMedium
        _ = TrinityTypography.titleLarge
        _ = TrinityTypography.titleLargeEmphasis
        _ = TrinityTypography.titleMedium
        _ = TrinityTypography.callout
        _ = TrinityTypography.footnote
        _ = TrinityTypography.caption2
        _ = TrinityTypography.caption2Emphasis
        _ = TrinityTypography.captionBold
        _ = TrinityTypography.unitLabel
        _ = TrinityTypography.unitLabelSmall
        _ = TrinityTypography.navigationLargeTitle
    }

    @Test("Display and title weights differ from their emphasis variants")
    func weightVariantsAreDistinct() {
        #expect(TrinityTypography.titleLarge != TrinityTypography.titleLargeEmphasis)
        #expect(TrinityTypography.caption2 != TrinityTypography.caption2Emphasis)
        #expect(TrinityTypography.callout != TrinityTypography.body)
        #expect(TrinityTypography.footnote != TrinityTypography.caption)
    }
}
