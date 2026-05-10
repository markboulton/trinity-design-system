import SwiftUI
import TrinityTokens
import TrinityTheme

/// Consolidated detail-page surface used by metric and insight detail views.
///
/// Combines: title block, optional filter row, hero chart slot, optional
/// supplementary content, narrative, evidence rows, deep-link button, share
/// sheet trigger, and disclaimer footer. Wrap in a `NavigationStack` or push
/// via `NavigationLink`.
///
/// Usage:
/// ```swift
/// TrinityDetailPage(
///     title: "Heart Rate",
///     subtitle: "Resting average: 58 bpm",
///     chart: { MyLineChart(data: data) },
///     narrative: "Your resting HR has trended down over the past 4 weeks.",
///     evidence: [.init(label: "Sample size", value: "28 days")],
///     disclaimer: "Data read from Apple Health. Not for clinical use."
/// )
/// ```
public struct TrinityDetailPage<ChartContent: View, FilterContent: View, SupplementaryContent: View>: View {

    // MARK: - Types

    public struct Row: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }

    public struct DeepLink {
        public let label: String
        public let destination: AnyView

        public init(label: String, destination: AnyView) {
            self.label = label
            self.destination = destination
        }
    }

    // MARK: - Properties

    @Environment(\.theme) private var theme

    public let title: String
    public let subtitle: String?
    @ViewBuilder public let filter: () -> FilterContent
    @ViewBuilder public let chart: () -> ChartContent
    @ViewBuilder public let supplementary: () -> SupplementaryContent
    public let narrativeTitle: String?
    public let narrative: String?
    public let evidence: [Row]
    public let deepLink: DeepLink?
    public let shareItem: String?
    public let disclaimer: String?

    // MARK: - Init

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder filter: @escaping () -> FilterContent,
        @ViewBuilder chart: @escaping () -> ChartContent,
        @ViewBuilder supplementary: @escaping () -> SupplementaryContent,
        narrativeTitle: String? = nil,
        narrative: String? = nil,
        evidence: [Row] = [],
        deepLink: DeepLink? = nil,
        shareItem: String? = nil,
        disclaimer: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.filter = filter
        self.chart = chart
        self.supplementary = supplementary
        self.narrativeTitle = narrativeTitle
        self.narrative = narrative
        self.evidence = evidence
        self.deepLink = deepLink
        self.shareItem = shareItem
        self.disclaimer = disclaimer
    }

    /// No-filter, no-supplementary convenience init.
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder chart: @escaping () -> ChartContent,
        narrativeTitle: String? = nil,
        narrative: String? = nil,
        evidence: [Row] = [],
        deepLink: DeepLink? = nil,
        shareItem: String? = nil,
        disclaimer: String? = nil
    ) where FilterContent == EmptyView, SupplementaryContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            filter: { EmptyView() },
            chart: chart,
            supplementary: { EmptyView() },
            narrativeTitle: narrativeTitle,
            narrative: narrative,
            evidence: evidence,
            deepLink: deepLink,
            shareItem: shareItem,
            disclaimer: disclaimer
        )
    }

    /// No-supplementary convenience init.
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder filter: @escaping () -> FilterContent,
        @ViewBuilder chart: @escaping () -> ChartContent,
        narrativeTitle: String? = nil,
        narrative: String? = nil,
        evidence: [Row] = [],
        deepLink: DeepLink? = nil,
        shareItem: String? = nil,
        disclaimer: String? = nil
    ) where SupplementaryContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            filter: filter,
            chart: chart,
            supplementary: { EmptyView() },
            narrativeTitle: narrativeTitle,
            narrative: narrative,
            evidence: evidence,
            deepLink: deepLink,
            shareItem: shareItem,
            disclaimer: disclaimer
        )
    }

    /// No-filter convenience init.
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder chart: @escaping () -> ChartContent,
        @ViewBuilder supplementary: @escaping () -> SupplementaryContent,
        narrativeTitle: String? = nil,
        narrative: String? = nil,
        evidence: [Row] = [],
        deepLink: DeepLink? = nil,
        shareItem: String? = nil,
        disclaimer: String? = nil
    ) where FilterContent == EmptyView {
        self.init(
            title: title,
            subtitle: subtitle,
            filter: { EmptyView() },
            chart: chart,
            supplementary: supplementary,
            narrativeTitle: narrativeTitle,
            narrative: narrative,
            evidence: evidence,
            deepLink: deepLink,
            shareItem: shareItem,
            disclaimer: disclaimer
        )
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.lg) {
                titleBlock
                filter()
                chart()
                    .frame(height: 240)
                supplementary()
                if let narrative {
                    narrativeBlock(text: narrative)
                }
                if !evidence.isEmpty {
                    evidenceBlock
                }
                if let deepLink {
                    deepLinkButton(deepLink)
                }
                if let shareItem {
                    ShareLink(item: shareItem) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
                if let disclaimer {
                    disclaimerBlock(text: disclaimer)
                }
            }
            .padding(TrinitySpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        #if canImport(UIKit)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Private views

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xxs) {
            Text(title)
                .font(TrinityTypography.titleMedium)
                .foregroundStyle(theme.labelPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(theme.labelPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func narrativeBlock(text: String) -> some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            Text(narrativeTitle ?? "Why we think this")
                .font(TrinityTypography.captionSmallEmphasis)
                .textCase(.uppercase)
                .tracking(TrinityTypography.sectionEyebrowTracking)
                .foregroundStyle(theme.labelSecondary)
            Text(text)
                .font(TrinityTypography.body)
                .foregroundStyle(theme.labelPrimary)
        }
    }

    private var evidenceBlock: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            Text("Evidence")
                .font(TrinityTypography.captionSmallEmphasis)
                .textCase(.uppercase)
                .tracking(TrinityTypography.sectionEyebrowTracking)
                .foregroundStyle(theme.labelSecondary)
            ForEach(evidence) { row in
                HStack {
                    Text(row.label)
                        .foregroundStyle(theme.labelPrimary)
                    Spacer()
                    Text(row.value)
                        .foregroundStyle(theme.labelSecondary)
                }
                .font(TrinityTypography.subheadline)
            }
        }
    }

    private func deepLinkButton(_ link: DeepLink) -> some View {
        NavigationLink {
            link.destination
        } label: {
            HStack {
                Text(link.label)
                Spacer()
                Image(systemName: TrinityIcons.chevronRight)
                    .frame(width: TrinityIcons.Size.small, height: TrinityIcons.Size.small)
            }
            .padding(TrinitySpacing.cardPadding)
            .frame(maxWidth: .infinity)
            .background(theme.accentSubtle)
            .clipShape(RoundedRectangle(cornerRadius: TrinityRadii.card))
        }
        .buttonStyle(.plain)
    }

    private func disclaimerBlock(text: String) -> some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xxs) {
            Text("About this data")
                .font(TrinityTypography.captionSmallEmphasis)
                .textCase(.uppercase)
                .tracking(TrinityTypography.sectionEyebrowTracking)
                .foregroundStyle(theme.labelSecondary)
            Text(text)
                .font(TrinityTypography.caption)
                .foregroundStyle(theme.labelSecondary)
        }
        .padding(.top, TrinitySpacing.md)
    }
}

// MARK: - Previews

#if canImport(UIKit)
#Preview("Detail page") {
    NavigationStack {
        TrinityDetailPage(
            title: "Heart Rate",
            subtitle: "7-day resting average: 58 bpm",
            chart: {
                RoundedRectangle(cornerRadius: TrinityRadii.card)
                    .fill(Color.gray.opacity(TrinityOpacity.tonalFill))
            },
            narrativeTitle: "What this means",
            narrative: "Your resting heart rate has trended downward over the past 4 weeks, suggesting improved cardiovascular fitness.",
            evidence: [
                .init(label: "Sample size", value: "28 days"),
                .init(label: "Lowest reading", value: "52 bpm"),
                .init(label: "7-day avg", value: "58 bpm")
            ],
            disclaimer: "Data read from Apple Health. Not for clinical use."
        )
        .navigationTitle("Heart Rate")
    }
    .theme(DemoTRTTheme())
}
#endif
