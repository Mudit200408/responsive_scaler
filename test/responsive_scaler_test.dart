import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  Widget _wrapWithMediaQuery(double width, Widget child) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(home: child),
    );
  }

  testWidgets('Scale factor is 0.85 for very small width', (tester) async {
    double? scale;
    await tester.pumpWidget(
      _wrapWithMediaQuery(350, Builder(builder: (context) {
        scale = context.scaleFactor;
        return Container();
      })),
    );
    expect(scale, 0.85);
  });

  testWidgets('Scale factor is 1.0 for normal phones', (tester) async {
    double? scale;
    await tester.pumpWidget(
      _wrapWithMediaQuery(400, Builder(builder: (context) {
        scale = context.scaleFactor;
        return Container();
      })),
    );
    expect(scale, 1.0);
  });
}
