/// Determines who scores and pantomimes next in a scored game.
///
/// Shared between the `point_mode_settings` and `game` features, so it lives
/// under `core/` rather than inside either feature — features may not import
/// each other directly.
enum GameMode { winnerNext, sequence }
