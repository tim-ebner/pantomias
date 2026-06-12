import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pantomias/ui/home/widgets/next_button.dart';
import 'package:pantomias/ui/shared/commons.dart';

import 'result_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.viewModel,
    required this.onRestartGame,
  });

  final ResultViewModel viewModel;
  final VoidCallback onRestartGame;

  static const _backgroundColor = Color(0xFFF3FBF8);
  static const _winnerScoreColor = Color(0xFF00745D);
  static const _mutedTextColor = Color(0xFF6B7A74);
  static const _rankTextColor = Color(0xFFB5CAC2);
  static const _softBorderColor = Color(0xFF8CECDF);
  static const _quietBorderColor = Color(0xFFDDE6E2);
  static const _winnerBadgeColor = Color(0xFFFFCA24);
  static const _winnerBadgeTextColor = Color(0xFF685710);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final rankedPlayers = viewModel.rankedPlayers;

        return ColoredBox(
          color: _backgroundColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minContentHeight = constraints.maxHeight - 32.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 560.0,
                      minHeight: minContentHeight > 0.0
                          ? minContentHeight
                          : 0.0,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Ergebnis',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: brandColor,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: 0.0,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          const Text(
                            'Super gespielt! Alle sind Gewinner!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _mutedTextColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              letterSpacing: 0.0,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          if (rankedPlayers.isNotEmpty) ...[
                            _WinnerCard(
                              player: rankedPlayers.first,
                              scoreLabel: _scoreLabel(
                                rankedPlayers.first.score,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            for (final entry
                                in rankedPlayers
                                    .skip(1)
                                    .toList()
                                    .asMap()
                                    .entries)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _RankedPlayerCard(
                                  player: entry.value,
                                  rank: entry.key + 2,
                                  scoreLabel: _scoreLabel(entry.value.score),
                                ),
                              ),
                          ],
                          const SizedBox(height: 20.0),
                          const Spacer(),
                          NextButton(
                            key: const ValueKey('new-scored-game-button'),
                            icon: Icons.replay,
                            label: 'Neues Punktespiel',
                            labelMaxLines: 2,
                            onPressed: onRestartGame,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _scoreLabel(int score) {
    return '$score Pkt';
  }
}

class _WinnerCard extends StatefulWidget {
  const _WinnerCard({required this.player, required this.scoreLabel});

  final ResultPlayerScore player;
  final String scoreLabel;

  @override
  State<_WinnerCard> createState() => _WinnerCardState();
}

class _WinnerCardState extends State<_WinnerCard> {
  static const _praiseMessages = [
    'Souveräner Auftritt!',
    'Super Spiel!',
    'Beschde!',
    'Geil Geil Geil!',
    'Abgeliefert!',
    'Päääm!',
  ];

  late String _praiseMessage;

  @override
  void initState() {
    super.initState();
    _praiseMessage = _randomPraiseMessage();
  }

  @override
  void didUpdateWidget(_WinnerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player != widget.player) {
      _praiseMessage = _randomPraiseMessage();
    }
  }

  String _randomPraiseMessage() {
    return _praiseMessages[Random().nextInt(_praiseMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12.0),
          padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: accentColor, width: 2.0),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26.0,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      _praiseMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ResultScreen._mutedTextColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              _WinnerScorePill(label: widget.scoreLabel),
            ],
          ),
        ),
        const Positioned(top: 0.0, child: _WinnerBadge()),
      ],
    );
  }
}

class _WinnerBadge extends StatelessWidget {
  const _WinnerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: ResultScreen._winnerBadgeColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: const Text(
        '1. PLATZ',
        style: TextStyle(
          color: ResultScreen._winnerBadgeTextColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
          height: 1.0,
          letterSpacing: 0.0,
        ),
      ),
    );
  }
}

class _WinnerScorePill extends StatelessWidget {
  const _WinnerScorePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66.0,
      height: 66.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ResultScreen._winnerScoreColor,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
          height: 1.0,
          letterSpacing: 0.0,
        ),
      ),
    );
  }
}

class _RankedPlayerCard extends StatelessWidget {
  const _RankedPlayerCard({
    required this.player,
    required this.rank,
    required this.scoreLabel,
  });

  final ResultPlayerScore player;
  final int rank;
  final String scoreLabel;

  @override
  Widget build(BuildContext context) {
    final borderColor = rank == 2
        ? ResultScreen._softBorderColor
        : ResultScreen._quietBorderColor;
    final scoreColor = rank == 2 ? brandColor : ResultScreen._mutedTextColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '$rank. PLATZ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ResultScreen._rankTextColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Text(
            scoreLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scoreColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              height: 1.0,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
