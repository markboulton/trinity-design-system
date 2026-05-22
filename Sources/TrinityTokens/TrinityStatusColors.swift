import SwiftUI

/// Status and wellness colour tokens that are universal across all Trinity-consuming apps.
///
/// Per-app brand colours (accent, category palettes) live in the `Theme` protocol —
/// these are static because they have the same meaning everywhere.
///
/// The RAG scale (`success` / `caution` / `warning` / `error`) is **adaptive**:
/// each resolves to a separate light-mode and dark-mode value via `Color.adaptive`,
/// so it stays legible on both white and near-black backgrounds. A single fixed
/// value cannot do both — a colour tuned for dark mode reads muddy on white.
public enum TrinityStatusColors {

    // MARK: - RAG status scale (4-step, adaptive light/dark)

    /// Green — "good / on track / optimal". Successful syncs, confirmations, in-range markers.
    public static let success = Color.adaptive(
        light: Color(red: 0.086, green: 0.608, blue: 0.431),  // #169B6E
        dark:  Color(red: 0.204, green: 0.847, blue: 0.627)   // #34D8A0
    )

    /// Yellow — "caution / borderline". The fourth RAG step, between `success`
    /// and `warning`. Used by 4-step wellness scales (e.g. recovery/sleep/strain
    /// bands: optimal → good → fair → poor).
    public static let caution = Color.adaptive(
        light: Color(red: 0.914, green: 0.725, blue: 0.173),  // #E9B92C
        dark:  Color(red: 0.961, green: 0.808, blue: 0.235)   // #F5CE3C
    )

    /// Amber — "warning / attention required".
    public static let warning = Color.adaptive(
        light: Color(red: 0.929, green: 0.616, blue: 0.286),  // #ED9D49
        dark:  Color(red: 0.973, green: 0.557, blue: 0.282)   // #F88E48
    )

    /// Red — "error / concerning / off track". Destructive confirmations, out-of-range markers.
    public static let error = Color.adaptive(
        light: Color(red: 0.867, green: 0.286, blue: 0.251),  // #DD4940
        dark:  Color(red: 0.961, green: 0.396, blue: 0.376)   // #F56560
    )

    // MARK: - Wellness RAG aliases

    /// Aligned with `success`. Use when the value being indicated is "good / on track".
    public static let wellnessGreen = success

    /// Aligned with `caution`. Use for "borderline / watch".
    public static let wellnessYellow = caution

    /// Aligned with `warning`. Use for "caution / attention required".
    public static let wellnessAmber = warning

    /// Aligned with `error`. Use for "concerning / off track".
    public static let wellnessRed = error

    // MARK: - Marker Range (desaturated — distinct from RAG status)

    /// Muted sage — used for in-range blood markers and similar non-status indicators.
    public static let markerInRange = Color(red: 0.42, green: 0.72, blue: 0.55)

    /// Muted coral — used for out-of-range blood markers.
    public static let markerOutOfRange = Color(red: 0.85, green: 0.45, blue: 0.42)
}
