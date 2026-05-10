import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct AtomsPage: View {

    @State private var filterSelection: String = "Week"
    @State private var chipOn: Bool = false
    @State private var chipSeverity: Int = 1
    @State private var fieldText: String = ""

    private let filterOptions = ["Day", "Week", "Month"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                buttonSection
                badgeSection
                segmentedFilterSection
                progressSection
                toggleChipSection
                textFieldSection
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Atoms")
    }

    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityButton").font(TrinityTypography.titleMedium)
            TrinityButton("Primary", icon: "plus", style: .primary) {}
            TrinityButton("Secondary", icon: "pencil", style: .secondary) {}
            TrinityButton("Destructive", icon: "trash", style: .destructive) {}
            TrinityButton("Loading", style: .primary, isLoading: true) {}
            TrinityButton("Disabled", style: .primary, isDisabled: true) {}
            HStack {
                TrinityButton("Edit", icon: "pencil", style: .tertiary) {}
                TrinityButton("Refresh", icon: "arrow.clockwise", style: .tertiary) {}
                Spacer()
            }
        }
    }

    private var badgeSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityBadge").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.sm) {
                TrinityBadge(text: "Trinity Pro", size: .regular)
                TrinityBadge(text: "Pro", size: .small)
            }
        }
    }

    private var segmentedFilterSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinitySegmentedFilter").font(TrinityTypography.titleMedium)
            TrinitySegmentedFilter(
                selection: $filterSelection,
                options: filterOptions,
                label: { $0 }
            )
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityProgressRing").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.xl) {
                TrinityProgressRing(value: 0.72, centreLabel: "72", captionLabel: "STEPS")
                TrinityProgressRing(value: 0.45, tint: TrinityStatusColors.warning, centreLabel: "45", captionLabel: "HRV")
                TrinityProgressRing(value: 0.9, tint: TrinityStatusColors.success, centreLabel: "90", captionLabel: "SLEEP")
            }
            Text("TrinityProgressBar").font(TrinityTypography.titleMedium)
            TrinityProgressBar(currentStep: 3, totalSteps: 5)
        }
    }

    private var toggleChipSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityToggleChip").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.sm) {
                TrinityToggleChip(label: "Acne", isOn: $chipOn, severity: $chipSeverity)
                TrinityToggleChip(label: "Fatigue", isOn: .constant(true), severity: .constant(2))
                TrinityToggleChip(label: "Insomnia", isOn: .constant(false))
            }
        }
    }

    private var textFieldSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityTextField").font(TrinityTypography.titleMedium)
            TrinityTextField(label: "Dosage (mg)", text: $fieldText, placeholder: "e.g. 150")
            TrinityTextField(label: "Name", text: .constant(""), placeholder: "Enter name…", errorMessage: "Name is required")
        }
    }
}
