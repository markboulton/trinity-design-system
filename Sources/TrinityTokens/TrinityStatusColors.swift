import SwiftUI

/// Status and wellness colour tokens that are universal across all Trinity-consuming apps.
///
/// Per-app brand colours (accent, category palettes) live in the `Theme` protocol —
/// these are static because they have the same meaning everywhere.
public enum TrinityStatusColors {

    // MARK: - Status (success, warning, error)

    /// Emerald green — successful syncs, confirmations, in-range markers.
    public static let success = Color(red: 0.133, green: 0.773, blue: 0.369) // #22c55e

    /// Amber — warnings, attention required.
    public static let warning = Color(red: 0.851, green: 0.467, blue: 0.024) // #d97706

    /// Red — errors, destructive confirmations, out-of-range markers.
    public static let error = Color(red: 0.863, green: 0.149, blue: 0.149) // #dc2626

    // MARK: - Wellness RAG Scale

    /// Aligned with `success`. Use when the value being indicated is "good / on track".
    public static let wellnessGreen = success

    /// Aligned with `warning`. Use for "caution / borderline".
    public static let wellnessAmber = warning

    /// Aligned with `error`. Use for "concerning / off track".
    public static let wellnessRed = error

    // MARK: - Marker Range (desaturated — distinct from RAG status)

    /// Muted sage — used for in-range blood markers and similar non-status indicators.
    public static let markerInRange = Color(red: 0.42, green: 0.72, blue: 0.55)

    /// Muted coral — used for out-of-range blood markers.
    public static let markerOutOfRange = Color(red: 0.85, green: 0.45, blue: 0.42)
}
