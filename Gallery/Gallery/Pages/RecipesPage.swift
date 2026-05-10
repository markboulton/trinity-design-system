import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct RecipesPage: View {
    var body: some View {
        List {
            NavigationLink("Today header", destination: TodayHeaderRecipe())
            NavigationLink("Settings list section", destination: SettingsRecipe())
            NavigationLink("Detail page hero", destination: DetailHeroRecipe())
        }
        .navigationTitle("Recipes")
    }
}

private struct TodayHeaderRecipe: View {
    @Environment(\.theme) private var theme
    var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.sm) {
            Text("Today")
                .font(TrinityTypography.navigationLargeTitle)
                .foregroundStyle(theme.labelPrimary)
            Text("Sunday, 10 May")
                .font(TrinityTypography.subheadline)
                .foregroundStyle(theme.labelSecondary)
            Spacer()
        }
        .trinityScreen()
        .navigationTitle("Today header")
    }
}

private struct SettingsRecipe: View {
    @Environment(\.theme) private var theme
    var body: some View {
        TrinitySection("Account") {
            TrinityCard {
                VStack(spacing: 0) {
                    TrinityMetricRow(label: "Protocol", value: "TRT")
                        .padding(TrinitySpacing.cardPadding)
                    Divider()
                    TrinityMetricRow(label: "Dose", value: "100", unit: "mg/week")
                        .padding(TrinitySpacing.cardPadding)
                }
            }
        }
        .trinityScreen()
        .navigationTitle("Settings")
    }
}

private struct DetailHeroRecipe: View {
    @Environment(\.theme) private var theme
    var body: some View {
        VStack(alignment: .leading, spacing: TrinitySpacing.md) {
            Text("Recovery").font(TrinityTypography.titleLarge).foregroundStyle(theme.labelPrimary)
            Text("82").font(TrinityTypography.numericLarge).foregroundStyle(theme.accent)
            Text("Above your 30-day average").font(TrinityTypography.subheadline).foregroundStyle(theme.labelSecondary)
            Spacer()
        }
        .trinityScreen()
        .navigationTitle("Detail")
    }
}
