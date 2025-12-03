import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';

T? _ambiguate<T>(T? value) => value;

class SnackBarContainer extends StatefulWidget {
  final String message;
  final String? title;
  final bool? dismissOnTap;
  final SnackNLoadPosition? position;
  final MaskType? maskType;
  final Completer<void>? completer;
  final bool animation;
  final SnackNLoadType type;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final bool? showIcon;
  final bool? showDivider;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final EdgeInsets? margin;

  const SnackBarContainer({
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
  });

  @override
  SnackBarContainerState createState() => SnackBarContainerState();
}

class SnackBarContainerState extends State<SnackBarContainer>
    with SingleTickerProviderStateMixin {
  late String _message;
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
    _message = widget.message;
    _alignment = SnackNLoadTheme.alignment(
      widget.position ?? SnackNLoadPosition.top,
    );
    _dismissOnTap =
        widget.dismissOnTap ?? (SnackNLoadTheme.dismissOnTap ?? false);
    _ignoring =
        _dismissOnTap ? false : SnackNLoadTheme.ignoring(widget.maskType);
    _maskColor = SnackNLoadTheme.maskColor(widget.maskType);
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
            return SnackNLoadTheme.loadingAnimation.buildWidget(
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
  final SnackNLoadType type;
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

  IconData _getIcon() {
    switch (type) {
      case SnackNLoadType.success:
        return Icons.check_circle;
      case SnackNLoadType.error:
        return Icons.error;
      case SnackNLoadType.warning:
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
        color: _getBackgroundColor(Theme.of(context)),
        borderRadius: BorderRadius.circular(
          SnackNLoadTheme.radius,
        ),
        boxShadow: SnackNLoadTheme.boxShadow,
      ),
      padding: contentPadding ?? SnackNLoadTheme.contentPadding,
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
                        fontSize: SnackNLoadTheme.fontSize,
                      ),
                  textAlign: SnackNLoadTheme.textAlign,
                ),
              ),
            if (title != null && showDivider)
              Divider(
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
                      fontSize: SnackNLoadTheme.fontSize,
                    ),
                textAlign: SnackNLoadTheme.textAlign,
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
