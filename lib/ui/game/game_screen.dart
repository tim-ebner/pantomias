import 'package:flutter/material.dart';

import '../shared/image_stage/image_stage.dart';
import 'game_view_model.dart';
import 'widgets/score_board.dart';
import 'widgets/scored_turn_actions.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.viewModel,
    required this.onNotGuessed,
    required this.onGuessed,
  });

  final GameViewModel viewModel;
  final VoidCallback onNotGuessed;
  final VoidCallback onGuessed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final activePlayer = viewModel.activePlayer;
        if (activePlayer == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScoreBoard(
                players: viewModel.players,
                activePlayerIndex: viewModel.activePlayerIndex,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ImageStage(viewModel: viewModel.imageDeckViewModel),
              ),
              const SizedBox(height: 16.0),
              ScoredTurnActions(
                onNotGuessed: onNotGuessed,
                onGuessed: onGuessed,
              ),
            ],
          ),
        );
      },
    );
  }
}
