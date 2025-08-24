import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ResponsiveScaler.init(designWidth: 390, maxAccessibilityScale: 1.5);

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
            padding: EdgeInsets.all(ResponsiveSpacing.widthLarge(context)),
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
                      bottom: isMobile
                          ? ResponsiveSpacing.heightLarge(context)
                          : 0,
                      right: isMobile
                          ? 0
                          : ResponsiveSpacing.widthLarge(context),
                    ),
                    child: SvgPicture.asset(
                      "assets/login_illustration.svg",
                      height: isMobile
                          ? scaledSize(context, 100)
                          : scaledSize(context, 200),
                    ),
                  ),
                ),

                // Login Form
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: _buildLoginForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(ResponsiveSpacing.widthMedium(context)),
        //constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome Back 👋", style: AppTextStyles.headlineMedium),
            SizedBox(height: ResponsiveSpacing.heightMedium(context)),

            // Email
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSpacing.heightMedium(context)),

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
            SizedBox(height: ResponsiveSpacing.heightLarge(context)),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSpacing.heightMedium(context),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Login", style: AppTextStyles.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
