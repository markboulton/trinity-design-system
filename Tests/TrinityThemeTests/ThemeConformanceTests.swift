import Testing
import SwiftUI
@testable import TrinityTheme

@Suite("Theme protocol")
struct ThemeConformanceTests {

    private struct StubTheme: Theme {
        var cardBackground: Color { .gray }
        var surfaceElevated: Color { .gray }
        var backgroundTertiary: Color { .gray }
        var labelPrimary: Color { .black }
        var labelSecondary: Color { .gray }
        var labelTertiary: Color { .gray }
        var labelMuted: Color { .gray }
        var labelOnFill: Color { .white }
        var borderSubtle: Color { .gray }
        var divider: Color { .gray }
        var accent: Color { .blue }
        var accentSubtle: Color { .blue.opacity(0.15) }
        var insightAccent: Color { .purple }
        var insightAccentSubtle: Color { .purple.opacity(0.15) }
        var chartPrimary: Color { .blue }
        var chartSecondary: Color { .orange }
        var chartGrid: Color { .gray }
        var chartAxis: Color { .gray }
        func categoryColor(_ category: TrinityCategoryToken) -> Color { .red }
        func categorySubtle(_ category: TrinityCategoryToken) -> Color { .red.opacity(0.15) }
    }

    @Test("Theme protocol can be implemented by a consumer")
    func conformance() {
        let theme: any Theme = StubTheme()
        #expect(theme.accent == .blue)
        #expect(theme.labelOnFill == .white)
        #expect(theme.categoryColor(.heart) == .red)
    }

    @Test("Theme protocol handles all category tokens without crashing")
    func allCategoryTokens() {
        let theme: any Theme = StubTheme()
        for token in TrinityCategoryToken.allCases {
            _ = theme.categoryColor(token)
            _ = theme.categorySubtle(token)
        }
    }
}
