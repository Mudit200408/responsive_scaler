import 'package:flutter/material.dart';
import 'dart:math';

class ResponsiveScaler {
  // Global configuration variables, set once at app start.
  static double? _designWidth;
  static double _minScale = 0.8;
  static double _maxScale = 1.8;
  static double _maxAccessibilityScale = 2.0;

  /// Initializes the ResponsiveScaler with your app's design specifications.
  /// This must be called once in your main() function before runApp().
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

  /// Calculates the responsive scale factor based on the current screen width.
  static double getScaleFactor(BuildContext context) {
    assert(
      _designWidth != null,
      'ResponsiveScaler.init() must be called before using scaleFactor! Call it in your main() function.',
    );

    final currentWidth = MediaQuery.of(context).size.width;
    final scale = currentWidth / _designWidth!;

    // Clamp the scale factor to the defined min and max values.
    return min(_maxScale, max(_minScale, scale));
  }

  /// A widget builder that applies automatic scaling to all descendant Text widgets.
  static Widget scale({
    required BuildContext context,
    required Widget child,
    bool preserveAccessibility = true,
  }) {
    assert(
      _designWidth != null,
      'ResponsiveScaler.init() must be called before using scale()! Call it in your main() function.',
    );

    final mediaQuery = MediaQuery.of(context);
    final scaleFactor = getScaleFactor(context);

    final TextScaler textScaler;

    if (preserveAccessibility) {
      // Calculate the combined scale from responsive factor and system accessibility.
      final combinedScale = scaleFactor * mediaQuery.textScaler.scale(1.0);

      // Clamp the final combined scale using the value set in init().
      final clampedCombinedScale = min(_maxAccessibilityScale, combinedScale);

      textScaler = TextScaler.linear(clampedCombinedScale);
    } else {
      // If not preserving accessibility, just use the responsive scale factor.
      textScaler = TextScaler.linear(scaleFactor);
    }

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: textScaler),
      child: child,
    );
  }
}

/// Extension on BuildContext to easily access the scale factor for manual scaling.
extension ResponsiveContext on BuildContext {
  /// The current responsive scale factor, clamped by min/maxScale.
  double get scaleFactor => ResponsiveScaler.getScaleFactor(this);
}
