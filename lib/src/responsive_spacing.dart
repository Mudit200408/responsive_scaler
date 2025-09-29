// No import 'package:flutter/material.dart'; needed
import 'package:responsive_scaler/responsive_scaler.dart';

/// A collection of pre-scaled spacing constants based on screen dimensions.
///
/// Provides responsive spacing values that automatically adjust to different screen sizes.
/// Use height-based spacing (h*) for vertical spacing and width-based spacing (w*) for horizontal spacing.
class ResponsiveSpacing {
  // Height-based spacing
  static double get hXSmall => ResponsiveScaler.screenHeight * 0.005;
  static double get hSmall => ResponsiveScaler.screenHeight * 0.01;
  static double get hMedium => ResponsiveScaler.screenHeight * 0.015;
  static double get hLarge => ResponsiveScaler.screenHeight * 0.02;
  static double get hXLarge => ResponsiveScaler.screenHeight * 0.03;
  static double hCustom(double factor) =>
      ResponsiveScaler.screenHeight * factor;

  // Width-based spacing
  static double get wXSmall => ResponsiveScaler.screenWidth * 0.01;
  static double get wSmall => ResponsiveScaler.screenWidth * 0.02;
  static double get wMedium => ResponsiveScaler.screenWidth * 0.04;
  static double get wLarge => ResponsiveScaler.screenWidth * 0.06;
  static double get wXLarge => ResponsiveScaler.screenWidth * 0.08;
  static double wCustom(double factor) => ResponsiveScaler.screenWidth * factor;
}
