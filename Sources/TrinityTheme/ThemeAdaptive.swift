#if canImport(UIKit)
import SwiftUI

extension Theme {
    /// Returns a colour that resolves differently in light and dark mode.
    func adaptive(light: Color, dark: Color) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
#endif
