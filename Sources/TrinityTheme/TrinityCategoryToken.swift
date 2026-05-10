/// Closed enum of category tokens used across all three Trinity-consuming apps.
///
/// Each app's `Theme` implementation maps these tokens to brand colours via
/// `Theme.categoryColor(_:)`. Apps that don't use a particular category
/// (e.g., VeloReady doesn't use `.doses`) should return `theme.accent` or a
/// neutral colour for that case — the API stays closed but each app implements
/// only the cases it cares about.
public enum TrinityCategoryToken: String, CaseIterable, Sendable {

    // MARK: - Universal Health

    case heart
    case activity
    case sleep
    case mindfulness

    // MARK: - TRT Companion

    case doses
    case wellness
    case sideEffects
    case bloodWork
    case appointments

    // MARK: - VeloReady (Cycling)

    case ride
    case recovery
    case strain
    case readiness

    // MARK: - GymReady (Strength)

    case session
    case volume
    case fatigue
}
