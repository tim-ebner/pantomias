import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/core/services/turn_timeout_alert.dart';
import 'package:pantomias/features/game/view/game_screen.dart';
import 'package:pantomias/features/game/viewmodel/game_view_model.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/routing/route_args.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shared/commons.dart';
import 'package:pantomias/shell/app_scaffold.dart';
import 'package:pantomias/shell/home_action_button.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.settings});

  final PointModeSettings settings;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameViewModel(
      imageMetaInfoRepository: context.read<ImageMetaInfoRepository>(),
      turnTimeoutAlert: context.read<TurnTimeoutAlert>(),
    )..start(
      playerNames: widget.settings.playerNames,
      roundLimit: widget.settings.roundLimit,
      turnTimeLimit: widget.settings.turnTimeLimit,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _completeTurn({required bool wasGuessed}) {
    final isFinished = _viewModel.completeTurn(wasGuessed: wasGuessed);
    if (isFinished) {
      context.go(
        Routes.result,
        extra: GameOutcome.fromGame(_viewModel, settings: widget.settings),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return AppScaffold(
          centerTitle: false,
          toolbarHeight: 112.0,
          titleSpacing: 24.0,
          title: _GameTitle(viewModel: _viewModel),
          actions: const [HomeActionButton()],
          body: GameScreen(
            viewModel: _viewModel,
            onGuessed: () => _completeTurn(wasGuessed: true),
            onNotGuessed: () => _completeTurn(wasGuessed: false),
          ),
        );
      },
    );
  }
}

class _GameTitle extends StatelessWidget {
  const _GameTitle({required this.viewModel});

  final GameViewModel viewModel;

  static const _roundLabelColor = Color(0xFF243B34);

  @override
  Widget build(BuildContext context) {
    final activePlayer = viewModel.activePlayer;
    if (activePlayer == null) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final roundLimit = viewModel.roundLimit;
    final roundLabel = roundLimit == null
        ? l10n.roundLabel(viewModel.currentRound)
        : l10n.roundLabelWithLimit(viewModel.currentRound, roundLimit);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roundLabel,
          key: const ValueKey('round-label'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _roundLabelColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          l10n.activePlayerLabel(activePlayer.name),
          key: const ValueKey('active-player-label'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: brandColor,
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );
  }
}
