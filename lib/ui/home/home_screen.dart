import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onStartQuickStart,
    required this.onStartScoredSetup,
  });

  final VoidCallback onStartQuickStart;
  final VoidCallback onStartScoredSetup;

  static const _brandColor = Color(0xFF006D5B);
  static const _quickStartColor = Color(0xFF2DDBB7);
  static const _pageBackgroundColor = Color(0xFFF3FBF8);
  static const _tileShadowColor = Color(0xFF005B4C);
  static const _buttonShadowColor = Color(0x33006D5B);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 24.0;
        const topPadding = 18.0;
        const bottomPadding = 28.0;
        const tileGap = 24.0;
        const buttonGap = 16.0;
        const quickStartButtonHeight = 88.0;
        const scoredSetupButtonHeight = 96.0;
        const maxContentWidth = 420.0;

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
            quickStartButtonHeight -
            scoredSetupButtonHeight;
        final tileSize = math.min(contentWidth, math.max(220.0, maxTileHeight));

        return ColoredBox(
          color: _pageBackgroundColor,
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
                    _ModeButton(
                      key: const ValueKey('quick-start-button'),
                      height: quickStartButtonHeight,
                      backgroundColor: _quickStartColor,
                      foregroundColor: _brandColor,
                      shadowColor: _tileShadowColor,
                      icon: Icons.play_circle_outline,
                      label: 'Schnellstart',
                      labelMaxLines: 1,
                      onPressed: onStartQuickStart,
                    ),
                    const SizedBox(height: buttonGap),
                    _ModeButton(
                      key: const ValueKey('scored-setup-button'),
                      height: scoredSetupButtonHeight,
                      backgroundColor: Colors.white,
                      foregroundColor: _brandColor,
                      shadowColor: _buttonShadowColor,
                      icon: Icons.workspace_premium_outlined,
                      label: 'Spiel mit Punkten',
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

  static const _brandColor = HomeScreen._brandColor;
  static const _tileShadowColor = HomeScreen._tileShadowColor;
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
              border: Border.all(color: _brandColor, width: 5.0),
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: const [
                BoxShadow(
                  color: _tileShadowColor,
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
                    color: _brandColor,
                    size: iconSize,
                  ),
                  SizedBox(height: spacing),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Los geht's!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: _brandColor,
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

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    super.key,
    required this.height,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.shadowColor,
    required this.icon,
    required this.label,
    required this.labelMaxLines,
    required this.onPressed,
  });

  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color shadowColor;
  final IconData icon;
  final String label;
  final int labelMaxLines;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0.0, 9.0),
            blurRadius: 0.0,
          ),
          if (backgroundColor == Colors.white)
            const BoxShadow(
              color: Color(0x18006D5B),
              offset: Offset(0.0, 18.0),
              blurRadius: 0.0,
              spreadRadius: -5.0,
            ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(36.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = (constraints.maxWidth * 0.06).clamp(
                  18.0,
                  28.0,
                );
                final sideSpacing = (constraints.maxWidth * 0.055).clamp(
                  16.0,
                  24.0,
                );
                final iconSize = (constraints.maxWidth * 0.11).clamp(
                  34.0,
                  42.0,
                );
                final chevronSize = (constraints.maxWidth * 0.095).clamp(
                  30.0,
                  36.0,
                );
                final labelFontSize = (constraints.maxWidth * 0.064).clamp(
                  20.0,
                  28.0,
                );
                final labelStyle = Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(
                      color: foregroundColor,
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.0,
                      height: 1.08,
                    );
                final labelText = Text(
                  label,
                  maxLines: labelMaxLines,
                  overflow: labelMaxLines == 1
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  softWrap: labelMaxLines > 1,
                  textAlign: TextAlign.center,
                  style: labelStyle,
                );

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    children: [
                      Icon(icon, color: foregroundColor, size: iconSize),
                      SizedBox(width: sideSpacing),
                      Expanded(
                        child: labelMaxLines == 1
                            ? FittedBox(fit: BoxFit.scaleDown, child: labelText)
                            : labelText,
                      ),
                      SizedBox(width: sideSpacing),
                      Icon(
                        Icons.chevron_right,
                        color: foregroundColor,
                        size: chevronSize,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
