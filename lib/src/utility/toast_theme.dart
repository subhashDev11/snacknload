import 'package:flutter/material.dart';
import 'snacknload_container.dart';
import 'package:snacknload/src/animations/animation.dart';
import 'package:snacknload/src/animations/opacity_animation.dart';
import 'package:snacknload/src/animations/offset_animation.dart';
import 'package:snacknload/src/animations/scale_animation.dart';
import 'enums.dart';

class SnackbarTheme {
  /// boxShadow color of loading
  static List<BoxShadow>? get boxShadow =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom ? SnackNLoad.instance.boxShadow ?? [BoxShadow()] : null;

  /// font color of status
  static Color get messageColor => SnackNLoad.instance.loadingStyle == LoadingStyle.custom
      ? SnackNLoad.instance.textColor!
      : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
          ? Colors.white
          : Colors.black;

  static Color get titleColor => SnackNLoad.instance.loadingStyle == LoadingStyle.custom
      ? SnackNLoad.instance.textColor!
      : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
          ? Colors.white
          : Colors.black;

  /// mask color of loading
  static Color maskColor(LoadingMaskType? maskType) {
    maskType ??= SnackNLoad.instance.maskType;
    return maskType == LoadingMaskType.custom
        ? SnackNLoad.instance.maskColor!
        : maskType == LoadingMaskType.black
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.transparent;
  }

  /// loading animation
  static SnackNLoadLoadingAnimation get loadingAnimation {
    SnackNLoadLoadingAnimation animation;
    switch (SnackNLoad.instance.animationStyle) {
      case LoadingAnimationStyle.custom:
        animation = SnackNLoad.instance.customAnimation!;
        break;
      case LoadingAnimationStyle.offset:
        animation = OffsetAnimation();
        break;
      case LoadingAnimationStyle.scale:
        animation = ScaleAnimation();
        break;
      default:
        animation = OpacityAnimation();
        break;
    }
    return animation;
  }

  /// font size of status
  static double get fontSize => SnackNLoad.instance.fontSize;

  /// toast position
  static LoadingToastPosition get toastPosition => SnackNLoad.instance.toastPosition;

  /// toast position
  static AlignmentGeometry alignment(LoadingToastPosition? position) => position == LoadingToastPosition.bottom
      ? AlignmentDirectional.bottomCenter
      : (position == LoadingToastPosition.top ? AlignmentDirectional.topCenter : AlignmentDirectional.center);

  /// display duration
  static Duration get displayDuration => SnackNLoad.instance.displayDuration;

  /// animation duration
  static Duration get animationDuration => SnackNLoad.instance.animationDuration;

  /// contentPadding of loading
  static EdgeInsets get contentPadding => SnackNLoad.instance.contentPadding;

  /// padding of status
  static EdgeInsets get textPadding => SnackNLoad.instance.textPadding;

  /// textAlign of status
  static TextAlign get textAlign => SnackNLoad.instance.toastTextAlign;

  /// textStyle of status
  static TextStyle? get textStyle => SnackNLoad.instance.textStyle;

  /// radius of loading
  static double get radius => SnackNLoad.instance.radius;
  static Color get successSnackbarBGColor => SnackNLoad.instance.successSnackbarBGColor ?? Colors.green;
  static Color get errorSnackbarBGColor => SnackNLoad.instance.errorSnackbarBGColor ?? Colors.red;
  static Color get infoSnackbarBGColor => SnackNLoad.instance.infoSnackbarBGColor ?? Colors.blue;
  static Color get warningSnackbarBGColor => SnackNLoad.instance.warningSnackbarBGColor ?? Colors.orange;

  /// should dismiss on user tap
  static bool? get dismissOnTap => SnackNLoad.instance.dismissOnTap;

  static bool ignoring(LoadingMaskType? maskType) {
    maskType ??= SnackNLoad.instance.maskType;
    return SnackNLoad.instance.userInteractions ?? (maskType == LoadingMaskType.none ? true : false);
  }
}
