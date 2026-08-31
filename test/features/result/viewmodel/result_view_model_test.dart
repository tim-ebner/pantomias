import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/features/result/viewmodel/result_view_model.dart';

void main() {
  test('rankedPlayers sorts players by score descending', () {
    final viewModel = ResultViewModel(
      players: const [
        ResultPlayerScore(name: 'Alice', score: 1),
        ResultPlayerScore(name: 'Bob', score: 3),
        ResultPlayerScore(name: 'Cara', score: 2),
      ],
    );

    expect(
      viewModel.rankedPlayers.map((player) => player.name),
      ['Bob', 'Cara', 'Alice'],
    );
  });

  test('rankedPlayers is empty when there are no players', () {
    final viewModel = ResultViewModel(players: const []);

    expect(viewModel.rankedPlayers, isEmpty);
  });
}
