import 'package:flutter/foundation.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';
import 'package:pantomias/data/model/turn_timeout_alert.dart';

import '../game/game_view_model.dart';
import '../point_mode_settings/point_mode_settings_view_model.dart';
import '../quick_start/quick_start_view_model.dart';
import '../result/result_view_model.dart';

enum HomeScreenState { start, quickStart, scoreSetup, scoreGame, scoreResults }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ImageMetaInfoRepository imageMetaInfoRepository,
    required ScoredGameSettingsRepository scoredGameSettingsRepository,
    required TurnTimeoutAlert turnTimeoutAlert,
  }) : quickStartViewModel = QuickStartViewModel(
         imageMetaInfoRepository: imageMetaInfoRepository,
       ),
       pointModeSettingsViewModel = PointModeSettingsViewModel(
         scoredGameSettingsRepository: scoredGameSettingsRepository,
       ),
       gameViewModel = GameViewModel(
         imageMetaInfoRepository: imageMetaInfoRepository,
         turnTimeoutAlert: turnTimeoutAlert,
       ),
       resultViewModel = ResultViewModel();

  final QuickStartViewModel quickStartViewModel;
  final PointModeSettingsViewModel pointModeSettingsViewModel;
  final GameViewModel gameViewModel;
  final ResultViewModel resultViewModel;

  HomeScreenState _screenState = HomeScreenState.start;
  HomeScreenState get screenState => _screenState;

  void showModeSelection() {
    gameViewModel.stop();
    _screenState = HomeScreenState.start;
    notifyListeners();
  }

  void startQuickStart() {
    gameViewModel.stop();
    quickStartViewModel.start();
    _screenState = HomeScreenState.quickStart;
    notifyListeners();
  }

  void startScoredSetup() {
    gameViewModel.stop();
    pointModeSettingsViewModel.resetFromSavedSettings();
    _screenState = HomeScreenState.scoreSetup;
    notifyListeners();
  }

  void startScoredGame() {
    final settings = pointModeSettingsViewModel.createGameSettings();
    if (settings == null) {
      return;
    }

    gameViewModel.start(
      playerNames: settings.playerNames,
      roundLimit: settings.roundLimit,
      turnTimeLimit: settings.turnTimeLimit,
    );
    pointModeSettingsViewModel.saveCurrentSettings();
    _screenState = HomeScreenState.scoreGame;
    notifyListeners();
  }

  void restartScoredGame() {
    if (!gameViewModel.canRestart) {
      startScoredSetup();
      return;
    }

    gameViewModel.restart();
    _screenState = HomeScreenState.scoreGame;
    notifyListeners();
  }

  void markGuessed() {
    _completeScoredTurn(wasGuessed: true);
  }

  void markNotGuessed() {
    _completeScoredTurn(wasGuessed: false);
  }

  void _completeScoredTurn({required bool wasGuessed}) {
    if (_screenState != HomeScreenState.scoreGame) {
      return;
    }

    final isFinished = gameViewModel.completeTurn(wasGuessed: wasGuessed);
    if (isFinished) {
      resultViewModel.showResultsFrom(gameViewModel.players);
      _screenState = HomeScreenState.scoreResults;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    quickStartViewModel.dispose();
    pointModeSettingsViewModel.dispose();
    gameViewModel.dispose();
    resultViewModel.dispose();
    super.dispose();
  }
}
