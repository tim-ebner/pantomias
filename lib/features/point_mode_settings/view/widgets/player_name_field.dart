import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

import '../../viewmodel/point_mode_settings_view_model.dart';
import 'point_mode_input_style.dart';

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

  static const _avatarSize = 38.0;
  static const _removeButtonSize = 34.0;

  @override
  Widget build(BuildContext context) {
    final trimmedName = player.name.trim();
    final avatarInitial = trimmedName.isNotEmpty
        ? trimmedName[0].toUpperCase()
        : playerNumber.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: pointModeCardBorderColor, width: 2.5),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
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
              avatarInitial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextFormField(
              key: ValueKey('player-name-field-${player.id}'),
              initialValue: player.name,
              cursorColor: brandColor,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: pointModeTextColor,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: context.l10n.playerLabel(playerNumber),
                hintStyle: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  color: pointModeFieldBorderColor,
                ),
              ),
              onChanged: (name) => onChanged(player.id, name),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 4.0),
          _RemoveButton(
            buttonKey: ValueKey('remove-player-button-${player.id}'),
            tooltip: context.l10n.removePlayerTooltip,
            onPressed: canRemove ? () => onRemove(player.id) : null,
          ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({
    required this.buttonKey,
    required this.tooltip,
    required this.onPressed,
  });

  final Key buttonKey;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          child: SizedBox(
            width: PlayerNameField._removeButtonSize,
            height: PlayerNameField._removeButtonSize,
            child: Icon(
              Icons.close_rounded,
              size: 18.0,
              color: onPressed == null
                  ? pointModeFieldBorderColor
                  : pointModeErrorColor,
            ),
          ),
        ),
      ),
    );
  }
}
