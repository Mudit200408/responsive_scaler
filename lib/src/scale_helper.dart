import 'package:flutter/widgets.dart';
import 'scale_manager.dart';

/// Scale any size (icon, svg, spacing etc.) based on the responsive factor
double scaledSize(BuildContext context, double baseSize) {
  return baseSize * context.scaleFactor;
}
