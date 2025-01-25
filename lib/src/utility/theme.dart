import 'package:flutter/material.dart';

import 'snacknload_container.dart';
import '../animations/animation.dart';
import '../animations/opacity_animation.dart';
import '../animations/offset_animation.dart';
import '../animations/scale_animation.dart';
import 'enums.dart';

class LoadingTheme {
  /// color of indicator
  static Color get indicatorColor =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.indicatorColor!
          : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
              ? Colors.white
              : Colors.black;

  /// progress color of loading
  static Color get progressColor =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.progressColor!
          : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
              ? Colors.white
              : Colors.black;

  /// background color of loading
  static Color get backgroundColor =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.backgroundColor!
          : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
              ? Colors.black.withOpacity(0.9)
              : Colors.white;

  /// boxShadow color of loading
  static List<BoxShadow>? get boxShadow =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.boxShadow ?? [BoxShadow()]
          : null;

  /// font color of status
  static Color get textColor =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
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
            ? Colors.black.withOpacity(0.5)
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

  /// size of indicator
  static double get indicatorSize => SnackNLoad.instance.indicatorSize;

  /// width of progress indicator
  static double get progressWidth => SnackNLoad.instance.progressWidth;

  /// width of indicator
  static double get lineWidth => SnackNLoad.instance.lineWidth;

  /// loading indicator type
  static LoadingIndicatorType get indicatorType =>
      SnackNLoad.instance.indicatorType;

  /// toast position
  static LoadingToastPosition get toastPosition =>
      SnackNLoad.instance.toastPosition;

  /// toast position
  static AlignmentGeometry alignment(LoadingToastPosition? position) =>
      position == LoadingToastPosition.bottom
          ? AlignmentDirectional.bottomCenter
          : (position == LoadingToastPosition.top
              ? AlignmentDirectional.topCenter
              : AlignmentDirectional.center);

  /// display duration
  static Duration get displayDuration => SnackNLoad.instance.displayDuration;

  /// animation duration
  static Duration get animationDuration =>
      SnackNLoad.instance.animationDuration;

  /// contentPadding of loading
  static EdgeInsets get contentPadding => SnackNLoad.instance.contentPadding;

  /// padding of status
  static EdgeInsets get textPadding => SnackNLoad.instance.textPadding;

  /// textAlign of status
  static TextAlign get textAlign => SnackNLoad.instance.textAlign;

  /// textStyle of status
  static TextStyle? get textStyle => SnackNLoad.instance.textStyle;

  /// radius of loading
  static double get radius => SnackNLoad.instance.radius;

  /// should dismiss on user tap
  static bool? get dismissOnTap => SnackNLoad.instance.dismissOnTap;

  static bool ignoring(LoadingMaskType? maskType) {
    maskType ??= SnackNLoad.instance.maskType;
    return SnackNLoad.instance.userInteractions ??
        (maskType == LoadingMaskType.none ? true : false);
  }
}
