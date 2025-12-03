import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';

class LoadingProgress extends StatefulWidget {
  final double value;

  const LoadingProgress({
    super.key,
    required this.value,
  });

  @override
  LoadingProgressState createState() => LoadingProgressState();
}

class LoadingProgressState extends State<LoadingProgress> {
  /// value of progress, should be 0.0~1.0.
  double _value = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateProgress(double value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SnackNLoadTheme.indicatorSize,
      height: SnackNLoadTheme.indicatorSize,
      child: _CircleProgress(
        value: _value,
        color: SnackNLoadTheme.progressColor,
        width: SnackNLoadTheme.progressWidth,
      ),
    );
  }
}

class _CircleProgress extends ProgressIndicator {
  @override
  final double value;
  final double width;
  @override
  final Color color;

  const _CircleProgress({
    required this.value,
    required this.width,
    required this.color,
  });

  @override
  __CircleProgressState createState() => __CircleProgressState();
}

class __CircleProgressState extends State<_CircleProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CirclePainter(
        color: widget.color,
        value: widget.value,
        width: widget.width,
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  final double value;
  final double width;

  _CirclePainter({
    required this.color,
    required this.value,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Offset.zero & size,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => value != oldDelegate.value;
}
