import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onStartQuickStart,
    required this.onStartScoredSetup,
  });

  final VoidCallback onStartQuickStart;
  final VoidCallback onStartScoredSetup;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pantomias',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 32.0),
              FilledButton.icon(
                key: const ValueKey('quick-start-button'),
                onPressed: onStartQuickStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Schnellstart'),
              ),
              const SizedBox(height: 12.0),
              OutlinedButton.icon(
                key: const ValueKey('scored-setup-button'),
                onPressed: onStartScoredSetup,
                icon: const Icon(Icons.emoji_events),
                label: const Text('Spiel mit Punkten'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
