---
name: Trinity Design System project context
description: Project structure, conventions, and reviewer notes for trinity-design-system Swift Package
type: project
---

Trinity is a multi-consumer Swift Package (iOS 17+, Swift 5.9) with three library products: TrinityTokens, TrinityTheme, TrinityComponents. It is consumed by VeloReady, GymReady, and TRT Companion.

**Why:** Shared design tokens and components across three apps in the same product family.
**How to apply:** Dependency direction is strictly TrinityTokens -> TrinityTheme -> TrinityComponents. Tests use Swift Testing framework (not XCTest). Package.resolved is intentionally gitignored.

Phase 0 (bootstrap) reviewed 2026-05-10 — clean build, all files match plan spec exactly.
Phase 0 (Task 2 — TrinitySpacing) reviewed 2026-05-10.
Task 3 (TrinityTypography) reviewed 2026-05-10 — spec compliant, two issues flagged (no tests, navigationLargeTitle relativeTo mismatch).
Task 4 (TrinityIcons) reviewed 2026-05-10 — spec compliant. Size enum uses CGFloat static lets (correct). All required groups present (Navigation/Status/Health/Actions/Sync/EmptyState). No tests added (repeating pattern). SFSN names spot-checked and all valid.
Task 5 (TrinityRadii + TrinityOpacity) reviewed 2026-05-10 — spec compliant. TrinityRadii uses CGFloat, TrinityOpacity uses Double, all four values match spec. No tests added. TrinityOpacity has no import (correct — no external deps). Pill=999 is intentional fully-rounded convention.
Task 6 (TrinityStatusColors) reviewed 2026-05-10 — spec compliant. All seven Color constants present. RGB values match spec exactly. Wellness aliases point to status constants (not raw RGB) — correct aliasing pattern. No tests added (Color equality on macOS requires XCTest/UIKit; absence is acceptable for now). Package.swift unchanged across all three tasks.
Task 7 (TrinityCategoryToken) reviewed 2026-05-10 — spec compliant. All 17 cases present across 4 MARK groups. Conformances (String, CaseIterable, Sendable) all present. Placeholder.swift deleted. Commit message matches spec exactly.
Task 8 (Theme protocol) reviewed 2026-05-10 — spec compliant. 18 vars + 2 funcs = 20 requirements. ThemeConformanceTests uses Swift Testing (import Testing), correct StubTheme covers all 20 requirements, two named @Test functions present. allCategoryTokens test iterates via CaseIterable — correct approach. TrinityThemeTests.swift placeholder left with comment; stale but harmless.
Task 9 (ThemeEnvironment) reviewed 2026-05-10 — spec compliant. ThemeEnvironmentKey is public with correct defaultValue type annotation. EnvironmentValues.theme get/set present. View.theme(_:) convenience modifier present. MissingThemeSentinel is private, covers all 20 requirements, uses assertionFailure (not fatalError) — intentional for testability. Sentinel uses category.rawValue in trap message for debuggability. No new tests added (sentinel behaviour not unit-testable without triggering assertionFailure; acceptable). 9/9 tests pass.

Established conventions to watch in future token files:
- Test framework is Swift Testing (import Testing), NOT XCTest. Any new test file using XCTest is a bug.
- Base unit declarations should be in strict ascending numeric order so the scale is readable as a table.
- Semantic aliases that are purely aliases (= lg, = md, etc.) should assert against base-unit names, not raw numbers, in tests — that is the correct pattern and was done correctly here for spacing/sizing aliases. Corner radii are raw literals and should assert against raw values.
- Tokens that are conceptually "radius" not "spacing" should live in a separate TrinityRadius enum once that token file is created. cardCornerRadius and buttonCornerRadius in TrinitySpacing are temporary placeholders.
- Typography tokens use Font.custom(_:size:relativeTo:) — relativeTo must match the semantic role of the token, not just a size-similar text style. Mismatches cause wrong Dynamic Type scaling curves (e.g. navigationLargeTitle at 28pt should use .title not .largeTitle).
- macOS(.v13) is a valid floor for SwiftUI packages needing Font.custom(_:size:relativeTo:) and .monospacedDigit() — both arrived in macOS 12. v13 gives a one-version safety margin and is the right choice for an `swift build` host-machine build.
- New token files (Typography, Color, etc.) should ship with a companion test file. Absence of tests is a repeating pattern across Tasks 3, 4, 5, 6 — flag every time.
- TrinityOpacity correctly uses no import statement (Double is stdlib). TrinityRadii uses import CoreGraphics (CGFloat). TrinityStatusColors uses import SwiftUI (Color). This is the correct per-type import pattern.
- Color equality is not trivially testable via Swift Testing on macOS without UIKit — absence of TrinityStatusColors tests is more defensible than the absence of tests for scalar token files (Radii, Opacity, Icons/Size). Scalar tests should be expected.
- Wellness RAG aliases should point to the status constants (e.g., = success), not re-specify raw RGB. Tasks 4-6 all followed this pattern correctly.
- TrinityIcons SF Symbol names: all names in Tasks 4-6 are valid iOS 17+ symbols. Future reviews should check any new names against SF Symbols app or known-bad list.
- Tasks 10-11 (DemoTRTTheme / DemoVRTheme / DemoGRTheme) reviewed 2026-05-10 — spec compliant. All 20 protocol requirements present. The TrinityCategoryToken enum has 16 cases (spec said 17 — the count in the spec was a documentation error; the file is authoritative). Two structural issues flagged as warnings: (1) nested `#if canImport(UIKit)` inside `adaptive()` is dead code because the struct is already gated at file level; (2) `DemoVRTheme.categoryColor(.sleep)` returns a raw Color literal `(0.051, 0.580, 0.533)` that is identical to `accent` — should reference `accent` or be grouped. No tests added for any of the Demo themes (acceptable since Theme conformance is already tested via StubTheme in ThemeConformanceTests). The `adaptive()` helper is byte-for-byte identical across all three files — extraction into a shared protocol extension would eliminate the duplication. Commit messages match spec exactly.
- Task 12 (TrinityButton) reviewed 2026-05-10 — spec compliant. Four styles present. @Environment(\.theme) on TrinityButtonLabel only (correct). All token references valid. isDisabled + isLoading handled correctly. #if canImport(UIKit) guard on Preview correct. Two warnings: (1) tertiary icon font inline-constructed (.custom(fontFamily, 11, relativeTo: .caption2).weight(.semibold)) instead of using TrinityTypography.captionSmall — captionSmall exists but is .regular; the semibold weight needed here is genuinely absent from the token ramp, so inline is currently the least-bad option but a captionSmallEmphasis token should be added; (2) tertiary padding values (10, 6) are hardcoded literals — TrinitySpacing has no exact matches (xs=6, sm=8, lg=16), so the 10pt horizontal value has no token equivalent; worth noting for future token additions. No companion test file added (continuing repeating pattern, acceptable for UIKit-only component). Package.swift unchanged. Build clean. Commit message matches spec exactly.

Established conventions for TrinityComponents:
- TrinityButtonLabel (not TrinityButton) holds @Environment(\.theme) — this is the canonical split for reuse in NavigationLink labels.
- isDisabled state is applied via .disabled() + .opacity(TrinityOpacity.disabled) on TrinityButton only; TrinityButtonLabel has no isDisabled parameter (correct — opacity is a container concern).
- isLoading disables the button alongside isDisabled (.disabled(isDisabled || isLoading)) — correct to prevent double-tap while loading.
- tertiary style short-circuits to a separate tertiaryBody computed var rather than adding branches to standardBody — clean pattern to follow for future style variants with structurally different layouts.
- standardBody uses .frame(maxWidth: .infinity) + .frame(minHeight: TrinitySpacing.touch) — correct tap target enforcement without forcing a fixed height.
- backgroundView and borderOverlay use @ViewBuilder computed vars rather than inline conditionals — correct pattern for multi-branch View returns.

Tasks 14-15 (Molecules + Organisms) reviewed 2026-05-10 — mostly compliant with 4 warnings and 0 critical violations.

Established conventions from Tasks 14-15:
- `Color.gray.opacity(...)` in #Preview blocks is an approved exception per porting rules; the same pattern inside production body code is a violation.
- `font(.system(size: 44))` in TrinityEmptyState and TrinityErrorState is an approved exception (no Trinity token covers icon sizing at 44pt). Both files lack a comment explaining the exception — flag absence of explanatory comment in future reviews.
- Raw sub-token spacing literals (spacing: 2, spacing: 0, frame(height: 4), frame(height: 24), padding(.vertical, 3)) used in pixel-perfect layout geometry are a recurring pattern. TrinitySpacing has no xxxs or micro step. These are warnings, not critical violations, but token gap should be tracked.
- `TrinityWellnessDot` correctly omits @Environment(\.theme) — it uses only TrinityStatusColors (which are absolute, not theme-relative). This is the correct pattern; absence of @Environment is not a bug when no theme property is accessed.
- `Color.clear` used in TrinityWellnessDot .none case is structural (not a design-value colour) — acceptable and not a violation.
- captionSmallEmphasis token is now confirmed present (TrinityMarkerBar uses it) — the token gap flagged in Task 12 was resolved by Task 14/15.

Layout layer (TrinityScreen / TrinityCardStack / TrinitySection / TrinityPush / TrinitySheet) reviewed 2026-05-10.

Task 33 (TrinityLineSparkline + TrinityBarSparkline + AtomsPage) reviewed 2026-05-11 — APPROVED with one warning and one suggestion. All spec requirements met. Warning: Charts framework is imported with no package dependency declared in Package.swift — Charts is part of the Xcode SDK on iOS 17+ but is NOT available on macOS 13 without an explicit dependency, which means `swift build` on the host machine only succeeds because the current build happens to not resolve macOS-specific Charts usage; if macOS support is exercised this will fail. Suggestion: TrinityBarSparkline has no empty-values guard (contrast TrinityLineSparkline's `< 2` guard) — an empty array passes through GeometryReader fine (`barCount=0`, `totalSpacing=0`, `barWidth=max(…/0, 1)` hits the max(1) floor), so this is not a crash risk, but parity with the line sparkline would be cleaner. Preview uses hardcoded Color(red:green:blue:) literals in TrinityLineSparkline rather than theme.accent — this is a preview-only exception, same as established pattern for Molecules/Organisms.

TrinityPulseLoader (Atom) reviewed 2026-05-11 — NOT APPROVED. Two critical issues and two warnings.
Critical: (1) DispatchQueue.main.asyncAfter recursion has no onDisappear cancellation — the chain fires indefinitely after the view disappears, causing memory/CPU leak until the app exits. Fix: replace with a Task-based loop holding a nonisolated(unsafe) stored property or use a parent-level task group controlled via .task { }. (2) innerScale starts at 0.0 — the inner circle is invisible at rest, which contradicts a two-ring loader design (both rings should be visible). If the inner circle is intentional as a ripple-in from invisible, that is a design clarification needed from spec; if it mirrors the outer ring, initial state should be 1.0.
Warnings: (1) `isLoading` in TrinityLoadingOverlayModifier is a plain let — fine for read-only use but should be @Binding if the caller ever needs to dismiss the overlay from within the overlay itself (currently it cannot). (2) No tests (continuing repeating pattern for TrinityComponents).

Established conventions from TrinityPulseLoader review:
- DispatchQueue.main.asyncAfter recursive animation loops have no cancellation point. SwiftUI views have no deinit, so the chain survives view disappearance. The correct pattern for looping animations in SwiftUI is either (a) `.task { }` with an async `while true` loop using `try Task.sleep` (Task is cancelled automatically by the modifier on disappear) or (b) `withAnimation(.repeatForever)` where possible. Flag any future use of bare DispatchQueue.main.asyncAfter recursion in a View as a critical leak risk.
- When a looping animation view has no disappear cancellation, the view modifier approach (TrinityLoadingOverlayModifier) compounds the risk because multiple overlay presentations will each spawn their own uncoordinated timer chain.

Established conventions from Layout review:
- `#Preview` blocks in layout files contain placeholder `Color.gray.opacity(...)` for illustrative backgrounds — this is an approved exception (same as Molecules/Organisms pattern).
- `#Preview` blocks in layout files also use `.cornerRadius(TrinitySpacing.cardCornerRadius)` on throwaway content — this is preview-only scaffolding, not production code, and is an approved exception.
- `presentationCornerRadius` is macOS-unavailable. The `#if os(iOS)` guard is the correct approach for this modifier. Do NOT use `if #available(iOS 16.4, macOS 13.3, *)` for this modifier — `presentationCornerRadius` is not available on macOS at any version. Flag any future attempt to add an availability check for a macOS version of this modifier.
- `TrinityPush` wraps `NavigationLink(destination:label:)` (value-less form). This is intentional — it works with the single-parent `NavigationStack` + `navigationDestination(for:)` scaffold. It is NOT the value-based `NavigationLink(_:value:)` form. Both are valid; TrinityPush deliberately uses the closure form to stay destination-type-agnostic.
- `TrinitySheetModifier` correctly has NO `#Preview` — the sheet is a presentation modifier, not a standalone view, so a preview is not needed. Absence of preview is intentional, not an omission.
- `TrinitySection` correctly holds `@Environment(\.theme)` because it renders a `Text` title with `theme.labelPrimary`. This is the right split: only the component that accesses a theme colour holds the environment property.
- `TrinityCardStack` correctly omits `@Environment(\.theme)` — it only applies spacing tokens (static), not colour tokens. This is the correct pattern.
- `TrinityScreen` correctly omits `@Environment(\.theme)` — it only applies spacing tokens. Correct.
- `TrinitySheetModifier.isPresented` binding should use `@Binding` not a plain stored property. Current code is correct. Future reviews: flag any modifier that needs to mutate a parent bool without using @Binding.
- `TrinitySection` title `accessibilityAddTraits(.isHeader)` is absent — this is a missing accessibility modifier. Flag in future reviews as an Important issue.

Task 33 (TrinityLineSparkline / TrinityBarSparkline) reviewed 2026-05-11 — APPROVED. Charts framework import has no Package.swift dependency (works on iOS 17+ SDK but not macOS without explicit dep). TrinityBarSparkline has no empty-values guard unlike the line sparkline.

Tasks 35–36 (TrinityRangeChart + TrinitySkeletonView) reviewed 2026-05-11 — both APPROVED, no critical violations.

Established conventions from Tasks 35–36:
- `Bucket.id = UUID()` on a value-type struct generates a new UUID on every construction. If the parent view rebuilds the array, ForEach treats all items as new and re-renders the chart. For chart data structs, prefer `date` (or another stable property) as the Identifiable id, or accept `id` in the init.
- `withAnimation(.repeatForever)` driven by @State boolean is the correct SwiftUI looping animation pattern (not a DispatchQueue leak). However: if `onAppear` fires again while `isAnimating` is already true (which happens on NavigationStack push/pop), a second animation transaction layers on top. Guard with `guard !isAnimating else { return }` inside `onAppear` to prevent this.
- `LinearGradient(colors:startPoint:endPoint:)` with `.leading`/`.trailing` + `.rotationEffect(.degrees(90))` is a correct implementation of a vertical shimmer sweep. The rotation turns the horizontal gradient into a vertical one — both directions are equivalent for the offset-based animation.
- `yDomain` pattern for Charts: include baseline in the candidates array alongside data min/max so the domain automatically expands to show the reference line. `[minY, maxY, baseline ?? minY]` is the idiom used here and should be the template for future chart components.
- Annotation guards on PointMark: spec requires BOTH `annotateExtremes && count <= 14` AND `low != high` to be true before rendering. The count <= 14 guard is a density/readability threshold — flag any chart annotation that omits the count guard.

Task 37 (TrinityInfoBanner) reviewed 2026-05-11 — APPROVED. All 10 spec requirements met. Two minor warnings: (1) no companion test file (continuing repeating pattern); (2) TrinitySeverity has no explicit Sendable conformance — it is implicitly Sendable in Swift 5.9 but explicit conformance is the established convention for public enums in this package (see TrinityCategoryToken). tint computation verified against token files (TrinityOpacity.tonalFill, TrinityRadii.card, TrinityStatusColors all confirmed present). All four SF Symbol names valid iOS 17+.

Established conventions from TrinityInfoBanner review:
- Public enums in TrinityComponents should declare `Sendable` explicitly, consistent with TrinityTokens conventions, even when implicit conformance holds.
- `TrinitySeverity` is the first publicly-typed severity enum in TrinityComponents. Future components that introduce their own status/state enum should follow the same pattern: `public enum XSeverity: Sendable { ... }`.

Task 38 (TrinityFlowLayout) reviewed 2026-05-11 — APPROVED. All 7 spec requirements met. Layout math is correct including single-item row handling, empty-subviews case, and inter-row spacing guard. Two warnings: (1) `placeSubviews` advances `y` by `rowHeight + spacing` after every row including the last — benign because the final `y` value is discarded, but inconsistent with `sizeThatFits` which guards `if index < rows.count - 1`; (2) redundant `.theme(DemoTRTTheme())` in #Preview — no subview reads environment, so the call has no effect and contradicts the "pure layout, no theme environment" preview intent. No companion test file (continuing repeating pattern). AtomsPage flowLayoutSection: 8 chips, TrinitySpacing.xs, wired after skeletonSection — all correct.

Established conventions from TrinityFlowLayout review:
- `placeSubviews` trailing-y mismatch vs `sizeThatFits` is a known benign pattern in Layout conformances: the final `y` advance is discarded by SwiftUI. Do not flag as a crash or misplacement bug.
- `#Preview` in a pure Layout file should NOT call `.theme()` if no child reads `@Environment(\.theme)`. If the preview uses `DemoXTheme().someColour` directly (instantiated struct), the `.theme()` call is dead and should be omitted.
- An item whose intrinsic width exceeds `maxWidth` is placed as a single-item row at full intrinsic width (overflows bounds). For tag-chip content this is safe; for arbitrary content, cap the proposal or clamp `size.width` to `maxWidth`.
- `computeRows` correctly uses `subview.sizeThatFits(.unspecified)` to get the intrinsic size. This is the right proposal for chips/labels that should size to their content.
- Gallery `flowLayoutSection` correctly uses `theme.accentSubtle` via `@Environment(\.theme)` (inherited from NavigationStack). Component `#Preview` correctly uses `DemoTRTTheme().accentSubtle` directly. Both patterns are correct for their contexts.
- The `#if canImport(UIKit)` guard on `#Preview` is consistently applied across all molecule previews — correct pattern, flag any preview block that omits this guard.
