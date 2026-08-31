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
          toolbarHeight: 64.0,
          leadingWidth: 64.0,
          showDivider: false,
          leading: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: _GameHomeButton(),
          ),
          title: _RoundPill(viewModel: _viewModel),
          actions: const [SizedBox(width: 64.0)],
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

/// Circular home/mode-selection button used only by the game screen's
/// header, styled to match the redesigned game screen.
class _GameHomeButton extends StatelessWidget {
  const _GameHomeButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.modeSelectionTooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: brandColor, width: 2.5),
        ),
        child: InkWell(
          key: const ValueKey('mode-selection-button'),
          customBorder: const CircleBorder(),
          onTap: () => context.go(Routes.home),
          child: const SizedBox(
            width: 44.0,
            height: 44.0,
            child: Icon(Icons.home, color: brandColor, size: 22.0),
          ),
        ),
      ),
    );
  }
}

/// Bold rounded pill showing the current round, matching the redesigned
/// game screen's header.
class _RoundPill extends StatelessWidget {
  const _RoundPill({required this.viewModel});

  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final roundLimit = viewModel.roundLimit;
    final roundLabel = roundLimit == null
        ? l10n.roundLabel(viewModel.currentRound)
        : l10n.roundLabelWithLimit(viewModel.currentRound, roundLimit);

    return Container(
      key: const ValueKey('round-label'),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: brandColor,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        roundLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
