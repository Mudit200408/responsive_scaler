// No import 'package:flutter/widgets.dart'; needed
import 'package:responsive_scaler/responsive_scaler.dart';

/// Scales a given size based on the responsive scale factor.
///
/// Use this helper function to scale any numeric value (like icon sizes, padding, etc.)
/// according to the current screen size and scaling configuration.
///
/// Example: `Icon(Icons.home, size: scaled(24))`
double scaled(double size) => size * ResponsiveScaler.scaleFactor;
