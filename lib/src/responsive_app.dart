import 'package:flutter/material.dart';
import 'scale_manager.dart';

class ResponsiveApp extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final bool enableScaling;
  final bool preserveAccessibility;

  const ResponsiveApp({
    super.key,
    required this.builder,
    this.enableScaling = true,
    this.preserveAccessibility = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = builder(context);
    
    if (!enableScaling) return child;
    
    return ResponsiveScaler.scale(
      context: context,
      child: child,
      preserveAccessibility: preserveAccessibility,
    );
  }
}