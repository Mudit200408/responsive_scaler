import 'dart:math';

import 'package:responsive_scaler/responsive_scaler.dart';

/// Extension on [num] to provide convenient shorthand for responsive scaling.
///
/// ### Example Usage:
///
/// **1. Basic Scaling:**
/// ```dart
/// Container(
///   width: 200.w,  // Scales 200 based on width ratio
///   height: 50.h,  // Scales 50 based on height ratio
///   padding: EdgeInsets.all(16.r), // Scales 16 based on "radius" (min ratio)
/// )
/// ```
///
/// **2. Clamped Scaling:**
/// ```dart
///  Width scaling that won't shrink below 150 or grow above 250
/// double size = 200.wc(minValue: 150, maxValue: 250);
///
///  Height scaling that won't shrink below 40
/// double headerHeight = 60.hc(minValue: 40);
/// ```
///
/// **3. Explicit Type Scaling:**
///
/// NOTE: scale(100, minValue: 80, maxValue: 120) is DEPRECATED!!!
///
/// ```dart
///  Defaults to width scaling
/// double x = 100.scale();
///
///  Explicitly choosing radius scaling with clamps
///  Default is ScaleType.width (Same as before, but recommended to use ScaleType.radius for predicatable UI)
///
/// double y = 100.scale(type: ScaleType.radius, minValue: 80, maxValue: 120);
/// ```
extension ScaleExtension on num {
  /// Scales based on width ratio.
  double get w {
    ResponsiveScaler.ensureInitialized();
    return this * ResponsiveScaler.widthScale;
  }

  /// Scales based on height ratio.
  double get h {
    ResponsiveScaler.ensureInitialized();
    return this * ResponsiveScaler.heightScale;
  }

  /// Scales based on the min(widthScale, heightScale).
  double get r {
    ResponsiveScaler.ensureInitialized();
    return this * ResponsiveScaler.radiusScale;
  }

  /// Height scaling with optional [minValue] and [maxValue] clamping.
  double hc({double? minValue, double? maxValue}) {
    ResponsiveScaler.ensureInitialized();
    return _clamp(this * ResponsiveScaler.heightScale, minValue, maxValue);
  }

  /// Width scaling with optional [minValue] and [maxValue] clamping.
  double wc({double? minValue, double? maxValue}) {
    ResponsiveScaler.ensureInitialized();
    return _clamp(this * ResponsiveScaler.widthScale, minValue, maxValue);
  }

  /// Radius scaling with optional [minValue] and [maxValue] clamping.
  double rc({double? minValue, double? maxValue}) {
    ResponsiveScaler.ensureInitialized();
    return _clamp(this * ResponsiveScaler.radiusScale, minValue, maxValue);
  }

  /// Generic scale method. Defaults to [ScaleType.width].
  double scale({
    ScaleType type = ScaleType.width,
    double? minValue,
    double? maxValue,
  }) {
    ResponsiveScaler.ensureInitialized();
    final factor = switch (type) {
      ScaleType.width => ResponsiveScaler.widthScale,
      ScaleType.height => ResponsiveScaler.heightScale,
      ScaleType.radius => ResponsiveScaler.radiusScale,
    };
    return _clamp(this * factor, minValue, maxValue);
  }

  /// Internal helper to apply clamping logic.
  double _clamp(double value, double? minV, double? maxV) {
    if (minV != null && maxV != null) return value.clamp(minV, maxV);
    if (minV != null) return max(value, minV);
    if (maxV != null) return min(value, maxV);
    return value;
  }
}
