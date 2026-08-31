import 'package:flutter/foundation.dart';

class ResultPlayerScore {
  const ResultPlayerScore({required this.name, required this.score});

  final String name;
  final int score;
}

class ResultViewModel extends ChangeNotifier {
  ResultViewModel({required List<ResultPlayerScore> players})
    : _players = players;

  final List<ResultPlayerScore> _players;

  List<ResultPlayerScore> get rankedPlayers {
    final rankedPlayers = List<ResultPlayerScore>.of(_players);
    rankedPlayers.sort((first, second) => second.score.compareTo(first.score));
    return rankedPlayers;
  }
}
