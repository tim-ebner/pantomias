import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'point_mode_settings_view_model.dart';
import 'widgets/player_name_field.dart';

class PointModeSettingsScreen extends StatelessWidget {
  const PointModeSettingsScreen({
    super.key,
    required this.viewModel,
    required this.onStartGame,
  });

  final PointModeSettingsViewModel viewModel;
  final VoidCallback onStartGame;

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
                    'Spiel mit Punkten',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24.0),
                  for (final entry
                      in viewModel.setupPlayers.asMap().entries) ...[
                    PlayerNameField(
                      player: entry.value,
                      playerNumber: entry.key + 1,
                      canRemove: viewModel.canRemoveSetupPlayer,
                      onChanged: viewModel.updateSetupPlayerName,
                      onRemove: viewModel.removeSetupPlayer,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: const ValueKey('add-player-button'),
                      onPressed: viewModel.addSetupPlayer,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Spieler hinzufügen'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: const ValueKey('round-limit-field'),
                    initialValue: viewModel.roundLimitText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: viewModel.isRoundLimitValid
                          ? null
                          : 'Bitte positive Rundenzahl eingeben',
                      labelText: 'Runden (optional)',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onChanged: viewModel.updateRoundLimit,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24.0),
                  FilledButton.icon(
                    key: const ValueKey('start-scored-game-button'),
                    onPressed: viewModel.canStartScoredGame
                        ? onStartGame
                        : null,
                    icon: const Icon(Icons.flag),
                    label: const Text('Spiel starten'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
