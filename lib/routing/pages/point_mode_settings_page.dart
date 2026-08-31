import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/core/data/scored_game_settings_repository.dart';
import 'package:pantomias/features/point_mode_settings/view/point_mode_settings_screen.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shell/app_scaffold.dart';
import 'package:pantomias/shell/home_icon_button.dart';
import 'package:pantomias/shell/title_pill.dart';
import 'package:provider/provider.dart';

class PointModeSettingsPage extends StatefulWidget {
  const PointModeSettingsPage({super.key});

  @override
  State<PointModeSettingsPage> createState() => _PointModeSettingsPageState();
}

class _PointModeSettingsPageState extends State<PointModeSettingsPage> {
  late final PointModeSettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PointModeSettingsViewModel(
      scoredGameSettingsRepository: context
          .read<ScoredGameSettingsRepository>(),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _startGame() {
    final settings = _viewModel.createGameSettings();
    if (settings == null) {
      return;
    }

    _viewModel.saveCurrentSettings();
    context.go(Routes.scoreGame, extra: settings);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0.0;

    return AppScaffold(
      toolbarHeight: 64.0,
      leadingWidth: 64.0,
      showDivider: false,
      leading: const Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: HomeIconButton(),
      ),
      title: TitlePill(
        label: context.l10n.pointModeSetupTitle.toUpperCase(),
      ),
      actions: const [SizedBox(width: 64.0)],
      body: PointModeSettingsScreen(
        viewModel: _viewModel,
        onStartGame: _startGame,
        isKeyboardVisible: isKeyboardVisible,
      ),
    );
  }
}
