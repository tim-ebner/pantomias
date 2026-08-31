import 'package:pantomias/features/game/viewmodel/game_view_model.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';
import 'package:pantomias/features/result/viewmodel/result_view_model.dart';

/// Payload carried from the game route to the result route via `extra`.
///
/// This is the one type allowed to bridge the `game` and `result` and
/// `point_mode_settings` features — it lives in `routing/` (the composition
/// root), not inside any single feature.
class GameOutcome {
  const GameOutcome({required this.players, required this.settings});

  factory GameOutcome.fromGame(
    GameViewModel gameViewModel, {
    required PointModeSettings settings,
  }) {
    return GameOutcome(
      players: gameViewModel.players
          .map(
            (player) =>
                ResultPlayerScore(name: player.name, score: player.score),
          )
          .toList(),
      settings: settings,
    );
  }

  final List<ResultPlayerScore> players;
  final PointModeSettings settings;
}
