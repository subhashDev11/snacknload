import 'package:flutter/widgets.dart';

abstract class SnackNLoadLoadingAnimation {
  SnackNLoadLoadingAnimation();

  Widget call(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return buildWidget(
      child,
      controller,
      alignment,
    );
  }

  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  );
}
