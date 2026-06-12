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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final roundLimitField = _NumberSetupField(
                        key: const ValueKey('round-limit-field'),
                        initialValue: viewModel.roundLimitText,
                        labelText: 'Runden (optional)',
                        errorText: viewModel.isRoundLimitValid
                            ? null
                            : 'Bitte positive Rundenzahl eingeben',
                        onChanged: viewModel.updateRoundLimit,
                        textInputAction: TextInputAction.next,
                      );
                      final turnTimeLimitField = _NumberSetupField(
                        key: const ValueKey('turn-time-limit-field'),
                        initialValue: viewModel.turnTimeLimitText,
                        labelText: 'Zeit in Minuten (optional)',
                        errorText: viewModel.isTurnTimeLimitValid
                            ? null
                            : 'Bitte positive Minutenzahl eingeben',
                        onChanged: viewModel.updateTurnTimeLimit,
                      );

                      if (constraints.maxWidth < 460.0) {
                        return Column(
                          children: [
                            roundLimitField,
                            const SizedBox(height: 12.0),
                            turnTimeLimitField,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: roundLimitField),
                          const SizedBox(width: 12.0),
                          Expanded(child: turnTimeLimitField),
                        ],
                      );
                    },
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

class _NumberSetupField extends StatelessWidget {
  const _NumberSetupField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    this.textInputAction = TextInputAction.done,
  });

  final String initialValue;
  final String labelText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        errorText: errorText,
        labelText: labelText,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      textInputAction: textInputAction,
    );
  }
}
