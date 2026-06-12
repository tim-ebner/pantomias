import 'package:flutter/foundation.dart';

import '../game/game_view_model.dart';

class ResultPlayerScore {
  const ResultPlayerScore({required this.name, required this.score});

  final String name;
  final int score;
}

class ResultViewModel extends ChangeNotifier {
  List<ResultPlayerScore> _players = [];

  List<ResultPlayerScore> get rankedPlayers {
    final rankedPlayers = List<ResultPlayerScore>.of(_players);
    rankedPlayers.sort((first, second) => second.score.compareTo(first.score));
    return rankedPlayers;
  }

  void showResultsFrom(List<PlayerScore> players) {
    _players = players
        .map(
          (player) => ResultPlayerScore(name: player.name, score: player.score),
        )
        .toList();
    notifyListeners();
  }
}
