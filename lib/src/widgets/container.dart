import 'dart:async';
import 'package:snacknload/src/utility/enums.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/utility/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

T? _ambiguate<T>(T? value) => value;

class LoadingContainer extends StatefulWidget {
  final Widget? indicator;
  final String? status;
  final bool? dismissOnTap;
  final LoadingToastPosition? toastPosition;
  final LoadingMaskType? maskType;
  final Completer<void>? completer;
  final bool animation;

  const LoadingContainer({
    super.key,
    this.indicator,
    this.status,
    this.dismissOnTap,
    this.toastPosition,
    this.maskType,
    this.completer,
    this.animation = true,
  });

  @override
  LoadingContainerState createState() => LoadingContainerState();
}

class LoadingContainerState extends State<LoadingContainer>
    with SingleTickerProviderStateMixin {
  String? _status;
  Color? _maskColor;
  late AnimationController _animationController;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap, _ignoring;

  //https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0
  bool get isPersistentCallbacks =>
      _ambiguate(SchedulerBinding.instance)!.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _status = widget.status;
    _alignment = (widget.indicator == null && widget.status?.isNotEmpty == true)
        ? LoadingTheme.alignment(widget.toastPosition)
        : AlignmentDirectional.center;
    _dismissOnTap =
        widget.dismissOnTap ?? (LoadingTheme.dismissOnTap ?? false);
    _ignoring =
        _dismissOnTap ? false : LoadingTheme.ignoring(widget.maskType);
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
    if (_status == status) return;
    setState(() {
      _status = status;
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
            return LoadingTheme.loadingAnimation.buildWidget(
              _Indicator(
                status: _status,
                indicator: widget.indicator,
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
  final Widget? indicator;
  final String? status;

  const _Indicator({
    required this.indicator,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: LoadingTheme.backgroundColor,
        borderRadius: BorderRadius.circular(
          LoadingTheme.radius,
        ),
        boxShadow: LoadingTheme.boxShadow,
      ),
      padding: LoadingTheme.contentPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (indicator != null)
            Container(
              margin: status?.isNotEmpty == true
                  ? LoadingTheme.textPadding
                  : EdgeInsets.zero,
              child: indicator,
            ),
          if (status != null)
            Text(
              status!,
              style: LoadingTheme.textStyle ??
                  TextStyle(
                    color: LoadingTheme.textColor,
                    fontSize: LoadingTheme.fontSize,
                  ),
              textAlign: LoadingTheme.textAlign,
            ),
        ],
      ),
    );
  }
}
