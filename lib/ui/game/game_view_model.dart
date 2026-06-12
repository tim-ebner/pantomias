import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/turn_timeout_alert.dart';

import '../shared/image_stage/image_deck_view_model.dart';

class PlayerScore {
  PlayerScore({required this.name, this.score = 0});

  final String name;
  int score;
}

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required ImageMetaInfoRepository imageMetaInfoRepository,
    required TurnTimeoutAlert turnTimeoutAlert,
  }) : _turnTimeoutAlert = turnTimeoutAlert,
       imageDeckViewModel = ImageDeckViewModel(
         imageMetaInfoRepository: imageMetaInfoRepository,
       );

  final TurnTimeoutAlert _turnTimeoutAlert;
  final ImageDeckViewModel imageDeckViewModel;

  List<PlayerScore> _players = [];
  List<PlayerScore> get players => List.unmodifiable(_players);

  int _activePlayerIndex = 0;
  int get activePlayerIndex => _activePlayerIndex;
  PlayerScore? get activePlayer =>
      _players.isEmpty ? null : _players[_activePlayerIndex];

  int _completedTurns = 0;
  int get completedTurns => _completedTurns;

  int? _roundLimit;
  int? get roundLimit => _roundLimit;

  Duration? _turnTimeLimit;
  Duration? get turnTimeLimit => _turnTimeLimit;

  Duration? _remainingTurnTime;
  Duration? get remainingTurnTime => _remainingTurnTime;

  Timer? _turnTimer;
  bool _hasPlayedTimeoutAlert = false;

  int get currentRound {
    if (_players.isEmpty) {
      return 1;
    }

    return (_completedTurns ~/ _players.length) + 1;
  }

  int? get totalTurns =>
      _roundLimit == null ? null : _roundLimit! * _players.length;

  bool get canRestart => _players.length >= 2;

  List<PlayerScore> get rankedPlayers {
    final rankedPlayers = List<PlayerScore>.of(_players);
    rankedPlayers.sort((first, second) => second.score.compareTo(first.score));
    return rankedPlayers;
  }

  void start({
    required List<String> playerNames,
    required int? roundLimit,
    required Duration? turnTimeLimit,
  }) {
    _turnTimer?.cancel();
    _players = playerNames
        .map((playerName) => PlayerScore(name: playerName))
        .toList();
    _activePlayerIndex = 0;
    _completedTurns = 0;
    _roundLimit = roundLimit;
    _turnTimeLimit = turnTimeLimit;
    imageDeckViewModel.start();
    _resetTurnTimer();
    notifyListeners();
  }

  void restart() {
    if (!canRestart) {
      return;
    }

    final playerNames = _players.map((player) => player.name).toList();
    start(
      playerNames: playerNames,
      roundLimit: _roundLimit,
      turnTimeLimit: _turnTimeLimit,
    );
  }

  void stop() {
    _turnTimer?.cancel();
    _turnTimer = null;
    _turnTimeLimit = null;
    _remainingTurnTime = null;
    _hasPlayedTimeoutAlert = false;
    notifyListeners();
  }

  bool completeTurn({required bool wasGuessed}) {
    if (_players.isEmpty) {
      return false;
    }

    _turnTimer?.cancel();
    _turnTimer = null;

    if (wasGuessed) {
      _players[_activePlayerIndex].score += 1;
    }

    _completedTurns += 1;
    final isFinished = _roundLimit != null && _completedTurns >= totalTurns!;
    if (!isFinished) {
      _activePlayerIndex = (_activePlayerIndex + 1) % _players.length;
      imageDeckViewModel.nextImage(revealImage: true);
      _resetTurnTimer();
    } else {
      _remainingTurnTime = null;
      _hasPlayedTimeoutAlert = false;
    }

    notifyListeners();
    return isFinished;
  }

  void _resetTurnTimer() {
    _turnTimer?.cancel();
    _turnTimer = null;
    _remainingTurnTime = _turnTimeLimit;
    _hasPlayedTimeoutAlert = false;

    final turnTimeLimit = _turnTimeLimit;
    if (turnTimeLimit == null || turnTimeLimit <= Duration.zero) {
      return;
    }

    _turnTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickTurnTimer(),
    );
  }

  void _tickTurnTimer() {
    final remainingTurnTime = _remainingTurnTime;
    if (remainingTurnTime == null) {
      return;
    }

    final nextRemainingTurnTime =
        remainingTurnTime - const Duration(seconds: 1);
    if (nextRemainingTurnTime <= Duration.zero) {
      _remainingTurnTime = Duration.zero;
      _turnTimer?.cancel();
      _turnTimer = null;
      _playTimeoutAlert();
    } else {
      _remainingTurnTime = nextRemainingTurnTime;
    }

    notifyListeners();
  }

  void _playTimeoutAlert() {
    if (_hasPlayedTimeoutAlert) {
      return;
    }

    _hasPlayedTimeoutAlert = true;
    unawaited(
      _turnTimeoutAlert.play().catchError((Object error, StackTrace stack) {}),
    );
  }

  @override
  void dispose() {
    _turnTimer?.cancel();
    imageDeckViewModel.dispose();
    super.dispose();
  }
}
