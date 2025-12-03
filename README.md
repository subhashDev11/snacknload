# SnackNLoad

SnackNLoad is a Flutter package that provides a powerful, customizable, and easy-to-use solution for loading indicators and top snackbars in your Flutter application. With SnackNLoad, you can manage loading states and display success, error, or informational snackbars with ease.

**Pub.dev Link:** https://pub.dev/packages/snacknload

![snacknload](https://github.com/user-attachments/assets/fa8f9f77-7f7d-4345-9512-7760301c9d5b)

## Features

- Multiple loading styles and indicators.
- Customizable snackbars with different types (success, error, info).
- Flexible masking options during loading.
- Custom animations for loading indicators.
- Support for toast notifications at different positions (top, center, bottom).
- Easy integration and configuration.
- Styled snackbar with position options of top, center, bottom.
- Show dialog with customization options and adaptive support.
- All features are accessible after initilization and no need to provide context because snacknload uses there in built global context.

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

* **GitHub:** https://github.com/subhashDev11
* **LinkedIn:** https://www.linkedin.com/in/subhashcs/
* **Medium:** https://medium.com/@subhashchandrashukla


