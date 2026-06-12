import 'package:flutter/material.dart';

import '../point_mode_settings_view_model.dart';

class PlayerNameField extends StatelessWidget {
  const PlayerNameField({
    super.key,
    required this.player,
    required this.playerNumber,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final SetupPlayerDraft player;
  final int playerNumber;
  final bool canRemove;
  final void Function(int playerId, String name) onChanged;
  final void Function(int playerId) onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey('player-name-field-${player.id}'),
            initialValue: player.name,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Spieler $playerNumber',
            ),
            onChanged: (name) => onChanged(player.id, name),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          key: ValueKey('remove-player-button-${player.id}'),
          tooltip: 'Spieler entfernen',
          onPressed: canRemove ? () => onRemove(player.id) : null,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
