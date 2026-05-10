import SwiftUI
import TrinityTokens
import TrinityTheme

/// Pill-shaped segmented filter for time-range / scope toggles.
///
/// Active state: soft accent fill + accent text.
/// Inactive state: transparent + secondary label.
///
/// Usage:
/// ```swift
/// enum Range: String, CaseIterable { case day = "Day", week = "Week", month = "Month" }
/// @State private var selection: Range = .week
/// TrinitySegmentedFilter(selection: $selection, options: Range.allCases) { $0.rawValue }
/// ```
public struct TrinitySegmentedFilter<Option: Hashable>: View {

    @Environment(\.theme) private var theme

    @Binding public var selection: Option
    public let options: [Option]
    public let label: (Option) -> String

    public init(
        selection: Binding<Option>,
        options: [Option],
        label: @escaping (Option) -> String
    ) {
        self._selection = selection
        self.options = options
        self.label = label
    }

    public var body: some View {
        HStack(spacing: TrinitySpacing.xs) {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Text(label(option))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .font(
                            selection == option
                                ? TrinityTypography.subheadlineEmphasis
                                : TrinityTypography.subheadline
                        )
                        .foregroundStyle(
                            selection == option
                                ? theme.accent
                                : theme.labelSecondary
                        )
                        .padding(.horizontal, TrinitySpacing.lg)
                        .padding(.vertical, TrinitySpacing.xs)
                        .background(
                            Capsule()
                                .fill(
                                    selection == option
                                        ? theme.accentSubtle
                                        : Color.clear
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(TrinitySpacing.xs)
        .background(
            Capsule()
                .fill(theme.backgroundTertiary)
        )
    }
}

#if canImport(UIKit)
private struct _TrinitySegmentedFilterPreview: View {
    @State private var selection: String
    private let options = ["Day", "Week", "Month"]

    init(initial: String) {
        _selection = State(initialValue: initial)
    }

    var body: some View {
        TrinitySegmentedFilter(selection: $selection, options: options) { $0 }
            .padding(TrinitySpacing.lg)
            .theme(DemoTRTTheme())
    }
}

#Preview("Day active") {
    _TrinitySegmentedFilterPreview(initial: "Day")
}

#Preview("Week active") {
    _TrinitySegmentedFilterPreview(initial: "Week")
}

#Preview("Month active") {
    _TrinitySegmentedFilterPreview(initial: "Month")
}
#endif
