import 'package:flutter/widgets.dart';

import 'animation.dart';

class OffsetAnimation extends SnackNLoadLoadingAnimation {
  OffsetAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    Offset begin = alignment == AlignmentDirectional.topCenter
        ? Offset(0, -1)
        : alignment == AlignmentDirectional.bottomCenter
            ? Offset(0, 1)
            : Offset(0, 0);
    Animation<Offset> animation = Tween(
      begin: begin,
      end: Offset(0, 0),
    ).animate(controller);
    return Opacity(
      opacity: controller.value,
      child: SlideTransition(
        position: animation,
        child: child,
      ),
    );
  }
}
