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

/// **Important — Static State Limitation:**
/// Scale factors (`widthScale`, `heightScale`, `radiusScale`) are stored as
/// static variables and updated each time [scale] is called from
/// `MaterialApp.builder`. In standard single-window mobile apps this is
/// always correct. In split-screen, multi-window, or any scenario where
/// multiple `MediaQuery` contexts exist simultaneously, these statics will
/// reflect the last-built context only. In those cases, use `LayoutBuilder`
/// for widget-level responsive sizing instead of the `.w`/`.h`/`.r` extensions.
///
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
  static double _scalingPower = 1.0;

  // Default value is set to infinity, but it will be updated in the init method if the developer wants to set a custom value.
  static double? _maxAccessibilityScale;

  /// Static variables to hold screen data for global access.
  static double screenWidth = 0;

  /// Static variables to hold screen data for global access.

  static double screenHeight = 0;

  static bool _isScaled = false;

  /// Returns whether the ResponsiveScaler has been initialized.
  static bool get isInitialized => _isScaled;

  /// Initializes the ResponsiveScaler with your app's design specifications.
  ///
  /// This must be called once in your main() function before runApp().
  ///
  /// [designWidth] The width in pixels that your UI was designed for (e.g., 390 for iPhone 12)
  /// [minScale] Minimum scaling factor to prevent text from becoming too small (default: 0.8)
  /// [maxScale] Maximum scaling factor to prevent text from becoming too large (default: 1.4)
  /// [scalingPower] Controls the scaling curve. 1.0 = linear (default).
  /// Values below 1.0 produce a gentler curve where close screen sizes
  /// feel more similar. Recommended range: 0.5–1.0.
  /// [maxAccessibilityScale] Maximum scale when accessibility settings are considered (default: 1.8)
  static void init({
    required double designWidth,
    required double designHeight,
    double minScale = 0.8,
    double maxScale = 1.4,
    double scalingPower = 1.0,
    double? maxAccessibilityScale,
  }) {
    _designWidth = designWidth;
    _designHeight = designHeight;
    _minScale = minScale;
    _maxScale = maxScale;
    _scalingPower = scalingPower;
    _maxAccessibilityScale = maxAccessibilityScale ?? (maxScale * 1.3);
    if (_maxAccessibilityScale! < maxScale) {
      throw ArgumentError(
        'maxAccessibilityScale ($_maxAccessibilityScale) must be >= maxScale ($maxScale).',
      );
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

    final mediaQuery = MediaQuery.of(context);

    // --- Capture and store screen data statically ---
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    // Scale based on width
    final rawScaleWidth = pow(screenWidth / _designWidth!, _scalingPower).toDouble();
    widthScale = rawScaleWidth.clamp(_minScale, _maxScale);

    // Scale based on height
    final rawScaleHeight = pow(screenHeight / _designHeight!, _scalingPower).toDouble();
    heightScale = rawScaleHeight.clamp(_minScale, _maxScale);

    // Use the min of rawScaleWidth and rawScaleHeight so that the UI elements don't overflow
    // Default for TextScaling
    final rawScaleRadius = min(rawScaleWidth, rawScaleHeight);
    radiusScale = rawScaleRadius.clamp(_minScale, _maxScale);

    // Use a local variable for calculations within this method for clarity.
    final localScaleFactor = min(_maxScale, max(_minScale, rawScaleRadius));

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
