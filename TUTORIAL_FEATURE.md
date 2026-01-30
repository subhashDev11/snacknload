# Tutorial & Tooltips Feature

## 📚 Overview

The **Tutorial/Tooltips** feature allows developers to create interactive onboarding experiences and feature highlights in their Flutter apps. Guide users through your app with beautiful, customizable tooltips that highlight specific widgets.

<p align="center">
  <img src="https://github.com/user-attachments/assets/34bdc434-7338-4e4a-a775-5799df110443" width="70%" />
  &nbsp;&nbsp;&nbsp;
</p>

## ✨ Features

- **🎯 Widget Targeting**: Highlight any widget using GlobalKeys
- **📍 Smart Positioning**: Auto-positioning or manual control (top, bottom, left, right, corners)
- **💫 Pulse Animation**: Optional pulsing effect on highlighted widgets
- **🎨 Fully Customizable**: Colors, icons, text, buttons, and more
- **⏱️ Auto-Advance**: Optional automatic progression between steps
- **👆 Interactive**: Tap outside to dismiss, custom tap callbacks
- **📊 Progress Tracking**: Built-in progress bar and step counter
- **🔄 Navigation**: Next, back, skip, and jump to specific steps
- **🎭 Blur Overlay**: Optional backdrop blur for modern look
- **📱 Responsive**: Automatically adjusts to screen size

## 🚀 Quick Start

### Basic Tutorial

```dart
import 'package:snacknload/snacknload.dart';

// 1. Create GlobalKeys for widgets you want to highlight
final GlobalKey homeKey = GlobalKey();
final GlobalKey searchKey = GlobalKey();

// 2. Assign keys to widgets
IconButton(
  key: homeKey,
  icon: Icon(Icons.home),
  onPressed: () {},
)

// 3. Create tutorial steps
final controller = TutorialController(
  steps: [
    TutorialStep(
      id: 'home',
      title: 'Home Button',
      description: 'Tap here to return to the home screen',
      targetKey: homeKey,
    ),
    TutorialStep(
      id: 'search',
      title: 'Search',
      description: 'Find anything in the app',
      targetKey: searchKey,
    ),
  ],
);

// 4. Show the tutorial
SnackNLoad.showTutorial(
  controller: controller,
  onComplete: () => print('Tutorial completed!'),
);
```

## 📖 Detailed Usage

### TutorialStep Configuration

```dart
TutorialStep(
  // Required
  id: 'unique_step_id',
  title: 'Step Title',
  description: 'Detailed description of this feature',
  targetKey: widgetGlobalKey,

  // Positioning
  position: TooltipPosition.auto, // or top, bottom, left, right, etc.

  // Appearance
  backgroundColor: Color(0xFF6366F1),
  textColor: Colors.white,
  icon: Icons.info_rounded,

  // Behavior
  showPulse: true,
  dismissOnTapOutside: false,
  autoAdvanceDuration: Duration(seconds: 3), // null = manual

  // Buttons
  showSkipButton: true,
  showNextButton: true,
  nextButtonText: 'Next',
  skipButtonText: 'Skip',

  // Callbacks
  onShow: () => print('Step shown'),
  onComplete: () => print('Step completed'),

  // Custom widget (overrides default tooltip)
  customTooltip: MyCustomTooltipWidget(),
)
```

### Tooltip Positions

```dart
enum TooltipPosition {
  top,           // Above the target
  bottom,        // Below the target
  left,          // Left of the target
  right,         // Right of the target
  topLeft,       // Top-left corner
  topRight,      // Top-right corner
  bottomLeft,    // Bottom-left corner
  bottomRight,   // Bottom-right corner
  auto,          // Automatically determines best position
}
```

### TutorialController Methods

```dart
final controller = TutorialController(steps: [...]);

// Navigation
controller.next();           // Move to next step
controller.previous();       // Move to previous step
controller.goToStep(2);      // Jump to specific step
controller.complete();       // Complete tutorial
controller.reset();          // Reset to first step

// State
controller.currentStepIndex; // Current step index (0-based)
controller.currentStep;      // Current TutorialStep object
controller.isFirstStep;      // true if on first step
controller.isLastStep;       // true if on last step
controller.totalSteps;       // Total number of steps

// Streams
controller.onStepChange.listen((index) {
  print('Changed to step $index');
});

controller.onComplete.listen((_) {
  print('Tutorial completed');
});

// Cleanup
controller.dispose();        // Dispose when done
```

## 🎨 Customization Examples

### Custom Colors & Icons

```dart
TutorialStep(
  id: 'custom_style',
  title: 'Custom Styled Step',
  description: 'This step has custom colors and icon',
  targetKey: myKey,
  backgroundColor: Color(0xFF8B5CF6),
  textColor: Colors.white,
  icon: Icons.star_rounded,
)
```

### Auto-Advancing Steps

```dart
TutorialStep(
  id: 'auto_advance',
  title: 'Auto-Advance',
  description: 'This step advances automatically in 3 seconds',
  targetKey: myKey,
  autoAdvanceDuration: Duration(seconds: 3),
  showNextButton: false, // Hide next button for auto-advance
)
```

### Dismissible on Tap Outside

```dart
TutorialStep(
  id: 'dismissible',
  title: 'Tap Outside',
  description: 'Tap anywhere outside to dismiss',
  targetKey: myKey,
  dismissOnTapOutside: true,
)
```

### No Skip Button

```dart
TutorialStep(
  id: 'no_skip',
  title: 'Required Step',
  description: 'Users must complete this step',
  targetKey: myKey,
  showSkipButton: false,
)
```

### Custom Button Text

```dart
TutorialStep(
  id: 'custom_buttons',
  title: 'Custom Buttons',
  description: 'Custom button labels',
  targetKey: myKey,
  nextButtonText: 'Got it!',
  skipButtonText: 'Maybe later',
)
```

### Custom Tooltip Widget

```dart
TutorialStep(
  id: 'custom_widget',
  title: 'Custom',
  description: 'This uses a custom widget',
  targetKey: myKey,
  customTooltip: Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.purple,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      'My custom tooltip!',
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

## 🎯 Advanced Examples

### Multi-Screen Tutorial

```dart
class MyApp extends StatelessWidget {
  final TutorialController tutorialController = TutorialController(
    steps: [
      // Screen 1 steps
      TutorialStep(id: 'screen1_step1', ...),
      TutorialStep(id: 'screen1_step2', ...),
      // Screen 2 steps
      TutorialStep(id: 'screen2_step1', ...),
    ],
  );

  void startTutorial() {
    SnackNLoad.showTutorial(
      controller: tutorialController,
      onComplete: () {
        // Save tutorial completion state
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('tutorial_completed', true);
        });
      },
    );
  }
}
```

### Conditional Tutorial

```dart
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    SharedPreferences.getInstance().then((prefs) {
      bool completed = prefs.getBool('tutorial_completed') ?? false;
      if (!completed) {
        _showTutorial();
      }
    });
  });
}
```

### Tutorial with Callbacks

```dart
final controller = TutorialController(
  steps: [
    TutorialStep(
      id: 'step1',
      title: 'First Step',
      description: 'Learn about this feature',
      targetKey: key1,
      onShow: () {
        // Analytics tracking
        analytics.logEvent(name: 'tutorial_step_shown', parameters: {
          'step_id': 'step1',
        });
      },
      onComplete: () {
        // Track completion
        analytics.logEvent(name: 'tutorial_step_completed', parameters: {
          'step_id': 'step1',
        });
      },
    ),
  ],
);

controller.onStepChange.listen((index) {
  print('User is now on step ${index + 1}');
});

controller.onComplete.listen((_) {
  analytics.logEvent(name: 'tutorial_completed');
});
```

### Dynamic Tutorial Steps

```dart
List<TutorialStep> generateTutorialSteps(UserRole role) {
  List<TutorialStep> steps = [
    TutorialStep(
      id: 'welcome',
      title: 'Welcome!',
      description: 'Let\'s get started',
      targetKey: homeKey,
    ),
  ];

  if (role == UserRole.admin) {
    steps.add(TutorialStep(
      id: 'admin_panel',
      title: 'Admin Panel',
      description: 'Access admin features here',
      targetKey: adminKey,
    ));
  }

  return steps;
}

final controller = TutorialController(
  steps: generateTutorialSteps(currentUser.role),
);
```

## 🎨 Styling Options

### Global Tutorial Styling

```dart
SnackNLoad.showTutorial(
  controller: controller,
  onComplete: () {},

  // Overlay customization
  overlayColor: Colors.black,
  overlayOpacity: 0.8,
  useBlur: true,

  // Animation
  animationDuration: Duration(milliseconds: 300),
);
```

### Per-Step Styling

Each `TutorialStep` can have its own:

- Background color
- Text color
- Icon
- Button text
- Pulse animation
- Position

## 📱 Best Practices

### 1. Keep It Short

```dart
// ✅ Good: 3-5 steps
final controller = TutorialController(
  steps: [
    TutorialStep(...), // Welcome
    TutorialStep(...), // Key feature 1
    TutorialStep(...), // Key feature 2
  ],
);

// ❌ Avoid: Too many steps
// Don't create 15+ step tutorials
```

### 2. Use Clear Language

```dart
// ✅ Good: Clear and concise
TutorialStep(
  title: 'Search',
  description: 'Find products by name or category',
  ...
)

// ❌ Avoid: Vague or too technical
TutorialStep(
  title: 'Query Interface',
  description: 'Utilize the search functionality to query the database',
  ...
)
```

### 3. Highlight Important Features

```dart
// ✅ Good: Focus on key features
steps: [
  TutorialStep(...), // Main action button
  TutorialStep(...), // Search
  TutorialStep(...), // Profile
]

// ❌ Avoid: Highlighting every button
// Don't create steps for obvious UI elements
```

### 4. Provide Skip Option

```dart
// ✅ Good: Allow users to skip
TutorialStep(
  showSkipButton: true,
  ...
)

// ❌ Avoid: Forcing users through long tutorials
TutorialStep(
  showSkipButton: false, // Only for critical steps
  ...
)
```

### 5. Save Completion State

```dart
// ✅ Good: Don't show tutorial every time
SnackNLoad.showTutorial(
  controller: controller,
  onComplete: () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_completed', true);
  },
);
```

### 6. Use Appropriate Timing

```dart
// ✅ Good: Show after first frame
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _showTutorial();
  });
}

// ❌ Avoid: Showing immediately in initState
// Widgets might not be rendered yet
```

## 🔧 Troubleshooting

### Tutorial Not Showing

**Problem**: Tutorial doesn't appear when called.

**Solution**: Ensure `SnackNLoad.init()` is added to MaterialApp:

```dart
MaterialApp(
  builder: SnackNLoad.init(), // Required!
  home: MyHomePage(),
)
```

### Widget Not Highlighted

**Problem**: Target widget is not highlighted correctly.

**Solution**:

1. Ensure GlobalKey is assigned to the widget
2. Wait for widget to be rendered:

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  _showTutorial();
});
```

### Tooltip Position Wrong

**Problem**: Tooltip appears in wrong position.

**Solutions**:

1. Use `TooltipPosition.auto` for automatic positioning
2. Manually specify position: `TooltipPosition.bottom`
3. Ensure target widget is visible on screen

### Tutorial Overlaps with Keyboard

**Problem**: Tutorial appears behind keyboard.

**Solution**: Dismiss keyboard before showing tutorial:

```dart
FocusScope.of(context).unfocus();
await Future.delayed(Duration(milliseconds: 100));
_showTutorial();
```

## 📊 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:snacknload/snacknload.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('tutorial_completed') ?? false;

    if (!completed) {
      _showTutorial();
    }
  }

  void _showTutorial() {
    final controller = TutorialController(
      steps: [
        TutorialStep(
          id: 'home',
          title: 'Welcome! 👋',
          description: 'This is your home screen where you\'ll see all your content',
          targetKey: _homeKey,
          position: TooltipPosition.bottom,
          icon: Icons.home_rounded,
          backgroundColor: Color(0xFF6366F1),
        ),
        TutorialStep(
          id: 'search',
          title: 'Search',
          description: 'Quickly find what you\'re looking for',
          targetKey: _searchKey,
          position: TooltipPosition.bottom,
          icon: Icons.search_rounded,
          backgroundColor: Color(0xFF10B981),
        ),
        TutorialStep(
          id: 'profile',
          title: 'Your Profile',
          description: 'Manage your account and preferences',
          targetKey: _profileKey,
          position: TooltipPosition.bottom,
          icon: Icons.person_rounded,
          backgroundColor: Color(0xFF3B82F6),
        ),
      ],
    );

    SnackNLoad.showTutorial(
      controller: controller,
      onComplete: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('tutorial_completed', true);

        SnackNLoad.showEnhancedSnackBar(
          '🎉 Tutorial completed!',
          title: 'Great Job',
          type: SnackNLoadType.success,
          position: SnackNLoadPosition.top,
        );
      },
      useBlur: true,
      overlayOpacity: 0.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          IconButton(
            key: _searchKey,
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            key: _profileKey,
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showTutorial,
          child: Text('Restart Tutorial'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, key: _homeKey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}
```

## 🎯 Use Cases

1. **App Onboarding**: Guide new users through your app
2. **Feature Highlights**: Showcase new features to existing users
3. **Contextual Help**: Provide help for complex features
4. **Walkthroughs**: Step-by-step guides for workflows
5. **Tips & Tricks**: Share productivity tips with users

## 🚀 Performance Tips

1. **Lazy Loading**: Only create tutorial when needed
2. **Dispose Controllers**: Always dispose controllers when done
3. **Optimize Steps**: Keep step count reasonable (3-7 steps)
4. **Conditional Rendering**: Only show tutorial to new users
5. **Blur Performance**: Disable blur on older devices if needed

## 📝 API Reference

### SnackNLoad.showTutorial()

```dart
static Future<void> showTutorial({
  required TutorialController controller,
  required VoidCallback onComplete,
  Color? overlayColor,
  double? overlayOpacity,
  bool useBlur = true,
  Duration animationDuration = const Duration(milliseconds: 300),
})
```

### TutorialController

```dart
class TutorialController {
  TutorialController({required List<TutorialStep> steps});

  // Properties
  int get currentStepIndex;
  TutorialStep get currentStep;
  bool get isFirstStep;
  bool get isLastStep;
  int get totalSteps;

  // Methods
  void next();
  void previous();
  void goToStep(int index);
  void complete();
  void reset();
  void dispose();

  // Streams
  Stream<void> get onComplete;
  Stream<int> get onStepChange;
}
```

### TutorialStep

See [TutorialStep Configuration](#tutorialstep-configuration) above for full details.

---

**Need help?** Check out the [example app](../example/lib/tutorial_demo.dart) for a complete working demo!
