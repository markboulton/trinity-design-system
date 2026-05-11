import SwiftUI
import TrinityTokens
import TrinityTheme

public struct TrinityFlowLayout: Layout {
    public var spacing: CGFloat

    public init(spacing: CGFloat = TrinitySpacing.sm) {
        self.spacing = spacing
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        for (index, row) in rows.enumerated() {
            let rowHeight = row.map(\.size.height).max() ?? 0
            let rowWidth = row.reduce(0) { $0 + $1.size.width }
                + CGFloat(max(row.count - 1, 0)) * spacing
            totalHeight += rowHeight
            if index < rows.count - 1 { totalHeight += spacing }
            maxWidth = max(maxWidth, rowWidth)
        }
        return CGSize(width: maxWidth, height: totalHeight)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map(\.size.height).max() ?? 0
            for item in row {
                item.view.place(
                    at: CGPoint(x: x, y: y),
                    anchor: .topLeading,
                    proposal: .unspecified
                )
                x += item.size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private struct RowItem {
        let view: LayoutSubview
        let size: CGSize
    }

    private func computeRows(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> [[RowItem]] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [[RowItem]] = []
        var currentRow: [RowItem] = []
        var rowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let needed = currentRow.isEmpty ? size.width : rowWidth + spacing + size.width
            if needed > maxWidth && !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = []
                rowWidth = 0
            }
            currentRow.append(RowItem(view: subview, size: size))
            rowWidth = currentRow.count == 1 ? size.width : rowWidth + spacing + size.width
        }
        if !currentRow.isEmpty { rows.append(currentRow) }
        return rows
    }
}

#if canImport(UIKit)
#Preview {
    let tags = ["Push", "Pull", "Legs", "Core", "Conditioning", "Full Body", "Cardio", "Mobility"]
    TrinityFlowLayout(spacing: TrinitySpacing.xs) {
        ForEach(tags, id: \.self) { tag in
            Text(tag)
                .font(TrinityTypography.captionEmphasis)
                .padding(.horizontal, TrinitySpacing.sm)
                .padding(.vertical, TrinitySpacing.xs)
                .background(DemoTRTTheme().accentSubtle)
                .clipShape(Capsule())
        }
    }
    .padding(TrinitySpacing.sectionPadding)
    .theme(DemoTRTTheme())
}
#endif
