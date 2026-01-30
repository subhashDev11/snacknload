import 'dart:async';
import 'package:flutter/material.dart';
import 'package:snacknload/snacknload.dart';

void configLoading() {
  SnackNLoad.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = IndicatorType.wave
    ..loadingStyle = LoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 16.0
    ..userInteractions = true
    ..backgroundColor = const Color(0xFF6366F1)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..successContainerColor = const Color(0xFF10B981)
    ..errorContainerColor = const Color(0xFFEF4444)
    ..warningContainerColor = const Color(0xFFF59E0B)
    ..infoContainerColor = const Color(0xFF3B82F6)
    ..textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
      color: Colors.white,
    );
}

class EnhancedDemoPage extends StatefulWidget {
  const EnhancedDemoPage({super.key, });


  @override
  State<EnhancedDemoPage> createState() => _EnhancedDemoPageState();
}

class _EnhancedDemoPageState extends State<EnhancedDemoPage> {
  Timer? _timer;
  late double _progress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      configLoading();
      SnackNLoad.addStatusCallback((status) {
        if (status == LoadingStatus.dismiss) {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Enhanced UI Demo",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Enhanced Loading Section
            _buildSection(
              'Enhanced Loading',
              'Modern loaders with blur and glassmorphism effects',
              [
                _buildButton(
                  'Enhanced Loading',
                  Icons.hourglass_empty_rounded,
                  const Color(0xFF6366F1),
                  () async {
                    await SnackNLoad.showEnhancedLoading(
                      status: 'Loading...',
                      maskType: MaskType.black,
                      useBlur: true,
                      useGlassmorphism: true,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    await SnackNLoad.dismiss();
                  },
                ),
                _buildButton(
                  'Enhanced Progress',
                  Icons.trending_up_rounded,
                  const Color(0xFF8B5CF6),
                  () {
                    _progress = 0;
                    _timer?.cancel();
                    _timer = Timer.periodic(
                      const Duration(milliseconds: 100),
                      (Timer timer) {
                        SnackNLoad.showProgress(
                          _progress,
                          status: '${(_progress * 100).toStringAsFixed(0)}%',
                        );
                        _progress += 0.03;

                        if (_progress >= 1) {
                          _timer?.cancel();
                          SnackNLoad.dismiss();
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Enhanced Snackbars Section
            _buildSection(
              'Enhanced Snackbars',
              'Rich notifications with progress bars and interactions',
              [
                _buildButton(
                  'Success Snackbar',
                  Icons.check_circle_rounded,
                  const Color(0xFF10B981),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      '🎉 Operation completed successfully!',
                      title: 'Success',
                      type: SnackNLoadType.success,
                      position: SnackNLoadPosition.top,
                      showProgressBar: true,
                      duration: const Duration(seconds: 4),
                      enableSwipeToDismiss: true,
                      useGlassmorphism: true,
                      showCloseButton: true,
                    );
                  },
                ),
                _buildButton(
                  'Error Snackbar',
                  Icons.error_rounded,
                  const Color(0xFFEF4444),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'Something went wrong. Please try again.',
                      title: 'Error',
                      type: SnackNLoadType.error,
                      position: SnackNLoadPosition.top,
                      showProgressBar: true,
                      duration: const Duration(seconds: 4),
                      enableSwipeToDismiss: true,
                      useGlassmorphism: true,
                    );
                  },
                ),
                _buildButton(
                  'Warning Snackbar',
                  Icons.warning_rounded,
                  const Color(0xFFF59E0B),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'Your session will expire in 5 minutes',
                      title: 'Warning',
                      type: SnackNLoadType.warning,
                      position: SnackNLoadPosition.top,
                      showProgressBar: true,
                      duration: const Duration(seconds: 4),
                      enableSwipeToDismiss: true,
                    );
                  },
                ),
                _buildButton(
                  'Info Snackbar',
                  Icons.info_rounded,
                  const Color(0xFF3B82F6),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'New features are now available!',
                      title: 'Info',
                      type: SnackNLoadType.info,
                      position: SnackNLoadPosition.top,
                      showProgressBar: true,
                      duration: const Duration(seconds: 4),
                      enableSwipeToDismiss: true,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Advanced Features
            _buildSection(
              'Advanced Features',
              'Custom widgets and interactions',
              [
                _buildButton(
                  'With Action Button',
                  Icons.touch_app_rounded,
                  const Color(0xFF06B6D4),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'Tap this notification to see more details',
                      title: 'Interactive',
                      type: SnackNLoadType.info,
                      position: SnackNLoadPosition.top,
                      showProgressBar: true,
                      duration: const Duration(seconds: 5),
                      onTap: () {
                        print('Snackbar tapped!');
                      },
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    );
                  },
                ),
                _buildButton(
                  'Bottom Position',
                  Icons.vertical_align_bottom_rounded,
                  const Color(0xFFEC4899),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'This notification appears at the bottom',
                      title: 'Bottom Snackbar',
                      type: SnackNLoadType.success,
                      position: SnackNLoadPosition.bottom,
                      showProgressBar: true,
                      duration: const Duration(seconds: 4),
                      enableSwipeToDismiss: true,
                    );
                  },
                ),
                _buildButton(
                  'No Progress Bar',
                  Icons.block_rounded,
                  const Color(0xFF64748B),
                  () {
                    SnackNLoad.showEnhancedSnackBar(
                      'This notification has no progress bar',
                      title: 'Simple',
                      type: SnackNLoadType.info,
                      position: SnackNLoadPosition.top,
                      showProgressBar: false,
                      duration: const Duration(seconds: 3),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Classic UI Section
            _buildSection(
              'Classic UI (Original)',
              'Traditional loaders and toasts',
              [
                _buildButton(
                  'Classic Loading',
                  Icons.refresh_rounded,
                  const Color(0xFF94A3B8),
                  () async {
                    await SnackNLoad.show(
                      status: 'Loading...',
                      maskType: MaskType.black,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    await SnackNLoad.dismiss();
                  },
                ),
                _buildButton(
                  'Classic Snackbar',
                  Icons.message_rounded,
                  const Color(0xFF94A3B8),
                  () {
                    SnackNLoad.showSnackBar(
                      'This is a classic snackbar',
                      type: SnackNLoadType.success,
                      position: SnackNLoadPosition.top,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Dismiss Button
            _buildDismissButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 12),
          Text(
            'Enhanced UI Demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Experience rich UI components with modern design',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, List<Widget> buttons) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: buttons,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildDismissButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        _timer?.cancel();
        await SnackNLoad.dismiss();
      },
      icon: const Icon(Icons.close_rounded),
      label: const Text('Dismiss All'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}
