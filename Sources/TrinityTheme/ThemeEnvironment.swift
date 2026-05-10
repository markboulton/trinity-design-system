import SwiftUI

/// EnvironmentKey for the active Theme.
///
/// Defaults to a fatal-trap stub so a missing `.theme(...)` modifier at the app
/// root surfaces immediately rather than silently rendering with neutral colours.
public struct ThemeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: any Theme = MissingThemeSentinel()
}

public extension EnvironmentValues {
    var theme: any Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the Trinity Theme for this view hierarchy.
    /// Apply once at the app root: `ContentView().theme(VRTheme())`.
    func theme(_ theme: any Theme) -> some View {
        environment(\.theme, theme)
    }
}

/// Sentinel theme used as the EnvironmentKey default. Crashes loudly if read,
/// signalling that the app forgot to set `.theme(...)` at its root.
private struct MissingThemeSentinel: Theme {
    private func trap(_ token: String) -> Color {
        assertionFailure("Trinity Theme not set. Apply `.theme(MyTheme())` at the app root before reading \(token).")
        return Color.red
    }

    var cardBackground: Color { trap("cardBackground") }
    var surfaceElevated: Color { trap("surfaceElevated") }
    var backgroundTertiary: Color { trap("backgroundTertiary") }
    var labelPrimary: Color { trap("labelPrimary") }
    var labelSecondary: Color { trap("labelSecondary") }
    var labelTertiary: Color { trap("labelTertiary") }
    var labelMuted: Color { trap("labelMuted") }
    var labelOnFill: Color { trap("labelOnFill") }
    var borderSubtle: Color { trap("borderSubtle") }
    var divider: Color { trap("divider") }
    var accent: Color { trap("accent") }
    var accentSubtle: Color { trap("accentSubtle") }
    var insightAccent: Color { trap("insightAccent") }
    var insightAccentSubtle: Color { trap("insightAccentSubtle") }
    var chartPrimary: Color { trap("chartPrimary") }
    var chartSecondary: Color { trap("chartSecondary") }
    var chartGrid: Color { trap("chartGrid") }
    var chartAxis: Color { trap("chartAxis") }
    func categoryColor(_ category: TrinityCategoryToken) -> Color { trap("categoryColor(.\(category.rawValue))") }
    func categorySubtle(_ category: TrinityCategoryToken) -> Color { trap("categorySubtle(.\(category.rawValue))") }
}
