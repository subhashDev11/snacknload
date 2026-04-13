import 'package:flutter/widgets.dart';
import 'animation.dart';

class OpacityAnimation extends SnackNLoadLoadingAnimation {
  OpacityAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return FadeTransition(
      opacity: controller,
      child: child,
    );
  }
}