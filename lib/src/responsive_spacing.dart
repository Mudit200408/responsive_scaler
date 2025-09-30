// No import 'package:flutter/material.dart'; needed
import 'package:responsive_scaler/responsive_scaler.dart';

/// A collection of pre-scaled spacing constants based on screen dimensions.
///
/// Provides responsive spacing values that automatically adjust to different screen sizes.
/// Use height-based spacing (h*) for vertical spacing and width-based spacing (w*) for horizontal spacing.
class ResponsiveSpacing {
  // Height-based spacing
  /// hXSmall = 0.5% of screen height
  static double get hXSmall => ResponsiveScaler.screenHeight * 0.005;
  /// hSmall = 1% of screen height
  static double get hSmall => ResponsiveScaler.screenHeight * 0.01;
  /// hMedium = 1.5% of screen height
  static double get hMedium => ResponsiveScaler.screenHeight * 0.015;
  /// hLarge = 2% of screen height
  static double get hLarge => ResponsiveScaler.screenHeight * 0.02;
  /// hXLarge = 3% of screen height
  static double get hXLarge => ResponsiveScaler.screenHeight * 0.03;
  /// hCustom = Custom factor of screen height (e.g., 0.05 for 5%)
  static double hCustom(double factor) =>
      ResponsiveScaler.screenHeight * factor;
  
  // Width-based spacing
  /// wXSmall = 1% of screen width
  static double get wXSmall => ResponsiveScaler.screenWidth * 0.01;
  /// wSmall = 2% of screen width
  static double get wSmall => ResponsiveScaler.screenWidth * 0.02;
  /// wMedium = 4% of screen width
  static double get wMedium => ResponsiveScaler.screenWidth * 0.04;
  /// wLarge = 6% of screen width
  static double get wLarge => ResponsiveScaler.screenWidth * 0.06;
  /// wXLarge = 8% of screen width
  static double get wXLarge => ResponsiveScaler.screenWidth * 0.08;
  /// wCustom = Custom factor of screen width (e.g., 0.05 for 5%)
  static double wCustom(double factor) => ResponsiveScaler.screenWidth * factor;
}
