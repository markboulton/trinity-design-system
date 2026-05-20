# CLAUDE.md — Trinity Design System

## What this package is

Trinity is a **multi-consumer Swift Package**. Three apps depend on `main` of this repo via SPM branch-tracking:

- VeloReady — `/Users/markboulton/Dev/VeloReady`
- GymReady — separate repo
- TRT Companion — separate repo

Apps pull new commits when their developer runs **File → Packages → Update to Latest Package Versions** (Xcode) or `swift package update` (CLI). There is no auto-update — but there is also no version gate. The moment a developer clicks Update, whatever is on `origin/main` lands in their app.

The master spec lives in VR's repo at `docs/superpowers/specs/2026-05-10-trinity-design-system-design.md`.

## The producer-side invariant

> **`origin/main` must always compile for every consumer app.**

A push that breaks any of the three apps becomes a landmine waiting for the next time someone updates their package. There is no CI gate yet — only the discipline below and the test suite enforce this.

## Session protocol

On every conversation start, before any work:

1. Read `MEMORY.md` (auto-loaded) and the linked memory files.
2. `git status` + `git log --oneline -5`.
3. `swift build && swift test` — verify the baseline is green before changing anything.
4. State your understanding of the current task before starting.

## What counts as a breaking change

Source-breaking for consumer apps — **requires the deprecate-then-remove process below**:

- Renaming a public type, property, function, enum case, or extension member.
- Removing any public symbol.
- Changing a function signature (parameter labels, types, order, count, defaults that callers relied on).
- Changing a public property's type.
- Removing or adding a case to a non-`@frozen` public enum (additions break exhaustive switches in consumers).
- Tightening generic constraints on a public type.
- Narrowing visibility (`public` → `internal` / `package` / `private`).
- Adding, renaming, or removing a `Theme` protocol requirement (every consumer app's `*Theme` struct must conform).

Not breaking — can be committed straight to `main`:

- Adding a brand-new public symbol.
- Adding optional initializer parameters with default values.
- Adding a new protocol requirement **with a default implementation in an extension**.
- Internal/private changes.
- Documentation, formatting, refactor that leaves the public surface byte-identical.

When in doubt, treat it as breaking. The deprecation step costs nothing.

## Deprecate-then-remove process

For any breaking change:

1. **Trinity PR 1** — Add the new API alongside the old. Mark the old with `@available(*, deprecated, message: "Use X instead.")`. Update `PublicAPISnapshot.swift` to reference *both* the new and the still-present deprecated symbol. `swift build && swift test` must pass. Merge to `main`.
2. **Per-consumer PRs** (VR, GR, TC) — `swift package update` to pick up the new Trinity tip. Migrate call sites away from the deprecated symbol (the warning makes them discoverable). Commit `Package.resolved`. Ship each app's release on its own cadence.
3. **Trinity PR 2** — Remove the deprecated symbol. Remove its entry from `PublicAPISnapshot.swift`. `swift build && swift test` must pass. Merge to `main`.

Never skip step 2. Never delete a symbol that any of the three apps still references.

## Branching policy

- **Additive change** (new component, new token, new optional parameter): commit directly to `main`. Established Phase 0 pattern.
- **Breaking change** (anything in the list above): branch (`feat/<name>` or `breaking/<name>`), open a PR, merge after the deprecation step has shipped to all consumers.
- **Bugfix that doesn't change public API**: direct to `main`.
- Always run `swift build && swift test` before committing.
- Push to `origin/main` only when the user authorises (matches global rule).

## The machine guard rail

**`Tests/TrinityComponentsTests/PublicAPISnapshot.swift`** instantiates every public Trinity type, every public initializer signature, every nested enum case, every token, and every `View` extension. It is compile-as-test: the test passes if the file compiles.

Discipline:

- **New public symbol added** → add an entry to the snapshot in the same PR.
- **Symbol renamed** → update both names in the snapshot (deprecated + new) in step 1 of the deprecation process.
- **Symbol removed** → remove from the snapshot in step 3, *after* consumers have migrated.
- **Snapshot won't compile because you removed something** → that is the test working. Do not delete the line to "make it pass". Either restore the symbol, or move it through the deprecation cycle.

Run `swift test` before every push. The snapshot lives or dies on this.

## Working with consuming apps

Three dev modes (from spec §5):

1. **Gallery iteration** (95% of work) — open Trinity in Xcode, run the Gallery on simulator, edit components, theme-switch between TRT/VR/GR demo themes. `swift build` does NOT compile the Gallery — it's a separate `.xcodeproj`. Verify the Gallery in Xcode before pushing if your change touches Gallery pages.
2. **`swift package edit`** — for "does this fit a real VR screen?". In VR's repo: `swift package edit Trinity --path ../trinity-design-system`. SPM swaps the remote URL for a local checkout; edits in either window propagate live. Unedit with `swift package unedit Trinity`.
3. **Breaking change** — use the deprecate-then-remove process. Never push a rename or removal to `main` without it.

## References

- `PRINCIPLES.md` — design rules (both consumer-side usage and producer-side breaking-change discipline)
- `docs/superpowers/plans/` — implementation plans (executed task-by-task)
- `docs/superpowers/specs/` — design specs
- Master multi-phase spec: `~/Dev/VeloReady/docs/superpowers/specs/2026-05-10-trinity-design-system-design.md`
- The `trinity-ui` Claude skill at `skills/trinity-ui/` is for **consuming apps**, not for working inside this repo.
