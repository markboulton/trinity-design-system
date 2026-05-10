import SwiftUI
import TrinityTokens
import TrinityTheme

/// Withings-style compound card: a hero metric with a generic trailing content
/// slot (sparkline, progress ring, or any custom view), followed by a stacked
/// list of supplementary metric rows separated by hairlines.
///
/// Usage:
/// ```swift
/// // Hero only
/// TrinityCompoundMetricCard(label: "Wellness Score", value: "4.2", unit: "/5")
///
/// // Hero + progress ring + rows
/// TrinityCompoundMetricCard(
///     label: "Steps", value: "7,234",
///     rows: [
///         .init(label: "Distance", value: "5.1", unit: "km"),
///         .init(label: "Calories", value: "312", unit: "kcal")
///     ]
/// ) {
///     TrinityProgressRing(value: 0.72, centreLabel: "72%", captionLabel: "GOAL")
/// }
/// ```
public struct TrinityCompoundMetricCard<Trailing: View, BottomContent: View>: View {

    // MARK: - Types

    public struct Row: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: String
        public let unit: String?

        public init(label: String, value: String, unit: String? = nil) {
            self.label = label
            self.value = value
            self.unit = unit
        }
    }

    // MARK: - Properties

    @Environment(\.theme) private var theme

    public let label: String
    public let value: String
    public let unit: String?
    /// When set, renders a relative date caption below the hero value.
    public let lastUpdated: Date?
    /// When set, the card becomes tappable and shows a trailing chevron.
    public let onTap: (() -> Void)?
    public let rows: [Row]
    @ViewBuilder public let trailingContent: () -> Trailing
    @ViewBuilder public let bottomContent: () -> BottomContent

    // MARK: - Init

    public init(
        label: String,
        value: String,
        unit: String? = nil,
        lastUpdated: Date? = nil,
        onTap: (() -> Void)? = nil,
        rows: [Row] = [],
        @ViewBuilder trailingContent: @escaping () -> Trailing,
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.label = label
        self.value = value
        self.unit = unit
        self.lastUpdated = lastUpdated
        self.onTap = onTap
        self.rows = rows
        self.trailingContent = trailingContent
        self.bottomContent = bottomContent
    }

    // MARK: - Body

    public var body: some View {
        let cardContent = VStack(spacing: 0) {
            heroBlock
                .padding(TrinitySpacing.cardPadding)

            if !rows.isEmpty {
                Divider()

                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    rowView(row)
                        .padding(.horizontal, TrinitySpacing.cardPadding)
                        .padding(.vertical, TrinitySpacing.md)

                    if index < rows.count - 1 {
                        Divider()
                    }
                }
            }

            bottomContentBlock
        }
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: TrinitySpacing.cardCornerRadius))

        if let onTap {
            Button(action: onTap) { cardContent }
                .buttonStyle(.plain)
        } else {
            cardContent
        }
    }

    // MARK: - Bottom content block

    @ViewBuilder
    private var bottomContentBlock: some View {
        if BottomContent.self != EmptyView.self {
            Divider()
            bottomContent()
                .padding(.horizontal, TrinitySpacing.cardPadding)
                .padding(.vertical, TrinitySpacing.md)
        }
    }

    // MARK: - Private views

    private var heroBlock: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            // Header row: eyebrow label left, date + chevron right
            HStack(alignment: .center, spacing: TrinitySpacing.sm) {
                Text(label)
                    .font(TrinityTypography.captionSmallEmphasis)
                    .textCase(.uppercase)
                    .tracking(TrinityTypography.sectionEyebrowTracking)
                    .foregroundStyle(theme.labelSecondary)

                Spacer()

                if let date = lastUpdated {
                    Text(relativeDateText(date))
                        .font(TrinityTypography.caption)
                        .foregroundStyle(theme.labelSecondary)
                }
                if onTap != nil {
                    Image(systemName: TrinityIcons.chevronRight)
                        .frame(width: TrinityIcons.Size.small, height: TrinityIcons.Size.small)
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(theme.labelTertiary)
                }
            }

            // Body row: hero value left, trailing content right
            HStack(alignment: .center, spacing: TrinitySpacing.md) {
                HStack(alignment: .firstTextBaseline, spacing: TrinitySpacing.xxs) {
                    Text(value)
                        .font(TrinityTypography.numericLarge)
                        .foregroundStyle(theme.labelPrimary)

                    if let unit {
                        Text(unit)
                            .font(TrinityTypography.subheadline)
                            .foregroundStyle(theme.labelSecondary)
                    }
                }

                Spacer()

                trailingContent()
            }
        }
    }

    private func rowView(_ row: Row) -> some View {
        HStack {
            Text(row.label)
                .font(TrinityTypography.subheadline)
                .foregroundStyle(theme.labelSecondary)

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: TrinitySpacing.xxs) {
                Text(row.value)
                    .font(TrinityTypography.numericSmall)
                    .foregroundStyle(theme.labelPrimary)

                if let unit = row.unit {
                    Text(unit)
                        .font(TrinityTypography.caption)
                        .foregroundStyle(theme.labelSecondary)
                }
            }
        }
    }

    // MARK: - Helpers

    private func relativeDateText(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Trailing-only init (no bottomContent)

extension TrinityCompoundMetricCard where BottomContent == EmptyView {
    public init(
        label: String,
        value: String,
        unit: String? = nil,
        lastUpdated: Date? = nil,
        onTap: (() -> Void)? = nil,
        rows: [Row] = [],
        @ViewBuilder trailingContent: @escaping () -> Trailing
    ) {
        self.init(
            label: label,
            value: value,
            unit: unit,
            lastUpdated: lastUpdated,
            onTap: onTap,
            rows: rows,
            trailingContent: trailingContent,
            bottomContent: { EmptyView() }
        )
    }
}

// MARK: - No trailing content init

extension TrinityCompoundMetricCard where Trailing == EmptyView, BottomContent == EmptyView {
    public init(
        label: String,
        value: String,
        unit: String? = nil,
        lastUpdated: Date? = nil,
        onTap: (() -> Void)? = nil,
        rows: [Row] = []
    ) {
        self.init(
            label: label,
            value: value,
            unit: unit,
            lastUpdated: lastUpdated,
            onTap: onTap,
            rows: rows,
            trailingContent: { EmptyView() },
            bottomContent: { EmptyView() }
        )
    }
}

// MARK: - Previews

#if canImport(UIKit)
#Preview("Hero only") {
    TrinityCompoundMetricCard(
        label: "Wellness Score",
        value: "4.2",
        unit: "/5"
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("With date & detail link") {
    TrinityCompoundMetricCard(
        label: "Steps",
        value: "3,509",
        lastUpdated: Date(),
        onTap: {},
        rows: [
            .init(label: "Active minutes", value: "21", unit: "min"),
            .init(label: "Distance", value: "2.8", unit: "km")
        ]
    ) {
        TrinityProgressRing(value: 0.35, centreLabel: "35%", captionLabel: "GOAL")
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Hero + ring + rows") {
    TrinityCompoundMetricCard(
        label: "Steps",
        value: "7,234",
        rows: [
            .init(label: "Distance", value: "5.1", unit: "km"),
            .init(label: "Calories", value: "312", unit: "kcal"),
            .init(label: "Active minutes", value: "38", unit: "min")
        ]
    ) {
        TrinityProgressRing(value: 0.72, centreLabel: "72%", captionLabel: "GOAL")
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}

#Preview("Hero + rows, no trailing") {
    TrinityCompoundMetricCard(
        label: "Next Injection",
        value: "2",
        unit: "days",
        rows: [
            .init(label: "Medication", value: "Test Cyp"),
            .init(label: "Dose", value: "75", unit: "mg"),
            .init(label: "Site", value: "Left Quad")
        ]
    )
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
