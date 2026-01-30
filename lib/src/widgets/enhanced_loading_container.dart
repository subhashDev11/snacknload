import 'dart:async';
import 'dart:ui';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

T? _ambiguate<T>(T? value) => value;

/// Enhanced loading container with modern UI effects including blur and glassmorphism.
///
/// This widget provides a premium loading experience with:
/// - Backdrop blur filter for depth
/// - Glassmorphism design with gradient backgrounds
/// - Smooth scale and fade animations
/// - Customizable appearance
class EnhancedLoadingContainer extends StatefulWidget {
  /// Custom loading indicator widget (e.g., CircularProgressIndicator)
  final Widget? indicator;

  /// Status text to display below the indicator
  final String? status;

  /// Whether tapping the backdrop should dismiss the loading
  final bool? dismissOnTap;

  /// Position of the loading indicator on screen
  final SnackNLoadPosition? position;

  /// Type of mask/backdrop (none, clear, black, custom)
  final MaskType? maskType;

  /// Completer to signal when animation is complete
  final Completer<void>? completer;

  /// Whether to animate the entrance/exit
  final bool animation;

  /// Enable blur effect on backdrop (may impact performance)
  final bool useBlur;

  /// Enable glassmorphism effect on container
  final bool useGlassmorphism;

  const EnhancedLoadingContainer({
    super.key,
    this.indicator,
    this.status,
    this.dismissOnTap,
    this.position,
    this.maskType,
    this.completer,
    this.animation = true,
    this.useBlur = true,
    this.useGlassmorphism = true,
  });

  @override
  EnhancedLoadingContainerState createState() =>
      EnhancedLoadingContainerState();
}

class EnhancedLoadingContainerState extends State<EnhancedLoadingContainer>
    with SingleTickerProviderStateMixin {
  // Current status text being displayed
  String? _currentStatus;

  // Backdrop mask color
  Color? _backdropMaskColor;

  // Animation controller for entrance/exit animations
  late AnimationController _animationController;

  // Scale animation for bounce effect
  late Animation<double> _scaleAnimation;

  // Fade animation for opacity
  late Animation<double> _fadeAnimation;

  // Alignment of the loading indicator
  late AlignmentGeometry _indicatorAlignment;

  // Whether tapping should dismiss
  late bool _shouldDismissOnTap;

  // Whether to ignore pointer events
  late bool _shouldIgnorePointer;

  /// Check if we're in persistent callbacks phase
  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _currentStatus = widget.status;
    _indicatorAlignment =
        (widget.indicator == null && widget.status?.isNotEmpty == true)
            ? SnackNLoadTheme.alignment(
                widget.position ?? SnackNLoadPosition.top,
              )
            : AlignmentDirectional.center;
    _shouldDismissOnTap =
        widget.dismissOnTap ?? (SnackNLoadTheme.dismissOnTap ?? false);
    _shouldIgnorePointer =
        _shouldDismissOnTap ? false : SnackNLoadTheme.ignoring(widget.maskType);
    _backdropMaskColor = SnackNLoadTheme.maskColor(widget.maskType);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });

    // Enhanced animations with custom curves
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack, // Bounce effect
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth fade
    );

    show(widget.animation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show(bool animation) {
    if (isPersistentCallbacks) {
      Completer<dynamic> completer = Completer<void>();
      _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) =>
          completer
              .complete(_animationController.forward(from: animation ? 0 : 1)));
      return completer.future;
    } else {
      return _animationController.forward(from: animation ? 0 : 1);
    }
  }

  Future<void> dismiss(bool animation) {
    if (isPersistentCallbacks) {
      Completer<dynamic> completer = Completer<void>();
      _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) =>
          completer
              .complete(_animationController.reverse(from: animation ? 1 : 0)));
      return completer.future;
    } else {
      return _animationController.reverse(from: animation ? 1 : 0);
    }
  }

  /// Update the status text dynamically
  void updateStatus(String status) {
    if (_currentStatus == status) return;
    setState(() {
      _currentStatus = status;
    });
  }

  /// Handle tap on backdrop
  void _onTap() async {
    if (_shouldDismissOnTap) await SnackNLoad.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: _indicatorAlignment,
      children: <Widget>[
        // Backdrop with blur effect
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: IgnorePointer(
                ignoring: _shouldIgnorePointer,
                child: _shouldDismissOnTap
                    ? GestureDetector(
                        onTap: _onTap,
                        behavior: HitTestBehavior.translucent,
                        child: widget.useBlur
                            ? BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0 * _fadeAnimation.value,
                                  sigmaY: 5.0 * _fadeAnimation.value,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: _backdropMaskColor,
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: _backdropMaskColor,
                              ),
                      )
                    : widget.useBlur
                        ? BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0 * _fadeAnimation.value,
                              sigmaY: 5.0 * _fadeAnimation.value,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: _backdropMaskColor,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: _backdropMaskColor,
                          ),
              ),
            );
          },
        ),
        // Loading indicator
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _EnhancedIndicator(
                  status: _currentStatus,
                  indicator: widget.indicator,
                  useGlassmorphism: widget.useGlassmorphism,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EnhancedIndicator extends StatelessWidget {
  final Widget? indicator;
  final String? status;
  final bool useGlassmorphism;

  const _EnhancedIndicator({
    required this.indicator,
    required this.status,
    required this.useGlassmorphism,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (indicator != null)
          Container(
            margin: status?.isNotEmpty == true
                ? SnackNLoadTheme.textPadding
                : EdgeInsets.zero,
            child: indicator,
          ),
        if (status != null)
          Text(
            status!,
            style: SnackNLoadTheme.textStyle ??
                TextStyle(
                  color: SnackNLoadTheme.textColor,
                  fontSize: SnackNLoadTheme.fontSize,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: SnackNLoadTheme.textAlign,
          ),
      ],
    );

    if (useGlassmorphism) {
      return Container(
        margin: const EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SnackNLoadTheme.radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: SnackNLoadTheme.contentPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SnackNLoadTheme.backgroundColor.withValues(alpha: 0.8),
                    SnackNLoadTheme.backgroundColor.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(SnackNLoadTheme.radius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: content,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: SnackNLoadTheme.backgroundColor,
        borderRadius: BorderRadius.circular(SnackNLoadTheme.radius),
        boxShadow: SnackNLoadTheme.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
      ),
      padding: SnackNLoadTheme.contentPadding,
      child: content,
    );
  }
}
