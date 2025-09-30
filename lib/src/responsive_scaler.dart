import 'package:flutter/material.dart';
import 'dart:math';

/// A utility class that provides automatic responsive scaling for Flutter apps.
///
/// This class enables automatic text scaling and provides screen dimension data
/// for responsive UI components without requiring manual wrapping of every widget.
class ResponsiveScaler {
  // Global configuration variables, set once at app start.
  static double? _designWidth;
  static double _minScale = 0.8;
  static double _maxScale = 1.4;
  static double _maxAccessibilityScale = 2.0;

  /// Static variables to hold screen data for global access.
  static double screenWidth = 0;

  /// Static variables to hold screen data for global access.

  static double screenHeight = 0;

  /// Static variables to hold screen data for global access.

  static double scaleFactor = 0;

  /// Initializes the ResponsiveScaler with your app's design specifications.
  ///
  /// This must be called once in your main() function before runApp().
  ///
  /// [designWidth] The width in pixels that your UI was designed for (e.g., 390 for iPhone 12)
  /// [minScale] Minimum scaling factor to prevent text from becoming too small (default: 0.8)
  /// [maxScale] Maximum scaling factor to prevent text from becoming too large (default: 1.4)
  /// [maxAccessibilityScale] Maximum scale when accessibility settings are considered (default: 1.8)
  static void init({
    required double designWidth,
    double minScale = 0.8,
    double maxScale = 1.4,
    double maxAccessibilityScale = 1.8,
  }) {
    _designWidth = designWidth;
    _minScale = minScale;
    _maxScale = maxScale;
    _maxAccessibilityScale = maxAccessibilityScale;
  }

  /// A widget builder that applies automatic scaling to all descendant Text widgets.
  ///
  /// Wrap your app's root widget with this method to enable automatic text scaling.
  ///
  /// [context] The build context
  /// [child] The widget tree to apply scaling to
  /// [preserveAccessibility] Whether to respect system accessibility text scaling (default: true)
  static Widget scale({
    required BuildContext context,
    required Widget child,
    bool preserveAccessibility = true,
  }) {
    assert(
      _designWidth != null,
      'ResponsiveScaler.init() must be called!',
    );

    final mediaQuery = MediaQuery.of(context);

    // --- Capture and store screen data statically ---
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    final rawScale = screenWidth / _designWidth!;

    // Use a local variable for calculations within this method for clarity.
    final localScaleFactor = min(_maxScale, max(_minScale, rawScale));

    // Update the static variable for external helpers to use.
    scaleFactor = localScaleFactor;

    // The rest of your existing scale() method logic for TextScaler...
    final TextScaler textScaler;
    if (preserveAccessibility) {
      final combinedScale = localScaleFactor * mediaQuery.textScaler.scale(1.0);
      final clampedCombinedScale = min(_maxAccessibilityScale, combinedScale);
      textScaler = TextScaler.linear(clampedCombinedScale);
    } else {
      textScaler = TextScaler.linear(localScaleFactor);
    }

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: textScaler),
      child: child,
    );
  }
}
