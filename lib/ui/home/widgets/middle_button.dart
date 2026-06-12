import 'package:flutter/material.dart';
import 'package:pantomias/ui/shared/commons.dart';

class MiddleButton extends StatelessWidget {
  const MiddleButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF005246),
            offset: Offset(0.0, 8.0),
            blurRadius: 0.0,
          ),
        ],
      ),
      child: FilledButton.icon(
        key: const ValueKey('new-scored-game-button'),
        onPressed: onPressed,
        icon: const Icon(Icons.replay),
        label: const Text('Neues Punktespiel'),
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: brandColor,
          minimumSize: const Size.fromHeight(72.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );
  }
}
