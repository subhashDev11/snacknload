import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snacknload/src/utility/snacknload_theme.dart';
import 'package:snacknload/src/widgets/dialog_container.dart';
import 'package:snacknload/src/widgets/loading_container.dart';
import 'package:snacknload/src/widgets/enhanced_loading_container.dart';
import 'package:snacknload/src/widgets/enhanced_snackbar_container.dart';
import 'package:snacknload/src/widgets/tutorial_tooltip.dart';

import 'package:snacknload/src/widgets/feature_spotlight.dart';
import 'package:snacknload/src/widgets/progress.dart';
import 'package:snacknload/src/widgets/indicator.dart';
import 'package:snacknload/src/widgets/overlay_entry.dart';
import 'package:snacknload/src/widgets/loading.dart';
import 'package:snacknload/src/widgets/snackbar_container.dart';
import 'package:snacknload/src/widgets/snacknload_button.dart';
import 'package:snacknload/src/animations/animation.dart';
import 'enums.dart';

class SnackNLoad {
  /// loading style, default [SnackNLoadStyle.dark].
  late LoadingStyle loadingStyle;

  /// loading indicator type, default [SnackNLoadIndicatorType.fadingCircle].
  late IndicatorType indicatorType;

  /// loading mask type, default [MaskType.none].
  late MaskType maskType;

  /// toast position, default [Position.center].
  late SnackNLoadPosition position;

  /// loading animationStyle, default [SnackNLoadAnimationStyle.opacity].
  late SnackNLoadAnimationStyle animationStyle;

  /// textAlign of status, default [TextAlign.center].
  late TextAlign textAlign;
  late TextAlign toastTextAlign;

  /// content padding of loading.
  late EdgeInsets contentPadding;

  /// padding of [status].
  late EdgeInsets textPadding;

  /// size of indicator, default 40.0.
  late double indicatorSize;

  /// radius of loading, default 5.0.
  late double radius;

  /// fontSize of loading, default 15.0.
  late double fontSize;

  /// width of progress indicator, default 2.0.
  late double progressWidth;

  /// width of indicator, default 4.0, only used for [SnackNLoadIndicatorType.ring, SnackNLoadIndicatorType.dualRing].
  late double lineWidth;

  /// display duration of [showSuccess] [showError] [showInfo] [showToast], default 2000ms.
  late Duration displayDuration;

  /// animation duration of indicator, default 200ms.
  late Duration animationDuration;

  /// loading custom animation, default null.
  SnackNLoadLoadingAnimation? customAnimation;

  /// textStyle of status, default null.
  TextStyle? textStyle;

  /// color of loading status, only used for [SnackNLoadStyle.custom].
  Color? textColor;

  /// color of loading indicator, only used for [SnackNLoadStyle.custom].
  Color? indicatorColor;

  /// progress color of loading, only used for [SnackNLoadStyle.custom].
  Color? progressColor;

  /// background color of loading, only used for [SnackNLoadStyle.custom].
  Color? backgroundColor;

  /// boxShadow of loading, only used for [SnackNLoadStyle.custom].
  List<BoxShadow>? boxShadow;

  /// mask color of loading, only used for [MaskType.custom].
  Color? maskColor;

  /// should allow user interactions while loading is displayed.
  bool? userInteractions;

  /// should dismiss on user tap.
  bool? dismissOnTap;

  /// indicator widget of loading
  Widget? indicatorWidget;

  /// success widget of loading
  Widget? successWidget;

  /// error widget of loading
  Widget? errorWidget;

  /// info widget of loading
  Widget? infoWidget;

  Widget? _w;

  Color? successContainerColor;
  Color? errorContainerColor;
  Color? infoContainerColor;
  Color? warningContainerColor;

  SnackNLoadOverlayEntry? overlayEntry;
  GlobalKey<LoadingContainerState>? _key;
  GlobalKey<LoadingProgressState>? _progressKey;
  Timer? _timer;

  Widget? get w => _w;

  GlobalKey<LoadingContainerState>? get key => _key;

  GlobalKey<LoadingProgressState>? get progressKey => _progressKey;

  final List<LoadingStatusCallback> _statusCallbacks =
      <LoadingStatusCallback>[];

  factory SnackNLoad() => _instance;
  static final SnackNLoad _instance = SnackNLoad._internal();

  SnackNLoad._internal() {
    /// set deafult value
    loadingStyle = LoadingStyle.dark;
    indicatorType = IndicatorType.fadingCircle;
    maskType = MaskType.black;
    position = SnackNLoadPosition.center;
    animationStyle = SnackNLoadAnimationStyle.opacity;
    textAlign = TextAlign.center;
    toastTextAlign = TextAlign.start;
    indicatorSize = 40.0;
    radius = 5.0;
    fontSize = 15.0;
    progressWidth = 2.0;
    lineWidth = 4.0;
    displayDuration = const Duration(milliseconds: 2000);
    animationDuration = const Duration(milliseconds: 200);
    textPadding = const EdgeInsets.only(bottom: 10.0);
    contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    );
    successContainerColor = Colors.green;
    errorContainerColor = Colors.red;
    infoContainerColor = Colors.blue;
    warningContainerColor = Colors.orange;
    progressColor = Colors.blue; // Initialize progress color
  }

  static SnackNLoad get instance => _instance;

  static bool get isShow => _instance.w != null;

  /// init SnackNLoad
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingWidget(child: child));
      } else {
        return LoadingWidget(child: child);
      }
    };
  }

  /// show loading with [status] [indicator] [maskType]
  static Future<void> show({
    String? status,
    Widget? indicator,
    MaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = indicator ?? (_instance.indicatorWidget ?? LoadingIndicator());
    return _instance._show(
      status: status,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// show progress with [value] [status] [maskType], value should be 0.0 ~ 1.0.
  static Future<void> showProgress(
    double value, {
    String? status,
    MaskType? maskType,
  }) async {
    assert(
      value >= 0.0 && value <= 1.0,
      'progress value should be 0.0 ~ 1.0',
    );

    if (_instance.loadingStyle == LoadingStyle.custom) {
      assert(
        _instance.progressColor != null,
        'while loading style is custom, progressColor should not be null',
      );
    }

    if (_instance.w == null || _instance.progressKey == null) {
      if (_instance.key != null) await dismiss(animation: false);
      GlobalKey<LoadingProgressState> progressKey =
          GlobalKey<LoadingProgressState>();
      Widget w = LoadingProgress(
        key: progressKey,
        value: value,
      );
      _instance._show(
        status: status,
        maskType: maskType,
        dismissOnTap: false,
        w: w,
      );
      _instance._progressKey = progressKey;
    }
    // update progress
    _instance.progressKey?.currentState?.updateProgress(min(1.0, value));
    // update status
    if (status != null) _instance.key?.currentState?.updateStatus(status);
  }

  /// showSuccess [status] [duration] [maskType]
  static Future<void> showSuccess(
    String status, {
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.successWidget ??
        Icon(
          Icons.done,
          color: SnackNLoadTheme.indicatorColor,
          size: SnackNLoadTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? SnackNLoadTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  Future<void> _showDialog({
    Widget? contentWidget,
    Widget? titleWidget,
    String? title,
    TextStyle? titleStyle,
    bool? dismissOnTap,
    MaskType? maskType,
    bool? useAdaptive,
    ShapeBorder? shape,
    List<ActionConfig>? actionConfigs,
    bool isFullScreen = false,
    SnackNLoadDialogType? dialogType,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoadLoading.init() in your MaterialApp',
    );

    maskType ??= _instance.maskType;
    if (maskType == MaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    if (animationStyle == SnackNLoadAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<LoadingContainerState>();
    _w = DialogContainer(
      useAdaptive: useAdaptive ?? false,
      title: title,
      titleWidget: titleWidget,
      titleStyle: titleStyle,
      contentWidget: contentWidget,
      completer: completer,
      animation: animation,
      dismissOnTap: dismissOnTap,
      maskType: maskType,
      shape: shape,
      actionConfigs: actionConfigs,
      isFullScreen: isFullScreen,
      dialogType: dialogType,
    );
    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
    });
    _markNeedsBuild();
    return completer.future;
  }

  /// showError [status] [duration] [maskType]
  static Future<void> showError(
    String status, {
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.errorWidget ??
        Icon(
          Icons.clear,
          color: SnackNLoadTheme.indicatorColor,
          size: SnackNLoadTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? SnackNLoadTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// showInfo [status] [duration] [maskType]
  static Future<void> showInfo(
    String status, {
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.infoWidget ??
        Icon(
          Icons.info_outline,
          color: SnackNLoadTheme.indicatorColor,
          size: SnackNLoadTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? SnackNLoadTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// showToast [status] [duration] [position] [maskType]
  static Future<void> showToast(
    String status, {
    Duration? duration,
    SnackNLoadPosition? position,
    MaskType? maskType,
    bool? dismissOnTap,
  }) {
    return _instance._show(
      status: status,
      duration: duration ?? SnackNLoadTheme.displayDuration,
      position: position ?? SnackNLoadTheme.position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// showSnackBar [message] [duration] [toastType] [position] [maskType]
  static Future<void> showSnackBar(
    String message, {
    Duration? duration,
    SnackNLoadPosition? position,
    MaskType? maskType,
    bool? dismissOnTap,
    bool? showIcon,
    String? title,
    SnackNLoadType? type,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    bool? showDivider,
    EdgeInsets? contentPadding,
    EdgeInsets? margin,
    Color? backgroundColor,
  }) {
    return _instance._showSnackbar(
      message: message,
      showIcon: showIcon,
      title: title,
      type: type ?? SnackNLoadType.info,
      showDivider: showDivider,
      messageStyle: messageStyle,
      titleStyle: titleStyle,
      duration: duration ??
          Duration(
            seconds: 3,
          ),
      position: position ?? SnackNLoadPosition.top,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      margin: margin,
      contentPadding: contentPadding,
      backgroundColor: backgroundColor,
    );
  }

  /// showDialog
  static Future<void> showDialog({
    Widget? contentWidget,
    Widget? titleWidget,
    String? title,
    TextStyle? titleStyle,
    bool? dismissOnTap,
    MaskType? maskType,
    bool? useAdaptive,
    List<ActionConfig>? actionConfigs,
    bool isFullScreen = false,
    SnackNLoadDialogType? dialogType,
  }) {
    return _instance._showDialog(
      contentWidget: contentWidget,
      titleWidget: titleWidget,
      title: title,
      titleStyle: titleStyle,
      dismissOnTap: dismissOnTap,
      maskType: maskType,
      useAdaptive: useAdaptive,
      actionConfigs: actionConfigs,
      isFullScreen: isFullScreen,
      dialogType: dialogType,
    );
  }

  /// Show a simple dialog with an OK button
  static Future<void> showOkDialog({
    required String title,
    required String content,
    String okLabel = 'OK',
    VoidCallback? onOk,
    bool useAdaptive = true,
    TextStyle? titleStyle,
    MaskType? maskType,
    SnackNLoadDialogType? dialogType,
  }) {
    return showDialog(
      title: title,
      contentWidget: Text(content),
      useAdaptive: useAdaptive,
      titleStyle: titleStyle,
      maskType: maskType,
      dialogType: dialogType,
      actionConfigs: [
        ActionConfig(
          label: okLabel,
          onPressed: onOk ?? () {},
        ),
      ],
    );
  }

  /// Show a dialog with Confirm/Cancel buttons
  static Future<void> showDecisiveDialog({
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool useAdaptive = true,
    TextStyle? titleStyle,
    MaskType? maskType,
    SnackNLoadDialogType? dialogType,
  }) {
    return showDialog(
      title: title,
      contentWidget: Text(content),
      useAdaptive: useAdaptive,
      titleStyle: titleStyle,
      maskType: maskType,
      dialogType: dialogType,
      actionConfigs: [
        ActionConfig(
          label: cancelLabel,
          onPressed: onCancel ?? () {},
          buttonVariant: ButtonVariant.ghost,
        ),
        ActionConfig(
          label: confirmLabel,
          onPressed: onConfirm,
          buttonVariant: ButtonVariant.primary,
        ),
      ],
    );
  }

  /// Show a dialog with custom actions
  static Future<void> showActionDialog({
    required String title,
    required Widget content,
    required List<ActionConfig> actions,
    bool useAdaptive = true,
    TextStyle? titleStyle,
    MaskType? maskType,
    SnackNLoadDialogType? dialogType,
  }) {
    return showDialog(
      title: title,
      contentWidget: content,
      useAdaptive: useAdaptive,
      titleStyle: titleStyle,
      maskType: maskType,
      dialogType: dialogType,
      actionConfigs: actions,
    );
  }

  /// Show a full screen dialog
  static Future<void> showFullScreenDialog({
    required String title,
    required Widget content,
    Widget? titleWidget,
    List<ActionConfig>? actions,
    TextStyle? titleStyle,
  }) {
    return showDialog(
      title: title,
      titleWidget: titleWidget,
      contentWidget: content,
      useAdaptive: false, // Full screen usually uses custom layout
      titleStyle: titleStyle,
      actionConfigs: actions,
      isFullScreen: true,
      maskType: MaskType.none, // Usually no mask for full screen
    );
  }

  /// Enhanced loading with modern UI effects (blur, glassmorphism)
  static Future<void> showEnhancedLoading({
    String? status,
    Widget? indicator,
    MaskType? maskType,
    bool? dismissOnTap,
    bool useBlur = true,
    bool useGlassmorphism = true,
  }) {
    Widget w = indicator ?? (_instance.indicatorWidget ?? LoadingIndicator());
    return _instance._showEnhanced(
      status: status,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
      useBlur: useBlur,
      useGlassmorphism: useGlassmorphism,
    );
  }

  /// Enhanced snackbar with rich UI features like GetX
  static Future<void> showEnhancedSnackBar(
    String message, {
    Duration? duration,
    SnackNLoadPosition? position,
    MaskType? maskType,
    bool? dismissOnTap,
    bool? showIcon,
    String? title,
    SnackNLoadType? type,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    bool? showDivider,
    EdgeInsets? contentPadding,
    EdgeInsets? margin,
    Color? backgroundColor,
    bool showProgressBar = true,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool enableSwipeToDismiss = true,
    bool useGlassmorphism = true,
    bool showCloseButton = true,
  }) {
    return _instance._showEnhancedSnackbar(
      message: message,
      showIcon: showIcon,
      title: title,
      type: type ?? SnackNLoadType.info,
      showDivider: showDivider,
      messageStyle: messageStyle,
      titleStyle: titleStyle,
      duration: duration ?? const Duration(seconds: 3),
      position: position ?? SnackNLoadPosition.top,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      margin: margin,
      contentPadding: contentPadding,
      backgroundColor: backgroundColor,
      showProgressBar: showProgressBar,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      enableSwipeToDismiss: enableSwipeToDismiss,
      useGlassmorphism: useGlassmorphism,
      showCloseButton: showCloseButton,
    );
  }

  /// Show interactive tutorial/onboarding tooltips
  ///
  /// Displays a series of tutorial steps that highlight specific widgets
  /// and guide users through app features.
  ///
  /// Example:
  /// ```dart
  /// final controller = TutorialController(
  ///   steps: [
  ///     TutorialStep(
  ///       id: 'step1',
  ///       title: 'Welcome!',
  ///       description: 'This is the home button',
  ///       targetKey: homeButtonKey,
  ///     ),
  ///   ],
  /// );
  ///
  /// SnackNLoad.showTutorial(
  ///   controller: controller,
  ///   onComplete: () => print('Tutorial completed!'),
  /// );
  /// ```
  static Future<void> showTutorial({
    required TutorialController controller,
    required VoidCallback onComplete,
    Color? overlayColor,
    double? overlayOpacity,
    bool useBlur = true,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    return _instance._showTutorial(
      controller: controller,
      onComplete: onComplete,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      useBlur: useBlur,
      animationDuration: animationDuration,
    );
  }

  /// Show feature spotlight
  ///
  /// Highlights a specific widget with a non-blocking spotlight effect.
  ///
  /// Example:
  /// ```dart
  /// SnackNLoad.showSpotlight(
  ///   config: SpotlightConfig(
  ///     id: 'new_feature',
  ///     targetKey: myButtonKey,
  ///     title: 'New Feature!',
  ///     description: 'Check out this new button',
  ///     icon: Icons.star,
  ///     shape: SpotlightShape.circle,
  ///   ),
  /// );
  /// ```
  static Future<void> showSpotlight({
    required SpotlightConfig config,
    Color? overlayColor,
    double overlayOpacity = 0.8,
    bool useBlur = true,
  }) {
    return _instance._showSpotlight(
      config: config,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      useBlur: useBlur,
    );
  }

  /// dismiss loading
  static Future<void> dismiss({
    bool animation = true,
  }) {
    // cancel timer
    _instance._cancelTimer();
    return _instance._dismiss(animation);
  }

  /// add loading status callback
  static void addStatusCallback(LoadingStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// remove single loading status callback
  static void removeCallback(LoadingStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// remove all loading status callback
  static void removeAllCallbacks() {
    _instance._statusCallbacks.clear();
  }

  /// show [status] [duration] [position] [maskType]
  Future<void> _show({
    Widget? w,
    String? status,
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
    SnackNLoadPosition? position,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoadLoading.init() in your MaterialApp',
    );

    if (loadingStyle == LoadingStyle.custom) {
      assert(
        backgroundColor != null,
        'while loading style is custom, backgroundColor should not be null',
      );
      assert(
        indicatorColor != null,
        'while loading style is custom, indicatorColor should not be null',
      );
      assert(
        textColor != null,
        'while loading style is custom, textColor should not be null',
      );
    }

    maskType ??= _instance.maskType;
    if (maskType == MaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    if (animationStyle == SnackNLoadAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

    position ??= SnackNLoadPosition.center;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<LoadingContainerState>();
    _w = LoadingContainer(
      key: _key,
      status: status,
      indicator: w,
      animation: animation,
      position: position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
    );
    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  /// show styled [status] [duration] [position] [maskType]
  Future<void> _showSnackbar({
    required String message,
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
    bool? showIcon,
    bool? showDivider,
    String? title,
    SnackNLoadPosition? position,
    required SnackNLoadType type,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? margin,
    Color? backgroundColor,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoadLoading.init() in your MaterialApp',
    );

    maskType ??= _instance.maskType;
    if (maskType == MaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    if (animationStyle == SnackNLoadAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

    position ??= SnackNLoadPosition.center;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<LoadingContainerState>();
    _w = SnackBarContainer(
      key: _key,
      type: type,
      message: message,
      title: title,
      showIcon: showIcon,
      animation: animation,
      position: position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
      titleStyle: titleStyle,
      messageStyle: messageStyle,
      showDivider: showDivider,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      margin: margin,
    );
    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  /// Enhanced show with modern UI effects
  Future<void> _showEnhanced({
    Widget? w,
    String? status,
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
    SnackNLoadPosition? position,
    bool useBlur = true,
    bool useGlassmorphism = true,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoadLoading.init() in your MaterialApp',
    );

    if (loadingStyle == LoadingStyle.custom) {
      assert(
        backgroundColor != null,
        'while loading style is custom, backgroundColor should not be null',
      );
      assert(
        indicatorColor != null,
        'while loading style is custom, indicatorColor should not be null',
      );
      assert(
        textColor != null,
        'while loading style is custom, textColor should not be null',
      );
    }

    maskType ??= _instance.maskType;
    if (maskType == MaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    position ??= SnackNLoadPosition.center;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<LoadingContainerState>();
    _w = EnhancedLoadingContainer(
      key: _key,
      status: status,
      indicator: w,
      animation: animation,
      position: position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
      useBlur: useBlur,
      useGlassmorphism: useGlassmorphism,
    );
    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  /// Enhanced snackbar with rich UI features
  Future<void> _showEnhancedSnackbar({
    required String message,
    Duration? duration,
    MaskType? maskType,
    bool? dismissOnTap,
    bool? showIcon,
    bool? showDivider,
    String? title,
    SnackNLoadPosition? position,
    required SnackNLoadType type,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    EdgeInsets? contentPadding,
    EdgeInsets? margin,
    Color? backgroundColor,
    bool showProgressBar = true,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool enableSwipeToDismiss = true,
    bool useGlassmorphism = true,
    bool showCloseButton = true,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoadLoading.init() in your MaterialApp',
    );

    maskType ??= _instance.maskType;
    if (maskType == MaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    position ??= SnackNLoadPosition.top;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<LoadingContainerState>();
    _w = EnhancedSnackBarContainer(
      key: _key,
      type: type,
      message: message,
      title: title,
      showIcon: showIcon,
      animation: animation,
      position: position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
      titleStyle: titleStyle,
      messageStyle: messageStyle,
      showDivider: showDivider,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      margin: margin,
      showProgressBar: showProgressBar,
      duration: duration,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      enableSwipeToDismiss: enableSwipeToDismiss,
      useGlassmorphism: useGlassmorphism,
      showCloseButton: showCloseButton,
    );
    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  /// Private method to show tutorial overlay
  Future<void> _showTutorial({
    required TutorialController controller,
    required VoidCallback onComplete,
    Color? overlayColor,
    double? overlayOpacity,
    bool useBlur = true,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoad.init() in your MaterialApp',
    );

    Completer<void> completer = Completer<void>();

    _w = TutorialOverlay(
      controller: controller,
      onComplete: () {
        onComplete();
        dismiss();
      },
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      useBlur: useBlur,
      animationDuration: animationDuration,
    );

    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
    });

    _markNeedsBuild();
    return completer.future;
  }

  /// Private method to show feature spotlight
  Future<void> _showSpotlight({
    required SpotlightConfig config,
    Color? overlayColor,
    double overlayOpacity = 0.8,
    bool useBlur = true,
  }) async {
    assert(
      overlayEntry != null,
      'You should call SnackNLoad.init() in your MaterialApp',
    );

    Completer<void> completer = Completer<void>();

    _w = FeatureSpotlight(
      config: config,
      onDismiss: () {
        dismiss();
      },
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      useBlur: useBlur,
    );

    completer.future.whenComplete(() {
      _callback(LoadingStatus.show);
    });

    _markNeedsBuild();
    return completer.future;
  }

  Future<void> _dismiss(bool animation) async {
    if (key != null && key?.currentState == null) {
      _reset();
      return;
    }

    return key?.currentState?.dismiss(animation).whenComplete(() {
      _reset();
    });
  }

  void _reset() {
    _w = null;
    _key = null;
    _progressKey = null;
    _cancelTimer();
    _markNeedsBuild();
    _callback(LoadingStatus.dismiss);
  }

  void _callback(LoadingStatus status) {
    for (final LoadingStatusCallback callback in _statusCallbacks) {
      callback(status);
    }
  }

  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
