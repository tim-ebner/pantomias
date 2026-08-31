import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shared/commons.dart';

/// Circular "back to mode selection" button shown in the header of every
/// route except the home route itself, styled to match the redesign.
class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.modeSelectionTooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: brandColor, width: 2.5),
        ),
        child: InkWell(
          key: const ValueKey('mode-selection-button'),
          customBorder: const CircleBorder(),
          onTap: () => context.go(Routes.home),
          child: const SizedBox(
            width: 44.0,
            height: 44.0,
            child: Icon(Icons.home, color: brandColor, size: 22.0),
          ),
        ),
      ),
    );
  }
}
