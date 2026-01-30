# Quick Reference Guide - Enhanced UI

## 🚀 Quick Start

### Installation

```yaml
dependencies:
  snacknload: ^1.4.0
```

### Initialization

```dart
MaterialApp(
  builder: SnackNLoad.init(),
  // ...
)
```

## 📖 Common Use Cases

### 1. Simple Loading

```dart
// Show
await SnackNLoad.showEnhancedLoading(
  status: 'Loading...',
);

// Dismiss
await SnackNLoad.dismiss();
```

### 2. Success Message

```dart
SnackNLoad.showEnhancedSnackBar(
  'Operation completed!',
  title: 'Success',
  type: SnackNLoadType.success,
);
```

### 3. Error Message

```dart
SnackNLoad.showEnhancedSnackBar(
  'Something went wrong',
  title: 'Error',
  type: SnackNLoadType.error,
  showCloseButton: true,
);
```

### 4. Interactive Notification

```dart
SnackNLoad.showEnhancedSnackBar(
  'New message received',
  title: 'Notification',
  type: SnackNLoadType.info,
  onTap: () => Navigator.push(...),
  trailing: Icon(Icons.arrow_forward_ios),
);
```

### 5. Custom Duration

```dart
SnackNLoad.showEnhancedSnackBar(
  'This will stay for 10 seconds',
  duration: Duration(seconds: 10),
  showProgressBar: true,
);
```

### 6. Bottom Position

```dart
SnackNLoad.showEnhancedSnackBar(
  'Bottom notification',
  position: SnackNLoadPosition.bottom,
);
```

### 7. No Auto-Dismiss

```dart
SnackNLoad.showEnhancedSnackBar(
  'Manual dismiss only',
  showProgressBar: false,
  showCloseButton: true,
);
```

### 8. Custom Loading Indicator

```dart
SnackNLoad.showEnhancedLoading(
  status: 'Processing...',
  indicator: CircularProgressIndicator(
    color: Colors.white,
  ),
);
```

## 🎨 Customization

### Global Configuration

```dart
void configLoading() {
  SnackNLoad.instance
    ..radius = 16.0
    ..successContainerColor = Color(0xFF10B981)
    ..errorContainerColor = Color(0xFFEF4444)
    ..warningContainerColor = Color(0xFFF59E0B)
    ..infoContainerColor = Color(0xFF3B82F6)
    ..textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
}
```

### Per-Call Customization

```dart
SnackNLoad.showEnhancedSnackBar(
  'Custom styled message',
  backgroundColor: Colors.purple,
  titleStyle: TextStyle(fontSize: 18),
  messageStyle: TextStyle(fontSize: 14),
  contentPadding: EdgeInsets.all(20),
  margin: EdgeInsets.all(24),
);
```

## 🎯 All Parameters

### showEnhancedLoading()

```dart
SnackNLoad.showEnhancedLoading({
  String? status,              // Text below indicator
  Widget? indicator,           // Custom loading widget
  MaskType? maskType,         // Background mask
  bool? dismissOnTap,         // Tap to dismiss
  bool useBlur = true,        // Blur effect
  bool useGlassmorphism = true, // Glass effect
});
```

### showEnhancedSnackBar()

```dart
SnackNLoad.showEnhancedSnackBar(
  String message,             // Required message
  {
  String? title,              // Optional title
  SnackNLoadType? type,       // success/error/warning/info
  SnackNLoadPosition? position, // top/center/bottom
  Duration? duration,         // Auto-dismiss time
  bool showProgressBar = true, // Show countdown
  bool enableSwipeToDismiss = true, // Swipe gesture
  bool useGlassmorphism = true, // Glass effect
  bool showCloseButton = true, // X button
  bool? showIcon,            // Type icon
  VoidCallback? onTap,       // Tap callback
  Widget? leading,           // Custom leading widget
  Widget? trailing,          // Custom trailing widget
  TextStyle? titleStyle,     // Title styling
  TextStyle? messageStyle,   // Message styling
  Color? backgroundColor,    // Custom color
  EdgeInsets? contentPadding, // Inner padding
  EdgeInsets? margin,        // Outer margin
  MaskType? maskType,        // Background mask
  bool? dismissOnTap,        // Tap anywhere to dismiss
});
```

## 🎭 Types

### SnackNLoadType

- `SnackNLoadType.success` - Green, check icon
- `SnackNLoadType.error` - Red, error icon
- `SnackNLoadType.warning` - Orange, warning icon
- `SnackNLoadType.info` - Blue, info icon

### SnackNLoadPosition

- `SnackNLoadPosition.top` - Top of screen
- `SnackNLoadPosition.center` - Center of screen
- `SnackNLoadPosition.bottom` - Bottom of screen

### MaskType

- `MaskType.none` - No background
- `MaskType.clear` - Transparent background
- `MaskType.black` - Semi-transparent black
- `MaskType.custom` - Custom color (set maskColor)

## 💡 Tips & Tricks

### 1. Async Operations

```dart
Future<void> loadData() async {
  await SnackNLoad.showEnhancedLoading(status: 'Loading...');

  try {
    await fetchData();
    await SnackNLoad.dismiss();
    SnackNLoad.showEnhancedSnackBar(
      'Data loaded!',
      type: SnackNLoadType.success,
    );
  } catch (e) {
    await SnackNLoad.dismiss();
    SnackNLoad.showEnhancedSnackBar(
      e.toString(),
      title: 'Error',
      type: SnackNLoadType.error,
    );
  }
}
```

### 2. Form Validation

```dart
void submitForm() {
  if (!isValid) {
    SnackNLoad.showEnhancedSnackBar(
      'Please fill all required fields',
      title: 'Validation Error',
      type: SnackNLoadType.warning,
    );
    return;
  }
  // Submit...
}
```

### 3. Network Status

```dart
void onNetworkChange(bool isOnline) {
  if (!isOnline) {
    SnackNLoad.showEnhancedSnackBar(
      'No internet connection',
      title: 'Offline',
      type: SnackNLoadType.error,
      showProgressBar: false,
      showCloseButton: true,
    );
  }
}
```

### 4. Action Notifications

```dart
void showActionNotification() {
  SnackNLoad.showEnhancedSnackBar(
    'Tap to view details',
    title: 'New Update Available',
    type: SnackNLoadType.info,
    onTap: () => Navigator.push(...),
    trailing: Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
      size: 16,
    ),
  );
}
```

### 5. Progress Tracking

```dart
void uploadFile() async {
  double progress = 0;

  while (progress < 1.0) {
    await SnackNLoad.showProgress(
      progress,
      status: '${(progress * 100).toInt()}%',
    );
    progress += 0.1;
    await Future.delayed(Duration(milliseconds: 500));
  }

  await SnackNLoad.dismiss();
  SnackNLoad.showEnhancedSnackBar(
    'Upload complete!',
    type: SnackNLoadType.success,
  );
}
```

## ⚠️ Common Mistakes

### ❌ Don't

```dart
// Forgetting to initialize
MaterialApp(
  // Missing: builder: SnackNLoad.init(),
)

// Not dismissing loading
await SnackNLoad.showEnhancedLoading();
// Forgot to call dismiss()

// Using context-dependent navigation in onTap
onTap: () => Navigator.of(context).push(...) // context not available
```

### ✅ Do

```dart
// Proper initialization
MaterialApp(
  builder: SnackNLoad.init(),
)

// Always dismiss
await SnackNLoad.showEnhancedLoading();
await someOperation();
await SnackNLoad.dismiss();

// Use global navigation
onTap: () => Navigator.push(
  navigatorKey.currentContext!,
  MaterialPageRoute(...),
)
```

## 🔧 Troubleshooting

### Issue: Snackbar not showing

**Solution**: Make sure you initialized SnackNLoad in MaterialApp builder

### Issue: Blur not working

**Solution**: Some platforms have limited blur support. Set `useBlur: false`

### Issue: Swipe not dismissing

**Solution**: Check if `enableSwipeToDismiss: true` and swipe distance > 100px

### Issue: Progress bar not animating

**Solution**: Ensure `showProgressBar: true` and `duration` is set

### Issue: Custom colors not applying

**Solution**: Use `backgroundColor` parameter or configure globally

## 📚 More Resources

- **Full Documentation**: [ENHANCED_UI.md](ENHANCED_UI.md)
- **Design Specs**: [DESIGN_SPECS.md](DESIGN_SPECS.md)
- **Implementation Details**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
- **Demo App**: [example/lib/enhanced_demo.dart](example/lib/enhanced_demo.dart)

## 🆘 Support

- **GitHub Issues**: https://github.com/subhashDev11/snacknload/issues
- **Package**: https://pub.dev/packages/snacknload
- **LinkedIn**: https://www.linkedin.com/in/subhashcs/

---

**Happy Coding! 🚀**
