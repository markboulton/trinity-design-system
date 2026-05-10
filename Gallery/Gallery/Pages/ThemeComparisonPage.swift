import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct ThemeComparisonPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                Text("Same components, three themes")
                    .font(TrinityTypography.titleMedium)

                comparisonRow(title: "Primary button") {
                    TrinityButton("Connect", icon: "link", style: .primary) {}
                }
                comparisonRow(title: "Secondary button") {
                    TrinityButton("Edit", icon: "pencil", style: .secondary) {}
                }
                comparisonRow(title: "Tertiary button") {
                    TrinityButton("Refresh", icon: "arrow.clockwise", style: .tertiary) {}
                }
                comparisonRow(title: "Progress ring") {
                    TrinityProgressRing(value: 0.72, centreLabel: "72", captionLabel: "SCORE")
                }
                comparisonRow(title: "Badge") {
                    TrinityBadge(text: "Pro", size: .small)
                }
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Theme Comparison")
    }

    @ViewBuilder
    private func comparisonRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            Text(title).font(TrinityTypography.subheadlineEmphasis)
            HStack(alignment: .top, spacing: TrinitySpacing.md) {
                themedColumn("TRT", theme: DemoTRTTheme(), content: content)
                themedColumn("VR",  theme: DemoVRTheme(),  content: content)
                themedColumn("GR",  theme: DemoGRTheme(),  content: content)
            }
        }
    }

    @ViewBuilder
    private func themedColumn<Content: View>(
        _ label: String,
        theme: any Theme,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.xs) {
            Text(label).font(TrinityTypography.caption)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .theme(theme)
    }
}
