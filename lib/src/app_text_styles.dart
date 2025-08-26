import 'package:flutter/material.dart';

/// Centralized font weights for consistent typography across the app.
class AppFontWeights {
  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const black = FontWeight.w900;
}

/// Pre-defined text styles following Material 3 design guidelines.
class AppTextStyles {
  // --- Display Styles (very large text, impactful) ---
  static final TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: AppFontWeights.regular,
  );

  static final TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: AppFontWeights.regular,
  );

  static final TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: AppFontWeights.regular,
  );

  // --- Headline Styles ---
  static final TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: AppFontWeights.bold,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: AppFontWeights.semiBold,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
  );

  // --- Title Styles ---
  static final TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: AppFontWeights.medium,
  );

  static final TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: AppFontWeights.medium,
  );

  static final TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  // --- Body Styles ---
  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeights.regular,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.regular,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
  );

  // --- Label Styles ---
  static final TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  static final TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.medium,
  );

  static final TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: AppFontWeights.medium,
  );

  // ---  Extra Variants with all weights ---
  static TextStyle thin(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.thin);
  static TextStyle extraLight(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.extraLight);
  static TextStyle light(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.light);
  static TextStyle regular(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.regular);
  static TextStyle medium(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.medium);
  static TextStyle semiBold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.semiBold);
  static TextStyle bold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.bold);
  static TextStyle extraBold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.extraBold);
  static TextStyle black(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.black);
}
