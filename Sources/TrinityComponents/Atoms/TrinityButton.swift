import SwiftUI
import TrinityTokens
import TrinityTheme

/// Primary button atom with primary, secondary, destructive, and tertiary variants.
///
/// `.tertiary` is for inline row actions (Edit, Refresh) — tonal accent fill,
/// compact padding, intrinsic width (no full-width fill).
public struct TrinityButton: View {

    public enum Style {
        case primary
        case secondary
        case destructive
        case tertiary
    }

    public let label: String
    public let icon: String?
    public let style: Style
    public let isLoading: Bool
    public let isDisabled: Bool
    public let action: () -> Void

    public init(
        _ label: String,
        icon: String? = nil,
        style: Style = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            TrinityButtonLabel(label, icon: icon, style: style, isLoading: isLoading)
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? TrinityOpacity.disabled : 1.0)
        .accessibilityLabel(label)
    }
}

/// Visual button label without a `Button` wrapper. Use inside `NavigationLink`
/// labels where nesting a `Button` inside a `NavigationLink` would create
/// conflicting tap targets.
public struct TrinityButtonLabel: View {

    @Environment(\.theme) private var theme

    public let label: String
    public let icon: String?
    public let style: TrinityButton.Style
    public let isLoading: Bool

    public init(
        _ label: String,
        icon: String? = nil,
        style: TrinityButton.Style = .primary,
        isLoading: Bool = false
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
    }

    public var body: some View {
        if style == .tertiary {
            tertiaryBody
        } else {
            standardBody
        }
    }

    private var tertiaryBody: some View {
        HStack(spacing: TrinitySpacing.xs) {
            if isLoading {
                ProgressView()
                    .controlSize(.mini)
                    .tint(theme.accent)
            } else if let icon {
                Image(systemName: icon)
                    .font(TrinityTypography.captionSmallEmphasis)
            }
            Text(label).font(TrinityTypography.subheadlineEmphasis)
        }
        .foregroundStyle(theme.accent)
        .padding(.horizontal, 10) // intentional intermediate — no 10pt token yet
        .padding(.vertical, TrinitySpacing.xs)
        .background(
            RoundedRectangle(cornerRadius: TrinitySpacing.buttonCornerRadius)
                .fill(theme.accentSubtle)
        )
    }

    private var standardBody: some View {
        HStack(spacing: TrinitySpacing.sm) {
            if isLoading {
                ProgressView()
                    .controlSize(.small)
                    .tint(foregroundColor)
            } else if let icon {
                Image(systemName: icon)
                    .font(TrinityTypography.subheadline)
            }
            Text(label).font(TrinityTypography.headline)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: TrinitySpacing.touch)
        .foregroundStyle(foregroundColor)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: TrinitySpacing.buttonCornerRadius))
        .overlay(borderOverlay)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary, .destructive: return theme.labelOnFill
        case .secondary, .tertiary:  return theme.accent
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:     theme.accent
        case .secondary:   Color.clear
        case .destructive: TrinityStatusColors.error
        case .tertiary:    Color.clear
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .secondary:
            RoundedRectangle(cornerRadius: TrinitySpacing.buttonCornerRadius)
                .strokeBorder(theme.accent, lineWidth: 1.5)
        default:
            EmptyView()
        }
    }
}

#if canImport(UIKit)
#Preview("All styles — TRT") {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityButton("Connect Strava", icon: "link", style: .primary) {}
        TrinityButton("Edit Profile", icon: "pencil", style: .secondary) {}
        TrinityButton("Remove Account", icon: "trash", style: .destructive) {}
        TrinityButton("Loading…", style: .primary, isLoading: true) {}
        TrinityButton("Disabled", style: .primary, isDisabled: true) {}
        HStack {
            TrinityButton("Edit", icon: "pencil", style: .tertiary) {}
            TrinityButton("Refresh", icon: "arrow.clockwise", style: .tertiary) {}
            Spacer()
        }
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
