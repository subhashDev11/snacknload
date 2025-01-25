// The MIT License (MIT)
//
// Copyright (c) 2020 nslogx
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'package:flutter/material.dart';

import 'snacknload_container.dart';
import '../animations/animation.dart';
import '../animations/opacity_animation.dart';
import '../animations/offset_animation.dart';
import '../animations/scale_animation.dart';
import 'enums.dart';

class ToastTheme {

  /// boxShadow color of loading
  static List<BoxShadow>? get boxShadow =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.boxShadow ?? [BoxShadow()]
          : null;

  /// font color of status
  static Color get messageColor =>
      SnackNLoad.instance.loadingStyle == LoadingStyle.custom
          ? SnackNLoad.instance.textColor!
          : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
          ? Colors.white
          : Colors.black;

  static Color get titleColor =>
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
  static TextAlign get textAlign => SnackNLoad.instance.toastTextAlign;

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
