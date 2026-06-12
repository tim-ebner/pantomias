import 'package:flutter/material.dart';

import 'result_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.viewModel,
    required this.onRestartGame,
    required this.onShowModeSelection,
  });

  final ResultViewModel viewModel;
  final VoidCallback onRestartGame;
  final VoidCallback onShowModeSelection;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ergebnis',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24.0),
                  for (final entry in viewModel.rankedPlayers.asMap().entries)
                    ListTile(
                      leading: Text('${entry.key + 1}.'),
                      title: Text(entry.value.name),
                      trailing: Text(_scoreLabel(entry.value.score)),
                    ),
                  const SizedBox(height: 24.0),
                  FilledButton.icon(
                    key: const ValueKey('new-scored-game-button'),
                    onPressed: onRestartGame,
                    icon: const Icon(Icons.replay),
                    label: const Text('Neues Punktespiel'),
                  ),
                  const SizedBox(height: 12.0),
                  OutlinedButton.icon(
                    key: const ValueKey('back-to-mode-selection-button'),
                    onPressed: onShowModeSelection,
                    icon: const Icon(Icons.home),
                    label: const Text('Modusauswahl'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _scoreLabel(int score) {
    return score == 1 ? '1 Punkt' : '$score Punkte';
  }
}
