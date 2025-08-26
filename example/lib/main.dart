import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
// Assuming your package files are structured like this
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization remains the same - this is where the magic starts
  ResponsiveScaler.init(designWidth: 390, maxAccessibilityScale: 1.8);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // The builder is crucial. It captures the screen data on each rebuild.
      builder: (context, child) {
        final scaledChild = ResponsiveScaler.scale(
          context: context,
          child: child!,
        );

        return ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
          child: scaledChild,
        );
      },
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSpacing.wLarge),
            child: ResponsiveRowColumn(
              layout: isMobile
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      // --- CHANGE: Using context-free ResponsiveSpacing constants ---
                      bottom: isMobile ? ResponsiveSpacing.hLarge : 0,
                      right: isMobile ? 0 : ResponsiveSpacing.wLarge,
                    ),
                    child: SvgPicture.asset(
                      "assets/login_illustration.svg",
                      // --- CHANGE: Using the simpler, context-free scaled() helper ---
                      height: isMobile ? scaled(200) : scaled(300),
                    ),
                  ),
                ),

                // Login Form
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  // --- CHANGE: Removed context passing, as it's no longer needed ---
                  child: _buildLoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- CHANGE: This method no longer needs the BuildContext ---
  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(ResponsiveSpacing.wMedium),
        constraints:
            BoxConstraints(maxWidth: scaled(400)), // Constrain form width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text scales automatically
            Text("Welcome Back 👋", style: AppTextStyles.headlineMedium),

            SizedBox(height: ResponsiveSpacing.hMedium),

            // Email
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: ResponsiveSpacing.hMedium),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: ResponsiveSpacing.hCustom(0.05)),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6c63ff),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSpacing.hMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Text scales automatically
                child: Text("Login", style: AppTextStyles.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
