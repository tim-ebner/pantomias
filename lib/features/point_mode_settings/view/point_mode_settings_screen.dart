import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/widgets/next_button.dart';
import 'package:pantomias/shared/commons.dart';

import '../viewmodel/point_mode_settings_view_model.dart';
import 'widgets/player_name_field.dart';
import 'widgets/point_mode_input_style.dart';

class PointModeSettingsScreen extends StatelessWidget {
  const PointModeSettingsScreen({
    super.key,
    required this.viewModel,
    required this.onStartGame,
    required this.isKeyboardVisible,
  });

  final PointModeSettingsViewModel viewModel;
  final VoidCallback onStartGame;
  final bool isKeyboardVisible;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final startGameButton = NextButton(
          key: const ValueKey('start-scored-game-button'),
          icon: Icons.play_arrow_rounded,
          label: l10n.startGameLabel,
          labelMaxLines: 2,
          onPressed: viewModel.canStartScoredGame ? onStartGame : null,
        );
        final formContent = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.scoredGameModeLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24.0),
            for (final entry in viewModel.setupPlayers.asMap().entries) ...[
              PlayerNameField(
                player: entry.value,
                playerNumber: entry.key + 1,
                canRemove: viewModel.canRemoveSetupPlayer,
                onChanged: viewModel.updateSetupPlayerName,
                onRemove: viewModel.removeSetupPlayer,
              ),
              if (entry.key < viewModel.setupPlayers.length - 1)
                const SizedBox(height: 12.0),
            ],
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const ValueKey('add-player-button'),
                style: TextButton.styleFrom(
                  foregroundColor: brandColor,
                  textStyle: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.0,
                  ),
                ),
                onPressed: viewModel.addSetupPlayer,
                icon: const Icon(Icons.add, size: 20.0),
                label: Text(l10n.addPlayerLabel),
              ),
            ),
            const SizedBox(height: 16.0),
            LayoutBuilder(
              builder: (context, constraints) {
                final roundLimitField = _SteppedSetupField(
                  key: const ValueKey('round-limit-field'),
                  initialValue: viewModel.roundLimitText,
                  labelText: l10n.roundsOptionalLabel,
                  hintText: '∞',
                  errorText: viewModel.isRoundLimitValid
                      ? null
                      : l10n.positiveRoundsError,
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
                  labelText: l10n.timeOptionalLabel,
                  hintText: '∞',
                  errorText: viewModel.isTurnTimeLimitValid
                      ? null
                      : l10n.positiveTimeError,
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
          ],
        );

        return ColoredBox(
          color: pageBackgroundColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  isKeyboardVisible ? 0.0 : bottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: isKeyboardVisible ? 0.0 : 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            formContent,
                            if (isKeyboardVisible) ...[
                              const SizedBox(height: 24.0),
                              startGameButton,
                              const SizedBox(height: bottomPadding),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!isKeyboardVisible) startGameButton,
                  ],
                ),
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
    this.hintText,
    this.inputFormatters,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
  });

  final String initialValue;
  final String labelText;
  final String? hintText;
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: pointModeCardBorderColor, width: 2.5),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              color: pointModeLabelColor,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  cursorColor: brandColor,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                    color: pointModeTextColor,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                      color: pointModeFieldBorderColor,
                    ),
                  ),
                  inputFormatters:
                      widget.inputFormatters ??
                      [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  textInputAction: widget.textInputAction,
                ),
              ),
              const SizedBox(width: 6.0),
              _StepControlButton(
                buttonKey: widget.decrementButtonKey,
                tooltip: context.l10n.decreaseTooltip,
                icon: Icons.remove,
                onPressed: widget.onDecrement,
              ),
              const SizedBox(width: 6.0),
              _StepControlButton(
                buttonKey: widget.incrementButtonKey,
                tooltip: context.l10n.increaseTooltip,
                icon: Icons.add,
                onPressed: widget.onIncrement,
              ),
            ],
          ),
          if (widget.errorText != null) ...[
            const SizedBox(height: 6.0),
            Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: pointModeErrorColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepControlButton extends StatelessWidget {
  const _StepControlButton({
    required this.buttonKey,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final Key buttonKey;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: pageBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: const BorderSide(color: pointModeFieldBorderColor, width: 2.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          child: SizedBox(
            width: 36.0,
            height: 36.0,
            child: Icon(icon, color: brandColor, size: 18.0),
          ),
        ),
      ),
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
