import 'package:flutter/material.dart';

import '../game_view_model.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.players,
    required this.activePlayerIndex,
  });

  final List<PlayerScore> players;
  final int activePlayerIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final entry in players.asMap().entries)
          Container(
            key: ValueKey('player-score-chip-${entry.key}'),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: entry.key == activePlayerIndex
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: entry.key == activePlayerIndex
                  ? colorScheme.primaryContainer
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.value.name),
                const SizedBox(width: 8.0),
                Text(
                  '${entry.value.score}',
                  key: ValueKey('player-score-${entry.key}'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
