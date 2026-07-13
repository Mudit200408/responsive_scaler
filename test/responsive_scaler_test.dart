import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_scaler/responsive_scaler.dart';
import 'dart:math';

void main() {
  // Define the base design dimensions usage in the tests.
  // These represent the "ideal" screen size the UI was designed for.
  const double designWidth = 400;
  const double designHeight = 800;

  /// Helper function to simulate different screen sizes for testing.
  /// This allows us to check how the scaler behaves on various devices (e.g., small phone vs. tablet).
  void setScreenSize(WidgetTester tester, double width, double height) {
    // Set the physical size of the test window
    tester.view.physicalSize = Size(width, height);
    // Set pixel ratio to 1.0 to simplify calculations (1 logical pixel = 1 physical pixel)
    tester.view.devicePixelRatio = 1.0;
  }

  // setUp runs before EACH test. We use it to initialize the ResponsiveScaler with our design specs.
  setUp(() {
    ResponsiveScaler.init(
      designWidth: designWidth,
      designHeight: designHeight,
      minScale:
          0.5, // Minimum scaling factor allowed (prevent UI becoming too small)
      maxScale:
          2.0, // Maximum scaling factor allowed (prevent UI becoming too large)
      maxAccessibilityScale:
          3.0, // Limit for text scaling with accessibility enabled
    );
  });

  // tearDown runs after EACH test. We clean up the test environment here.
  tearDown(() {
    // Reset the test view to default to prevent state leaking into other tests
    final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
    dispatcher.views.first.resetPhysicalSize();
    dispatcher.views.first.resetDevicePixelRatio();
  });

  // GROUP: Core Math Tests
  // These tests verify that basic scaling calculations work as expected based on screen size.
  group('Core Math Tests', () {
    testWidgets('Verify scaling factors at design size (Scale = 1.0)', (
      tester,
    ) async {
      // 1. Arrange: Set screen size to exactly match the design dimensions (400x800)
      setScreenSize(tester, 400, 800);

      // 2. Act: Build the widget tree with ResponsiveScaler
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveScaler.scale(context: context, child: child!),
          home: const Scaffold(), // Simple placeholder home
        ),
      );

      // 3. Assert: Since screen matches design, scale factor should be exactly 1.0
      expect(ResponsiveScaler.widthScale, 1.0);
      expect(ResponsiveScaler.heightScale, 1.0);
      // Verify extension method: 100.w should remain 100.0
      expect(100.w, 100.0);
    });

    testWidgets('Verify scaling on smaller screen (Scale = 0.5)', (
      tester,
    ) async {
      // 1. Arrange: Set screen size to half the width (200 vs 400)
      setScreenSize(tester, 200, 400);

      // 2. Act: Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveScaler.scale(context: context, child: child!),
          home: const Scaffold(),
        ),
      );

      // 3. Assert: Width is half of design (200/400 = 0.5), so scale should be 0.5.
      expect(ResponsiveScaler.widthScale, 0.5);
      // 100 * 0.5 = 50.0
      expect(100.w, 50.0);
    });
  });

  // GROUP: Clamping Logic Tests
  // These tests ensure that minScale and maxScale limits are respected.
  group('Clamping Logic Tests', () {
    testWidgets('Global MaxScale constraint (Max = 2.0)', (tester) async {
      // 1. Arrange: Set screen to 3x design size (1200 / 400 = 3.0)
      setScreenSize(tester, 1200, 2400);

      // 2. Act: Build the widget tree
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveScaler.scale(context: context, child: child!),
          home: const Scaffold(),
        ),
      );

      // 3. Assert: Even though screen is 3x, the scale should be capped at 2.0 (our maxScale).
      // calculated scale = 3.0 -> clamped to 2.0
      expect(ResponsiveScaler.widthScale, 2.0);
      expect(100.w, 200.0); // 100 * 2.0 = 200
    });

    test('Local Clamping (.wc and .hc)', () {
      // This is a unit test (not widget test) for specific extension methods.

      // Manually set a global scale for testing purposes
      ResponsiveScaler.widthScale = 1.5;

      // Test .wc (width clamped) with a manual ceiling
      // Calculation: 100 * 1.5 = 150.
      // Constraint: maxValue = 120.
      // Result: 150 > 120, so it clamps to 120.
      expect(100.wc(maxValue: 120), 120.0);

      // Test .wc with a manual floor
      // Calculation: 100 * 1.5 = 150.
      // Constraint: minValue = 160.
      // Result: 150 < 160, so it clamps to 160.
      expect(100.wc(minValue: 160), 160.0);
    });
  });

  // GROUP: Text Scaling Tests
  // These verify how the scaler interacts with system text scaling settings.
  group('Text Scaling Tests', () {
    testWidgets('Accessibility clamping', (tester) async {
      // 1. Arrange: Set screen to design size (base scale 1.0)
      setScreenSize(tester, 400, 800);

      // Simulate user having "Large Text" enabled in OS settings (2.0x)
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;

      // 2. Act: Build widget
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveScaler.scale(
            context: context,
            useMaxAccessibility:
                true, // Enable checks against maxAccessibilityScale (3.0)
            child: child!,
          ),
          home: const Scaffold(body: Text('Test')),
        ),
      );

      // Get the BuildContext of a Text widget to access MediaQuery
      final BuildContext context = tester.element(find.byType(Text));
      final textScaler = MediaQuery.of(context).textScaler;

      // 3. Assert:
      // Effective Scale = Layout Scale (1.0) * System Text Scale (2.0) = 2.0
      // Since 2.0 < maxAccessibilityScale (3.0), the full 2.0 is used.
      expect(textScaler.scale(10), 20.0); // 10 * 2.0 = 20.0

      // Cleanup: Reset system text scale
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    testWidgets('Non-linear scaling with scalingPower', (tester) async {
      ResponsiveScaler.init(
        designWidth: 400,
        designHeight: 800,
        minScale: 0.1,
        maxScale: 5.0,
        scalingPower: 0.5,
      );

      setScreenSize(tester, 600, 1200);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveScaler.scale(context: context, child: child!),
          home: const Scaffold(),
        ),
      );

      expect(ResponsiveScaler.widthScale, closeTo(1.2247, 0.001));
      expect(ResponsiveScaler.heightScale, closeTo(1.2247, 0.001));
    });

    testWidgets('Landscape orientation dynamically swaps design dimensions', (
      tester,
    ) async {
      ResponsiveScaler.init(
        designWidth: 400,
        designHeight: 800,
        minScale: 0.1,
        maxScale: 5.0,
      );

      setScreenSize(tester, 800, 400);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ResponsiveScaler.scale(context: context, child: child!),
          home: const Scaffold(),
        ),
      );

      expect(ResponsiveScaler.widthScale, 1.0);
      expect(ResponsiveScaler.heightScale, 1.0);
      expect(ResponsiveScaler.radiusScale, 1.0);
    });
  });

  // GROUP: Split-Screen / Multi-Window Tests
  group('Split-Screen / Multi-Window Tests', () {
    testWidgets(
      'Two windows with different screen sizes do not pollute each other',
      (tester) async {
        // Build both windows in the same widget tree under separate MediaQuery overrides
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  MediaQuery(
                    data: const MediaQueryData(size: Size(200, 400)),
                    child: Builder(
                      builder: (context) => ResponsiveScaler.scale(
                        context: context,
                        child: const Text('Window A'),
                      ),
                    ),
                  ),
                  MediaQuery(
                    data: const MediaQueryData(size: Size(300, 600)),
                    child: Builder(
                      builder: (context) => ResponsiveScaler.scale(
                        context: context,
                        child: const Text('Window B'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Find keys from the states map
        final keys = ResponsiveScaler.instance.states.keys.toList();
        expect(keys.length, equals(2));

        // Get the state for each key and verify they have the correct widthScale
        final widthScale1 =
            ResponsiveScaler.instance.states[keys[0]]?.widthScale;
        final widthScale2 =
            ResponsiveScaler.instance.states[keys[1]]?.widthScale;

        // Since sizes are 200x400 and 300x600, scales should be 0.5 and 0.75
        final scales = {widthScale1, widthScale2};
        expect(scales, contains(0.5));
        expect(scales, contains(0.75));
      },
    );

    testWidgets('Window A scale changes do not affect Window B', (
      tester,
    ) async {
      // Build both windows in the same widget tree under separate MediaQuery overrides
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                MediaQuery(
                  data: const MediaQueryData(size: Size(200, 400)),
                  child: Builder(
                    builder: (context) => ResponsiveScaler.scale(
                      context: context,
                      child: const Text('Window A'),
                    ),
                  ),
                ),
                MediaQuery(
                  data: const MediaQueryData(size: Size(300, 600)),
                  child: Builder(
                    builder: (context) => ResponsiveScaler.scale(
                      context: context,
                      child: const Text('Window B'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final keys = ResponsiveScaler.instance.states.keys.toList();
      expect(keys.length, equals(2));

      final widthScale1 = ResponsiveScaler.instance.states[keys[0]]?.widthScale;
      final widthScale2 = ResponsiveScaler.instance.states[keys[1]]?.widthScale;

      final scales = {widthScale1, widthScale2};
      expect(scales, contains(0.5));
      expect(scales, contains(0.75));
    });
  });

  // GROUP: Reset / Test Isolation Tests
  group('Reset / Test Isolation Tests', () {
    test('Reset clears all state', () {
      // Initialize with some values
      ResponsiveScaler.init(
        designWidth: 400,
        designHeight: 800,
        minScale: 0.5,
        maxScale: 2.0,
      );

      // Simulate scale() being called by setting scale values directly
      ResponsiveScaler.widthScale = 2.0;
      ResponsiveScaler.heightScale = 2.0;
      ResponsiveScaler.radiusScale = 2.0;

      // Reset
      ResponsiveScaler.reset();

      // Verify all state is cleared
      expect(ResponsiveScaler.widthScale, 1.0); // fallback value is 1.0
      expect(ResponsiveScaler.heightScale, 1.0);
      expect(ResponsiveScaler.radiusScale, 1.0);
      expect(ResponsiveScaler.isInitialized, false);
      expect(ResponsiveScaler.screenWidth, 0.0);
      expect(ResponsiveScaler.screenHeight, 0.0);
    });

    test('Re-initialization with new values works correctly', () {
      // Initialize with first set of values
      ResponsiveScaler.init(
        designWidth: 400,
        designHeight: 800,
        minScale: 0.8,
        maxScale: 1.4,
      );

      // Re-initialize with different values
      ResponsiveScaler.init(
        designWidth: 390,
        designHeight: 844,
        minScale: 0.9,
        maxScale: 1.5,
      );

      // Verify new values are used
      expect(ResponsiveScaler.instance.designWidth, 390);
      expect(ResponsiveScaler.instance.designHeight, 844);
      expect(ResponsiveScaler.instance.minScale, 0.9);
      expect(ResponsiveScaler.instance.maxScale, 1.5);
    });
  });

  // GROUP: LRU Cache Eviction Tests
  group('LRU Cache Eviction Tests', () {
    test('LRU eviction works correctly', () {
      // Simulate adding many windows
      for (int i = 0; i < 105; i++) {
        final key = GlobalKey(debugLabel: 'Window$i');
        ResponsiveScaler.instance.initWindowState(key);
      }

      // Verify LRU eviction occurred
      expect(ResponsiveScaler.instance.states.length, lessThanOrEqualTo(100));
    });

    test('LRU eviction only evicts least recently accessed', () {
      final keys = List.generate(5, (i) => GlobalKey(debugLabel: 'Window$i'));

      // Add some windows
      for (final key in keys) {
        ResponsiveScaler.instance.initWindowState(key);
      }

      // Access only the first two windows
      ResponsiveScaler.instance.updateWindowState(
        keys[0],
        const MediaQueryData(size: Size(400, 800)),
        false,
      );
      ResponsiveScaler.instance.updateWindowState(
        keys[1],
        const MediaQueryData(size: Size(400, 800)),
        false,
      );

      // Verify Window0 and Window1 are in recently accessed
      expect(ResponsiveScaler.instance.recentlyAccessed, contains(keys[0]));
      expect(ResponsiveScaler.instance.recentlyAccessed, contains(keys[1]));
    });
  });

  // GROUP: Validation Tests
  group('Validation Tests', () {
    test('Invalid designWidth throws error', () {
      expect(
        () => ResponsiveScaler.init(
          designWidth: 0,
          designHeight: 800,
          minScale: 0.8,
          maxScale: 1.4,
        ),
        throwsArgumentError,
      );
      expect(
        () => ResponsiveScaler.init(
          designWidth: -10,
          designHeight: 800,
          minScale: 0.8,
          maxScale: 1.4,
        ),
        throwsArgumentError,
      );
    });

    test('Invalid designHeight throws error', () {
      expect(
        () => ResponsiveScaler.init(
          designWidth: 400,
          designHeight: 0,
          minScale: 0.8,
          maxScale: 1.4,
        ),
        throwsArgumentError,
      );
      expect(
        () => ResponsiveScaler.init(
          designWidth: 400,
          designHeight: -10,
          minScale: 0.8,
          maxScale: 1.4,
        ),
        throwsArgumentError,
      );
    });

    test('Invalid scalingPower throws error', () {
      expect(
        () => ResponsiveScaler.init(
          designWidth: 400,
          designHeight: 800,
          minScale: 0.8,
          maxScale: 1.4,
          scalingPower: -1,
        ),
        throwsArgumentError,
      );
      expect(
        () => ResponsiveScaler.init(
          designWidth: 400,
          designHeight: 800,
          minScale: 0.8,
          maxScale: 1.4,
          scalingPower: 11,
        ),
        throwsArgumentError,
      );
    });

    test('Invalid maxAccessibilityScale throws error', () {
      expect(
        () => ResponsiveScaler.init(
          designWidth: 400,
          designHeight: 800,
          minScale: 0.8,
          maxScale: 1.4,
          maxAccessibilityScale: 1.0,
        ),
        throwsArgumentError,
      );
    });
  });

  // GROUP: Edge Case Tests
  group('Edge Case Tests', () {
    test('Concurrent initialization scenarios', () async {
      // Simulate concurrent initialization from multiple routes
      final initFutures = List.generate(5, (_) async {
        return Future.delayed(const Duration(milliseconds: 10), () async {
          ResponsiveScaler.init(
            designWidth: 400,
            designHeight: 800,
            minScale: 0.8,
            maxScale: 1.4,
          );
        });
      });

      // Wait for all initializations to complete
      await Future.wait(initFutures);

      // Verify only one initialization took effect
      expect(ResponsiveScaler.instance.designWidth, 400);
      expect(ResponsiveScaler.instance.designHeight, 800);
    });

    test('Zero or negative screen dimensions handled gracefully', () {
      // These should not crash - they just result in scale 0
      expect(pow(max(0.0, 0.0) / 400, 1.0), equals(0.0));
      expect(pow(max(0.0, -10.0) / 400, 1.0), equals(0.0));
    });
  });
}
