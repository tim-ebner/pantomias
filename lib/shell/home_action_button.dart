import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/routing/routes.dart';

/// The AppBar "back to mode selection" icon shown on every route except
/// the home route itself.
class HomeActionButton extends StatelessWidget {
  const HomeActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('mode-selection-button'),
      tooltip: context.l10n.modeSelectionTooltip,
      onPressed: () => context.go(Routes.home),
      icon: const Icon(Icons.home),
    );
  }
}
