import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pantomias/ui/home/widgets/next_button.dart';

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
                      final roundLimitField = _SteppedSetupField(
                        key: const ValueKey('round-limit-field'),
                        initialValue: viewModel.roundLimitText,
                        labelText: 'Runden (optional)',
                        errorText: viewModel.isRoundLimitValid
                            ? null
                            : 'Bitte positive Rundenzahl eingeben',
                        onChanged: viewModel.updateRoundLimit,
                        onDecrement: viewModel.decrementRoundLimit,
                        onIncrement: viewModel.incrementRoundLimit,
                        decrementButtonKey: const ValueKey(
                          'round-limit-decrement-button',
                        ),
                        incrementButtonKey: const ValueKey(
                          'round-limit-increment-button',
                        ),
                        textInputAction: TextInputAction.next,
                      );
                      final turnTimeLimitField = _SteppedSetupField(
                        key: const ValueKey('turn-time-limit-field'),
                        initialValue: viewModel.turnTimeLimitText,
                        labelText: 'Zeit (Min:Sek, optional)',
                        errorText: viewModel.isTurnTimeLimitValid
                            ? null
                            : 'Bitte positive Zeit eingeben',
                        onChanged: viewModel.updateTurnTimeLimit,
                        onDecrement: viewModel.decrementTurnTimeLimit,
                        onIncrement: viewModel.incrementTurnTimeLimit,
                        decrementButtonKey: const ValueKey(
                          'turn-time-limit-decrement-button',
                        ),
                        incrementButtonKey: const ValueKey(
                          'turn-time-limit-increment-button',
                        ),
                        inputFormatters: [_DurationInputFormatter()],
                        keyboardType: TextInputType.datetime,
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
                  NextButton(
                    key: const ValueKey('start-scored-game-button'),
                    icon: Icons.flag,
                    label: 'Spiel starten',
                    labelMaxLines: 2,
                    onPressed: viewModel.canStartScoredGame
                        ? onStartGame
                        : () {},
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

class _SteppedSetupField extends StatefulWidget {
  const _SteppedSetupField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    required this.onDecrement,
    required this.onIncrement,
    required this.decrementButtonKey,
    required this.incrementButtonKey,
    this.inputFormatters,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
  });

  final String initialValue;
  final String labelText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Key decrementButtonKey;
  final Key incrementButtonKey;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  State<_SteppedSetupField> createState() => _SteppedSetupFieldState();
}

class _SteppedSetupFieldState extends State<_SteppedSetupField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _SteppedSetupField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.initialValue,
        selection: TextSelection.collapsed(offset: widget.initialValue.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        errorText: widget.errorText,
        labelText: widget.labelText,
        prefixIcon: IconButton(
          key: widget.decrementButtonKey,
          tooltip: 'Verringern',
          onPressed: widget.onDecrement,
          icon: const Icon(Icons.remove),
        ),
        suffixIcon: IconButton(
          key: widget.incrementButtonKey,
          tooltip: 'Erhöhen',
          onPressed: widget.onIncrement,
          icon: const Icon(Icons.add),
        ),
      ),
      inputFormatters:
          widget.inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
    );
  }
}

class _DurationInputFormatter extends TextInputFormatter {
  static final _durationPattern = RegExp(r'^\d*(?::\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_durationPattern.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
