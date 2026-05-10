import SwiftUI
import TrinityTokens
import TrinityTheme

/// Pill-shaped toggle for tagging side effects or conditions.
///
/// When active, severity pills appear inline to the right with no layout shift.
/// Severity levels map to wellness status colours (mild/moderate/severe).
///
/// Usage:
/// ```swift
/// TrinityToggleChip(label: "Acne", isOn: $isOn, severity: $severity)
/// TrinityToggleChip(label: "Night Sweats", isOn: $isNightSweats)
/// ```
public struct TrinityToggleChip: View {

    @Environment(\.theme) private var theme

    public let label: String
    @Binding public var isOn: Bool
    @Binding public var severity: Int

    public init(
        label: String,
        isOn: Binding<Bool>,
        severity: Binding<Int> = .constant(1)
    ) {
        self.label = label
        self._isOn = isOn
        self._severity = severity
    }

    public var body: some View {
        HStack(spacing: TrinitySpacing.sm) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isOn.toggle()
                    if !isOn { severity = 1 }
                }
            } label: {
                Text(label)
                    .font(TrinityTypography.subheadline)
                    .foregroundStyle(isOn ? theme.labelOnFill : theme.labelPrimary)
                    .padding(.horizontal, TrinitySpacing.md)
                    .padding(.vertical, TrinitySpacing.sm)
                    .frame(minHeight: 36)
                    .background(
                        RoundedRectangle(cornerRadius: TrinitySpacing.buttonCornerRadius)
                            .fill(isOn ? severityColor : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: TrinitySpacing.buttonCornerRadius)
                            .strokeBorder(
                                isOn ? severityColor : theme.borderSubtle,
                                lineWidth: 1
                            )
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(label): \(isOn ? "active" : "inactive")")

            if isOn {
                HStack(spacing: TrinitySpacing.xs) {
                    ForEach(1...3, id: \.self) { level in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                severity = level
                            }
                        } label: {
                            Text(severityLabel(level))
                                .font(TrinityTypography.caption)
                                .foregroundStyle(severity == level ? theme.labelOnFill : theme.labelSecondary)
                                .padding(.horizontal, TrinitySpacing.sm)
                                .padding(.vertical, TrinitySpacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: TrinitySpacing.xs)
                                        .fill(severity == level ? severityColorForLevel(level) : theme.surfaceElevated)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
    }

    private var severityColor: Color {
        severityColorForLevel(severity)
    }

    private func severityColorForLevel(_ level: Int) -> Color {
        switch level {
        case 1: TrinityStatusColors.warning
        case 2: TrinityStatusColors.wellnessAmber
        case 3: TrinityStatusColors.wellnessRed
        default: theme.borderSubtle
        }
    }

    private func severityLabel(_ level: Int) -> String {
        switch level {
        case 1: "Mild"
        case 2: "Moderate"
        case 3: "Severe"
        default: ""
        }
    }
}

#if canImport(UIKit)
#Preview("Toggle chips") {
    VStack(alignment: .leading, spacing: TrinitySpacing.lg) {
        TrinityToggleChip(label: "Acne", isOn: .constant(true), severity: .constant(2))
        TrinityToggleChip(label: "Night Sweats", isOn: .constant(false))
        TrinityToggleChip(label: "Water Retention", isOn: .constant(true), severity: .constant(1))
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
