import SwiftUI

/// Shared brand colours that are not theme-variant.
///
/// These are accent/gradient colours used across all Trinity apps,
/// distinct from per-app Theme colours which live in the Theme protocol.
public enum TrinityBrandColors {
    /// Gradient start — muted violet.
    public static let gradientStart = Color(red: 0.55, green: 0.36, blue: 0.75)
    /// Gradient mid — muted rose.
    public static let gradientMid   = Color(red: 0.72, green: 0.38, blue: 0.55)
    /// Gradient end — muted amber.
    public static let gradientEnd   = Color(red: 0.82, green: 0.55, blue: 0.32)
}
