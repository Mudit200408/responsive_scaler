import 'package:responsive_scaler/responsive_scaler.dart';

/// DEPRECATED: Use factor.r instead. (4.r, 8.r, 16.r, 24.r, 32.r)
/// A utility class providing standardized, responsive spacing constants.
///
/// These constants use the `.r` (Radius/Shortest Side) scaling strategy.
/// This ensures that padding and margins remain consistent and proportional
/// across different screen aspect ratios and orientations.

@deprecated
class ResponsiveSpacing {
  // --- Height-based (Vertical) Spacing ---

  /// DEPRECATED: Use 4.r instead.
  static double get hXSmall => 4.r;

  /// DEPRECATED: Use 8.r instead.
  static double get hSmall => 8.r;

  /// DEPRECATED: Use 16.r instead.
  static double get hMedium => 16.r;

  /// DEPRECATED: Use 24.r instead.
  static double get hLarge => 24.r;

  /// DEPRECATED: Use 32.r instead.
  static double get hXLarge => 32.r;

  /// DEPRECATED: Use factor.r instead.
  static double hCustom(double factor) => factor.r;

  // --- Width-based (Horizontal) Spacing ---

  /// DEPRECATED: Use 4.r instead.
  static double get wXSmall => 4.r;

  /// DEPRECATED: Use 8.r instead.
  static double get wSmall => 8.r;

  /// DEPRECATED: Use 16.r instead.
  static double get wMedium => 16.r;

  /// DEPRECATED: Use 24.r instead.
  static double get wLarge => 24.r;

  /// DEPRECATED: Use 32.r instead.
  static double get wXLarge => 32.r;

  /// DEPRECATED: Use factor.r instead.
  static double wCustom(double factor) => factor.r;
}
