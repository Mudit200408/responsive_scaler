import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap your MaterialApp with ResponsiveApp for automatic scaling.
    return ResponsiveApp(
      builder: (context) => MaterialApp(
        title: 'Responsive Scaler Example',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Scaler Demo')),
      body: ListView(
        // Using responsive padding for the whole list
        padding: EdgeInsets.all(ResponsiveSpacing.widthMedium(context)),
        children: [
          // --- Text Example (with AppTextStyles) ---
          const Text(
            'Headline (from AppTextStyles)',
            style: AppTextStyles.headlineMedium,
          ),

          // --- Responsive Spacing (SizedBox) ---
          SizedBox(height: ResponsiveSpacing.heightMedium(context)),

          // --- Text Example (without AppTextStyles) ---
          const Text(
            'This is a body text with a manually defined style. It also scales automatically based on screen width.',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),

          SizedBox(height: ResponsiveSpacing.heightLarge(context)),

          const Divider(),

          SizedBox(height: ResponsiveSpacing.heightLarge(context)),

          const Text('Icon and SVG Scaling', style: AppTextStyles.titleLarge),

          SizedBox(height: ResponsiveSpacing.heightSmall(context)),

          // --- Icon and SVG Scaling Example ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Responsive Icon ---
              Column(
                children: [
                  const Text("Icon", style: AppTextStyles.labelMedium),
                  SizedBox(height: ResponsiveSpacing.heightExtraSmall(context)),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: AppIconSizes.size32(context),
                  ),
                ],
              ),

              SizedBox(width: ResponsiveSpacing.widthLarge(context)),

              // --- Responsive SVG ---
              // Note: Requires flutter_svg package and an asset in assets/flutter_logo.svg
              Column(
                children: [
                  const Text("SVG", style: AppTextStyles.labelMedium),
                  SizedBox(height: ResponsiveSpacing.heightExtraSmall(context)),
                  SvgPicture.asset(
                    'assets/star.svg',
                    width: scaledSize(context, 50),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
