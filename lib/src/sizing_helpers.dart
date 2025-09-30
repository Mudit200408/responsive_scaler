import 'dart:math';
import 'package:responsive_scaler/responsive_scaler.dart';

/// Scales a given size by the global [ResponsiveScaler.scaleFactor], with optional clamping.
///
/// The result is:
///   - Clamped between [minValue] and [maxValue] if both are provided.
///   - Clamped to at least [minValue] if only [minValue] is provided.
///   - Clamped to at most [maxValue] if only [maxValue] is provided.
///   - Returned as-is if neither is provided.
///
/// Example:
///   scaled(100, minValue: 120, maxValue: 140) with scaleFactor=1.5
///   → 100 * 1.5 = 150, clamped to 140.
///
double scale(double size, {double? minValue, double? maxValue}) {
  double value = size * ResponsiveScaler.scaleFactor;
  if (minValue != null)
    value = maxValue != null
        ? value.clamp(minValue, maxValue)
        : max(value, minValue);
  if (maxValue != null)
    value = minValue != null
        ? value.clamp(minValue, maxValue)
        : min(value, maxValue);
  return value;
}

/// Extension on [num] to provide a convenient `.scale` getter with optional clamping.
///
/// Usage:
///   16.scale(minValue: 12, maxValue: 20) or 16.scale()
///   → Scales 16 by [ResponsiveScaler.scaleFactor] and clamps the result.
///
extension ScaleExtension on num {
  /// Scales the number by the global [ResponsiveScaler.scaleFactor], with optional clamping.
  ///
  /// See [scaled] for clamping logic and examples.
  double scale({double? minValue, double? maxValue}) {
    double value = this * ResponsiveScaler.scaleFactor;
    if (minValue != null)
      value = maxValue != null
          ? value.clamp(minValue, maxValue)
          : max(value, minValue);
    if (maxValue != null)
      value = minValue != null
          ? value.clamp(minValue, maxValue)
          : min(value, maxValue);
    return value;
  }
}
