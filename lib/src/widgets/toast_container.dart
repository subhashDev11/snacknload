import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utility/enums.dart';
import '../utility/snacknload_container.dart';
import '../utility/toast_theme.dart';

T? _ambiguate<T>(T? value) => value;

class ToastContainer extends StatefulWidget {
  final String message;
  final String? title;
  final bool? dismissOnTap;
  final LoadingToastPosition? toastPosition;
  final LoadingMaskType? maskType;
  final Completer<void>? completer;
  final bool animation;
  final ToastType type;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final bool? showIcon;
  final bool? showDivider;

  const ToastContainer({
    super.key,
    this.messageStyle,
    this.titleStyle,
    required this.message,
    this.title,
    this.dismissOnTap,
    this.toastPosition,
    this.maskType,
    this.completer,
    this.animation = true,
    required this.type,
    this.showIcon,
    this.showDivider,
  });

  @override
  ToastContainerState createState() => ToastContainerState();
}

class ToastContainerState extends State<ToastContainer> with SingleTickerProviderStateMixin {
  late String _message;
  Color? _maskColor;
  late AnimationController _animationController;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap, _ignoring;

  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase == SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _message = widget.message;
    _alignment = ToastTheme.alignment(widget.toastPosition);
    _dismissOnTap = widget.dismissOnTap ?? (ToastTheme.dismissOnTap ?? false);
    _ignoring = _dismissOnTap ? false : ToastTheme.ignoring(widget.maskType);
    _maskColor = ToastTheme.maskColor(widget.maskType);
    _animationController = AnimationController(
      vsync: this,
      duration: ToastTheme.animationDuration,
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
      Completer<void> completer = Completer<void>();
      _ambiguate(SchedulerBinding.instance)!
          .addPostFrameCallback((_) => completer.complete(_animationController.forward(from: animation ? 0 : 1)));
      return completer.future;
    } else {
      return _animationController.forward(from: animation ? 0 : 1);
    }
  }

  Future<void> dismiss(bool animation) {
    if (isPersistentCallbacks) {
      Completer<void> completer = Completer<void>();
      _ambiguate(SchedulerBinding.instance)!
          .addPostFrameCallback((_) => completer.complete(_animationController.reverse(from: animation ? 1 : 0)));
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
            return ToastTheme.loadingAnimation.buildWidget(
              _Indicator(
                message: _message,
                title: widget.title,
                titleStyle: widget.titleStyle,
                messageStyle: widget.messageStyle,
                showIcon: widget.showIcon ?? true,
                type: widget.type,
                showDivider: widget.showDivider ?? false,
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

class _Indicator extends StatelessWidget {
  final String message;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final ToastType type;
  final bool showIcon;
  final bool showDivider;

  const _Indicator({
    required this.message,
    this.title,
    this.messageStyle,
    this.titleStyle,
    required this.type,
    required this.showIcon,
    required this.showDivider,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(50.0),
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(
          ToastTheme.radius,
        ),
        boxShadow: ToastTheme.boxShadow,
      ),
      padding: ToastTheme.contentPadding,
      child: Builder(builder: (context) {
        final content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                ),
                child: Text(
                  title!,
                  style: titleStyle ??
                      TextStyle(
                        color: Colors.white,
                        fontSize: ToastTheme.fontSize,
                      ),
                  textAlign: ToastTheme.textAlign,
                ),
              ),
            if (title != null && showDivider) Divider(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 5,
              ),
              child: Text(
                message,
                style: messageStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: ToastTheme.fontSize,
                    ),
                textAlign: ToastTheme.textAlign,
              ),
            ),
          ],
        );
        return showIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIcon(),
                    size: 25,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: content,
                  ),
                ],
              )
            : content;
      }),
    );
  }
}
