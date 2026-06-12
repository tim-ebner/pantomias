import 'package:flutter/foundation.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';

import '../shared/image_stage/image_deck_view_model.dart';

class PlayerScore {
  PlayerScore({required this.name, this.score = 0});

  final String name;
  int score;
}

class GameViewModel extends ChangeNotifier {
  GameViewModel({required ImageMetaInfoRepository imageMetaInfoRepository})
    : imageDeckViewModel = ImageDeckViewModel(
        imageMetaInfoRepository: imageMetaInfoRepository,
      );

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

  void start({required List<String> playerNames, required int? roundLimit}) {
    _players = playerNames
        .map((playerName) => PlayerScore(name: playerName))
        .toList();
    _activePlayerIndex = 0;
    _completedTurns = 0;
    _roundLimit = roundLimit;
    imageDeckViewModel.start();
    notifyListeners();
  }

  void restart() {
    if (!canRestart) {
      return;
    }

    final playerNames = _players.map((player) => player.name).toList();
    start(playerNames: playerNames, roundLimit: _roundLimit);
  }

  bool completeTurn({required bool wasGuessed}) {
    if (_players.isEmpty) {
      return false;
    }

    if (wasGuessed) {
      _players[_activePlayerIndex].score += 1;
    }

    _completedTurns += 1;
    final isFinished = _roundLimit != null && _completedTurns >= totalTurns!;
    if (!isFinished) {
      _activePlayerIndex = (_activePlayerIndex + 1) % _players.length;
      imageDeckViewModel.nextImage(revealImage: true);
    }

    notifyListeners();
    return isFinished;
  }

  @override
  void dispose() {
    imageDeckViewModel.dispose();
    super.dispose();
  }
}
