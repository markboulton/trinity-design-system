import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct AtomsPage: View {

    @Environment(\.theme) var theme

    @State private var filterSelection: String = "Week"
    @State private var chipOn: Bool = false
    @State private var chipSeverity: Int = 1
    @State private var fieldText: String = ""
    @State private var scaleValue: Int = 3
    @State private var invertedScaleValue: Int = 2
    @State private var weekdaySelection: Set<Int> = [3, 6]

    private let filterOptions = ["Day", "Week", "Month"]
    private let sampleLine: [Double] = [240, 242, 245, 243, 248, 246, 250, 248]
    private let sampleBars: [Double] = [3200, 5100, 4800, 6200, 7100, 3900, 5500, 6800]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TrinitySpacing.sectionSpacing) {
                buttonSection
                badgeSection
                statusBadgeSection
                segmentedFilterSection
                progressSection
                openArcGaugeSection
                toggleChipSection
                scaleSelectorSection
                textFieldSection
                pulseLoaderSection
                lineSparklineSection
                barSparklineSection
                skeletonSection
                flowLayoutSection
                dateNavigatorSection
                healthKitSyncSection
                weekdayPickerSection
            }
            .padding(TrinitySpacing.sectionPadding)
        }
        .navigationTitle("Atoms")
    }

    private var openArcGaugeSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityOpenArcGauge").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.xl) {
                TrinityOpenArcGauge(value: 84, minValue: 0, maxValue: 100, label: "Readiness",
                                    displayText: "84", tint: TrinityStatusColors.success, baseline: 90)
                TrinityOpenArcGauge(value: 268, minValue: 150, maxValue: 350, label: "Fitness",
                                    displayText: "268", unit: "W")
            }
        }
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

    private var statusBadgeSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityStatusBadge").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.sm) {
                TrinityStatusBadge("OPTIMAL", style: .success)
                TrinityStatusBadge("HIGH", style: .warning)
                TrinityStatusBadge("POOR", style: .error)
            }
            HStack(spacing: TrinitySpacing.sm) {
                TrinityStatusBadge("SYNCED", style: .success, weight: .subtle)
                TrinityStatusBadge("INFO", style: .info, weight: .subtle)
                TrinityStatusBadge("NEW", style: .info, icon: "sparkles")
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
            Text("TrinityStepBar").font(TrinityTypography.titleMedium)
            TrinityStepBar(totalSteps: 6, completedSteps: 3)
            TrinityStepBar(totalSteps: 7, completedSteps: 4)
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

    private var pulseLoaderSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityPulseLoader").font(TrinityTypography.titleMedium)
            HStack(spacing: TrinitySpacing.lg) {
                TrinityPulseLoader(size: 60)
                TrinityPulseLoader(size: 80)
                TrinityPulseLoader(size: 100)
            }
            .padding(TrinitySpacing.cardPadding)
        }
    }

    private var lineSparklineSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityLineSparkline").font(TrinityTypography.titleMedium)
            TrinityLineSparkline(values: sampleLine, tint: theme.accent)
                .frame(width: 200, height: 48)
        }
    }

    private var barSparklineSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityBarSparkline").font(TrinityTypography.titleMedium)
            TrinityBarSparkline(values: sampleBars, tint: theme.accent)
                .frame(width: 200, height: 48)
        }
    }

    private var skeletonSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinitySkeletonView").font(TrinityTypography.titleMedium)
            TrinitySkeletonView(height: 60)
            TrinitySkeletonView(height: 100)
            TrinitySkeletonView(height: 40, cornerRadius: 4)
        }
    }

    private var scaleSelectorSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityScaleSelector").font(TrinityTypography.titleMedium)
            TrinityScaleSelector(label: "Energy", value: $scaleValue)
            TrinityScaleSelector(label: "Sleep", value: $scaleValue, sourceLabel: "From Apple Watch")
            TrinityScaleSelector(label: "Anxiety", value: $invertedScaleValue, isInverted: true)
        }
    }

    private var dateNavigatorSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityDateNavigator").font(TrinityTypography.titleMedium)
            TrinityDateNavigator(
                title: "April 2026",
                canGoBack: true,
                canGoForward: false,
                onBack: {},
                onForward: {}
            )
            TrinityDateNavigator(
                title: "Week 18",
                canGoBack: true,
                canGoForward: true,
                onBack: {},
                onForward: {}
            )
        }
    }

    private var healthKitSyncSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityHealthKitSyncIndicator").font(TrinityTypography.titleMedium)
            TrinityHealthKitSyncIndicator(state: .syncing("Syncing HealthKit"))
            TrinityHealthKitSyncIndicator(state: .synced(nil), isAnalysing: true)
            TrinityHealthKitSyncIndicator(state: .synced(Date(timeIntervalSinceNow: -120)))
        }
    }

    private var weekdayPickerSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityWeekdayPicker").font(TrinityTypography.titleMedium)
            TrinityWeekdayPicker(selection: $weekdaySelection)
        }
    }

    private var flowLayoutSection: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("TrinityFlowLayout").font(TrinityTypography.titleMedium)
            TrinityFlowLayout(spacing: TrinitySpacing.xs) {
                ForEach(["Push", "Pull", "Legs", "Core", "Conditioning", "Full Body", "Cardio", "Mobility"], id: \.self) { tag in
                    Text(tag)
                        .font(TrinityTypography.captionEmphasis)
                        .padding(.horizontal, TrinitySpacing.sm)
                        .padding(.vertical, TrinitySpacing.xs)
                        .background(theme.accentSubtle)
                        .clipShape(Capsule())
                }
            }
        }
    }
}
