import 'package:flutter/material.dart';

/// Centralized font weights (to keep it clean and reusable)
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

/// Example text styles aligned with Material 3, now covering all weights
class AppTextStyles {
  // --- Display Styles (very large text, impactful) ---
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: AppFontWeights.regular,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: AppFontWeights.regular,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: AppFontWeights.regular,
  );

  // --- Headline Styles ---
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: AppFontWeights.bold,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: AppFontWeights.semiBold,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
  );

  // --- Title Styles ---
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: AppFontWeights.medium,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: AppFontWeights.medium,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  // --- Body Styles ---
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeights.regular,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.regular,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
  );

  // --- Label Styles ---
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.medium,
  );

  static const TextStyle labelSmall = TextStyle(
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
