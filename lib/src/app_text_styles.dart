// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

/// Centralized font weights for consistent typography across the app.
///
/// Provides predefined font weights to ensure design consistency
/// across different text styles.
class AppFontWeights {
  /// Thin font weight (w100).
  static const thin = FontWeight.w100;

  /// Extra-light font weight (w200).
  static const extraLight = FontWeight.w200;

  /// Light font weight (w300).
  static const light = FontWeight.w300;

  /// Regular font weight (w400).
  static const regular = FontWeight.w400;

  /// Medium font weight (w500).
  static const medium = FontWeight.w500;

  /// Semi-bold font weight (w600).
  static const semiBold = FontWeight.w600;

  /// Bold font weight (w700).
  static const bold = FontWeight.w700;

  /// Extra-bold font weight (w800).
  static const extraBold = FontWeight.w800;

  /// Black font weight (w900).
  static const black = FontWeight.w900;
}

/// Pre-defined text styles following Material 3 design guidelines.
///
/// Use these styles for consistent typography across headings,
/// titles, body text, and labels.
class AppTextStyles {
  // --- Display Styles (very large text, impactful) ---

  /// Display style for very large text (57sp).
  static final TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: AppFontWeights.regular,
  );

  /// Display style for large text (45sp).
  static final TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: AppFontWeights.regular,
  );

  /// Display style for medium text (36sp).
  static final TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: AppFontWeights.regular,
  );

  // --- Headline Styles ---

  /// Headline style for large headings (32sp).
  static final TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: AppFontWeights.bold,
  );

  /// Headline style for medium headings (28sp).
  static final TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: AppFontWeights.semiBold,
  );

  /// Headline style for small headings (24sp).
  static final TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: AppFontWeights.semiBold,
  );

  // --- Title Styles ---

  /// Title style for large text (22sp).
  static final TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: AppFontWeights.medium,
  );

  /// Title style for medium text (18sp).
  static final TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: AppFontWeights.medium,
  );

  /// Title style for small text (14sp).
  static final TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  // --- Body Styles ---

  /// Body style for large text (16sp).
  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: AppFontWeights.regular,
  );

  /// Body style for medium text (14sp).
  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.regular,
  );

  /// Body style for small text (12sp).
  static final TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.regular,
  );

  // --- Label Styles ---

  /// Label style for large text (14sp).
  static final TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: AppFontWeights.medium,
  );

  /// Label style for medium text (12sp).
  static final TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: AppFontWeights.medium,
  );

  /// Label style for small text (11sp).
  static final TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: AppFontWeights.medium,
  );

  // ---  Extra Variants with all weights ---

  /// Creates a thin text style with the given [size].
  static TextStyle thin(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.thin);

  /// Creates an extra-light text style with the given [size].
  static TextStyle extraLight(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.extraLight);

  /// Creates a light text style with the given [size].
  static TextStyle light(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.light);

  /// Creates a regular text style with the given [size].
  static TextStyle regular(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.regular);

  /// Creates a medium text style with the given [size].
  static TextStyle medium(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.medium);

  /// Creates a semi-bold text style with the given [size].
  static TextStyle semiBold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.semiBold);

  /// Creates a bold text style with the given [size].
  static TextStyle bold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.bold);

  /// Creates an extra-bold text style with the given [size].
  static TextStyle extraBold(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.extraBold);

  /// Creates a black text style with the given [size].
  static TextStyle black(double size) =>
      TextStyle(fontSize: size, fontWeight: AppFontWeights.black);
}
