import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

import '../../viewmodel/game_view_model.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.players,
    required this.activePlayerIndex,
  });

  final List<PlayerScore> players;
  final int activePlayerIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final entry in players.asMap().entries)
          _ScorePill(
            key: ValueKey('player-score-chip-${entry.key}'),
            scoreKey: ValueKey('player-score-${entry.key}'),
            name: entry.value.name,
            score: entry.value.score,
            isActive: entry.key == activePlayerIndex,
          ),
      ],
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({
    super.key,
    required this.scoreKey,
    required this.name,
    required this.score,
    required this.isActive,
  });

  final Key scoreKey;
  final String name;
  final int score;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 16.0 : 14.0,
        vertical: isActive ? 9.0 : 7.0,
      ),
      decoration: BoxDecoration(
        color: isActive ? brandColor : Colors.white,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: isActive ? brandColor : scorePillInactiveBorderColor,
          width: 2.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90.0),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isActive ? 15.0 : 13.0,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : scorePillInactiveTextColor,
              ),
            ),
          ),
          const SizedBox(width: 6.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9.0,
              vertical: 1.0,
            ),
            decoration: BoxDecoration(
              color: isActive ? quickStartColor : pageBackgroundColor,
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Text(
              '$score',
              key: scoreKey,
              style: TextStyle(
                fontSize: isActive ? 15.0 : 13.0,
                fontWeight: FontWeight.w900,
                color: isActive ? brandColor : scorePillInactiveTextColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (!isActive) {
      return pill;
    }

    return Semantics(
      key: const ValueKey('active-player-pill'),
      label: context.l10n.activePlayerLabel(name),
      child: _PulsingGlow(child: pill),
    );
  }
}

/// Soft pulsing glow ring drawn behind the active player's pill to draw the
/// eye to whose turn it is.
class _PulsingGlow extends StatefulWidget {
  const _PulsingGlow({required this.child});

  final Widget child;

  @override
  State<_PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<_PulsingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Infinitely repeating animations never let a real reduce-motion user
    // (or WidgetTester.pumpAndSettle) settle, so only loop when allowed.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.0),
            boxShadow: [
              BoxShadow(
                color: quickStartColor.withValues(alpha: 0.55 * (1 - t)),
                spreadRadius: 8.0 * t,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
