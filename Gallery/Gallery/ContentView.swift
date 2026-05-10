import SwiftUI
import TrinityComponents
import TrinityTheme

struct ContentView: View {

    @Binding var selectedTheme: GalleryApp.ThemeOption

    var body: some View {
        NavigationStack {
            List {
                Section("Tokens") {
                    NavigationLink("Tokens", destination: TokensPage())
                }
                Section("Components") {
                    NavigationLink("Atoms", destination: AtomsPage())
                    NavigationLink("Molecules", destination: MoleculesPage())
                    NavigationLink("Organisms", destination: OrganismsPage())
                }
                Section("Quality") {
                    NavigationLink("Theme Comparison", destination: ThemeComparisonPage())
                    NavigationLink("Recipes", destination: RecipesPage())
                }
            }
            .navigationTitle("Trinity Gallery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(GalleryApp.ThemeOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}
