import SwiftUI

/// Typography tokens — Inter Variable (UI text) + IBM Plex Mono (numeric data).
///
/// Apps must register both font families in their Info.plist and bundle the
/// .ttf files in their app target. Font files ship separately per app to keep
/// the package free of binary assets:
///   - `InterVariable.ttf`        — all UI chrome (labels, body, headings)
///   - `IBMPlexMono-Regular.ttf`  — numeric / metric data
///   - `IBMPlexMono-Medium.ttf`
///   - `IBMPlexMono-Bold.ttf`
public enum TrinityTypography {

    // MARK: - Font Family

    /// Inter Variable — family name used by all UI-text token roles. Apps register this font.
    public static let fontFamily = "InterVariable"

    /// IBM Plex Mono — PostScript names used by all numeric / metric / chart token roles.
    /// IBM Plex Mono is not a variable font; each weight is a separately registered face.
    public static let monoRegular = "IBMPlexMono-Regular"
    public static let monoMedium = "IBMPlexMono-Medium"
    public static let monoBold = "IBMPlexMono-Bold"

    // MARK: - Display

    public static let displayLarge = Font.custom(fontFamily, size: 34, relativeTo: .largeTitle).weight(.regular)
    public static let displayMedium = Font.custom(fontFamily, size: 28, relativeTo: .title).weight(.regular)

    // MARK: - Title

    public static let titleLarge = Font.custom(fontFamily, size: 22, relativeTo: .title2).weight(.regular)
    public static let titleMedium = Font.custom(fontFamily, size: 20, relativeTo: .title3).weight(.regular)
    public static let titleSmall = Font.custom(fontFamily, size: 17, relativeTo: .headline).weight(.semibold)

    // MARK: - Headline / Body

    public static let headline = Font.custom(fontFamily, size: 17, relativeTo: .headline).weight(.semibold)
    public static let body = Font.custom(fontFamily, size: 17, relativeTo: .body).weight(.regular)
    public static let bodyEmphasis = Font.custom(fontFamily, size: 17, relativeTo: .body).weight(.semibold)

    // MARK: - Subheadline / Caption

    public static let subheadline = Font.custom(fontFamily, size: 15, relativeTo: .subheadline).weight(.regular)
    public static let subheadlineEmphasis = Font.custom(fontFamily, size: 15, relativeTo: .subheadline).weight(.semibold)
    public static let caption = Font.custom(fontFamily, size: 13, relativeTo: .caption).weight(.regular)
    public static let captionEmphasis = Font.custom(fontFamily, size: 13, relativeTo: .caption).weight(.semibold)
    public static let captionSmall = Font.custom(fontFamily, size: 11, relativeTo: .caption2).weight(.regular)
    public static let captionSmallEmphasis = Font.custom(fontFamily, size: 11, relativeTo: .caption2).weight(.semibold)

    // MARK: - Numeric (IBM Plex Mono — all data values)

    /// 34pt IBM Plex Mono Bold — primary numeric display in compound cards.
    public static let numericLarge = Font.custom(monoBold, size: 34, relativeTo: .title)
    /// 24pt IBM Plex Mono Medium — secondary numeric display.
    public static let numericMedium = Font.custom(monoMedium, size: 24, relativeTo: .title2)
    /// 17pt IBM Plex Mono Medium — inline numeric values.
    public static let numericSmall = Font.custom(monoMedium, size: 17, relativeTo: .body)
    /// 14pt IBM Plex Mono Medium — small numeric labels.
    public static let numericCaption = Font.custom(monoMedium, size: 14, relativeTo: .footnote)

    /// 34pt IBM Plex Mono Bold — alias of `numericLarge` for metric-card hero values.
    public static let metricLarge = numericLarge

    // MARK: - Hero Metrics (IBM Plex Mono — dominant single-value display)

    /// 42pt IBM Plex Mono Medium — compound-card hero metric.
    public static let heroMetric = Font.custom(monoMedium, size: 42, relativeTo: .largeTitle)
    /// 48pt IBM Plex Mono Bold — full-screen hero value.
    public static let heroNumeric = Font.custom(monoBold, size: 48, relativeTo: .largeTitle)
    /// 40pt IBM Plex Mono Bold — compact hero variant.
    public static let heroNumericSmall = Font.custom(monoBold, size: 40, relativeTo: .largeTitle)

    // MARK: - Chart (IBM Plex Mono)

    /// 12pt IBM Plex Mono Regular — chart axis labels.
    public static let chartLabel = Font.custom(monoRegular, size: 12, relativeTo: .caption2)
    /// 14pt IBM Plex Mono Medium — chart value annotations.
    public static let chartValue = Font.custom(monoMedium, size: 14, relativeTo: .footnote)

    /// 11pt IBM Plex Mono Medium — ALL-CAPS section eyebrow label. Pair with `sectionEyebrowTracking`.
    public static let sectionLabel = Font.custom(monoMedium, size: 11, relativeTo: .caption2)

    // MARK: - Navigation

    public static let navigationLargeTitle = Font.custom(fontFamily, size: 28, relativeTo: .title).weight(.regular)
    public static let navigationTitle = Font.custom(fontFamily, size: 17, relativeTo: .headline).weight(.regular)

    // MARK: - Letter Spacing

    /// Tracking applied to ALL-CAPS section eyebrow labels.
    public static let sectionEyebrowTracking: CGFloat = 1.4
}
