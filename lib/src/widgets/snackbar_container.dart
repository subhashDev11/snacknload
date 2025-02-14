import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/toast_theme.dart';

T? _ambiguate<T>(T? value) => value;

class SnackbarContainer extends StatefulWidget {
  final String message;
  final String? title;
  final bool? dismissOnTap;
  final LoadingToastPosition? toastPosition;
  final LoadingMaskType? maskType;
  final Completer<void>? completer;
  final bool animation;
  final SnackbarType type;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final bool? showIcon;
  final bool? showDivider;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;

  const SnackbarContainer({
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
    required this.backgroundColor,
    required this.contentPadding,
    required this.margin,
  });

  @override
  SnackbarContainerState createState() => SnackbarContainerState();
}

class SnackbarContainerState extends State<SnackbarContainer> with SingleTickerProviderStateMixin {
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
    _alignment = SnackbarTheme.alignment(widget.toastPosition);
    _dismissOnTap = widget.dismissOnTap ?? (SnackbarTheme.dismissOnTap ?? false);
    _ignoring = _dismissOnTap ? false : SnackbarTheme.ignoring(widget.maskType);
    _maskColor = SnackbarTheme.maskColor(widget.maskType);
    _animationController = AnimationController(
      vsync: this,
      duration: SnackbarTheme.animationDuration,
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
            return SnackbarTheme.loadingAnimation.buildWidget(
              _Indicator(
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
  final SnackbarType type;
  final bool showIcon;
  final bool showDivider;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;


  const _Indicator({
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
  });

  Color _getBackgroundColor() {
    if(backgroundColor!=null){
      return backgroundColor!;
    }
    switch (type) {
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.warning:
        return Colors.orange;
      case SnackbarType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.error:
        return Icons.error;
      case SnackbarType.warning:
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(50.0),
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(
          SnackbarTheme.radius,
        ),
        boxShadow: SnackbarTheme.boxShadow,
      ),
      padding: contentPadding ?? SnackbarTheme.contentPadding,
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
                        fontSize: SnackbarTheme.fontSize,
                      ),
                  textAlign: SnackbarTheme.textAlign,
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
                      fontSize: SnackbarTheme.fontSize,
                    ),
                textAlign: SnackbarTheme.textAlign,
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
