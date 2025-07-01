import 'package:flutter/material.dart';
import 'snacknload_container.dart';
import 'package:snacknload/src/animations/animation.dart';
import 'package:snacknload/src/animations/opacity_animation.dart';
import 'package:snacknload/src/animations/offset_animation.dart';
import 'package:snacknload/src/animations/scale_animation.dart';
import 'enums.dart';

class SnackNLoadTheme {
  /// Colors
  static Color get indicatorColor => _getColor(Colors.black, Colors.white);
  static Color get progressColor => _getColor(Colors.black, Colors.white);
  static Color get backgroundColor => _getColor(Colors.white, Colors.black.withOpacity(0.9));
  static Color get textColor => _getColor(Colors.black, Colors.white);
  static Color get successContainerColor => SnackNLoad.instance.successContainerColor ?? Colors.green;
  static Color get errorContainerColor => SnackNLoad.instance.errorContainerColor ?? Colors.red;
  static Color get infoContainerColor => SnackNLoad.instance.infoContainerColor ?? Colors.blue;
  static Color get warningContainerColor => SnackNLoad.instance.warningContainerColor ?? Colors.orange;

  /// Box Shadow
  static List<BoxShadow>? get boxShadow => SnackNLoad.instance.loadingStyle == LoadingStyle.custom
      ? SnackNLoad.instance.boxShadow ?? [BoxShadow()]
      : null;

  /// Mask Color
  static Color maskColor(MaskType? maskType) {
    maskType ??= SnackNLoad.instance.maskType;
    return maskType == MaskType.custom
        ? SnackNLoad.instance.maskColor!
        : maskType == MaskType.black
        ? Colors.black.withOpacity(0.5)
        : Colors.transparent;
  }

  /// Loading Animation
  static SnackNLoadLoadingAnimation get loadingAnimation {
    switch (SnackNLoad.instance.animationStyle) {
      case SnackNLoadAnimationStyle.custom:
        return SnackNLoad.instance.customAnimation!;
      case SnackNLoadAnimationStyle.offset:
        return OffsetAnimation();
      case SnackNLoadAnimationStyle.scale:
        return ScaleAnimation();
      default:
        return OpacityAnimation();
    }
  }

  /// Other Properties
  static double get fontSize => SnackNLoad.instance.fontSize;
  static double get indicatorSize => SnackNLoad.instance.indicatorSize;
  static double get progressWidth => SnackNLoad.instance.progressWidth;
  static double get lineWidth => SnackNLoad.instance.lineWidth;
  static IndicatorType get indicatorType => SnackNLoad.instance.indicatorType;
  static SnackNLoadPosition get position => SnackNLoad.instance.position;
  static Duration get displayDuration => SnackNLoad.instance.displayDuration;
  static Duration get animationDuration => SnackNLoad.instance.animationDuration;
  static EdgeInsets get contentPadding => SnackNLoad.instance.contentPadding;
  static EdgeInsets get textPadding => SnackNLoad.instance.textPadding;
  static TextAlign get textAlign => SnackNLoad.instance.textAlign;
  static TextStyle? get textStyle => SnackNLoad.instance.textStyle;
  static double get radius => SnackNLoad.instance.radius;
  static bool? get dismissOnTap => SnackNLoad.instance.dismissOnTap;

  /// Determines if user interactions are ignored
  static bool ignoring(MaskType? maskType) {
    maskType ??= SnackNLoad.instance.maskType;
    return SnackNLoad.instance.userInteractions ?? (maskType == MaskType.none);
  }

  /// Alignment based on position
  static AlignmentGeometry alignment(SnackNLoadPosition position) {
    return position == SnackNLoadPosition.bottom
        ? AlignmentDirectional.bottomCenter
        : (position == SnackNLoadPosition.top ? AlignmentDirectional.topCenter : AlignmentDirectional.center);
  }

  /// Helper function to get the color based on the loading style
  static Color _getColor(Color light, Color dark) {
    return SnackNLoad.instance.loadingStyle == LoadingStyle.custom
        ? SnackNLoad.instance.textColor!
        : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
        ? dark
        : light;
  }
}
