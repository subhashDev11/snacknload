// import 'package:flutter/material.dart';
// import 'snacknload_container.dart';
// import 'package:snacknload/src/animations/animation.dart';
// import 'package:snacknload/src/animations/opacity_animation.dart';
// import 'package:snacknload/src/animations/offset_animation.dart';
// import 'package:snacknload/src/animations/scale_animation.dart';
// import 'enums.dart';
//
// class SnackbarTheme {
//   /// boxShadow color of loading
//   static List<BoxShadow>? get boxShadow =>
//       SnackNLoad.instance.loadingStyle == LoadingStyle.custom ? SnackNLoad.instance.boxShadow ?? [BoxShadow()] : null;
//
//   /// font color of status
//   static Color get messageColor => SnackNLoad.instance.loadingStyle == LoadingStyle.custom
//       ? SnackNLoad.instance.textColor!
//       : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
//           ? Colors.white
//           : Colors.black;
//
//   static Color get titleColor => SnackNLoad.instance.loadingStyle == LoadingStyle.custom
//       ? SnackNLoad.instance.textColor!
//       : SnackNLoad.instance.loadingStyle == LoadingStyle.dark
//           ? Colors.white
//           : Colors.black;
//
//   /// mask color of loading
//   static Color maskColor(MaskType? maskType) {
//     maskType ??= SnackNLoad.instance.maskType;
//     return maskType == MaskType.custom
//         ? SnackNLoad.instance.maskColor!
//         : maskType == MaskType.black
//             ? Colors.black.withValues(alpha: 0.5)
//             : Colors.transparent;
//   }
//
//   /// loading animation
//   static SnackNLoadLoadingAnimation get loadingAnimation {
//     SnackNLoadLoadingAnimation animation;
//     switch (SnackNLoad.instance.animationStyle) {
//       case SnackNLoadAnimationStyle.custom:
//         animation = SnackNLoad.instance.customAnimation!;
//         break;
//       case SnackNLoadAnimationStyle.offset:
//         animation = OffsetAnimation();
//         break;
//       case SnackNLoadAnimationStyle.scale:
//         animation = ScaleAnimation();
//         break;
//       default:
//         animation = OpacityAnimation();
//         break;
//     }
//     return animation;
//   }
//
//   /// font size of status
//   static double get fontSize => SnackNLoad.instance.fontSize;
//
//   /// toast position
//   static Position get toastPosition => SnackNLoad.instance.toastPosition;
//
//   /// toast position
//   static AlignmentGeometry alignment(Position position) => position == Position.bottom
//       ? AlignmentDirectional.bottomCenter
//       : (position == Position.top ? AlignmentDirectional.topCenter : AlignmentDirectional.center);
//
//   /// display duration
//   static Duration get displayDuration => SnackNLoad.instance.displayDuration;
//
//   /// animation duration
//   static Duration get animationDuration => SnackNLoad.instance.animationDuration;
//
//   /// contentPadding of loading
//   static EdgeInsets get contentPadding => SnackNLoad.instance.contentPadding;
//
//   /// padding of status
//   static EdgeInsets get textPadding => SnackNLoad.instance.textPadding;
//
//   /// textAlign of status
//   static TextAlign get textAlign => SnackNLoad.instance.toastTextAlign;
//
//   /// textStyle of status
//   static TextStyle? get textStyle => SnackNLoad.instance.textStyle;
//
//   /// radius of loading
//   static double get radius => SnackNLoad.instance.radius;
//   static Color get successSnackbarBGColor => SnackNLoad.instance.successSnackbarBGColor ?? Colors.green;
//   static Color get errorSnackbarBGColor => SnackNLoad.instance.errorSnackbarBGColor ?? Colors.red;
//   static Color get infoSnackbarBGColor => SnackNLoad.instance.infoSnackbarBGColor ?? Colors.blue;
//   static Color get warningSnackbarBGColor => SnackNLoad.instance.warningSnackbarBGColor ?? Colors.orange;
//
//   /// should dismiss on user tap
//   static bool? get dismissOnTap => SnackNLoad.instance.dismissOnTap;
//
//   static bool ignoring(MaskType? maskType) {
//     maskType ??= SnackNLoad.instance.maskType;
//     return SnackNLoad.instance.userInteractions ?? (maskType == MaskType.none ? true : false);
//   }
// }
