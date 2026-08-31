# Pantomias

Flutter party-game app: players guess a pantomime prompt shown to a
teammate, either casually ("Schnellstart") or in a scored, round- and
timer-limited mode ("Spiel mit Punkten"). MVVM with a simplified
Clean layering, `provider` for dependency injection, `go_router` for
navigation, and German-first localization (`app_de.arb` is the
template/source locale; English is also supported).

## Architecture rules

- Three layers per feature: `view/`, `viewmodel/`, and optionally
  `repository/` (only if the feature owns data nobody else touches —
  most don't). No separate domain/use-case layer.
- ViewModels `extend ChangeNotifier` and only import
  `package:flutter/foundation.dart` — never `package:flutter/material.dart`.
  They hold state and business logic, nothing UI-related.
- Views (`*_screen.dart`) are presentational: they receive a
  ViewModel and callbacks via constructor, and never access a
  repository or call `context.go` directly.
- Route-glue widgets (`*_page.dart`, under `lib/routing/pages/`) own
  ViewModel construction and disposal (`initState`/`dispose`) and all
  navigation (`context.go`). They are the only widgets allowed to
  reach across feature boundaries.
- Repositories are concrete classes — no abstract interfaces needed;
  mock them directly with `mocktail` in tests. The one exception is
  `TurnTimeoutAlert` (`lib/core/services/turn_timeout_alert.dart`),
  which stays abstract because its implementation wraps real
  audio/vibration plugin side effects that must be fully fakeable.
- **Import boundary**: nothing under `lib/features/**` may import
  `package:go_router` or another `lib/features/**` subtree. Only
  `lib/routing/**` (the composition root) crosses feature boundaries
  — e.g. `lib/routing/route_args.dart` is the one place allowed to
  translate between two features' types.

## Folder structure

```
lib/
  main.dart          # bootstrap only: WidgetsFlutterBinding, SharedPreferences, runApp
  app.dart            # MyApp: MultiProvider + MaterialApp.router

  routing/
    routes.dart        # path constants
    app_router.dart    # GoRouter route table
    route_args.dart     # cross-feature route payload types (e.g. GameOutcome)
    pages/              # one *_page.dart per route — owns ViewModel lifecycle + navigation

  shell/                # AppBar/Scaffold chrome shared by every route

  core/
    data/                # cross-cutting repositories + their models
    services/            # cross-cutting services (e.g. TurnTimeoutAlert)

  shared/                # cross-cutting UI: constants, widgets used by 2+ features

  features/
    <feature>/
      view/              # screen + feature-local widgets
      viewmodel/          # ChangeNotifier
      repository/         # only if this feature owns data nobody else touches

  l10n/                  # ARB files + flutter gen-l10n output + context.l10n extension
```

- `core/` = non-UI, app-wide singleton material, registered once in
  `MultiProvider` (`app.dart`).
- `shared/` = cross-cutting **UI** — anything used by two or more
  features.
- `features/<name>/` = everything specific to one feature.
- `routing/` = the composition root that wires features together.

## Naming conventions

- Files: `snake_case.dart`. Classes: `PascalCase`.
- `<feature>_screen.dart` = presentational widget (under `view/`).
- `<feature>_page.dart` = route-glue widget (under `routing/pages/`
  only — never inside a feature folder).
- `<feature>_view_model.dart` = `ChangeNotifier` (under `viewmodel/`).
- Widget `ValueKey`s use kebab-case (e.g. `'start-scored-game-button'`)
  — this convention is used both in production widgets and in tests
  to look them up, so keep it consistent.
- One public top-level widget per file; small tightly-coupled helper
  widgets may live in the same file prefixed with `_`.

## State management & navigation

- `provider`/`MultiProvider` in `app.dart` registers the app-wide
  singletons (repositories, services). Look them up with
  `context.read<T>()` only at ViewModel-construction time, inside a
  page's `initState`.
- ViewModels are plain constructor-injected objects, not looked up
  from the widget tree.
- `go_router`: path constants in `routes.dart`, the route table in
  `app_router.dart`, cross-route payloads in `route_args.dart`.
  Navigate with `context.go()`, not `push()`, unless a real back-stack
  is intentionally introduced later — the app has none today.

## Testing requirements

- **New ViewModel or repository logic must ship with a unit test.**
  This is a hard rule, not a suggestion.
- Put unit tests under `test/features/<feature>/viewmodel/..._test.dart`
  (mirroring `lib/features/...`) or `test/core/data/..._test.dart` for
  repositories.
- Use `mocktail` to mock repositories/services — no code generation.
  When a mock method returns a list the code under test might mutate,
  stub it with `thenAnswer((_) => [...])` (a fresh list per call), not
  `thenReturn(...)` (same instance every call) — mirrors how the real
  repositories build a fresh list on every call.
- Keep `test/widget_test.dart` as the end-to-end happy-path smoke
  test; extend it when a change materially affects the user-facing
  flow rather than duplicating that coverage in unit tests.
- Run `flutter test --coverage`; inspect with
  `genhtml coverage/lcov.info -o coverage/html`. Target ~50%+ overall
  line coverage, concentrated in ViewModels and repositories rather
  than widget styling code.

## Code quality (Clean Code / Flutter best practices)

- Keep widgets small — extract a private/child widget once a
  `build()` method exceeds roughly 100–150 lines or nests more than
  3–4 levels deep.
- No business logic in `build()` — computed values belong in the
  ViewModel or a small private pure function.
- No magic numbers/colors in widgets — use `lib/shared/commons.dart`
  for constants shared across features, or a private `static const`
  block for feature-local ones.
- Prefer `const` constructors wherever possible (enforced by lint).
- Meaningful names; avoid `data`/`temp`/`helper`/`utils` catch-alls.
- Single responsibility per file.

## Linting

`analysis_options.yaml` extends `flutter_lints` with additive rules:
`avoid_print`, `prefer_const_constructors`,
`prefer_const_constructors_in_immutables`,
`prefer_const_literals_to_create_immutables`, `prefer_final_locals`,
`prefer_final_in_for_each`, `unnecessary_lambdas`,
`avoid_redundant_argument_values`, `sort_child_properties_last`,
`always_declare_return_types`, `unawaited_futures`. A stricter preset
like `very_good_analysis` is worth considering later, once the
codebase would need few or no suppressions — not adopted yet.

## Do's / Don'ts

- Do keep ViewModels Flutter-UI-free and unit-testable.
- Do put navigation and ViewModel lifecycle only in `routing/pages/*`.
- Do write a unit test alongside any new ViewModel/repository logic.
- Don't add a repository interface unless something genuinely needs
  more than one implementation (or must fake a real plugin, like
  `TurnTimeoutAlert`).
- Don't import across `lib/features/**` — go through `lib/routing/**`.
- Don't introduce a domain/use-case layer, Riverpod, GetIt, or other
  architecture not already decided above without checking first.

## Workflow / autonomy

- Running `flutter analyze` and `flutter test`, and committing once
  both are clean, may happen autonomously.
- Force-pushing, `git reset --hard`, deleting assets, or bumping the
  app version (`pubspec.yaml`) require being asked first.
- Never skip writing a ViewModel/repository test for new business
  logic to save time.
