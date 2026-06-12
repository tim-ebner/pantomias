import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/game_screen.dart';
import '../point_mode_settings/point_mode_settings_screen.dart';
import '../quick_start/quick_start_screen.dart';
import '../result/result_screen.dart';
import 'home_screen.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const _titleBarBackgroundColor = Color(0xFFF3FBF8);
  static const _titleBarDividerColor = Color(0xFFE3ECE8);
  static const _brandColor = Color(0xFF006D5B);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: _titleBarBackgroundColor,
            foregroundColor: _brandColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            centerTitle: viewModel.screenState != HomeScreenState.scoreGame,
            toolbarHeight: viewModel.screenState == HomeScreenState.scoreGame
                ? 112.0
                : 80.0,
            titleSpacing: viewModel.screenState == HomeScreenState.scoreGame
                ? 24.0
                : NavigationToolbar.kMiddleSpacing,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: _titleBarBackgroundColor,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            shape: const Border(
              bottom: BorderSide(color: _titleBarDividerColor),
            ),
            iconTheme: const IconThemeData(color: _brandColor, size: 32.0),
            actionsIconTheme: const IconThemeData(
              color: _brandColor,
              size: 32.0,
            ),
            title: _buildAppBarTitle(),
            actions: [
              if (viewModel.screenState != HomeScreenState.start)
                IconButton(
                  key: const ValueKey('mode-selection-button'),
                  tooltip: 'Modusauswahl',
                  onPressed: viewModel.showModeSelection,
                  icon: const Icon(Icons.home),
                ),
            ],
          ),
          body: SafeArea(child: _buildBody()),
          floatingActionButton:
              viewModel.screenState == HomeScreenState.quickStart
              ? FloatingActionButton(
                  key: const ValueKey('quick-next-button'),
                  onPressed: viewModel.quickStartViewModel.nextImage,
                  child: const Icon(Icons.navigate_next),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody() {
    return switch (viewModel.screenState) {
      HomeScreenState.start => HomeScreen(
        onStartQuickStart: viewModel.startQuickStart,
        onStartScoredSetup: viewModel.startScoredSetup,
      ),
      HomeScreenState.quickStart => QuickStartScreen(
        viewModel: viewModel.quickStartViewModel,
      ),
      HomeScreenState.scoreSetup => PointModeSettingsScreen(
        viewModel: viewModel.pointModeSettingsViewModel,
        onStartGame: viewModel.startScoredGame,
      ),
      HomeScreenState.scoreGame => GameScreen(
        viewModel: viewModel.gameViewModel,
        onNotGuessed: viewModel.markNotGuessed,
        onGuessed: viewModel.markGuessed,
      ),
      HomeScreenState.scoreResults => ResultScreen(
        viewModel: viewModel.resultViewModel,
        onRestartGame: viewModel.restartScoredGame,
        onShowModeSelection: viewModel.showModeSelection,
      ),
    };
  }

  Widget _buildAppBarTitle() {
    if (viewModel.screenState == HomeScreenState.scoreGame) {
      return ListenableBuilder(
        listenable: viewModel.gameViewModel,
        builder: (context, child) {
          final activePlayer = viewModel.gameViewModel.activePlayer;
          if (activePlayer == null) {
            return const SizedBox.shrink();
          }

          final roundLabel = viewModel.gameViewModel.roundLimit == null
              ? 'Runde ${viewModel.gameViewModel.currentRound}'
              : 'Runde ${viewModel.gameViewModel.currentRound} von ${viewModel.gameViewModel.roundLimit}';

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
                  color: Color(0xFF243B34),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Am Zug: ${activePlayer.name}',
                key: const ValueKey('active-player-label'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _brandColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          );
        },
      );
    }

    return const Text(
      'Pantomias',
      style: TextStyle(
        color: _brandColor,
        fontSize: 40.0,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: 0.0,
      ),
    );
  }
}
