# Enhanced UI Features 🎨

This document describes the new enhanced UI features added to SnackNLoad, inspired by GetX's rich UI offerings.

## 🌟 New Features

### 1. Enhanced Loading (`showEnhancedLoading`)

Modern loading indicators with advanced visual effects:

```dart
SnackNLoad.showEnhancedLoading(
  status: 'Loading...',
  maskType: MaskType.black,
  useBlur: true,              // Blur backdrop effect
  useGlassmorphism: true,     // Glassmorphic container
);
```

**Features:**

- ✨ Blur backdrop filter for modern look
- 🎭 Glassmorphism effect with gradient backgrounds
- 🎬 Smooth scale and fade animations
- 💫 Enhanced shadows and borders
- 🎨 Customizable blur intensity

### 2. Enhanced Snackbar (`showEnhancedSnackBar`)

Rich notifications with interactive features:

```dart
SnackNLoad.showEnhancedSnackBar(
  'Operation completed successfully!',
  title: 'Success',
  type: SnackNLoadType.success,
  position: SnackNLoadPosition.top,
  showProgressBar: true,          // Auto-dismiss progress indicator
  duration: Duration(seconds: 4),
  enableSwipeToDismiss: true,     // Swipe to dismiss
  useGlassmorphism: true,         // Modern glass effect
  showCloseButton: true,          // Close button
  onTap: () {                     // Tap callback
    print('Snackbar tapped!');
  },
  leading: Icon(...),             // Custom leading widget
  trailing: Icon(...),            // Custom trailing widget
);
```

**Features:**

- 📊 Auto-dismiss progress bar
- 👆 Swipe-to-dismiss gesture
- 🎨 Glassmorphism with gradient backgrounds
- ❌ Optional close button
- 🔘 Tap callbacks for interactions
- 🎯 Custom leading/trailing widgets
- 🎭 Smooth slide animations
- 💎 Premium design with shadows

## 🎯 Comparison: Classic vs Enhanced

| Feature              | Classic | Enhanced |
| -------------------- | ------- | -------- |
| Blur Effect          | ❌      | ✅       |
| Glassmorphism        | ❌      | ✅       |
| Progress Bar         | ❌      | ✅       |
| Swipe to Dismiss     | ❌      | ✅       |
| Close Button         | ❌      | ✅       |
| Tap Callback         | ❌      | ✅       |
| Custom Widgets       | ❌      | ✅       |
| Gradient Backgrounds | ❌      | ✅       |
| Advanced Animations  | Basic   | Advanced |

## 📖 Usage Examples

### Success Notification

```dart
SnackNLoad.showEnhancedSnackBar(
  '🎉 Your profile has been updated!',
  title: 'Success',
  type: SnackNLoadType.success,
  showProgressBar: true,
  duration: Duration(seconds: 3),
);
```

### Error Notification

```dart
SnackNLoad.showEnhancedSnackBar(
  'Failed to connect to server. Please check your internet.',
  title: 'Connection Error',
  type: SnackNLoadType.error,
  showProgressBar: true,
  showCloseButton: true,
);
```

### Interactive Notification

```dart
SnackNLoad.showEnhancedSnackBar(
  'You have a new message from John',
  title: 'New Message',
  type: SnackNLoadType.info,
  onTap: () {
    // Navigate to messages
    Navigator.push(...);
  },
  trailing: Icon(
    Icons.arrow_forward_ios,
    color: Colors.white,
    size: 16,
  ),
);
```

### Custom Loading

```dart
SnackNLoad.showEnhancedLoading(
  status: 'Processing payment...',
  indicator: CircularProgressIndicator(
    color: Colors.white,
  ),
  useBlur: true,
  useGlassmorphism: true,
);
```

## 🎨 Design Philosophy

The enhanced UI features follow modern design principles:

1. **Glassmorphism**: Frosted glass effect with blur and transparency
2. **Micro-interactions**: Smooth animations and transitions
3. **Visual Hierarchy**: Clear typography and spacing
4. **Feedback**: Progress indicators and interactive elements
5. **Accessibility**: Swipe gestures and close buttons

## 🔧 Configuration

You can customize the enhanced UI globally:

```dart
SnackNLoad.instance
  ..radius = 16.0                                    // Rounded corners
  ..successContainerColor = Color(0xFF10B981)        // Modern green
  ..errorContainerColor = Color(0xFFEF4444)          // Modern red
  ..warningContainerColor = Color(0xFFF59E0B)        // Modern orange
  ..infoContainerColor = Color(0xFF3B82F6)           // Modern blue
  ..textStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.white,
  );
```

## 🎭 Animation Details

### Enhanced Loading

- **Entry**: Scale from 0 to 1 with easeOutBack curve
- **Fade**: Opacity animation with easeOut curve
- **Blur**: Progressive blur from 0 to 5 sigma
- **Duration**: 300ms

### Enhanced Snackbar

- **Entry**: Slide from top/bottom with easeOutCubic curve
- **Fade**: Opacity animation with easeOut curve
- **Swipe**: Gesture-based dismissal with drag tracking
- **Progress**: Linear countdown animation
- **Duration**: 400ms

## 🚀 Performance

The enhanced UI features are optimized for performance:

- Uses `BackdropFilter` efficiently
- Minimal rebuilds with `AnimatedBuilder`
- Gesture detection only when needed
- Automatic cleanup of resources

## 💡 Tips

1. **Use glassmorphism sparingly** - It can be CPU intensive on older devices
2. **Enable swipe-to-dismiss** - Improves user experience
3. **Show progress bars** - Gives users visual feedback on auto-dismiss
4. **Use appropriate durations** - 3-4 seconds for most notifications
5. **Add close buttons** - For important messages that users might want to keep visible

## 🔄 Migration from Classic

To migrate from classic to enhanced UI:

```dart
// Before
SnackNLoad.showSnackBar(
  'Message',
  type: SnackNLoadType.success,
);

// After
SnackNLoad.showEnhancedSnackBar(
  'Message',
  type: SnackNLoadType.success,
  showProgressBar: true,
  enableSwipeToDismiss: true,
  useGlassmorphism: true,
);
```

## 🎯 Best Practices

1. **Success messages**: Use green with check icon
2. **Errors**: Use red with error icon, add close button
3. **Warnings**: Use orange/yellow with warning icon
4. **Info**: Use blue with info icon
5. **Interactive**: Add onTap callback and trailing arrow icon
6. **Long messages**: Increase duration or disable auto-dismiss

## 📱 Platform Support

Enhanced UI features work on:

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

Note: Blur effects may have varying performance on different platforms.
