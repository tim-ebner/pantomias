import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

class ScoredTurnActions extends StatelessWidget {
  const ScoredTurnActions({
    super.key,
    required this.onNotGuessed,
    required this.onGuessed,
    this.enabled = true,
  });

  final VoidCallback onNotGuessed;
  final VoidCallback onGuessed;
  final bool enabled;

  static const _height = 76.0;
  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              key: const ValueKey('not-guessed-button'),
              label: l10n.notGuessedLabel,
              icon: Icons.close_rounded,
              foregroundColor: wrongColor,
              backgroundColor: Colors.white,
              borderColor: wrongColor,
              onPressed: enabled ? onNotGuessed : null,
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: _ActionButton(
              key: const ValueKey('guessed-button'),
              label: l10n.guessedLabel,
              icon: Icons.check_rounded,
              foregroundColor: Colors.white,
              backgroundColor: brandColor,
              shadowColor: tileShadowColor,
              onPressed: enabled ? onGuessed : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed,
    this.borderColor,
    this.shadowColor,
  });

  final String label;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      ScoredTurnActions._borderRadius,
    );
    final shadowColor = this.shadowColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadowColor == null
            ? null
            : [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0.0, 6.0),
                  spreadRadius: -1.0,
                ),
              ],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: Container(
            height: ScoredTurnActions._height,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: 3.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: 24.0),
                const SizedBox(height: 4.0),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
