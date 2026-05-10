import SwiftUI

/// Typography tokens — Inter Variable font ramp.
///
/// Apps must register the Inter Variable font in their Info.plist and
/// bundle the .ttf in their app target. The font file ships separately
/// per app to keep the package free of binary assets.
public enum TrinityTypography {

    // MARK: - Font Family

    /// Font family name used by all token roles. Apps register this font.
    public static let fontFamily = "InterVariable"

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

    // MARK: - Numeric (tabular figures for metrics)

    public static let numericLarge = Font.custom(fontFamily, size: 34, relativeTo: .largeTitle)
        .weight(.regular)
        .monospacedDigit()
    public static let numericMedium = Font.custom(fontFamily, size: 22, relativeTo: .title2)
        .weight(.regular)
        .monospacedDigit()
    public static let numericSmall = Font.custom(fontFamily, size: 17, relativeTo: .body)
        .weight(.regular)
        .monospacedDigit()

    // MARK: - Navigation

    public static let navigationLargeTitle = Font.custom(fontFamily, size: 28, relativeTo: .largeTitle).weight(.regular)
    public static let navigationTitle = Font.custom(fontFamily, size: 17, relativeTo: .headline).weight(.regular)
}
