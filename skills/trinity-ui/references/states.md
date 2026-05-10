# States — loading, empty, error

## Loading

Prefer skeletons:

```swift
if viewModel.isLoading {
    ScoreCardSkeleton()  // mimics the loaded layout
} else {
    ScoreCard(value: viewModel.score)
}
```

Use `ProgressView` only when:
- The layout of loaded content is fundamentally unknown
- The wait is brief (<500ms expected)
- It's an inline spot loader (e.g., next to a sync button)

Never block the entire screen with a centred `ProgressView` unless the user
explicitly requested an action and is waiting on its completion.

## Empty

Use `TrinityEmptyState`:

```swift
TrinityEmptyState(
    icon: TrinityIcons.trayFull,
    title: "No activities yet",
    description: "Connect Strava to import your rides.",
    primaryAction: (label: "Connect", action: connectStrava),
    secondaryAction: nil
)
```

Never write inline text like "No activities" — it has no consistent treatment
across the three apps.

## Error

Use `TrinityErrorState`:

```swift
TrinityErrorState(
    title: "Couldn't load activities",
    description: error.localizedDescription,
    retryAction: { Task { await viewModel.retry() } },
    secondaryAction: nil
)
```

Never use a toast for errors. Errors that prevent the screen from working get
the full-screen treatment; errors that only affect part of the screen
substitute the affected component.

## Refresh

Pull-to-refresh on primary screens:

```swift
.trinityScreen(refreshable: { await viewModel.refresh() })
```

Explicit refresh buttons live only in detail/debug screens.
