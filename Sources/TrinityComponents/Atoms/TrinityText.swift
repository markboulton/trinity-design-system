import SwiftUI
import TrinityTokens
import TrinityTheme

/// Atomic text component — use for all text to ensure consistency.
///
/// All styles map to `TrinityTypography` tokens and use `theme` colours
/// via `@Environment(\.theme)`. Pass an explicit `color` to override.
///
/// Usage:
/// ```swift
/// TrinityText("Recovery", style: .headline)
/// TrinityText("section eyebrow", style: .sectionEyebrow)
/// TrinityText("Custom", style: .body, color: theme.accent)
/// ```
public struct TrinityText: View {

    @Environment(\.theme) private var theme

    public enum Style {
        case displayLarge
        case displayMedium
        case navigationLargeTitle
        case titleLarge
        case titleLargeEmphasis
        case titleMedium
        case titleSmall
        case headline
        case body
        case bodyEmphasis
        case subheadline
        case subheadlineEmphasis
        case caption
        case captionEmphasis
        case caption2
        case captionSmall
        case captionSmallEmphasis
        case numericLarge
        case numericMedium
        case numericSmall
        /// IBM-style eyebrow: caption, uppercase, letter-spaced — for section labels.
        case sectionEyebrow

        var font: Font {
            switch self {
            case .displayLarge:         return TrinityTypography.displayLarge
            case .displayMedium:        return TrinityTypography.displayMedium
            case .navigationLargeTitle: return TrinityTypography.navigationLargeTitle
            case .titleLarge:           return TrinityTypography.titleLarge
            case .titleLargeEmphasis:   return TrinityTypography.titleLargeEmphasis
            case .titleMedium:          return TrinityTypography.titleMedium
            case .titleSmall:           return TrinityTypography.titleSmall
            case .headline:             return TrinityTypography.headline
            case .body:                 return TrinityTypography.body
            case .bodyEmphasis:         return TrinityTypography.bodyEmphasis
            case .subheadline:          return TrinityTypography.subheadline
            case .subheadlineEmphasis:  return TrinityTypography.subheadlineEmphasis
            case .caption:              return TrinityTypography.caption
            case .captionEmphasis:      return TrinityTypography.captionEmphasis
            case .caption2:             return TrinityTypography.caption2
            case .captionSmall:         return TrinityTypography.captionSmall
            case .captionSmallEmphasis: return TrinityTypography.captionSmallEmphasis
            case .numericLarge:         return TrinityTypography.numericLarge
            case .numericMedium:        return TrinityTypography.numericMedium
            case .numericSmall:         return TrinityTypography.numericSmall
            case .sectionEyebrow:       return TrinityTypography.captionSmallEmphasis
            }
        }

        var textCase: Text.Case? {
            self == .sectionEyebrow ? .uppercase : nil
        }

        var tracking: CGFloat {
            self == .sectionEyebrow ? TrinityTypography.sectionEyebrowTracking : 0
        }
    }

    public let text: String
    public let style: Style
    public let color: Color?

    public init(_ text: String, style: Style = .body, color: Color? = nil) {
        self.text = text
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(style.font)
            .tracking(style.tracking)
            .textCase(style.textCase)
            .foregroundStyle(color ?? defaultColor)
    }

    private var defaultColor: Color {
        switch style {
        case .caption, .captionEmphasis, .caption2, .captionSmall, .captionSmallEmphasis,
             .subheadline, .subheadlineEmphasis:
            return theme.labelSecondary
        case .sectionEyebrow:
            return theme.labelMuted
        default:
            return theme.labelPrimary
        }
    }
}

#if canImport(UIKit)
#Preview("All Styles") {
    ScrollView {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            TrinityText("Display Large", style: .displayLarge)
            TrinityText("Display Medium", style: .displayMedium)
            TrinityText("Title Large", style: .titleLarge)
            TrinityText("Title Medium", style: .titleMedium)
            TrinityText("Title Small", style: .titleSmall)
            TrinityText("Headline", style: .headline)
            TrinityText("Body Text", style: .body)
            TrinityText("Body Emphasis", style: .bodyEmphasis)
            TrinityText("Subheadline", style: .subheadline)
            TrinityText("Subheadline Emphasis", style: .subheadlineEmphasis)
            TrinityText("Caption", style: .caption)
            TrinityText("Caption Emphasis", style: .captionEmphasis)
            TrinityText("Caption Small", style: .captionSmall)
            TrinityText("Caption Small Emphasis", style: .captionSmallEmphasis)
            TrinityText("1,234", style: .numericLarge)
            TrinityText("1,234", style: .numericMedium)
            TrinityText("1,234", style: .numericSmall)
            TrinityText("section eyebrow", style: .sectionEyebrow)
        }
        .padding(TrinitySpacing.lg)
    }
    .theme(DemoTRTTheme())
}
#endif
