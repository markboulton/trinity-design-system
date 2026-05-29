import SwiftUI
import TrinityTokens

/// The single point of variation between Trinity-consuming apps.
///
/// Each app supplies one concrete `Theme` at app boot via `View.theme(_:)`
/// (see `ThemeEnvironment.swift`). Components reach for `@Environment(\.theme)`
/// rather than referencing colour values directly.
///
/// Tokens that are NOT in this protocol (spacing, typography, icons, status
/// colours, opacity, radii) are static and identical across all apps.
public protocol Theme {

    // MARK: - Surfaces

    var cardBackground: Color { get }
    var surfaceElevated: Color { get }
    var backgroundTertiary: Color { get }

    // MARK: - Text

    var labelPrimary: Color { get }
    var labelSecondary: Color { get }
    var labelTertiary: Color { get }
    var labelMuted: Color { get }
    var labelOnFill: Color { get }

    // MARK: - Borders & Dividers

    var borderSubtle: Color { get }
    var divider: Color { get }

    // MARK: - Brand

    var accent: Color { get }
    var accentSubtle: Color { get }
    var insightAccent: Color { get }
    var insightAccentSubtle: Color { get }

    // MARK: - Categories

    func categoryColor(_ category: TrinityCategoryToken) -> Color
    func categorySubtle(_ category: TrinityCategoryToken) -> Color

    // MARK: - Charts

    var chartPrimary: Color { get }
    var chartSecondary: Color { get }
    var chartGrid: Color { get }
    var chartAxis: Color { get }

    // MARK: - Typography overrides

    /// Font for the hero value in `TrinityCompoundMetricCard`. Defaults to
    /// `TrinityTypography.numericLarge` (34pt IBM Plex Mono Bold). Apps may override
    /// the weight or typeface of metric-card hero numbers without forking the
    /// component — e.g. TRT Companion overrides this to Inter Medium.
    var metricValueFont: Font { get }
}

public extension Theme {
    /// Default keeps the historic bold mono hero, so existing consumers
    /// (GymReady, VeloReady, Meso) are unchanged unless they opt in.
    var metricValueFont: Font { TrinityTypography.numericLarge }
}
