import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';
import 'package:pantomias/core/services/turn_timeout_alert.dart';
import 'package:pantomias/features/game/view/game_screen.dart';
import 'package:pantomias/features/game/viewmodel/game_view_model.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/routing/route_args.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shell/app_scaffold.dart';
import 'package:pantomias/shell/home_icon_button.dart';
import 'package:pantomias/shell/title_pill.dart';
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
    _viewModel =
        GameViewModel(
          imageMetaInfoRepository: context.read<ImageMetaInfoRepository>(),
          imageShowHistoryRepository: context
              .read<ImageShowHistoryRepository>(),
          turnTimeoutAlert: context.read<TurnTimeoutAlert>(),
        )..start(
          playerNames: widget.settings.playerNames,
          roundLimit: widget.settings.roundLimit,
          turnTimeLimit: widget.settings.turnTimeLimit,
          gameMode: widget.settings.gameMode,
        );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _completeTurn({required bool wasGuessed, int? guesserIndex}) {
    final isFinished = _viewModel.completeTurn(
      wasGuessed: wasGuessed,
      guesserIndex: guesserIndex,
    );
    if (isFinished) {
      context.go(
        Routes.result,
        extra: GameOutcome.fromGame(_viewModel, settings: widget.settings),
      );
    }
  }

  String _roundLabel(BuildContext context) {
    final l10n = context.l10n;
    final roundLimit = _viewModel.roundLimit;
    return roundLimit == null
        ? l10n.roundLabel(_viewModel.currentRound)
        : l10n.roundLabelWithLimit(_viewModel.currentRound, roundLimit);
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
            child: HomeIconButton(),
          ),
          title: TitlePill(
            key: const ValueKey('round-label'),
            label: _roundLabel(context),
          ),
          actions: const [SizedBox(width: 64.0)],
          body: GameScreen(
            viewModel: _viewModel,
            onGuessed: ({guesserIndex}) =>
                _completeTurn(wasGuessed: true, guesserIndex: guesserIndex),
            onNotGuessed: () => _completeTurn(wasGuessed: false),
          ),
        );
      },
    );
  }
}
