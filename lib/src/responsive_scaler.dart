import 'package:flutter/material.dart';
import 'dart:math';

/// Defines the strategy for scaling values based on device dimensions.
enum ScaleType {
  /// Scales based on the ratio of current screen width to design width.
  width,

  /// Scales based on the ratio of current screen height to design height.
  height,

  /// Scales based on the smaller of the width or height ratios (prevents overflow).
  radius
}

/// A utility class that provides automatic responsive scaling for Flutter apps.
///
/// This class enables automatic text scaling and provides screen dimension data
/// for responsive UI components without requiring manual wrapping of every widget.
class ResponsiveScaler {
  // Global configuration variables, set once at app start.
  static double? _designWidth;
  static double? _designHeight;
  static double _minScale = 0.8;
  static double _maxScale = 1.4;

  // Default value is set to infinity, but it will be updated in the init method if the developer wants to set a custom value.
  static double? _maxAccessibilityScale;

  /// Static variables to hold screen data for global access.
  static double screenWidth = 0;

  /// Static variables to hold screen data for global access.

  static double screenHeight = 0;

  /// Static variables to hold screen data for global access.

  static double scaleFactor = 0;

static bool _isScaled = false;

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
    required double designHeight,
    double minScale = 0.8,
    double maxScale = 1.4,
    double? maxAccessibilityScale,
  }) {
    _designWidth = designWidth;
    _designHeight = designHeight;
    _minScale = minScale;
    _maxScale = maxScale;
    if (maxAccessibilityScale != null) {
      if (maxAccessibilityScale < maxScale) {
        throw ArgumentError(
          'maxAccessibilityScale ($maxAccessibilityScale) must be >= maxScale ($maxScale).',
        );
      }

      _maxAccessibilityScale = maxAccessibilityScale;
    }
  }

  /// Static variables to store the scale factors
  ///
  /// [widthScale] The scale factor based on the width of the screen
  static double widthScale = 0.0;

  /// [heightScale] The scale factor based on the height of the screen
  static double heightScale = 0.0;

  /// [radiusScale] The scale factor based on the smaller of the width or height ratios
  static double radiusScale = 0.0;

  /// A widget builder that applies automatic scaling to all descendant Text widgets.
  ///
  /// Wrap your app's root widget with this method to enable automatic text scaling.
  ///
  /// [context] The build context
  /// [child] The widget tree to apply scaling to
  /// [useMaxAccessibility] Whether to respect system accessibility text scaling (default: true)
  static Widget scale({
    required BuildContext context,
    required Widget child,
    bool useMaxAccessibility = false,
  }) {
    if (_designWidth == null || _designHeight == null) {
      throw StateError(
        'ResponsiveScaler.init() must be called before using scale().',
      );
    }

    if (useMaxAccessibility && _maxAccessibilityScale == null) {
      throw StateError(
        'maxAccessibilityScale must be provided when useMaxAccessibility is true.',
      );
    }

    final mediaQuery = MediaQuery.of(context);

    // --- Capture and store screen data statically ---
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    // Scale based on width
    final rawScaleWidth = screenWidth / _designWidth!;
    widthScale = rawScaleWidth.clamp(_minScale, _maxScale);

    // Scale based on height
    final rawScaleHeight = screenHeight / _designHeight!;
    heightScale = rawScaleHeight.clamp(_minScale, _maxScale);

    // Use the min of rawScaleWidth and rawScaleHeight so that the UI elements don't overflow
    // Default for TextScaling
    final rawScaleRadius = min(rawScaleWidth, rawScaleHeight);
    radiusScale = rawScaleRadius.clamp(_minScale, _maxScale);

    // Use a local variable for calculations within this method for clarity.
    final localScaleFactor = min(_maxScale, max(_minScale, rawScaleRadius));

    // Update the static variable for external helpers to use.
    scaleFactor = localScaleFactor;
    _isScaled = true;

    // System accessibility scaling
    final systemScale = mediaQuery.textScaler.scale(1.0);
    final combinedScale = localScaleFactor * systemScale;

    // The rest of your existing scale() method logic for TextScaler...
    final TextScaler textScaler;
    if (useMaxAccessibility == false) {
      textScaler = TextScaler.linear(combinedScale);
    } else {
      final clampedScale = min(_maxAccessibilityScale!, combinedScale);
      textScaler = TextScaler.linear(clampedScale);
    }

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: textScaler),
      child: child,
    );
  }

  /// Ensures that the ResponsiveScaler has been initialized.
  static void ensureInitialized() {
    if (!_isScaled) {
      throw StateError(
        'ResponsiveScaler.init() and ResponsiveScaler.scale() must be called first.',
      );
    }
  }
}
