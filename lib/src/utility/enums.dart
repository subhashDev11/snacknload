/// Toast type
enum ToastType { info, success, error, warning }

/// Snackbar type
enum SnackbarType { info, success, error, warning }

/// Loading style
enum LoadingStyle {
  light,
  dark,
  custom,
}

/// Toast position
enum LoadingToastPosition {
  top,
  center,
  bottom,
}

/// Loading animation
enum LoadingAnimationStyle {
  opacity,
  offset,
  scale,
  custom,
}

/// Loading mask type
/// [none] default mask type, allow user interactions while loading is displayed
/// [clear] don't allow user interactions while loading is displayed
/// [black] don't allow user interactions while loading is displayed
/// [custom] while mask type is custom, maskColor should not be null
enum LoadingMaskType {
  none,
  clear,
  black,
  custom,
}

/// Loading indicator type. see [https://github.com/jogboms/flutter_spinkit#-showcase]
enum LoadingIndicatorType {
  fadingCircle,
  circle,
  threeBounce,
  chasingDots,
  wave,
  wanderingCubes,
  rotatingPlain,
  doubleBounce,
  fadingFour,
  fadingCube,
  pulse,
  cubeGrid,
  rotatingCircle,
  foldingCube,
  pumpingHeart,
  dualRing,
  hourGlass,
  pouringHourGlass,
  fadingGrid,
  ring,
  ripple,
  spinningCircle,
  squareCircle,
}

/// Loading status
enum LoadingStatus {
  show,
  dismiss,
}

typedef LoadingStatusCallback = void Function(LoadingStatus status);
