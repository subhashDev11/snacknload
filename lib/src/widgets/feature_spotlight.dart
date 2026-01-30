import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Shape of the spotlight highlight
enum SpotlightShape {
  circle,
  rectangle,
  roundedRectangle,
}

/// Position of the tooltip relative to spotlight
enum SpotlightTooltipPosition {
  top,
  bottom,
  left,
  right,
  auto,
}

/// Configuration for a single spotlight
class SpotlightConfig {
  /// Unique identifier
  final String id;

  /// Global key of the widget to highlight
  final GlobalKey targetKey;

  /// Title of the spotlight
  final String title;

  /// Description text
  final String description;

  /// Icon to show in tooltip
  final IconData? icon;

  /// Shape of the highlight
  final SpotlightShape shape;

  /// Tooltip position
  final SpotlightTooltipPosition tooltipPosition;

  /// Background color of tooltip
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Whether to show pulse animation
  final bool showPulse;

  /// Padding around the highlighted widget
  final double padding;

  /// Duration to show before auto-dismissing (null = manual)
  final Duration? autoDismissDuration;

  /// Callback when shown
  final VoidCallback? onShow;

  /// Callback when dismissed
  final VoidCallback? onDismiss;

  const SpotlightConfig({
    required this.id,
    required this.targetKey,
    required this.title,
    required this.description,
    this.icon,
    this.shape = SpotlightShape.roundedRectangle,
    this.tooltipPosition = SpotlightTooltipPosition.auto,
    this.backgroundColor,
    this.textColor,
    this.showPulse = true,
    this.padding = 8.0,
    this.autoDismissDuration,
    this.onShow,
    this.onDismiss,
  });
}

/// Feature spotlight overlay widget
class FeatureSpotlight extends StatefulWidget {
  /// Spotlight configuration
  final SpotlightConfig config;

  /// Callback when dismissed
  final VoidCallback onDismiss;

  /// Overlay color
  final Color? overlayColor;

  /// Overlay opacity
  final double overlayOpacity;

  /// Whether to use blur effect
  final bool useBlur;

  const FeatureSpotlight({
    super.key,
    required this.config,
    required this.onDismiss,
    this.overlayColor,
    this.overlayOpacity = 0.8,
    this.useBlur = true,
  });

  @override
  State<FeatureSpotlight> createState() => _FeatureSpotlightState();
}

class _FeatureSpotlightState extends State<FeatureSpotlight>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  Timer? _autoDismissTimer;
  Offset? _targetPosition;
  Size? _targetSize;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTargetPosition();
      _fadeController.forward();
      widget.config.onShow?.call();
      _startAutoDismissTimer();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  void _updateTargetPosition() {
    setState(() {
      final RenderBox? renderBox = widget.config.targetKey.currentContext
          ?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        _targetPosition = renderBox.localToGlobal(Offset.zero);
        _targetSize = renderBox.size;
      }
    });
  }

  void _startAutoDismissTimer() {
    final duration = widget.config.autoDismissDuration;
    if (duration != null) {
      _autoDismissTimer = Timer(duration, _dismiss);
    }
  }

  void _dismiss() {
    _fadeController.reverse().then((_) {
      widget.config.onDismiss?.call();
      widget.onDismiss();
    });
  }

  SpotlightTooltipPosition _calculateBestPosition() {
    if (widget.config.tooltipPosition != SpotlightTooltipPosition.auto) {
      return widget.config.tooltipPosition;
    }

    if (_targetPosition == null || _targetSize == null) {
      return SpotlightTooltipPosition.bottom;
    }

    final screenSize = MediaQuery.of(context).size;
    final targetCenter = _targetPosition! +
        Offset(_targetSize!.width / 2, _targetSize!.height / 2);

    final spaceBottom = screenSize.height - targetCenter.dy;
    final spaceTop = targetCenter.dy;

    return spaceBottom > spaceTop
        ? SpotlightTooltipPosition.bottom
        : SpotlightTooltipPosition.top;
  }

  @override
  Widget build(BuildContext context) {
    if (_targetPosition == null || _targetSize == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        onTap: _dismiss,
        child: Stack(
          children: [
            // Overlay background
            Positioned.fill(
              child: widget.useBlur
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: (widget.overlayColor ?? Colors.black)
                            .withValues(alpha: widget.overlayOpacity),
                      ),
                    )
                  : Container(
                      color: (widget.overlayColor ?? Colors.black)
                          .withValues(alpha: widget.overlayOpacity),
                    ),
            ),

            // Spotlight cutout with pulse
            CustomPaint(
              painter: _SpotlightPainter(
                targetRect: Rect.fromLTWH(
                  _targetPosition!.dx - widget.config.padding,
                  _targetPosition!.dy - widget.config.padding,
                  _targetSize!.width + (widget.config.padding * 2),
                  _targetSize!.height + (widget.config.padding * 2),
                ),
                shape: widget.config.shape,
                showPulse: widget.config.showPulse,
                pulseAnimation: _pulseController,
              ),
              child: Container(),
            ),

            // Tooltip
            _buildTooltip(_calculateBestPosition()),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltip(SpotlightTooltipPosition position) {
    const padding = 16.0;
    double? top, bottom, left, right;

    final screenWidth = MediaQuery.of(context).size.width;

    switch (position) {
      case SpotlightTooltipPosition.top:
        bottom = MediaQuery.of(context).size.height -
            _targetPosition!.dy +
            widget.config.padding +
            padding;
        left = (_targetPosition!.dx + (_targetSize!.width / 2) - 150)
            .clamp(padding, screenWidth - 300 - padding);
        break;
      case SpotlightTooltipPosition.bottom:
        top = _targetPosition!.dy +
            _targetSize!.height +
            widget.config.padding +
            padding;
        left = (_targetPosition!.dx + (_targetSize!.width / 2) - 150)
            .clamp(padding, screenWidth - 300 - padding);
        break;
      case SpotlightTooltipPosition.left:
        right = MediaQuery.of(context).size.width -
            _targetPosition!.dx +
            widget.config.padding +
            padding;
        top = _targetPosition!.dy + (_targetSize!.height / 2) - 75;
        break;
      case SpotlightTooltipPosition.right:
        left = _targetPosition!.dx +
            _targetSize!.width +
            widget.config.padding +
            padding;
        top = _targetPosition!.dy + (_targetSize!.height / 2) - 75;
        break;
      default:
        top = _targetPosition!.dy +
            _targetSize!.height +
            widget.config.padding +
            padding;
        left = (_targetPosition!.dx + (_targetSize!.width / 2) - 150)
            .clamp(padding, screenWidth - 300 - padding);
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: _DefaultTooltip(config: widget.config),
    );
  }
}

/// Default tooltip widget
class _DefaultTooltip extends StatelessWidget {
  final SpotlightConfig config;

  const _DefaultTooltip({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: config.backgroundColor ?? const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              if (config.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    config.icon,
                    color: config.textColor ?? Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  config.title,
                  style: TextStyle(
                    color: config.textColor ?? Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            config.description,
            style: TextStyle(
              color: (config.textColor ?? Colors.white).withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Got it button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Will be handled by parent
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Got it!',
                style: TextStyle(
                  color: config.textColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for spotlight effect
class _SpotlightPainter extends CustomPainter {
  final Rect targetRect;
  final SpotlightShape shape;
  final bool showPulse;
  final Animation<double> pulseAnimation;

  _SpotlightPainter({
    required this.targetRect,
    required this.shape,
    required this.showPulse,
    required this.pulseAnimation,
  }) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    // Draw cutout based on shape
    switch (shape) {
      case SpotlightShape.circle:
        final center = targetRect.center;
        final radius = (targetRect.width > targetRect.height
                ? targetRect.width
                : targetRect.height) /
            2;
        canvas.drawCircle(center, radius, paint);
        break;
      case SpotlightShape.rectangle:
        canvas.drawRect(targetRect, paint);
        break;
      case SpotlightShape.roundedRectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(targetRect, const Radius.circular(12)),
          paint,
        );
        break;
    }

    // Draw pulse effect
    if (showPulse) {
      final pulsePaint = Paint()
        ..color =
            Colors.white.withValues(alpha: 0.3 * (1 - pulseAnimation.value))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final pulseExpansion = 12 * pulseAnimation.value;

      switch (shape) {
        case SpotlightShape.circle:
          final center = targetRect.center;
          final radius = (targetRect.width > targetRect.height
                  ? targetRect.width
                  : targetRect.height) /
              2;
          canvas.drawCircle(center, radius + pulseExpansion, pulsePaint);
          break;
        case SpotlightShape.rectangle:
          canvas.drawRect(targetRect.inflate(pulseExpansion), pulsePaint);
          break;
        case SpotlightShape.roundedRectangle:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              targetRect.inflate(pulseExpansion),
              Radius.circular(12 + pulseExpansion),
            ),
            pulsePaint,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) {
    return targetRect != oldDelegate.targetRect ||
        shape != oldDelegate.shape ||
        showPulse != oldDelegate.showPulse;
  }
}
