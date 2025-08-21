import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  // 1. Initialize the scaler with your app's design width before running the app.
  // For example, if your UI was designed on a device with a width of 390px.
  ResponsiveScaler.init(
    designWidth: 390,
    // Optional: You can also set min and max scale factors.
    // minScale: 0.8,
    // maxScale: 1.2,
    maxAccessibilityScale: 1.2,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Use the MaterialApp.builder to apply scaling to the entire app.
    return MaterialApp(
      title: 'Responsive Scaler Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      builder: (context, child) {
        // The scale method now reads the global config set in main().
        return ResponsiveScaler.scale(context: context, child: child!);
      },
      home: const MyHomePage(),
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
              // Note: Requires flutter_svg package and an asset in assets/star.svg
              Column(
                children: [
                  const Text("SVG", style: AppTextStyles.labelMedium),
                  SizedBox(height: ResponsiveSpacing.heightExtraSmall(context)),
                  SvgPicture.asset(
                    'assets/star.svg',
                    width: scaledSize(context, 100),
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
