import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public extension Color {

    /// A colour that resolves to `light` or `dark` depending on the active
    /// interface style.
    ///
    /// Use for tokens that need a different value in each mode — e.g. status
    /// colours that must stay legible on both a near-white and a near-black
    /// background. A single fixed value cannot satisfy both: what reads as a
    /// clean orange on white turns muddy/brown, and what glows correctly on
    /// black looks washed-out on white.
    ///
    /// On platforms without UIKit (e.g. a macOS `swift build` host) the
    /// `light` value is returned — adaptive resolution is an iOS concern and
    /// the host build only needs the symbol to exist.
    static func adaptive(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        return light
        #endif
    }
}
