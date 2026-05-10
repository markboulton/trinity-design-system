import SwiftUI

/// Standard navigation push.
///
/// Wraps `NavigationLink` to enforce the convention: a tap on a card or row
/// pushes a detail destination. App-level navigation must use a single parent
/// `NavigationStack` with `navigationDestination(for:)` — this helper assumes
/// that scaffolding is already in place.
///
/// In debug builds, the helper does not enforce a parent NavigationStack — that
/// would require runtime traversal of the view hierarchy. Detection is left to
/// the swiftlint-trinity rule `trinity_no_nested_navigation_stack` and to code review.
public struct TrinityPush<Label: View, Destination: View>: View {

    public let destination: () -> Destination
    public let label: () -> Label

    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }

    public var body: some View {
        NavigationLink(destination: destination, label: label)
    }
}
