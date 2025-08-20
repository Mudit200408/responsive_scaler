import 'package:flutter/material.dart';

class ResponsiveScaler {
  /// Get responsive scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // More granular breakpoints
    if (width <= 320) return 0.8;   // very small phones
    if (width <= 375) return 0.9;   // small phones
    if (width <= 414) return 1.0;   // regular phones
    if (width <= 768) return 1.1;   // large phones/small tablets
    if (width <= 1024) return 1.2;  // tablets
    if (width <= 1440) return 1.3;  // small desktop
    return 1.4;                     // large desktop
  }

  /// Wrap your app with this for automatic scaling
  static Widget scale({
    required BuildContext context,
    required Widget child,
    bool preserveAccessibility = true,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final scaleFactor = getScaleFactor(context);
    
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: preserveAccessibility 
          ? TextScaler.linear(scaleFactor * mediaQuery.textScaler.scale(1.0))
          : TextScaler.linear(scaleFactor),
      ),
      child: child,
    );
  }
}

extension ResponsiveContext on BuildContext {
  double get scaleFactor => ResponsiveScaler.getScaleFactor(this);
}