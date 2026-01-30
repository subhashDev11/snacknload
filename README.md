# SnackNLoad

SnackNLoad is a Flutter package that provides a powerful, customizable, and easy-to-use solution for loading indicators and top snackbars in your Flutter application. With SnackNLoad, you can manage loading states and display success, error, or informational snackbars with ease.

**Pub.dev Link:** https://pub.dev/packages/snacknload

<p align="center">
  <img src="https://github.com/user-attachments/assets/c1706620-2f26-46a4-8fe6-5878b41d2ae5" width="45%" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/34bdc434-7338-4e4a-a775-5799df110443" width="45%" />
</p>

![snacknload](https://github.com/user-attachments/assets/fa8f9f77-7f7d-4345-9512-7760301c9d5b)

## Features

### 📚 Detailed Documentation

For complete guides on specific features, please refer to:

- **[Enhanced UI Features (Loaders & Snackbars)](./ENHANCED_UI.md)**: Full guide to glassmorphism, rich snackbars, and modern loaders.
- **[Tutorial & Tooltips System](./TUTORIAL_FEATURE.md)**: Comprehensive guide on implementing interactive tutorials and onboarding.

### 🎨 Enhanced UI (NEW!)

- **Rich Snackbars** with glassmorphism, progress bars, and swipe-to-dismiss (like GetX)
- **Modern Loading** indicators with blur effects and smooth animations
- **Interactive Elements** with tap callbacks and custom widgets
- **Premium Design** with gradients, shadows, and micro-interactions

### 🎓 Tutorial & Tooltips (NEW!)

- **Interactive Onboarding** - Guide users through your app features
- **Widget Highlighting** - Spotlight specific UI elements with pulse animations
- **Smart Positioning** - Auto-positioning or manual control for tooltips
- **Customizable Steps** - Full control over colors, icons, text, and behavior
- **Progress Tracking** - Built-in progress bar and step navigation
- **Auto-Advance** - Optional automatic progression between steps

### 📦 Core Features

- Multiple loading styles and indicators.
- Customizable snackbars with different types (success, error, info, warning).
- Flexible masking options during loading.
- Custom animations for loading indicators.
- Support for toast notifications at different positions (top, center, bottom).
- Easy integration and configuration.
- Styled snackbar with position options of top, center, bottom.
- Show dialog with customization options and adaptive support.
- All features are accessible after initialization and no need to provide context because snacknload uses their in-built global context.

## Installation

Add `snacknload` to your `pubspec.yaml` file:

```yaml
dependencies:
  snacknload: ^1.0.2
```

Then, run:

```bash
flutter pub get
```

## Getting Started

### 1. Import the Package

```dart
import 'package:snacknload/snacknload.dart';
```

### 2. Configure SnackNLoad

Configure `SnackNLoad` in your `main()` function:

```dart
void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  SnackNLoad.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = IndicatorType.fadingCircle
    ..loadingStyle = LoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
```

### 3. Initialize SnackNLoad in Your App

Use `SnackNLoad.init()` in the `builder` property of your `MaterialApp`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackNLoad Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'SnackNLoad Example'),
      builder: SnackNLoad.init(),
    );
  }
}
```

### 4. Use SnackNLoad in Your Widgets

#### Show a Loading Indicator

```dart
SnackNLoad.show(status: 'Loading...', maskType: MaskType.black);
```

#### Dismiss the Loading Indicator

```dart
SnackNLoad.dismiss();
```

#### Show a Success Snackbar

```dart
SnackNLoad.showSuccess('Operation Successful!');
```

#### Show an Error Snackbar

```dart
SnackNLoad.showError('Something went wrong!');
```

#### Show an Informational Snackbar

```dart
SnackNLoad.showInfo('Here is some information.');
```

#### Display a Toast

```dart
SnackNLoad.showToast('This is a toast message.');
```

#### Show a Top Snackbar

```dart
SnackNLoad.showSnackBar(
  'Welcome in year 2025!\nMay this year fulfill your dreams and bring happiness.',
  type: SnackNLoadType.success,
  title: "Hello",
  showIcon: false,
  position: SnackNLoadPosition.top,
);
```

### 🎨 Enhanced UI Features (NEW!)

#### Enhanced Loading with Glassmorphism

```dart
SnackNLoad.showEnhancedLoading(
  status: 'Loading...',
  maskType: MaskType.black,
  useBlur: true,              // Blur backdrop effect
  useGlassmorphism: true,     // Modern glass effect
);
```

#### Enhanced Snackbar with Rich Features

```dart
SnackNLoad.showEnhancedSnackBar(
  '🎉 Operation completed successfully!',
  title: 'Success',
  type: SnackNLoadType.success,
  position: SnackNLoadPosition.top,
  showProgressBar: true,          // Auto-dismiss progress bar
  duration: Duration(seconds: 4),
  enableSwipeToDismiss: true,     // Swipe to dismiss
  useGlassmorphism: true,         // Glassmorphism effect
  showCloseButton: true,          // Show close button
  onTap: () {                     // Tap callback
    print('Snackbar tapped!');
  },
);
```

#### Interactive Snackbar with Custom Widgets

```dart
SnackNLoad.showEnhancedSnackBar(
  'You have a new message',
  title: 'Notification',
  type: SnackNLoadType.info,
  onTap: () => Navigator.push(...),
  trailing: Icon(
    Icons.arrow_forward_ios,
    color: Colors.white,
    size: 16,
  ),
);
```

### 🎓 Tutorial & Tooltips (NEW!)

#### Basic Tutorial

```dart
// 1. Create GlobalKeys for widgets
final GlobalKey homeKey = GlobalKey();
final GlobalKey searchKey = GlobalKey();

// 2. Assign keys to widgets
IconButton(
  key: homeKey,
  icon: Icon(Icons.home),
  onPressed: () {},
)

// 3. Create and show tutorial
final controller = TutorialController(
  steps: [
    TutorialStep(
      id: 'home',
      title: 'Home Button',
      description: 'Tap here to return to the home screen',
      targetKey: homeKey,
      icon: Icons.home_rounded,
    ),
    TutorialStep(
      id: 'search',
      title: 'Search',
      description: 'Find anything in the app',
      targetKey: searchKey,
      icon: Icons.search_rounded,
    ),
  ],
);

SnackNLoad.showTutorial(
  controller: controller,
  onComplete: () => print('Tutorial completed!'),
);
```

#### Advanced Tutorial with Custom Styling

```dart
TutorialStep(
  id: 'custom',
  title: 'Custom Step',
  description: 'This step has custom colors and auto-advances',
  targetKey: myKey,
  backgroundColor: Color(0xFF8B5CF6),
  textColor: Colors.white,
  icon: Icons.star_rounded,
  showPulse: true,
  autoAdvanceDuration: Duration(seconds: 3),
  dismissOnTapOutside: true,
  onShow: () => print('Step shown'),
  onComplete: () => print('Step completed'),
)
```

**📖 See [TUTORIAL_FEATURE.md](TUTORIAL_FEATURE.md) for complete documentation and examples.**

> 📖 **For detailed documentation on enhanced UI features, see [ENHANCED_UI.md](ENHANCED_UI.md)**

#### Custom Animation

Create a custom animation for the loading indicator by extending `SnackNLoadLoadingAnimation`:

```dart
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
```

### 🧩 Enhanced Dialog System (NEW!)

#### Multiple Dialog Styles

Choose from Material, Cupertino, or our new Enhanced custom style!

```dart
// Enhanced Style (Custom UI)
SnackNLoad.showOkDialog(
  title: 'Enhanced',
  content: 'This uses the new Enhanced style!',
  dialogType: SnackNLoadDialogType.enhanced,
);

// iOS Style
SnackNLoad.showOkDialog(
  title: 'Cupertino',
  content: 'This looks like iOS!',
  dialogType: SnackNLoadDialogType.cupertino,
);
```

#### Convenience Methods

**Simple OK Dialog**

```dart
SnackNLoad.showOkDialog(
    title: 'Success',
    content: 'Operation completed!',
    onOk: () => print('OK'),
);
```

**Confirm/Cancel Dialog**

```dart
SnackNLoad.showDecisiveDialog(
    title: 'Delete?',
    content: 'Are you sure?',
    confirmLabel: 'Delete',
    onConfirm: () => deleteItem(),
    onCancel: () => print('Cancelled'),
);
```

**Full Screen Dialog**

```dart
SnackNLoad.showFullScreenDialog(
    title: 'Details',
    content: DetailsPage(),
);
```

## Advanced Usage

### Loading Styles

Choose from multiple loading styles:

```dart
SnackNLoad.instance.loadingStyle = LoadingStyle.dark;
```

### Toast Positions

Set toast position to top, center, or bottom:

```dart
SnackNLoad.instance.position = SnackNLoadPosition.top;
```

### Indicator Types

Switch between various indicator types:

```dart
SnackNLoad.instance.indicatorType = IndicatorType.wave;
```

### Mask Types

Control user interactions during loading:

```dart
SnackNLoad.instance.maskType = MaskType.black;
```

## Example Application

Check out the full example in the `example` folder to explore all the features.

## Acknowledgments

SnackNLoad is inspired by and extends the functionality of flutter_easyloading. We appreciate the contributions of the original package’s authors, which laid the groundwork for this project.

## License

SnackNLoad is released under the MIT License.

**Contributing**

We welcome contributions! Please feel free to open issues or submit pull requests.

**Connect with me:**

- **GitHub:** https://github.com/subhashDev11
- **LinkedIn:** https://www.linkedin.com/in/subhashcs/
- **Medium:** https://medium.com/@subhashchandrashukla
