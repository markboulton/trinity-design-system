# Layout — detailed rules

## The screen container

Every primary screen body wraps in `.trinityScreen()`. This:
- Applies `TrinitySpacing.sectionPadding` (20pt) horizontally
- Provides a vertical scroll
- Optionally accepts a `refreshable` async closure for pull-to-refresh

```swift
struct TodayView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ... screen content ...
        }
        .trinityScreen(refreshable: { await viewModel.refresh() })
    }
}
```

## Card stacks

When the screen is a list of cards, wrap them in `TrinityCardStack`:

```swift
TrinityCardStack {
    ScoreCard(value: 82)
    ActivityCard(activity: today)
    InsightsCard(insights: insights)
}
```

The stack applies `TrinitySpacing.cardSpacing` (12pt) between children. Do
not add `.padding(.bottom, 12)` to individual cards.

## Sections

Use `TrinitySection` to break a screen into named sub-areas:

```swift
TrinitySection("This Week") {
    WeekSummaryCard()
    WeekDistanceCard()
}

TrinitySection("Recovery") {
    RecoveryCard()
}
```

Sections inject `titleMedium` for the title and `sectionSpacing` (20pt) below.

## Don'ts

- Don't `.padding(.horizontal, 20)` — use `trinityScreen()`
- Don't `VStack(spacing: 12)` for cards — use `TrinityCardStack`
- Don't add external padding to a card — the stack owns it
- Don't hardcode `cornerRadius: 10` — use `TrinitySpacing.cardCornerRadius`
- Don't use `Spacer()` to fake spacing when a token exists

## Touch targets

- 44pt minimum (`TrinitySpacing.touch`)
- Trinity components handle this automatically; custom buttons must enforce it
