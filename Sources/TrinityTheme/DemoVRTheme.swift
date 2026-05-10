import SwiftUI

#if canImport(UIKit)
/// Demo theme matching VeloReady's brand palette. Used by the Gallery app for
/// theme switching. VR's real `VRTheme` lives in the VeloReady repo.
public struct DemoVRTheme: Theme {

    public init() {}

    // Surfaces — aligned with TC palette
    public var cardBackground: Color {
        adaptive(
            light: Color(.secondarySystemGroupedBackground),
            dark: Color(red: 0.075, green: 0.075, blue: 0.075)
        )
    }
    public var surfaceElevated: Color {
        adaptive(
            light: Color(.tertiarySystemGroupedBackground),
            dark: Color(red: 0.078, green: 0.078, blue: 0.078)
        )
    }
    public var backgroundTertiary: Color {
        adaptive(
            light: Color(.tertiarySystemGroupedBackground),
            dark: Color(red: 0.141, green: 0.141, blue: 0.141)
        )
    }

    // Text
    public var labelPrimary: Color {
        adaptive(light: Color(.label), dark: Color(red: 0.941, green: 0.941, blue: 0.941))
    }
    public var labelSecondary: Color {
        adaptive(
            light: Color(red: 0.30, green: 0.30, blue: 0.30),
            dark: Color(red: 0.627, green: 0.627, blue: 0.627)
        )
    }
    public var labelTertiary: Color { labelSecondary }
    public var labelMuted: Color {
        adaptive(
            light: Color(red: 0.45, green: 0.45, blue: 0.45),
            dark: Color(red: 0.400, green: 0.400, blue: 0.400)
        )
    }
    public var labelOnFill: Color { .white }

    // Borders
    public var borderSubtle: Color {
        adaptive(
            light: Color(.separator).opacity(0.5),
            dark: Color(red: 0.165, green: 0.165, blue: 0.165)
        )
    }
    public var divider: Color {
        adaptive(light: Color(.separator), dark: Color(red: 0.165, green: 0.165, blue: 0.165))
    }

    // Brand — VR teal accent
    public var accent: Color { Color(red: 0.051, green: 0.580, blue: 0.533) } // teal #0D9488
    public var accentSubtle: Color { accent.opacity(0.12) }
    public var insightAccent: Color { Color(red: 0.545, green: 0.361, blue: 0.969) }
    public var insightAccentSubtle: Color { insightAccent.opacity(0.15) }

    // Categories
    public func categoryColor(_ category: TrinityCategoryToken) -> Color {
        switch category {
        case .ride:        return Color(red: 0.976, green: 0.451, blue: 0.086) // orange
        case .recovery:    return Color(red: 0.133, green: 0.773, blue: 0.369) // emerald
        case .strain:      return Color(red: 0.957, green: 0.247, blue: 0.369) // rose
        case .readiness:   return accent
        case .heart:       return Color(red: 0.957, green: 0.247, blue: 0.369)
        case .sleep:       return Color(red: 0.051, green: 0.580, blue: 0.533)
        case .activity, .wellness: return Color(red: 0.133, green: 0.773, blue: 0.369)
        case .mindfulness, .appointments: return Color(red: 0.133, green: 0.827, blue: 0.933)
        case .doses, .sideEffects, .bloodWork, .session, .volume, .fatigue:
            return accent
        }
    }
    public func categorySubtle(_ category: TrinityCategoryToken) -> Color {
        categoryColor(category).opacity(0.15)
    }

    // Charts
    public var chartPrimary: Color { accent }
    public var chartSecondary: Color { categoryColor(.ride) }
    public var chartGrid: Color {
        adaptive(
            light: Color(.separator).opacity(0.5),
            dark: Color(red: 0.165, green: 0.165, blue: 0.165)
        )
    }
    public var chartAxis: Color {
        adaptive(
            light: Color(.tertiaryLabel),
            dark: Color(red: 0.400, green: 0.400, blue: 0.400)
        )
    }

    private func adaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        dark
        #endif
    }
}
#endif // canImport(UIKit)
