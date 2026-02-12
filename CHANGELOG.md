## 3.0.3 - Optional Blur & Enhanced Customization 🛠️

- **Optional Blur & Glassmorphism**: `useBlur` and `useGlassmorphism` now default to `false` in `SnackNLoad.show()` and `SnackNLoad.showEnhancedLoading()`, providing a standard dialog appearance by default.
- **New `backdropBlur` Parameter**: Added `backdropBlur` parameter to customize the intensity of the background blur (defaults to `5.0`).
- **Enhanced Control**: Users now have granular control over the visual effects of the loading container.

## 3.0.2 - Fixes & Improvements 🛠️

- **Progress Indicator Update**: Added missing `dismissOnTap` parameter support to `SnackNLoad.showProgress()`. Now you can control whether users can dismiss the progress dialog by tapping the mask.

## 3.0.1 - Minor exception message changes 🛠️

## 3.0.0 - Styles Reset & Configuration Fixes 🛠️

### ⚠️ Breaking Changes

- **Glassmorphism Disabled by Default**: To provide more standard behavior out-of-the-box, `glassmorphism` and enhanced shadows are now **disabled by default**. You must explicitly enable them if desired.
- **Default Shadows Removed**: The container no longer forces a default black shadow when `boxShadow` is not configured. It now properly respects the `SnackNLoad.instance.boxShadow` configuration, defaulting to no shadow (`null`) if nothing is set.

### 🐛 Fixes

- **BoxShadow Configuration**: Fixed a bug where `SnackNLoad.instance.boxShadow` (e.g., `[]`) was being ignored by the Enhanced Loading widget. You can now completely remove shadows by passing an empty list.
- **Dialog Updates**: Standardized dialog styles to match the new clean design philosophy.

## 2.0.0 - The Enhanced UI & Features Update 🚀

This major release introduces a complete overhaul of the UI components, adding modern aesthetics and powerful new features including Enhanced Dialogs, Interactive Tutorials, and Glassmorphic Loading/Snackbars.

### 🧩 Enhanced Dialog System (New!)

- **Multiple Dialog Styles**: Choose from `material`, `cupertino`, `adaptive`, or the new `enhanced` custom style.
- **New Methods**: `showOkDialog`, `showDecisiveDialog`, `showActionDialog`, `showFullScreenDialog`.
- **Custom UI**: Premium design with shadows, rounding, and extensive customization.

### 🎓 Tutorial & Tooltips

- **Interactive Onboarding**: Guide users step-by-step through your app.
- **Spotlight Effects**: Pulse animations and widget highlighting.
- **Controller**: Full programmatic control over the tutorial flow.

### 🎨 Enhanced UI Components

- **Enhanced Loading**: Glassmorphic blur effects, modern indicators, and smooth animations.
- **Enhanced Snackbar**: Rich notifications with progress bars, swipe-to-dismiss, and gradient styles.

### 🛠️ Improvements & Fixes

- **Stability**: Fixed lifecycle issues in overlays and tutorials.
- **Documentation**: Comprehensive guides and improved API docs.
- **Performance**: Optimized rendering for complex overlays.

## 1.0.1

- First release.

## 1.0.2

- Type added on showSnackbar

## 1.0.3

- Snackbar customization properties added

## 1.0.4

- Code format fixes

## 1.0.5

- Code formating and pub score related changes

## 1.0.6

### Improvements & Fixes

- Naming convention fixes.

### Breaking Changes

- Renamed `SnackbarType` to `Type`.
- Renamed `ToastType` to `Type`.
- Renamed `LoadingIndicatorPosition` to `Position`.

### Default Values Updated

- **Snackbar type:** `Info`
- **Snackbar position:** `Top`
- **Toast position:** `Top`

## 1.0.7

- Code formating and pub score related changes

## 1.0.8

- Default option changes

## 1.0.9

- Upgrade to latest

# 1.2.0

- SDK 3.35 compatibility support added

# 1.3.0

- Bug fixes and improvements
