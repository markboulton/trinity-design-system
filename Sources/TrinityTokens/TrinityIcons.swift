import CoreGraphics
import Foundation

/// SF Symbol name constants used across Trinity components.
///
/// String constants rather than `Image` instances so consumers can choose
/// rendering mode (`.symbolRenderingMode`, hierarchical, multicolor) per use.
public enum TrinityIcons {

    // MARK: - Sizes (point sizes for SF Symbols inside Trinity components)

    public enum Size {
        public static let small: CGFloat = 13
        public static let medium: CGFloat = 17
        public static let large: CGFloat = 22
        public static let xlarge: CGFloat = 28
    }

    // MARK: - Navigation

    public static let chevronRight = "chevron.right"
    public static let chevronDown = "chevron.down"
    public static let chevronUp = "chevron.up"
    public static let xmark = "xmark"
    public static let arrowClockwise = "arrow.clockwise"

    // MARK: - Status

    public static let checkmark = "checkmark"
    public static let checkmarkCircle = "checkmark.circle.fill"
    public static let exclamationTriangle = "exclamationmark.triangle.fill"
    public static let infoCircle = "info.circle"

    // MARK: - Health

    public static let heart = "heart.fill"
    public static let bed = "bed.double.fill"
    public static let bolt = "bolt.fill"
    public static let figure = "figure.run"
    public static let flame = "flame.fill"
    public static let lungs = "lungs.fill"

    // MARK: - Actions

    public static let plus = "plus"
    public static let pencil = "pencil"
    public static let trash = "trash"
    public static let ellipsis = "ellipsis"
    public static let gear = "gearshape"
    public static let link = "link"

    // MARK: - Sync / Connectivity

    public static let cloud = "cloud.fill"
    public static let arrowTriangle2Circlepath = "arrow.triangle.2.circlepath"
    public static let wifi = "wifi"

    // MARK: - Empty State

    public static let trayFull = "tray.fill"
    public static let questionMarkCircle = "questionmark.circle"
}
