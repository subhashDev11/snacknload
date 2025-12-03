import 'package:flutter/material.dart';
import 'package:snacknload/snacknload.dart';

class CustomAnimation extends SnackNLoadLoadingAnimation {
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
