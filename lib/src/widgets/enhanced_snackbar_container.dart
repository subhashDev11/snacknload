import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';

T? _ambiguate<T>(T? value) => value;

/// Enhanced snackbar with rich UI features inspired by GetX.
///
/// This widget provides a premium notification experience with:
/// - Auto-dismiss progress bar
/// - Swipe-to-dismiss gesture
/// - Tap callbacks for interactivity
/// - Custom leading/trailing widgets
/// - Glassmorphism design
/// - Smooth slide animations
class EnhancedSnackBarContainer extends StatefulWidget {
  /// The main message text to display
  final String message;

  /// Optional title text displayed above the message
  final String? title;

  /// Whether tapping anywhere should dismiss the snackbar
  final bool? dismissOnTap;

  /// Position on screen (top, center, bottom)
  final SnackNLoadPosition? position;

  /// Type of backdrop mask
  final MaskType? maskType;

  /// Completer to signal when animation is complete
  final Completer<void>? completer;

  /// Whether to animate the entrance/exit
  final bool animation;

  /// Type of snackbar (success, error, warning, info)
  final SnackNLoadType type;

  /// Custom text style for title
  final TextStyle? titleStyle;

  /// Custom text style for message
  final TextStyle? messageStyle;

  /// Whether to show the type icon
  final bool? showIcon;

  /// Whether to show a divider (deprecated, kept for compatibility)
  final bool? showDivider;

  /// Custom background color (overrides type color)
  final Color? backgroundColor;

  /// Inner padding around content
  final EdgeInsets? contentPadding;

  /// Outer margin around snackbar
  final EdgeInsets? margin;

  /// Show animated progress bar for auto-dismiss countdown
  final bool showProgressBar;

  /// Duration before auto-dismiss (required if showProgressBar is true)
  final Duration? duration;

  /// Custom widget to show before the icon/message
  final Widget? leading;

  /// Custom widget to show after the message
  final Widget? trailing;

  /// Callback when snackbar is tapped
  final VoidCallback? onTap;

  /// Enable vertical swipe gesture to dismiss
  final bool enableSwipeToDismiss;

  /// Enable glassmorphism effect with blur
  final bool useGlassmorphism;

  /// Show close button (X) in top-right corner
  final bool showCloseButton;

  const EnhancedSnackBarContainer({
    super.key,
    this.messageStyle,
    this.titleStyle,
    required this.message,
    this.title,
    this.dismissOnTap,
    this.position,
    this.maskType,
    this.completer,
    this.animation = true,
    required this.type,
    this.showIcon,
    this.showDivider,
    required this.backgroundColor,
    required this.contentPadding,
    required this.margin,
    this.showProgressBar = true,
    this.duration,
    this.leading,
    this.trailing,
    this.onTap,
    this.enableSwipeToDismiss = true,
    this.useGlassmorphism = true,
    this.showCloseButton = true,
  });

  @override
  EnhancedSnackBarContainerState createState() =>
      EnhancedSnackBarContainerState();
}

class EnhancedSnackBarContainerState extends State<EnhancedSnackBarContainer>
    with TickerProviderStateMixin {
  late String _message;
  Color? _maskColor;
  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap, _ignoring;
  double _dragDistance = 0;

  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _message = widget.message;
    _alignment = SnackNLoadTheme.alignment(
      widget.position ?? SnackNLoadPosition.top,
    );
    _dismissOnTap =
        widget.dismissOnTap ?? (SnackNLoadTheme.dismissOnTap ?? false);
    _ignoring =
        _dismissOnTap ? false : SnackNLoadTheme.ignoring(widget.maskType);
    _maskColor = SnackNLoadTheme.maskColor(widget.maskType);

    // Main animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((status) {
        bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });

    // Progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(seconds: 3),
    );

    // Slide animation based on position
    final isTop = widget.position == SnackNLoadPosition.top;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    show(widget.animation);

    // Start progress animation if enabled
    if (widget.showProgressBar && widget.duration != null) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
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

  void updateStatus(String status) {
    if (_message == status) return;
    setState(() {
      _message = status;
    });
  }

  void _onTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
    }
    if (_dismissOnTap) await SnackNLoad.dismiss();
  }

  void _onDismiss() async {
    await SnackNLoad.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: _alignment,
      children: <Widget>[
        // Backdrop
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: IgnorePointer(
                ignoring: _ignoring,
                child: _dismissOnTap
                    ? GestureDetector(
                        onTap: _onTap,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: _maskColor,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: _maskColor,
                      ),
              ),
            );
          },
        ),
        // Snackbar content
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.enableSwipeToDismiss
                    ? GestureDetector(
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            _dragDistance += details.delta.dy;
                          });
                        },
                        onVerticalDragEnd: (details) {
                          if (_dragDistance.abs() > 100) {
                            _onDismiss();
                          }
                          setState(() {
                            _dragDistance = 0;
                          });
                        },
                        child: Transform.translate(
                          offset: Offset(0, _dragDistance),
                          child: _EnhancedIndicator(
                            message: _message,
                            title: widget.title,
                            titleStyle: widget.titleStyle,
                            messageStyle: widget.messageStyle,
                            showIcon: widget.showIcon ?? true,
                            type: widget.type,
                            showDivider: widget.showDivider ?? false,
                            backgroundColor: widget.backgroundColor,
                            contentPadding: widget.contentPadding,
                            margin: widget.margin,
                            showProgressBar: widget.showProgressBar,
                            progressAnimation: _progressController,
                            leading: widget.leading,
                            trailing: widget.trailing,
                            onTap: widget.onTap != null ? _onTap : null,
                            useGlassmorphism: widget.useGlassmorphism,
                            showCloseButton: widget.showCloseButton,
                            onClose: _onDismiss,
                          ),
                        ),
                      )
                    : _EnhancedIndicator(
                        message: _message,
                        title: widget.title,
                        titleStyle: widget.titleStyle,
                        messageStyle: widget.messageStyle,
                        showIcon: widget.showIcon ?? true,
                        type: widget.type,
                        showDivider: widget.showDivider ?? false,
                        backgroundColor: widget.backgroundColor,
                        contentPadding: widget.contentPadding,
                        margin: widget.margin,
                        showProgressBar: widget.showProgressBar,
                        progressAnimation: _progressController,
                        leading: widget.leading,
                        trailing: widget.trailing,
                        onTap: widget.onTap != null ? _onTap : null,
                        useGlassmorphism: widget.useGlassmorphism,
                        showCloseButton: widget.showCloseButton,
                        onClose: _onDismiss,
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
  final String message;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final SnackNLoadType type;
  final bool showIcon;
  final bool showDivider;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;
  final bool showProgressBar;
  final AnimationController progressAnimation;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useGlassmorphism;
  final bool showCloseButton;
  final VoidCallback onClose;

  const _EnhancedIndicator({
    required this.message,
    this.title,
    this.messageStyle,
    this.titleStyle,
    required this.type,
    required this.showIcon,
    required this.showDivider,
    required this.backgroundColor,
    required this.margin,
    required this.contentPadding,
    required this.showProgressBar,
    required this.progressAnimation,
    this.leading,
    this.trailing,
    this.onTap,
    required this.useGlassmorphism,
    required this.showCloseButton,
    required this.onClose,
  });

  Color _getBackgroundColor(ThemeData theme) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    switch (type) {
      case SnackNLoadType.success:
        return SnackNLoadTheme.successContainerColor;
      case SnackNLoadType.error:
        return SnackNLoadTheme.errorContainerColor;
      case SnackNLoadType.warning:
        return SnackNLoadTheme.warningContainerColor;
      case SnackNLoadType.info:
        return theme.primaryColor;
    }
  }

  Color _getDarkerColor(Color color) {
    return Color.fromRGBO(
      (color.red * 0.8).round(),
      (color.green * 0.8).round(),
      (color.blue * 0.8).round(),
      1,
    );
  }

  IconData _getIcon() {
    switch (type) {
      case SnackNLoadType.success:
        return Icons.check_circle_rounded;
      case SnackNLoadType.error:
        return Icons.error_rounded;
      case SnackNLoadType.warning:
        return Icons.warning_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(Theme.of(context));
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ] else if (showIcon) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(),
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: titleStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: messageStyle ??
                        TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
            if (showCloseButton) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ],
    );

    Widget container;

    if (useGlassmorphism) {
      container = Container(
        margin: margin ?? const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bgColor.withOpacity(0.9),
                    _getDarkerColor(bgColor).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                    child: onTap != null
                        ? InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(16),
                            child: content,
                          )
                        : content,
                  ),
                  if (showProgressBar)
                    AnimatedBuilder(
                      animation: progressAnimation,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: LinearProgressIndicator(
                            value: 1 - progressAnimation.value,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                            minHeight: 3,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      container = Container(
        margin: margin ?? const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bgColor,
              _getDarkerColor(bgColor),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
              child: onTap != null
                  ? InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(16),
                      child: content,
                    )
                  : content,
            ),
            if (showProgressBar)
              AnimatedBuilder(
                animation: progressAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: LinearProgressIndicator(
                      value: 1 - progressAnimation.value,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                      minHeight: 3,
                    ),
                  );
                },
              ),
          ],
        ),
      );
    }

    return container;
  }
}
