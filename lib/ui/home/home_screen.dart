import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/ui/home/widgets/next_button.dart';
import 'package:pantomias/ui/shared/commons.dart';

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
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = math.min(
          maxContentWidth,
          math.max(0.0, constraints.maxWidth - horizontalPadding * 2),
        );
        final maxTileHeight =
            constraints.maxHeight -
            topPadding -
            bottomPadding -
            tileGap -
            buttonGap -
            nextButtonHeight -
            nextButtonHeight;
        final tileSize = math.min(contentWidth, math.max(220.0, maxTileHeight));

        return ColoredBox(
          color: pageBackgroundColor,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StartTile(size: tileSize),
                    const SizedBox(height: tileGap),
                    NextButton(
                      key: const ValueKey('quick-start-button'),
                      shadowColor: tileShadowColor,
                      icon: Icons.play_circle_outline,
                      label: l10n.quickStartLabel,
                      onPressed: onStartQuickStart,
                    ),
                    const SizedBox(height: buttonGap),
                    NextButton(
                      key: const ValueKey('scored-setup-button'),
                      backgroundColor: Colors.white,
                      shadowColor: buttonShadowColor,
                      icon: Icons.workspace_premium_outlined,
                      label: l10n.scoredGameModeLabel,
                      labelMaxLines: 2,
                      onPressed: onStartScoredSetup,
                    ),
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

class _StartTile extends StatefulWidget {
  const _StartTile({required this.size});

  final double size;

  @override
  State<_StartTile> createState() => _StartTileState();
}

class _StartTileState extends State<_StartTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _opacity;

  static const _minimumOpacity = 0.50;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: _minimumOpacity,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: _minimumOpacity,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 1.0,
      ),
    ]).animate(_fadeController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _syncAnimation() {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final shouldAnimate = TickerMode.valuesOf(context).enabled && !reduceMotion;

    if (shouldAnimate) {
      if (!_fadeController.isAnimating) {
        _fadeController.repeat();
      }
    } else {
      _fadeController.stop();
      _fadeController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = (widget.size * 0.32).clamp(72.0, 112.0);
    final spacing = (widget.size * 0.08).clamp(16.0, 28.0);
    final padding = (widget.size * 0.09).clamp(22.0, 32.0);

    return Align(
      child: FadeTransition(
        opacity: _opacity,
        child: SizedBox.square(
          dimension: widget.size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: brandColor, width: 5.0),
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: const [
                BoxShadow(
                  color: tileShadowColor,
                  offset: Offset(0.0, 10.0),
                  spreadRadius: -1.0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.theater_comedy_outlined,
                    color: brandColor,
                    size: iconSize,
                  ),
                  SizedBox(height: spacing),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      context.l10n.startTileTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: brandColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
