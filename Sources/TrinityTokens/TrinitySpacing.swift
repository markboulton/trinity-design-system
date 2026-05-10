import CoreGraphics

/// Spacing tokens for Trinity design system.
///
/// Base units form a 4pt scale with semantic aliases on top. Apple Health rhythm
/// drives the card stack values (12pt between cards, 16pt internal padding).
public enum TrinitySpacing {

    // MARK: - Base Units

    public static let hairline: CGFloat = 2
    public static let xxs: CGFloat = 6
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 20
    public static let xxl: CGFloat = 24
    public static let huge: CGFloat = 32

    /// Minimum tap target (Apple HIG).
    public static let touch: CGFloat = 44

    // MARK: - Semantic Aliases

    /// Internal padding inside a card — 16pt (Apple Health standard).
    public static let cardPadding: CGFloat = lg

    /// Vertical spacing between stacked cards — 12pt (Apple Health rhythm).
    public static let cardSpacing: CGFloat = md

    /// Vertical spacing between major sections — 20pt.
    public static let sectionSpacing: CGFloat = xl

    /// Horizontal padding applied at the screen edge — 20pt.
    public static let sectionPadding: CGFloat = xl

    /// Spacing inside card content blocks — 12pt.
    public static let cardContentSpacing: CGFloat = md

    /// Card corner radius.
    public static let cardCornerRadius: CGFloat = 10

    /// Button / input corner radius.
    public static let buttonCornerRadius: CGFloat = 8
}
