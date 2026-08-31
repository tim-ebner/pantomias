---
name: scaffold-feature
description: Scaffold a new Pantomias feature (view/viewmodel skeleton, optional repository, optional route + provider wiring). Use when adding a new screen or feature to the app.
---

# Scaffold a new feature

Follow the architecture and naming conventions in `CLAUDE.md` at the
repo root — read it first if you haven't already this session.

## 1. Gather the shape of the feature

Ask (or infer from the request) if not already clear:

- Feature name, in `snake_case` (e.g. `leaderboard`).
- One-line purpose.
- Does it need its own repository, or does it read from an existing
  one in `lib/core/data/`?
- Does it need its own route (a new screen the user navigates to), or
  is it embedded inside an existing screen?

## 2. Create the view

`lib/features/<name>/view/<name>_screen.dart` — a `StatelessWidget`
(or `StatefulWidget` only if it needs purely presentational local
state, e.g. an `AnimationController`) that takes the feature's
ViewModel and any callbacks via constructor. Follow the shape of
`lib/features/quick_start/view/quick_start_screen.dart` for a simple
example, or `lib/features/point_mode_settings/view/point_mode_settings_screen.dart`
for one with local widgets under `view/widgets/`.

Never import `package:go_router` or a repository directly here.

## 3. Create the ViewModel

`lib/features/<name>/viewmodel/<name>_view_model.dart` — a class
`extends ChangeNotifier`, importing only
`package:flutter/foundation.dart` (plus whatever repository/service
types it needs). Constructor-inject dependencies. Follow
`lib/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart`
for the shape: private mutable state, public getters, methods that
mutate state and call `notifyListeners()`.

## 4. Repository (only if needed)

- If the feature needs data nobody else touches: create
  `lib/features/<name>/repository/<name>_repository.dart` as a plain
  concrete class (no interface needed — see `CLAUDE.md`'s repository
  rule).
- If the data is or will be shared across features: add it to
  `lib/core/data/` instead.

## 5. Route wiring (only if the feature needs its own screen/route)

1. Add a path constant to `lib/routing/routes.dart`.
2. Create `lib/routing/pages/<name>_page.dart`: a `StatefulWidget`
   that constructs the ViewModel in `initState` via `context.read<T>()`
   for its dependencies, disposes it in `dispose`, and renders
   `AppScaffold(title: ..., body: <Name>Screen(...))` from
   `lib/shell/app_scaffold.dart`. Add `HomeActionButton()` to
   `actions` unless this is the home route. Wire navigation callbacks
   with `context.go(Routes.<name>)`.
3. Add the `GoRoute` entry to `lib/routing/app_router.dart`. If the
   route needs data passed in via `extra`, add the payload type to
   `lib/routing/route_args.dart` and a `redirect:` guard that sends
   back to `Routes.home` when `state.extra` is missing or the wrong
   type (see the `/score-game` and `/result` routes for the pattern).

## 6. New app-wide singleton (only if needed)

If step 4 added a repository/service meant to be a long-lived
singleton, register it in `MultiProvider` inside `lib/app.dart`.

## 7. Test

Create `test/features/<name>/viewmodel/<name>_view_model_test.dart`
with a `mocktail` mock for each injected repository/service (see
`test/features/point_mode_settings/viewmodel/point_mode_settings_view_model_test.dart`
for the pattern, including the `thenAnswer((_) => [...])` note in
`CLAUDE.md` if any mocked method returns a list). Cover at minimum:
the initial state, and each public method that changes state.

## 8. Verify

Run `flutter analyze` and `flutter test`. Report the result. Do not
commit unless explicitly asked to.
