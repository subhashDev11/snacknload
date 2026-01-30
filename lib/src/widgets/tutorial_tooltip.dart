import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Position of the tooltip relative to the target widget
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  auto, // Automatically determines best position
}

/// Shape of the tooltip container
enum TooltipShape {
  rectangle,
  roundedRectangle,
  balloon,
}

/// Configuration for a single tutorial step
class TutorialStep {
  /// Unique identifier for this step
  final String id;

  /// Title of the tutorial step
  final String title;

  /// Description/content of the tutorial step
  final String description;

  /// Global key of the widget to highlight
  final GlobalKey targetKey;

  /// Position of the tooltip relative to target
  final TooltipPosition position;

  /// Custom widget to show instead of default tooltip
  final Widget? customTooltip;

  /// Whether to show a pulsing animation on the target
  final bool showPulse;

  /// Whether to allow tapping outside to dismiss
  final bool dismissOnTapOutside;

  /// Callback when this step is shown
  final VoidCallback? onShow;

  /// Callback when this step is completed
  final VoidCallback? onComplete;

  /// Custom background color for the tooltip
  final Color? backgroundColor;

  /// Custom text color for the tooltip
  final Color? textColor;

  /// Icon to show in the tooltip
  final IconData? icon;

  /// Whether to show skip button
  final bool showSkipButton;

  /// Whether to show next button
  final bool showNextButton;

  /// Custom next button text
  final String? nextButtonText;

  /// Custom skip button text
  final String? skipButtonText;

  /// Duration to auto-advance to next step (null = manual)
  final Duration? autoAdvanceDuration;

  /// Whether to advance to next step when tapping the target
  final bool advanceOnTapTarget;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetKey,
    this.position = TooltipPosition.auto,
    this.customTooltip,
    this.showPulse = true,
    this.dismissOnTapOutside = false,
    this.onShow,
    this.onComplete,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.showSkipButton = true,
    this.showNextButton = true,
    this.nextButtonText,
    this.skipButtonText,
    this.autoAdvanceDuration,
    this.advanceOnTapTarget = true,
  });
}

/// Controller for managing tutorial flow
class TutorialController {
  final List<TutorialStep> steps;
  int _currentStepIndex = 0;
  final _onCompleteController = StreamController<void>.broadcast();
  final _onStepChangeController = StreamController<int>.broadcast();

  TutorialController({required this.steps});

  /// Current step index
  int get currentStepIndex => _currentStepIndex;

  /// Current step
  TutorialStep get currentStep => steps[_currentStepIndex];

  /// Whether this is the first step
  bool get isFirstStep => _currentStepIndex == 0;

  /// Whether this is the last step
  bool get isLastStep => _currentStepIndex == steps.length - 1;

  /// Total number of steps
  int get totalSteps => steps.length;

  /// Stream that emits when tutorial is completed
  Stream<void> get onComplete => _onCompleteController.stream;

  /// Stream that emits when step changes
  Stream<int> get onStepChange => _onStepChangeController.stream;

  /// Move to next step
  void next() {
    if (!isLastStep) {
      currentStep.onComplete?.call();
      _currentStepIndex++;
      _onStepChangeController.add(_currentStepIndex);
      currentStep.onShow?.call();
    } else {
      complete();
    }
  }

  /// Move to previous step
  void previous() {
    if (!isFirstStep) {
      _currentStepIndex--;
      _onStepChangeController.add(_currentStepIndex);
      currentStep.onShow?.call();
    }
  }

  /// Skip to a specific step
  void goToStep(int index) {
    if (index >= 0 && index < steps.length) {
      currentStep.onComplete?.call();
      _currentStepIndex = index;
      _onStepChangeController.add(_currentStepIndex);
      currentStep.onShow?.call();
    }
  }

  /// Complete the tutorial
  void complete() {
    currentStep.onComplete?.call();
    _onCompleteController.add(null);
  }

  /// Reset to first step
  void reset() {
    _currentStepIndex = 0;
    _onStepChangeController.add(_currentStepIndex);
  }

  void dispose() {
    _onCompleteController.close();
    _onStepChangeController.close();
  }
}

/// Overlay widget that displays the tutorial
class TutorialOverlay extends StatefulWidget {
  final TutorialController controller;
  final VoidCallback onComplete;
  final Color? overlayColor;
  final double? overlayOpacity;
  final bool useBlur;
  final Duration animationDuration;

  const TutorialOverlay({
    super.key,
    required this.controller,
    required this.onComplete,
    this.overlayColor,
    this.overlayOpacity,
    this.useBlur = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  Timer? _autoAdvanceTimer;
  StreamSubscription? _stepChangeSubscription;
  StreamSubscription? _completeSubscription;
  Offset? _targetPosition;
  Size? _targetSize;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Listen to step changes
    _stepChangeSubscription = widget.controller.onStepChange.listen((_) {
      if (mounted) {
        _updateTargetPosition();
        _startAutoAdvanceTimer();
      }
    });

    // Listen to completion
    _completeSubscription = widget.controller.onComplete.listen((_) {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted) widget.onComplete();
        });
      }
    });

    // Initial setup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateTargetPosition();
        _fadeController.forward();
        _startAutoAdvanceTimer();
        widget.controller.currentStep.onShow?.call();
      }
    });
  }

  @override
  void dispose() {
    _stepChangeSubscription?.cancel();
    _completeSubscription?.cancel();
    _fadeController.dispose();
    _pulseController.dispose();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _updateTargetPosition() {
    setState(() {
      final RenderBox? renderBox = widget
          .controller.currentStep.targetKey.currentContext
          ?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        _targetPosition = renderBox.localToGlobal(Offset.zero);
        _targetSize = renderBox.size;
      }
    });
  }

  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    final duration = widget.controller.currentStep.autoAdvanceDuration;
    if (duration != null) {
      _autoAdvanceTimer = Timer(duration, () {
        if (mounted) {
          widget.controller.next();
        }
      });
    }
  }

  TooltipPosition _calculateBestPosition() {
    if (widget.controller.currentStep.position != TooltipPosition.auto) {
      return widget.controller.currentStep.position;
    }

    if (_targetPosition == null || _targetSize == null) {
      return TooltipPosition.bottom;
    }

    final screenSize = MediaQuery.of(context).size;
    final targetCenter = _targetPosition! +
        Offset(_targetSize!.width / 2, _targetSize!.height / 2);

    // Determine best position based on available space
    final spaceTop = targetCenter.dy;
    final spaceBottom = screenSize.height - targetCenter.dy;
    final spaceLeft = targetCenter.dx;
    final spaceRight = screenSize.width - targetCenter.dx;

    if (spaceBottom > spaceTop && spaceBottom > 200) {
      return TooltipPosition.bottom;
    } else if (spaceTop > 200) {
      return TooltipPosition.top;
    } else if (spaceRight > spaceLeft && spaceRight > 200) {
      return TooltipPosition.right;
    } else {
      return TooltipPosition.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_targetPosition == null || _targetSize == null) {
      return const SizedBox.shrink();
    }

    final step = widget.controller.currentStep;
    final position = _calculateBestPosition();

    return FadeTransition(
      opacity: _fadeController,
      child: Stack(
        children: [
          // 1. Clipped Background (Blur + Color overlay)
          // ClipPath with evenOdd fillType creates a hole
          ClipPath(
            clipper: _HoleClipper(Rect.fromLTWH(
              _targetPosition!.dx,
              _targetPosition!.dy,
              _targetSize!.width,
              _targetSize!.height,
            )),
            child: GestureDetector(
              onTap: step.dismissOnTapOutside
                  ? () => widget.controller.complete()
                  : null,
              child: Container(
                color: (widget.overlayColor ?? Colors.black)
                    .withValues(alpha: widget.overlayOpacity ?? 0.7),
                child: widget.useBlur
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // 2. Target Tap Handler
          Positioned(
            left: _targetPosition!.dx,
            top: _targetPosition!.dy,
            width: _targetSize!.width,
            height: _targetSize!.height,
            child: GestureDetector(
              onTap: step.advanceOnTapTarget
                  ? () => widget.controller.next()
                  : null,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(),
            ),
          ),

          // 3. Pulse Effect (Visual on top of overlay)
          if (step.showPulse)
            IgnorePointer(
              child: CustomPaint(
                painter: _HighlightPainter(
                  targetRect: Rect.fromLTWH(
                    _targetPosition!.dx,
                    _targetPosition!.dy,
                    _targetSize!.width,
                    _targetSize!.height,
                  ),
                  showPulse: true,
                  pulseAnimation: _pulseController,
                  isHole: false, // Pulse only
                ),
                child: Container(),
              ),
            ),

          // 4. Tooltip
          _buildTooltip(position),
        ],
      ),
    );
  }

  Widget _buildTooltip(TooltipPosition position) {
    final step = widget.controller.currentStep;

    if (step.customTooltip != null) {
      return _positionTooltip(step.customTooltip!, position);
    }

    return _positionTooltip(
      _DefaultTooltip(
        step: step,
        controller: widget.controller,
      ),
      position,
    );
  }

  Widget _positionTooltip(Widget tooltip, TooltipPosition position) {
    const padding = 16.0;
    const arrowSize = 12.0;

    double? top, bottom, left, right;

    switch (position) {
      case TooltipPosition.top:
        bottom = MediaQuery.of(context).size.height -
            _targetPosition!.dy +
            padding +
            arrowSize;
        left = _targetPosition!.dx + (_targetSize!.width / 2) - 150;
        break;
      case TooltipPosition.bottom:
        top = _targetPosition!.dy + _targetSize!.height + padding + arrowSize;
        left = _targetPosition!.dx + (_targetSize!.width / 2) - 150;
        break;
      case TooltipPosition.left:
        right = MediaQuery.of(context).size.width -
            _targetPosition!.dx +
            padding +
            arrowSize;
        top = _targetPosition!.dy + (_targetSize!.height / 2) - 75;
        break;
      case TooltipPosition.right:
        left = _targetPosition!.dx + _targetSize!.width + padding + arrowSize;
        top = _targetPosition!.dy + (_targetSize!.height / 2) - 75;
        break;
      default:
        top = _targetPosition!.dy + _targetSize!.height + padding + arrowSize;
        left = _targetPosition!.dx + (_targetSize!.width / 2) - 150;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left?.clamp(
          padding, MediaQuery.of(context).size.width - 300 - padding),
      right: right,
      child: tooltip,
    );
  }
}

/// Default tooltip widget
class _DefaultTooltip extends StatelessWidget {
  final TutorialStep step;
  final TutorialController controller;

  const _DefaultTooltip({
    required this.step,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = step.backgroundColor ?? theme.colorScheme.primary;
    final contentColor = step.textColor ?? theme.colorScheme.onPrimary;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and step counter
          Row(
            children: [
              if (step.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: contentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    step.icon,
                    color: contentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: contentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.currentStepIndex + 1}/${controller.totalSteps}',
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            step.description,
            style: TextStyle(
              color: contentColor.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (controller.currentStepIndex + 1) / controller.totalSteps,
              backgroundColor: contentColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                contentColor,
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (step.showSkipButton)
                TextButton(
                  onPressed: () => controller.complete(),
                  child: Text(
                    step.skipButtonText ?? 'Skip',
                    style: TextStyle(
                      color: contentColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              if (!controller.isFirstStep)
                TextButton.icon(
                  onPressed: () => controller.previous(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: contentColor,
                    size: 18,
                  ),
                  label: Text(
                    'Back',
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              if (step.showNextButton)
                ElevatedButton.icon(
                  onPressed: () => controller.next(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: contentColor,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    controller.isLastStep ? Icons.check : Icons.arrow_forward,
                    size: 18,
                  ),
                  label: Text(
                    controller.isLastStep
                        ? 'Finish'
                        : (step.nextButtonText ?? 'Next'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for highlight cutout with pulse effect
class _HighlightPainter extends CustomPainter {
  final Rect targetRect;
  final bool showPulse;
  final Animation<double> pulseAnimation;
  final bool isHole;

  _HighlightPainter({
    required this.targetRect,
    required this.showPulse,
    required this.pulseAnimation,
    this.isHole = false,
  }) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    // If drawing hole (mask), we draw a solid shape to be filtered out
    if (isHole) {
      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      final expandedRect = targetRect.inflate(8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(expandedRect, const Radius.circular(8)),
        paint,
      );
      return;
    }

    // Only draw pulse if NOT drawing hole stuff
    if (showPulse) {
      final pulsePaint = Paint()
        ..color =
            Colors.white.withValues(alpha: 0.3 * (1 - pulseAnimation.value))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final pulseRadius = 8 + (20 * pulseAnimation.value);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          targetRect.inflate(pulseRadius),
          Radius.circular(8 + pulseRadius),
        ),
        pulsePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HighlightPainter oldDelegate) {
    return targetRect != oldDelegate.targetRect ||
        showPulse != oldDelegate.showPulse ||
        isHole != oldDelegate.isHole;
  }
}

class _HoleClipper extends CustomClipper<Path> {
  final Rect holeRect;

  _HoleClipper(this.holeRect);

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        holeRect.inflate(8),
        const Radius.circular(8),
      ));

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(_HoleClipper oldClipper) => holeRect != oldClipper.holeRect;
}
