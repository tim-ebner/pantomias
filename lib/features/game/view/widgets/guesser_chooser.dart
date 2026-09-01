import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

import '../../viewmodel/game_view_model.dart';

/// Overlay shown in `winnerNext` mode after "Erraten" is tapped, letting the
/// active player pick who guessed the word correctly.
class GuesserChooser extends StatelessWidget {
  const GuesserChooser({
    super.key,
    required this.players,
    required this.activePlayerIndex,
    required this.onPick,
  });

  final List<PlayerScore> players;
  final int activePlayerIndex;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: pageBackgroundColor.withValues(alpha: 0.97),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.whoGuessedLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: brandColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  for (final entry in players.asMap().entries)
                    if (entry.key != activePlayerIndex)
                      _GuesserOption(
                        key: ValueKey('guesser-option-${entry.key}'),
                        name: entry.value.name,
                        onTap: () => onPick(entry.key),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuesserOption extends StatelessWidget {
  const _GuesserOption({super.key, required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  static const _avatarSize = 30.0;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999.0),
        side: const BorderSide(color: quickStartColor, width: 2.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _avatarSize,
                height: _avatarSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: brandColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: scorePillInactiveTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
