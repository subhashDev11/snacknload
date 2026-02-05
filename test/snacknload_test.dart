import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snacknload/snacknload.dart';
import 'package:snacknload/src/widgets/loading_container.dart';

void main() {
  setUp(() async {
    // Reset any existing state
    await SnackNLoad.dismiss(animation: false);
  });

  tearDown(() async {
    await SnackNLoad.dismiss(animation: false);
  });

  Widget createTestApp({Widget? child}) {
    return MaterialApp(
      builder: SnackNLoad.init(),
      home: Scaffold(
        body: child ?? const SizedBox(),
      ),
    );
  }

  group('SnackNLoad Initialization', () {
    testWidgets('init builder wraps child correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(child: const Text('Home')));
      expect(find.text('Home'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('throws assert error if show called without init',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: Text('No Init'))));
      await tester.pumpAndSettle();
      expect(() => SnackNLoad.show(), throwsAssertionError);
    });
  });

  group('SnackNLoad Loading', () {
    testWidgets('show() renders EnhancedLoadingContainer by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      SnackNLoad.show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500)); // Full animation

      expect(find.byType(EnhancedLoadingContainer), findsOneWidget);
      expect(find.byType(LoadingContainer), findsNothing);
    });

    testWidgets('showSuccess() renders success text',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      SnackNLoad.showSuccess('Success!');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('show() with custom style and empty boxShadow has no shadow',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      // Configure for no shadow
      SnackNLoad.instance
        ..loadingStyle = LoadingStyle.custom
        ..maskType = MaskType.custom
        ..backgroundColor = Colors.transparent
        ..textColor = Colors.black
        ..indicatorColor = Colors.black
        ..boxShadow = [];

      SnackNLoad.show(status: 'No Shadow');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final enhancedContainerFinder = find.byType(EnhancedLoadingContainer);
      expect(enhancedContainerFinder, findsOneWidget);

      // Verify the container decoration has no shadow
      // We look for the inner Container that holds the decoration
      final containerFinder = find.descendant(
        of: enhancedContainerFinder,
        matching: find.byType(Container),
      );

      // There might be multiple containers (backdrop, etc.), we need to find the one with decoration
      // The content container is usually the one with the specific background color from config
      bool foundNoShadow = false;

      // Check all containers found
      containerFinder.evaluate().forEach((element) {
        final container = element.widget as Container;
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          // Check if this is the content container (it should have the background color or be the glassmorphism one)
          // Since we disabled glassmorphism by default, it should be the standard one

          // If the decoration has a boxShadow property that is null or empty, we found it
          if (decoration.boxShadow == null || decoration.boxShadow!.isEmpty) {
            // We can be more specific if we knew the exact structure, but finding at least one valid
            // container with no shadow that isn't just the backdrop is good.
            // The backdrop has color but usually no decoration/shadow.
            // The content container usually has borderRadius.
            if (decoration.borderRadius != null) {
              foundNoShadow = true;
            }
          }
        }
      });

      expect(foundNoShadow, isTrue,
          reason: "Could not find a content container with no shadow");
    });

    testWidgets('showProgress() accepts dismissOnTap parameter and passes it',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      // Show progress with dismissOnTap: true
      await SnackNLoad.showProgress(0.5,
          status: 'Progress', dismissOnTap: true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify container exists
      final containerFinder = find.byType(EnhancedLoadingContainer);
      expect(containerFinder, findsOneWidget);

      // Verify dismissOnTap property was passed correctly
      final container =
          tester.widget<EnhancedLoadingContainer>(containerFinder);
      expect(container.dismissOnTap, isTrue);
    });
  });

  group('SnackNLoad Snackbar', () {
    testWidgets('showSnackBar() renders EnhancedSnackBarContainer by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      SnackNLoad.showSnackBar('Hello Toast');
      await tester.pump();
      // Wait for slide animation (400ms) to ensure visibility
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(EnhancedSnackBarContainer), findsOneWidget);
      expect(find.text('Hello Toast'), findsOneWidget);
    });
  });

  // Skipped due to test environment flakiness (overlay/navigator interactions)
  group('SnackNLoad Dialog', () {
    testWidgets('showOkDialog renders DialogContainer with content',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      SnackNLoad.showOkDialog(title: 'Alert', content: 'Something happened');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(DialogContainer), findsOneWidget);
    });
  });
}
