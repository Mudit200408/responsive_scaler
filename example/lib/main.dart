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
    maxAccessibilityScale: 2.0,
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
          Container(
            padding: EdgeInsets.all(ResponsiveSpacing.widthMedium(context)),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Radhe Radhe',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMedium,
                ),
                SizedBox(width: ResponsiveSpacing.widthMedium(context)),
                SvgPicture.asset(
                  'assets/star.svg',
                  width: AppIconSizes.size32(context),
                  height: AppIconSizes.size32(context),
                ),
              ],
            ),
          ),

          // --- Responsive Spacing (SizedBox) ---
          SizedBox(height: ResponsiveSpacing.heightMedium(context)),

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveSpacing.widthSmall(context)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Body Small',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              SizedBox(width: ResponsiveSpacing.heightMedium(context)),
              Container(
                padding: EdgeInsets.all(ResponsiveSpacing.widthSmall(context)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Body Medium',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              SizedBox(width: ResponsiveSpacing.heightMedium(context)),
              Container(
                padding: EdgeInsets.all(ResponsiveSpacing.widthSmall(context)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Body Large',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSpacing.heightMedium(context)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Title Small',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall,
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.heightMedium(context)),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Title Medium',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.heightMedium(context)),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Title Large',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSpacing.heightMedium(context)),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Headline Small',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSmall,
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.heightMedium(context)),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Headline Medium',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineMedium,
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.heightMedium(context)),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveSpacing.widthSmall(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Headline Large',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineLarge,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveSpacing.heightMedium(context)),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Label Small',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: ResponsiveSpacing.widthSmall(context)),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: AppIconSizes.size12(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.widthSmall(context)),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Label Medium',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: ResponsiveSpacing.widthSmall(context)),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: AppIconSizes.size12(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveSpacing.widthSmall(context)),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Label Large',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: ResponsiveSpacing.widthSmall(context)),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: AppIconSizes.size12(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveSpacing.heightLarge(context)),

          // --- Extra Variants with all weights ---
          Text("Thin Font", style: AppTextStyles.thin(16)),
          Text("Extra Light Font", style: AppTextStyles.extraLight(16)),
          Text("Light Font", style: AppTextStyles.light(16)),
          Text("Regular Font", style: AppTextStyles.regular(16)),
          Text("Medium Font", style: AppTextStyles.medium(16)),
          Text("Semi Bold Font", style: AppTextStyles.semiBold(16)),
          Text("Bold Font", style: AppTextStyles.bold(16)),
          Text("Extra Bold Font", style: AppTextStyles.extraBold(16)),
          Text("Black Font", style: AppTextStyles.black(16)),
        ],
      ),
    );
  }
}
