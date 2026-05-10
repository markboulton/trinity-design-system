# Checklist: scaffolding a new screen

Use this when the user asks for a new screen in any Trinity-consuming app.

## Before writing code

- [ ] Confirm: is this a primary screen (tab destination) or a detail screen (pushed/presented)?
- [ ] Confirm: does it need pull-to-refresh?
- [ ] Confirm: what data does it show? List, single object, or a hybrid?
- [ ] Confirm: empty state — what's the user supposed to do if there's no data?
- [ ] Confirm: error state — what's the user supposed to do if loading fails?

## Skeleton template (apply to all new screens)

```swift
import SwiftUI
import TrinityComponents
import TrinityTokens
import TrinityTheme

struct NewScreenView: View {

    @Environment(\.theme) private var theme
    @StateObject private var viewModel = NewScreenViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                NewScreenSkeleton()
            case .loaded(let data):
                content(data: data)
            case .empty:
                TrinityEmptyState(
                    icon: TrinityIcons.trayFull,
                    title: "No data",
                    description: "Description here",
                    primaryAction: nil,
                    secondaryAction: nil
                )
            case .error(let error):
                TrinityErrorState(
                    title: "Couldn't load",
                    description: error.localizedDescription,
                    retryAction: { Task { await viewModel.refresh() } },
                    secondaryAction: nil
                )
            }
        }
        .trinityScreen(refreshable: { await viewModel.refresh() })
        .navigationTitle("New Screen")
    }

    private func content(data: NewScreenData) -> some View {
        TrinityCardStack {
            // Cards here
        }
    }
}
```

## Verify

- [ ] No hardcoded `.padding(.horizontal, ...)` — uses `trinityScreen()`
- [ ] No `VStack(spacing:)` for cards — uses `TrinityCardStack`
- [ ] Empty state uses `TrinityEmptyState` (not inline text)
- [ ] Error state uses `TrinityErrorState` (not toast or inline red text)
- [ ] All colours come from `theme.x` or `TrinityStatusColors.x`
- [ ] All typography comes from `TrinityTypography.x`
- [ ] Pull-to-refresh wired via `trinityScreen(refreshable:)` if applicable
- [ ] Single parent `NavigationStack` (don't nest)
- [ ] Pushed via `TrinityPush` / `navigationDestination(for:)`
