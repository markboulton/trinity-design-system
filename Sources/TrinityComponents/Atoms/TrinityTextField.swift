import SwiftUI
import TrinityTokens
import TrinityTheme

/// Apple Health-style labeled text field with optional error message.
///
/// Shows a label above the field, a rounded input area, and an inline error
/// message below when `errorMessage` is non-nil.
///
/// Usage:
/// ```swift
/// TrinityTextField(label: "Name", text: $name, placeholder: "Enter name…")
/// TrinityTextField(label: "Dosage", text: $dosage, placeholder: "e.g. 150",
///                  errorMessage: "Dosage is required")
/// ```
public struct TrinityTextField: View {

    @Environment(\.theme) private var theme

    public let label: String
    @Binding public var text: String
    public let placeholder: String
    public let errorMessage: String?

    public init(
        label: String,
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: String? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.errorMessage = errorMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            Text(label)
                .font(TrinityTypography.headline)
                .foregroundStyle(theme.labelPrimary)

            TextField(placeholder, text: $text)
                .font(TrinityTypography.body)
                .padding(.horizontal, TrinitySpacing.md)
                .padding(.vertical, TrinitySpacing.sm + 2)
                .background(
                    RoundedRectangle(cornerRadius: TrinityRadii.button)
                        .fill(theme.backgroundTertiary)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: TrinityRadii.button)
                        .strokeBorder(
                            errorMessage != nil ? TrinityStatusColors.error : theme.borderSubtle,
                            lineWidth: 1
                        )
                )
                .accessibilityLabel(label)

            if let errorMessage {
                Text(errorMessage)
                    .font(TrinityTypography.captionSmall)
                    .foregroundStyle(TrinityStatusColors.error)
            }
        }
    }
}

#if canImport(UIKit)
#Preview("Text fields") {
    VStack(spacing: TrinitySpacing.lg) {
        TrinityTextField(
            label: "Medication Name",
            text: .constant("Testosterone Cypionate"),
            placeholder: "Enter name…"
        )
        TrinityTextField(
            label: "Dosage (mg)",
            text: .constant(""),
            placeholder: "e.g. 150",
            errorMessage: "Dosage is required"
        )
    }
    .padding(TrinitySpacing.lg)
    .theme(DemoTRTTheme())
}
#endif
