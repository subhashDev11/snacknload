import 'package:flutter/material.dart';
import 'package:snacknload/snacknload.dart';

class TutorialDemoPage extends StatefulWidget {
  const TutorialDemoPage({super.key});

  @override
  State<TutorialDemoPage> createState() => _TutorialDemoPageState();
}

class _TutorialDemoPageState extends State<TutorialDemoPage> {
  // Global keys for targeting widgets in tutorial
  final GlobalKey _homeButtonKey = GlobalKey();
  final GlobalKey _searchButtonKey = GlobalKey();
  final GlobalKey _profileButtonKey = GlobalKey();
  final GlobalKey _settingsButtonKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  bool _tutorialCompleted = false;

  @override
  void initState() {
    super.initState();
    // Show tutorial after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_tutorialCompleted) {
        _showTutorial();
      }
    });
  }

  void _showTutorial() {
    final controller = TutorialController(
      steps: [
        TutorialStep(
          id: 'welcome',
          title: 'Welcome! 👋',
          description:
              'Let\'s take a quick tour of the app features. Tap Next to continue.',
          targetKey: _homeButtonKey,
          position: TooltipPosition.top,
          icon: Icons.home_rounded,
          backgroundColor: const Color(0xFF6366F1),
          showPulse: true,
          onShow: () => debugPrint('Welcome step shown'),
        ),
        TutorialStep(
          id: 'search',
          title: 'Search',
          description: 'Use this button to search for content across the app.',
          targetKey: _searchButtonKey,
          position: TooltipPosition.bottom,
          icon: Icons.search_rounded,
          backgroundColor: const Color(0xFF10B981),
          showPulse: true,
        ),
        TutorialStep(
          id: 'profile',
          title: 'Your Profile',
          description: 'Access your profile settings and preferences here.',
          targetKey: _profileButtonKey,
          position: TooltipPosition.bottom,
          icon: Icons.person_rounded,
          backgroundColor: const Color(0xFF3B82F6),
          showPulse: true,
        ),
        TutorialStep(
          id: 'settings',
          title: 'Settings',
          description: 'Customize your app experience in the settings menu.',
          targetKey: _settingsButtonKey,
          position: TooltipPosition.bottom,
          icon: Icons.settings_rounded,
          backgroundColor: const Color(0xFFF59E0B),
          showPulse: true,
        ),
        TutorialStep(
          id: 'add',
          title: 'Create New',
          description:
              'Tap this button to create new content. You\'re all set!',
          targetKey: _fabKey,
          position: TooltipPosition.top,
          icon: Icons.add_circle_rounded,
          backgroundColor: const Color(0xFFEC4899),
          showPulse: true,
          nextButtonText: 'Finish',
          autoAdvanceDuration: null, // Manual advancement only
          onComplete: () => debugPrint('Tutorial completed!'),
        ),
      ],
    );

    SnackNLoad.showTutorial(
      controller: controller,
      onComplete: () {
        if (mounted) {
          setState(() {
            _tutorialCompleted = true;
          });
        }
        SnackNLoad.showEnhancedSnackBar(
          '🎉 Tutorial completed!',
          title: 'Great Job',
          type: SnackNLoadType.success,
          position: SnackNLoadPosition.top,
          showProgressBar: true,
          duration: const Duration(seconds: 3),
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
        title: const Text(
          'Tutorial Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            key: _searchButtonKey,
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
          IconButton(
            key: _profileButtonKey,
            icon: const Icon(Icons.person),
            onPressed: () {},
            tooltip: 'Profile',
          ),
          IconButton(
            key: _settingsButtonKey,
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_rounded,
              size: 100,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(height: 24),
            const Text(
              'Interactive Tutorial Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _tutorialCompleted
                  ? 'Tutorial completed! ✅'
                  : 'Tutorial in progress...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _tutorialCompleted = false;
                });
                _showTutorial();
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Restart Tutorial'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _showCustomTutorial,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Custom Tutorial'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF6366F1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, key: _homeButtonKey),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomTutorial() {
    final controller = TutorialController(
      steps: [
        TutorialStep(
          id: 'custom1',
          title: 'Custom Tutorial',
          description: 'This tutorial has different colors and no skip button!',
          targetKey: _fabKey,
          position: TooltipPosition.top,
          backgroundColor: const Color(0xFF8B5CF6),
          textColor: Colors.white,
          icon: Icons.star_rounded,
          showSkipButton: false,
          showPulse: true,
        ),
        TutorialStep(
          id: 'custom2',
          title: 'Auto-Advance',
          description: 'This step will automatically advance in 3 seconds...',
          targetKey: _homeButtonKey,
          position: TooltipPosition.bottom,
          backgroundColor: const Color(0xFF06B6D4),
          icon: Icons.timer_rounded,
          autoAdvanceDuration: const Duration(seconds: 3),
          showNextButton: false,
        ),
        TutorialStep(
          id: 'custom3',
          title: 'Tap Outside',
          description:
              'You can tap outside this tooltip to dismiss the tutorial.',
          targetKey: _searchButtonKey,
          position: TooltipPosition.bottom,
          backgroundColor: const Color(0xFFEF4444),
          icon: Icons.touch_app_rounded,
          dismissOnTapOutside: true,
          showPulse: false,
        ),
      ],
    );

    SnackNLoad.showTutorial(
      controller: controller,
      onComplete: () {
        SnackNLoad.showEnhancedSnackBar(
          'Custom tutorial finished!',
          type: SnackNLoadType.info,
          position: SnackNLoadPosition.top,
          showProgressBar: true,
          duration: const Duration(seconds: 2),
        );
      },
      overlayColor: Colors.purple,
      overlayOpacity: 0.6,
    );
  }
}
