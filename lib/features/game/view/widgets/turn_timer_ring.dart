import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pantomias/shared/commons.dart';

/// Circular countdown for the active turn. Stroke color shifts by remaining
/// fraction and the whole ring pulses once the turn is about to run out.
class TurnTimerRing extends StatefulWidget {
  const TurnTimerRing({
    super.key,
    required this.remaining,
    required this.total,
  });

  final Duration remaining;
  final Duration total;

  static const _size = 96.0;
  static const _strokeWidth = 8.0;

  @override
  State<TurnTimerRing> createState() => _TurnTimerRingState();
}

class _TurnTimerRingState extends State<TurnTimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  bool get _isUrgent =>
      widget.remaining > Duration.zero && widget.remaining.inSeconds <= 10;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant TurnTimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    // Infinitely repeating animations never let a real reduce-motion user
    // (or WidgetTester.pumpAndSettle) settle, so only loop when allowed.
    if (_isUrgent && !MediaQuery.disableAnimationsOf(context)) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else if (_pulseController.isAnimating) {
      _pulseController
        ..stop()
        ..value = 0.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMillis = widget.total.inMilliseconds;
    final fraction = totalMillis <= 0
        ? 0.0
        : (widget.remaining.inMilliseconds / totalMillis).clamp(0.0, 1.0);
    final ringColor = fraction < 0.25
        ? wrongColor
        : fraction < 0.5
        ? timerAmberColor
        : brandColor;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + 0.08 * _pulseController.value;
        return Transform.scale(scale: scale, child: child);
      },
      child: SizedBox(
        width: TurnTimerRing._size,
        height: TurnTimerRing._size,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: fraction),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) {
            return CustomPaint(
              painter: _RingPainter(progress: value, color: ringColor),
              child: Center(
                child: Text(
                  _formatDuration(widget.remaining),
                  key: const ValueKey('turn-timer-label'),
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    color: ringColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - TurnTimerRing._strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = timerTrackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = TurnTimerRing._strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = TurnTimerRing._strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
