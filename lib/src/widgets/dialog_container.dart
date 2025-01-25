import 'dart:async';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

T? _ambiguate<T>(T? value) => value;

class DialogContainer extends StatefulWidget {
  final Widget? contentWidget;
  final Widget? titleWidget;
  final String? title;
  final TextStyle? titleStyle;
  final bool? dismissOnTap;
  final LoadingMaskType? maskType;
  final Completer<void>? completer;
  final bool animation;
  final bool useAdaptive;
  final ShapeBorder? shape;
  final List<Widget>? actions;

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
    this.actions,
  });

  @override
  DialogContainerState createState() => DialogContainerState();
}

class DialogContainerState extends State<DialogContainer> with SingleTickerProviderStateMixin {
  Color? _maskColor;
  late AnimationController _animationController;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap, _ignoring;

  //https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0
  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase == SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _alignment = AlignmentDirectional.center;
    _dismissOnTap = widget.dismissOnTap ?? (LoadingTheme.dismissOnTap ?? false);
    _ignoring = _dismissOnTap ? false : LoadingTheme.ignoring(widget.maskType);
    _maskColor = LoadingTheme.maskColor(widget.maskType);
    _animationController = AnimationController(
      vsync: this,
      duration: LoadingTheme.animationDuration,
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
      _ambiguate(SchedulerBinding.instance)!
          .addPostFrameCallback((_) => completer.complete(_animationController.forward(from: animation ? 0 : 1)));
      return completer.future;
    } else {
      return _animationController.forward(from: animation ? 0 : 1);
    }
  }

  Future<void> dismiss(bool animation) {
    if (isPersistentCallbacks) {
      Completer<dynamic> completer = Completer<void>();
      _ambiguate(SchedulerBinding.instance)!
          .addPostFrameCallback((_) => completer.complete(_animationController.reverse(from: animation ? 1 : 0)));
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
            return LoadingTheme.loadingAnimation.buildWidget(
              DialogWidget(
                useAdaptive: widget.useAdaptive,
                title: widget.title,
                titleWidget: widget.titleWidget,
                titleStyle: widget.titleStyle,
                content: widget.contentWidget,
                shape: widget.shape,
                actions: widget.actions,
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
  final List<Widget>? actions;

  const DialogWidget({
    super.key,
    this.titleStyle,
    this.title,
    this.titleWidget,
    this.content,
    this.shape,
    required this.useAdaptive,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (useAdaptive) {
      return AlertDialog.adaptive(
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                LoadingTheme.radius,
              ),
            ),
        title: Text(
          title!,
          style: titleStyle ??
              Theme.of(context).dialogTheme.titleTextStyle,
        ),
        content: content,
        actions: actions,
      );
    }
    return AlertDialog(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              LoadingTheme.radius,
            ),
          ),
      title: Text(
        title!,
        style: titleStyle ??
            Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: content,
      actions: actions,
    );
    
  }
}
