import SwiftUI
import TrinityTokens
import TrinityTheme

/// Horizontal row of 7 circular day toggles (Mon–Sun). Stores the selected
/// days as `Set<Int>` using the `Calendar.component(.weekday:)` numbering
/// convention — 1=Sun, 2=Mon, … 7=Sat.
///
/// Used for selecting recurring weekdays in schedules and protocol configuration.
public struct TrinityWeekdayPicker: View {

    @Environment(\.theme) private var theme

    @Binding public var selection: Set<Int>

    // Apple Health order: Mon–Sun (weekday numbers 2–7, then 1)
    private let weekdays: [(Int, String)] = [
        (2, "M"), (3, "T"), (4, "W"), (5, "T"), (6, "F"), (7, "S"), (1, "S")
    ]

    private static let daySize: CGFloat = 36

    public init(selection: Binding<Set<Int>>) {
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: TrinitySpacing.sm) {
            ForEach(weekdays, id: \.0) { day, label in
                Button {
                    if selection.contains(day) { selection.remove(day) }
                    else { selection.insert(day) }
                } label: {
                    Text(label)
                        .font(TrinityTypography.captionEmphasis)
                        .foregroundStyle(
                            selection.contains(day) ? theme.labelOnFill : theme.labelPrimary
                        )
                        .frame(width: Self.daySize, height: Self.daySize)
                        .background(
                            Circle()
                                .fill(
                                    selection.contains(day)
                                        ? theme.accent
                                        : theme.surfaceElevated
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if canImport(UIKit)
#Preview("Empty selection") {
    struct Wrapper: View {
        @State private var days: Set<Int> = []
        var body: some View {
            TrinityWeekdayPicker(selection: $days)
                .padding()
                .theme(DemoTRTTheme())
        }
    }
    return Wrapper()
}

#Preview("Tue / Fri selected") {
    struct Wrapper: View {
        @State private var days: Set<Int> = [3, 6]
        var body: some View {
            TrinityWeekdayPicker(selection: $days)
                .padding()
                .theme(DemoTRTTheme())
        }
    }
    return Wrapper()
}
#endif
