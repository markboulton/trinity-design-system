# Navigation — detailed rules

## Single parent NavigationStack

Each scene has ONE NavigationStack at the root. Routes flow through
`navigationDestination(for:)`:

```swift
NavigationStack(path: $router.path) {
    HomeView()
        .navigationDestination(for: ActivityID.self) { id in
            ActivityDetailView(id: id)
        }
        .navigationDestination(for: SettingsRoute.self) { route in
            SettingsView(route: route)
        }
}
```

Never nest a `NavigationStack` inside another. The lint rule
`trinity_no_nested_navigation_stack` flags this.

## Push (drill-down)

Tap on a card or row to push a detail page:

```swift
TrinityPush(to: ActivityDetailView(id: activity.id)) {
    ActivityCard(activity: activity)
}
```

Or use `NavigationLink(value:)` with the typed router.

## Sheet (contextual action)

For "More" menus, contextual edits, share sheets, time-bound interactions:

```swift
.trinitySheet(isPresented: $showEditor) {
    ActivityEditorView(activity: activity)
}
```

Default detents are `[.medium, .large]` with drag indicator visible.

## Fullscreen cover (mode change)

Reserved for onboarding, paywalls, auth, anything that takes over the app's
context entirely. Use `.fullScreenCover(...)` directly — Trinity does not ship
a wrapper for this because it's app-specific.

## Back navigation

System back button only. Never add a custom "Cancel" or "Back" button to a
pushed screen. Sheets and covers can have a "Done"/"Cancel" toolbar button.
