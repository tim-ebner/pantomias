import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const _titleBarBackgroundColor = Color(0xFFF3FBF8);
  static const _titleBarDividerColor = Color(0xFFE3ECE8);
  static const _brandColor = Color(0xFF006D5B);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: _titleBarBackgroundColor,
            foregroundColor: _brandColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            toolbarHeight: 80.0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: _titleBarBackgroundColor,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            shape: const Border(
              bottom: BorderSide(color: _titleBarDividerColor),
            ),
            iconTheme: const IconThemeData(color: _brandColor, size: 32.0),
            actionsIconTheme: const IconThemeData(
              color: _brandColor,
              size: 32.0,
            ),
            title: const Text(
              'Pantomias',
              style: TextStyle(
                color: _brandColor,
                fontSize: 40.0,
                fontWeight: FontWeight.w900,
                height: 1.0,
                letterSpacing: 0.0,
              ),
            ),
            actions: [
              if (viewModel.screenState != HomeScreenState.start)
                IconButton(
                  key: const ValueKey('mode-selection-button'),
                  tooltip: 'Modusauswahl',
                  onPressed: viewModel.showModeSelection,
                  icon: const Icon(Icons.home),
                ),
            ],
          ),
          body: SafeArea(child: _buildBody(context)),
          floatingActionButton:
              viewModel.screenState == HomeScreenState.quickStart
              ? FloatingActionButton(
                  key: const ValueKey('quick-next-button'),
                  onPressed: viewModel.nextImage,
                  child: const Icon(Icons.navigate_next),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return switch (viewModel.screenState) {
      HomeScreenState.start => _buildModeSelection(context),
      HomeScreenState.quickStart => _buildQuickStart(context),
      HomeScreenState.scoreSetup => _buildScoreSetup(context),
      HomeScreenState.scoreGame => _buildScoreGame(context),
      HomeScreenState.scoreResults => _buildScoreResults(context),
    };
  }

  Widget _buildModeSelection(BuildContext context) {
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
                onPressed: viewModel.startQuickStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Schnellstart'),
              ),
              const SizedBox(height: 12.0),
              OutlinedButton.icon(
                key: const ValueKey('scored-setup-button'),
                onPressed: viewModel.startScoredSetup,
                icon: const Icon(Icons.emoji_events),
                label: const Text('Spiel mit Punkten'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildImageStage(context),
    );
  }

  Widget _buildScoreSetup(BuildContext context) {
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
              for (final entry in viewModel.setupPlayers.asMap().entries) ...[
                _PlayerNameField(
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
                    ? viewModel.startScoredGame
                    : null,
                icon: const Icon(Icons.flag),
                label: const Text('Spiel starten'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreGame(BuildContext context) {
    final activePlayer = viewModel.activePlayer;
    if (activePlayer == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            viewModel.roundLimit == null
                ? 'Runde ${viewModel.currentRound}'
                : 'Runde ${viewModel.currentRound} von ${viewModel.roundLimit}',
            key: const ValueKey('round-label'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6.0),
          Text(
            'Am Zug: ${activePlayer.name}',
            key: const ValueKey('active-player-label'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12.0),
          _ScoreBoard(
            players: viewModel.players,
            activePlayerIndex: viewModel.activePlayerIndex,
          ),
          const SizedBox(height: 16.0),
          Expanded(child: _buildImageStage(context)),
          const SizedBox(height: 16.0),
          _ScoredTurnActions(
            onNotGuessed: viewModel.markNotGuessed,
            onGuessed: viewModel.markGuessed,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreResults(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ergebnis',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24.0),
              for (final entry in viewModel.rankedPlayers.asMap().entries)
                ListTile(
                  leading: Text('${entry.key + 1}.'),
                  title: Text(entry.value.name),
                  trailing: Text(_scoreLabel(entry.value.score)),
                ),
              const SizedBox(height: 24.0),
              FilledButton.icon(
                key: const ValueKey('new-scored-game-button'),
                onPressed: viewModel.restartScoredGame,
                icon: const Icon(Icons.replay),
                label: const Text('Neues Punktespiel'),
              ),
              const SizedBox(height: 12.0),
              OutlinedButton.icon(
                key: const ValueKey('back-to-mode-selection-button'),
                onPressed: viewModel.showModeSelection,
                icon: const Icon(Icons.home),
                label: const Text('Modusauswahl'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageStage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            viewModel.imageName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: Center(
            child: Image.asset(viewModel.imageAssetPath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 16.0),
        IconButton.filledTonal(
          key: const ValueKey('toggle-image-button'),
          tooltip: viewModel.isImageShown ? 'Bild ausblenden' : 'Bild anzeigen',
          onPressed: viewModel.toggleImage,
          icon: viewModel.toggleIcon,
        ),
      ],
    );
  }

  String _scoreLabel(int score) {
    return score == 1 ? '1 Punkt' : '$score Punkte';
  }
}

class _ScoredTurnActions extends StatelessWidget {
  const _ScoredTurnActions({
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

class _PlayerNameField extends StatelessWidget {
  const _PlayerNameField({
    required this.player,
    required this.playerNumber,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final SetupPlayerDraft player;
  final int playerNumber;
  final bool canRemove;
  final void Function(int playerId, String name) onChanged;
  final void Function(int playerId) onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey('player-name-field-${player.id}'),
            initialValue: player.name,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Spieler $playerNumber',
            ),
            onChanged: (name) => onChanged(player.id, name),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          key: ValueKey('remove-player-button-${player.id}'),
          tooltip: 'Spieler entfernen',
          onPressed: canRemove ? () => onRemove(player.id) : null,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

class _ScoreBoard extends StatelessWidget {
  const _ScoreBoard({required this.players, required this.activePlayerIndex});

  final List<PlayerScore> players;
  final int activePlayerIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final entry in players.asMap().entries)
          Container(
            key: ValueKey('player-score-chip-${entry.key}'),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: entry.key == activePlayerIndex
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: entry.key == activePlayerIndex
                  ? colorScheme.primaryContainer
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.value.name),
                const SizedBox(width: 8.0),
                Text(
                  '${entry.value.score}',
                  key: ValueKey('player-score-${entry.key}'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
