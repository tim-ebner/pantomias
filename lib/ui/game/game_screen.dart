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
              if (viewModel.remainingTurnTime != null) ...[
                const SizedBox(height: 12.0),
                _TurnTimer(remainingTime: viewModel.remainingTurnTime!),
              ],
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

class _TurnTimer extends StatelessWidget {
  const _TurnTimer({required this.remainingTime});

  final Duration remainingTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExpired = remainingTime == Duration.zero;
    final foregroundColor = isExpired
        ? Colors.red.shade700
        : colorScheme.primary;
    final backgroundColor = isExpired
        ? Colors.red.shade50
        : colorScheme.primaryContainer.withValues(alpha: 0.42);

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: foregroundColor, width: 2.0),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: SizedBox(
            height: 48.0,
            child: Center(
              child: Text(
                _formatRemainingTime(remainingTime),
                key: const ValueKey('turn-timer-label'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatRemainingTime(Duration duration) {
    if (duration == Duration.zero) {
      return 'Zeit abgelaufen';
    }

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
