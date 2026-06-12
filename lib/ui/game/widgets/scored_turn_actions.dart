import 'package:flutter/material.dart';

class ScoredTurnActions extends StatelessWidget {
  const ScoredTurnActions({
    super.key,
    required this.onNotGuessed,
    required this.onGuessed,
  });

  final VoidCallback onNotGuessed;
  final VoidCallback onGuessed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final wrongColor = Colors.red.shade700;
    final correctColor = colorScheme.primary;
    const gap = 24.0;

    final notGuessedButton = _ScoreActionButton(
      key: const ValueKey('not-guessed-button'),
      label: 'Falsch',
      icon: Icons.close,
      foregroundColor: wrongColor,
      backgroundColor: colorScheme.surface,
      borderColor: wrongColor,
      onPressed: onNotGuessed,
    );
    final guessedButton = _ScoreActionButton(
      key: const ValueKey('guessed-button'),
      label: 'Erraten',
      icon: Icons.check_circle_outline,
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: correctColor,
      onPressed: onGuessed,
    );

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 320.0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  notGuessedButton,
                  const SizedBox(height: 16.0),
                  guessedButton,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: notGuessedButton),
                const SizedBox(width: gap),
                Expanded(child: guessedButton),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScoreActionButton extends StatelessWidget {
  const _ScoreActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed,
    this.borderColor,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Color? borderColor;

  static const _height = 132.0;
  static const _borderRadius = 30.0;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w800,
    );
    final borderRadius = BorderRadius.circular(_borderRadius);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 3.0),
          borderRadius: borderRadius,
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: SizedBox(
            height: _height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: 42.0),
                const SizedBox(height: 18.0),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
