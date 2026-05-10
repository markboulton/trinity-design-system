import CoreGraphics

/// Corner radius tokens.
///
/// `card` and `button` are referenced from `TrinitySpacing` for backward
/// compatibility with the spacing-derived semantic aliases. Use these tokens
/// directly when you don't want to reach through Spacing.
public enum TrinityRadii {
    public static let card: CGFloat = 10
    public static let button: CGFloat = 8
    public static let pill: CGFloat = 999  // fully rounded
    public static let sheet: CGFloat = 16
}
