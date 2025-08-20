import 'package:flutter/material.dart';

/// Material 3–aligned scale manager for text, icons, and SVGs.
/// Respects system accessibility scaling.
class ScaleManager {
  static double getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Material 3 breakpoint-inspired scaling
    if (width < 360) return 0.85; // very small phones
    if (width < 600) return 1.0;  // phones
    if (width < 840) return 1.05; // tablets portrait
    if (width < 1200) return 1.1; // tablets landscape / small desktop
    return 1.15;                  // desktop / large screens
  }

  /// Apply global scaling to MaterialApp, preserving system accessibility scaling
  static Widget applyGlobalScaling(BuildContext context, Widget child) {
    final mq = MediaQuery.of(context);
    final customScale = getScaleFactor(context);

    return MediaQuery(
      data: mq.copyWith(
        textScaler: TextScaler.linear(
          customScale * mq.textScaler.scale(1.0), // combine custom + system scale
        ),
      ),
      child: child,
    );
  }
}

/// Extension for easy scale access
extension ResponsiveContext on BuildContext {
  double get scaleFactor => ScaleManager.getScaleFactor(this);
}
