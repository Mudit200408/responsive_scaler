import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  // Helper to wrap a widget with a specific screen width
  Widget wrapWithMediaQuery(double width, Widget child) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: MaterialApp(
        home: Builder(builder: (context) => child),
      ),
    );
  }

  group('ResponsiveScaler getScaleFactor', () {
    testWidgets('returns 0.8 for very small phones (<= 320)', (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(320, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 0.8);
    });

    testWidgets('returns 0.9 for small phones (<= 375)', (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(375, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 0.9);
    });

    testWidgets('returns 1.0 for regular phones (<= 414)', (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(414, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 1.0);
    });

    testWidgets('returns 1.1 for large phones/small tablets (<= 768)',
        (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(768, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 1.1);
    });

    testWidgets('returns 1.2 for tablets (<= 1024)', (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(1024, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 1.2);
    });

    testWidgets('returns 1.4 for large desktops (> 1440)', (tester) async {
      double? scale;
      await tester.pumpWidget(
        wrapWithMediaQuery(1500, Builder(builder: (context) {
          scale = context.scaleFactor;
          return Container();
        })),
      );
      expect(scale, 1.4);
    });
  });

  group('ResponsiveScaler.scale widget', () {
    testWidgets('correctly scales Text widget', (tester) async {
      // Define a base text widget
      const text = Text('Hello', style: TextStyle(fontSize: 10));

      // Wrap it with the scaler on a "tablet" screen size
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1024, 800)),
            child: ResponsiveApp(
              builder: (context) => const Scaffold(body: text),
            ),
          ),
        ),
      );

      // Find the Text widget
      final textWidget = tester.widget<Text>(find.text('Hello'));

      // On a 1024px screen, scale factor is 1.2.
      // The effective font size should be 10 * 1.2 = 12.
      // We check the textScaler's scale method to confirm this.
      final textScaler = textWidget.textScaler as TextScaler;
      expect(textScaler.scale(10), 12.0);
    });
  });
}