import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/widgets/stage_card.dart';

import '../viewmodel/game_view_model.dart';
import 'widgets/score_board.dart';
import 'widgets/scored_turn_actions.dart';
import 'widgets/turn_timer_ring.dart';

class GameScreen extends StatefulWidget {
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
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const _maxContentWidth = 480.0;

  late final AnimationController _advanceController;
  StageFeedback? _transientFeedback;
  VoidCallback? _pendingCallback;

  @override
  void initState() {
    super.initState();
    _advanceController = AnimationController(vsync: this)
      ..addStatusListener(_onAdvanceStatusChanged);
  }

  @override
  void dispose() {
    _advanceController.dispose();
    super.dispose();
  }

  void _onAdvanceStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }

    final callback = _pendingCallback;
    _pendingCallback = null;
    callback?.call();

    if (!mounted) {
      return;
    }
    setState(() => _transientFeedback = null);
  }

  void _handleGuessed() {
    if (_transientFeedback != null) {
      return;
    }
    setState(() => _transientFeedback = StageFeedback.correct);
    _pendingCallback = widget.onGuessed;
    _advanceController
      ..duration = const Duration(milliseconds: 900)
      ..forward(from: 0.0);
  }

  void _handleNotGuessed() {
    if (_transientFeedback != null) {
      return;
    }
    setState(() => _transientFeedback = StageFeedback.wrong);
    _pendingCallback = widget.onNotGuessed;
    _advanceController
      ..duration = const Duration(milliseconds: 1000)
      ..forward(from: 0.0);
  }

  void _handleToggleReveal() {
    widget.viewModel.imageDeckViewModel.toggleImage();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        final viewModel = widget.viewModel;
        final activePlayer = viewModel.activePlayer;
        if (activePlayer == null) {
          return const SizedBox.shrink();
        }

        final remaining = viewModel.remainingTurnTime;
        final total = viewModel.turnTimeLimit;
        final isExpired = remaining == Duration.zero;
        final effectiveFeedback =
            _transientFeedback ?? (isExpired ? StageFeedback.expired : null);
        final isBusy = _transientFeedback != null;

        final imageDeckViewModel = viewModel.imageDeckViewModel;
        final currentImage = imageDeckViewModel.currentImage;
        final isImageShown = imageDeckViewModel.isImageShown;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScoreBoard(
                    players: viewModel.players,
                    activePlayerIndex: viewModel.activePlayerIndex,
                  ),
                  if (remaining != null && total != null) ...[
                    const SizedBox(height: 14.0),
                    Center(
                      child: TurnTimerRing(remaining: remaining, total: total),
                    ),
                  ],
                  const SizedBox(height: 12.0),
                  Expanded(
                    child: StageCard(
                      isRevealed: isImageShown,
                      promptWord: currentImage == null
                          ? ''
                          : context.l10n.pantomimePrompt(
                              currentImage.promptId,
                            ),
                      imageAssetPath: currentImage?.imageUrl,
                      feedback: effectiveFeedback,
                      onTap: effectiveFeedback == null
                          ? _handleToggleReveal
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ScoredTurnActions(
                    onNotGuessed: _handleNotGuessed,
                    onGuessed: _handleGuessed,
                    enabled: !isBusy,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
