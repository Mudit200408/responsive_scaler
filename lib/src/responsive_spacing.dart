import 'package:flutter/material.dart';

class ResponsiveSpacing {
  // Height-based spacing
  static double heightExtraSmall(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.005;
  static double heightSmall(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.01;
  static double heightMedium(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.015;
  static double heightLarge(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.02;
  static double heightExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.03;

  // Width-based spacing
  static double widthExtraSmall(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.01;
  static double widthSmall(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.02;
  static double widthMedium(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.04;
  static double widthLarge(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.06;
  static double widthExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.08;
}
