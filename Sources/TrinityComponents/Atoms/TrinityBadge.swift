import SwiftUI
import TrinityTokens
import TrinityTheme

/// Gradient-bordered badge for subscription or branding prompts.
///
/// A subtle warm gradient (muted violet → rose → amber) is used for the
/// text fill and border. Available in `.small` (inline row use) and
/// `.regular` (feature gates and prompts).
///
/// Usage:
/// ```swift
/// TrinityBadge(text: "Pro", size: .small)
/// TrinityBadge(text: "Trinity Pro", size: .regular)
/// ```
public struct TrinityBadge: View {

    /// The brand gradient used for badge borders and text fills.
    public static let brandGradient = LinearGradient(
        colors: [
            TrinityBrandColors.gradientStart,
            TrinityBrandColors.gradientMid,
            TrinityBrandColors.gradientEnd,
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    public enum Size {
        /// For inline use in list rows.
        case small
        /// For feature gates and prompts.
        case regular
    }

    public let text: String
    public let size: Size

    public init(text: String, size: Size = .regular) {
        self.text = text
        self.size = size
    }

    private var font: Font {
        switch size {
        case .small:   return TrinityTypography.captionSmallEmphasis
        case .regular: return TrinityTypography.captionEmphasis
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small:   return TrinitySpacing.sm
        case .regular: return TrinitySpacing.md
        }
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .small:   return TrinitySpacing.xxs
        case .regular: return TrinitySpacing.xs
        }
    }

    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(Self.brandGradient)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                Capsule()
                    .strokeBorder(Self.brandGradient, lineWidth: TrinityBorderWidth.medium)
            )
    }
}

#if canImport(UIKit)
#Preview("TrinityBadge — both sizes") {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityBadge(text: "Pro", size: .small)
        TrinityBadge(text: "Trinity Pro", size: .regular)
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
