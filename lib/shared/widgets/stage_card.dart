import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

enum StageFeedback { correct, wrong, expired }

/// The main tappable stage: shows the hidden placeholder or the revealed
/// prompt, and overlays a themed result (with confetti / shake) once a turn
/// has been resolved.
class StageCard extends StatelessWidget {
  const StageCard({
    super.key,
    required this.isRevealed,
    required this.promptWord,
    required this.imageAssetPath,
    required this.feedback,
    required this.onTap,
    this.overlay,
  });

  final bool isRevealed;
  final String promptWord;
  final String? imageAssetPath;
  final StageFeedback? feedback;
  final VoidCallback? onTap;

  /// Painted above everything else, including the feedback overlay — used
  /// for transient in-stage UI like the winner-next guesser chooser.
  final Widget? overlay;

  static const _borderRadius = 36.0;
  static const _borderWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return _ShakeWrapper(
      feedback: feedback,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: brandColor, width: _borderWidth),
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: const [
              BoxShadow(
                color: tileShadowColor,
                offset: Offset(0.0, 12.0),
                spreadRadius: -4.0,
              ),
            ],
          ),
          // Container's own clip follows the border's outer radius, so a
          // full-bleed child (like the feedback overlay) would still paint
          // with square corners inside the curve. Clip to the border's
          // *inner* radius instead, matching the content Container already
          // insets by _borderWidth.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius - _borderWidth),
            child: Stack(
              fit: StackFit.expand,
              children: [
                isRevealed
                    ? _RevealedContent(
                        word: promptWord,
                        imageAssetPath: imageAssetPath,
                      )
                    : const _HiddenContent(),
                if (feedback != null)
                  KeyedSubtree(
                    key: ValueKey(feedback),
                    child: _FeedbackOverlay(feedback: feedback!),
                  ),
                _ConfettiLayer(feedback: feedback),
                if (overlay != null) overlay!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HiddenContent extends StatelessWidget {
  const _HiddenContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110.0,
            height: 110.0,
            decoration: const BoxDecoration(
              color: pageBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility_outlined,
              size: 48.0,
              color: brandColor,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            l10n.imageHiddenLabel,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w900,
              color: brandColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            l10n.stageHiddenHelperLabel,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: stageHelperTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevealedContent extends StatelessWidget {
  const _RevealedContent({required this.word, required this.imageAssetPath});

  final String word;
  final String? imageAssetPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return _ShrinkToFitHeadline(
                word: word,
                maxWidth: constraints.maxWidth,
              );
            },
          ),
          const SizedBox(height: 16.0),
          if (imageAssetPath != null)
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280.0),
                child: Image.asset(imageAssetPath!, fit: BoxFit.contain),
              ),
            ),
          const SizedBox(height: 16.0),
          Text(
            l10n.stageRevealedHelperLabel,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: stageHelperTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders [word] as large as possible on a single line within
/// [maxWidth], shrinking the font size from [_maxFontSize] down to
/// [_minFontSize]. If even the minimum size doesn't fit on one line,
/// falls back to [_minFontSize] with a wrapped second line and an
/// ellipsis for anything beyond that.
class _ShrinkToFitHeadline extends StatelessWidget {
  const _ShrinkToFitHeadline({required this.word, required this.maxWidth});

  final String word;
  final double maxWidth;

  static const _maxFontSize = 44.0;
  static const _minFontSize = 24.0;
  static const _fontSizeStep = 2.0;
  static const _fontWeight = FontWeight.w900;
  static const _lineHeight = 1.05;

  TextStyle _styleFor(double fontSize) => const TextStyle(
    fontWeight: _fontWeight,
    color: brandColor,
    height: _lineHeight,
  ).copyWith(fontSize: fontSize);

  /// Largest font size in [_minFontSize].._maxFontSize] at which [word]
  /// fits on a single line within [maxWidth], or `null` if even
  /// [_minFontSize] doesn't fit on one line.
  double? _resolveSingleLineFontSize(TextScaler textScaler) {
    final steps = ((_maxFontSize - _minFontSize) / _fontSizeStep).floor();
    for (var i = 0; i <= steps; i++) {
      final fontSize = _maxFontSize - i * _fontSizeStep;
      final painter = TextPainter(
        text: TextSpan(text: word, style: _styleFor(fontSize)),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout(maxWidth: maxWidth);
      if (!painter.didExceedMaxLines) {
        return fontSize;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final singleLineFontSize = _resolveSingleLineFontSize(textScaler);

    return Text(
      word,
      maxLines: singleLineFontSize != null ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: _styleFor(singleLineFontSize ?? _minFontSize),
    );
  }
}

class _FeedbackOverlay extends StatelessWidget {
  const _FeedbackOverlay({required this.feedback});

  final StageFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (Color color, IconData icon, String label) = switch (feedback) {
      StageFeedback.correct => (
        brandColor,
        Icons.check_rounded,
        l10n.turnGuessedFeedbackLabel,
      ),
      StageFeedback.wrong => (
        wrongColor,
        Icons.close_rounded,
        l10n.notGuessedLabel,
      ),
      StageFeedback.expired => (
        timerAmberColor,
        Icons.access_time_rounded,
        l10n.timeExpiredLabel,
      ),
    };

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.4 + 0.6 * value, child: child),
        );
      },
      child: ColoredBox(
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78.0,
                height: 78.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40.0, color: color),
              ),
              const SizedBox(height: 10.0),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shakes its child once when [feedback] transitions to [StageFeedback.wrong].
class _ShakeWrapper extends StatefulWidget {
  const _ShakeWrapper({required this.feedback, required this.child});

  final StageFeedback? feedback;
  final Widget child;

  @override
  State<_ShakeWrapper> createState() => _ShakeWrapperState();
}

class _ShakeWrapperState extends State<_ShakeWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 9.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 9.0, end: -6.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 4.0), weight: 20.0),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 20.0),
    ]).animate(_controller);
    if (widget.feedback == StageFeedback.wrong) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant _ShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.feedback == StageFeedback.wrong &&
        oldWidget.feedback != StageFeedback.wrong) {
      _controller.forward(from: 0.0);
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
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offset.value, 0.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Bursts ~10 confetti dots outward from the center once [feedback]
/// transitions to [StageFeedback.correct].
class _ConfettiLayer extends StatefulWidget {
  const _ConfettiLayer({required this.feedback});

  final StageFeedback? feedback;

  @override
  State<_ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<_ConfettiLayer>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    quickStartColor,
    Color(0xFFFFCA24),
    brandColor,
    accentColor,
  ];

  late final AnimationController _controller;
  List<_ConfettiParticle> _particles = const [];
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 700),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() => _active = false);
          }
        });
    if (widget.feedback == StageFeedback.correct) {
      _burst();
    }
  }

  @override
  void didUpdateWidget(covariant _ConfettiLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.feedback == StageFeedback.correct &&
        oldWidget.feedback != StageFeedback.correct) {
      _burst();
    }
  }

  void _burst() {
    _particles = List.generate(10, (i) {
      final angle = (i / 10) * 2 * math.pi;
      final distance = 70.0 + (i % 3) * 20.0;
      return _ConfettiParticle(
        color: _colors[i % _colors.length],
        target: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
      );
    });
    _active = true;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final opacity = (t < 0.15 ? t / 0.15 : 1.0 - (t - 0.15) / 0.85).clamp(
            0.0,
            1.0,
          );
          return Stack(
            children: [
              for (final particle in _particles)
                Positioned.fill(
                  child: Align(
                    child: Transform.translate(
                      offset: particle.target * t,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: particle.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  const _ConfettiParticle({required this.color, required this.target});

  final Color color;
  final Offset target;
}
