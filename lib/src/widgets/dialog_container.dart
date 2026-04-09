import 'dart:async';
import 'dart:ui';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:snacknload/src/widgets/snacknload_button.dart';

T? _ambiguate<T>(T? value) => value;

class DialogContainer extends StatefulWidget {
  final Widget? contentWidget;
  final Widget? titleWidget;
  final String? title;
  final TextStyle? titleStyle;
  final bool? dismissOnTap;
  final MaskType? maskType;
  final Completer<void>? completer;
  final bool animation;
  final bool useAdaptive;
  final ShapeBorder? shape;
  final List<ActionConfig>? actionConfigs;
  final bool isFullScreen;
  final SnackNLoadDialogType? dialogType;
  final Color? maskColor;

  const DialogContainer({
    super.key,
    this.contentWidget,
    this.titleWidget,
    this.dismissOnTap,
    this.title,
    this.titleStyle,
    this.maskType,
    this.completer,
    this.animation = true,
    required this.useAdaptive,
    this.shape,
    this.actionConfigs,
    this.isFullScreen = false,
    this.dialogType,
    this.maskColor,
  });

  @override
  DialogContainerState createState() => DialogContainerState();
}

class DialogContainerState extends State<DialogContainer>
    with SingleTickerProviderStateMixin {
  Color? _maskColor;
  late AnimationController _animationController;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap, _ignoring;

  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _alignment = AlignmentDirectional.center;
    _dismissOnTap =
        widget.dismissOnTap ?? (SnackNLoadTheme.dismissOnTap ?? false);
    _ignoring =
        _dismissOnTap ? false : SnackNLoadTheme.ignoring(widget.maskType);
    _maskColor = widget.maskColor ?? SnackNLoadTheme.maskColor(widget.maskType);
    _animationController = AnimationController(
      vsync: this,
      duration: SnackNLoadTheme.animationDuration,
    )..addStatusListener((status) {
        bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });
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

  void _onTap() async {
    if (_dismissOnTap) await SnackNLoad.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // Allows interaction with dialog or backdrop
    return Stack(
      alignment: _alignment,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _animationController.value,
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
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return SnackNLoadTheme.loadingAnimation.buildWidget(
              DialogWidget(
                useAdaptive: widget.useAdaptive,
                title: widget.title,
                titleWidget: widget.titleWidget,
                titleStyle: widget.titleStyle,
                content: widget.contentWidget,
                shape: widget.shape,
                actionConfigs: widget.actionConfigs,
                isFullScreen: widget.isFullScreen,
                dialogType: widget.dialogType,
              ),
              _animationController,
              _alignment,
            );
          },
        ),
      ],
    );
  }
}

class DialogWidget extends StatelessWidget {
  final Widget? content;
  final Widget? titleWidget;
  final String? title;
  final TextStyle? titleStyle;
  final bool useAdaptive;
  final ShapeBorder? shape;
  final List<ActionConfig>? actionConfigs;
  final bool isFullScreen;
  final SnackNLoadDialogType? dialogType;

  const DialogWidget({
    super.key,
    this.titleStyle,
    this.title,
    this.titleWidget,
    this.content,
    this.shape,
    required this.useAdaptive,
    required this.actionConfigs,
    this.isFullScreen = false,
    this.dialogType,
  });

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return _buildFullScreenDialog(context);
    }

    // Default to enhanced if not specified
    final type = dialogType ?? SnackNLoadDialogType.enhanced;

    switch (type) {
      case SnackNLoadDialogType.cupertino:
        return _buildCupertinoDialog(context);
      case SnackNLoadDialogType.enhanced:
        return _buildEnhancedDialog(context);
      case SnackNLoadDialogType.material:
        return _buildMaterialDialog(context);
      case SnackNLoadDialogType.adaptive:
        return _buildAdaptiveDialog(context);
    }
  }

  Widget _buildFullScreenDialog(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => SnackNLoad.dismiss(),
        ),
        title: titleWidget ??
            (title != null
                ? Text(
                    title!,
                    style: titleStyle ??
                        Theme.of(context).appBarTheme.titleTextStyle,
                  )
                : null),
        actions: _buildActions(context, forAppBar: true),
      ),
      body: content ?? const SizedBox.shrink(),
    );
  }

  Widget _buildAdaptiveDialog(BuildContext context) {
    return AlertDialog.adaptive(
      shape: _getShape(),
      title: _buildTitle(context),
      content: content,
      actions: _buildActions(context),
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    return AlertDialog(
      shape: _getShape(),
      title: _buildTitle(context),
      content: content,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      actions: _buildActions(context),
    );
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: _buildTitle(context),
      content: content,
      actions: actionConfigs
              ?.map(
                (e) => CupertinoDialogAction(
                  onPressed: () async {
                    if (e.autoDismiss) await SnackNLoad.dismiss();
                    e.onPressed();
                  },
                  isDefaultAction: e.buttonVariant == ButtonVariant.primary,
                  isDestructiveAction: e.buttonVariant == ButtonVariant.danger,
                  child: Text(e.label),
                ),
              )
              .toList() ??
          [],
    );
  }

  Widget _buildEnhancedDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 32,
              offset: const Offset(0, 16),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surface.withValues(alpha: 0.8)
                    : colorScheme.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null || titleWidget != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                          fontFamily: theme.textTheme.titleLarge?.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                        child: _buildTitle(context) ?? const SizedBox(),
                      ),
                    ),
                  if (content != null)
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top:
                                (title != null || titleWidget != null) ? 8 : 32,
                            bottom: 24,
                          ),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                              letterSpacing: 0.1,
                            ),
                            textAlign: TextAlign.center,
                            child: content!,
                          ),
                        ),
                      ),
                    ),
                  if (actionConfigs != null && actionConfigs!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: actionConfigs!.map((e) {
                          final isPrimary =
                              e.buttonVariant == ButtonVariant.primary;
                          final isDestructive =
                              e.buttonVariant == ButtonVariant.danger;
                          final isGhost =
                              e.buttonVariant == ButtonVariant.ghost;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (e.autoDismiss) await SnackNLoad.dismiss();
                                e.onPressed();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isGhost
                                    ? Colors.transparent
                                    : (isDestructive
                                        ? colorScheme.error
                                        : (isPrimary
                                            ? colorScheme.primary
                                            : colorScheme
                                                .surfaceContainerHighest)),
                                foregroundColor: isGhost
                                    ? colorScheme.primary
                                    : (isDestructive
                                        ? colorScheme.onError
                                        : (isPrimary
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurfaceVariant)),
                                elevation: isPrimary ? 0 : 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: Colors.transparent,
                              ).copyWith(
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return (isDestructive
                                              ? colorScheme.onError
                                              : (isPrimary
                                                  ? colorScheme.onPrimary
                                                  : colorScheme
                                                      .onSurfaceVariant))
                                          .withValues(alpha: 0.1);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              child: Text(
                                e.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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

  ShapeBorder? _getShape() {
    return shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SnackNLoadTheme.radius),
        );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget;
    if (title != null) {
      return Text(
        title!,
      );
    }
    return null;
  }

  List<Widget> _buildActions(BuildContext context, {bool forAppBar = false}) {
    if (forAppBar) {
      return actionConfigs
              ?.map(
                (e) => TextButton(
                  onPressed: () async {
                    if (e.autoDismiss) await SnackNLoad.dismiss();
                    e.onPressed();
                  },
                  child: Text(
                    e.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList() ??
          [];
    }
    return actionConfigs
            ?.map(
              (e) => SnackNLoadButton(
                text: e.label,
                icon: e.iconData,
                variant: e.buttonVariant ?? ButtonVariant.primary,
                onPressed: () async {
                  if (e.autoDismiss) await SnackNLoad.dismiss();
                  e.onPressed();
                },
              ),
            )
            .toList() ??
        [];
  }
}

class ActionConfig {
  final String label;
  final Function onPressed;
  final IconData? iconData;
  final ButtonVariant? buttonVariant;
  final bool autoDismiss;

  ActionConfig({
    required this.label,
    required this.onPressed,
    this.iconData,
    this.buttonVariant,
    this.autoDismiss = true,
  });
}
