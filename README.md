# Responsive Scaler

[![pub version](https://img.shields.io/pub/v/responsive_scaler.svg)](https://pub.dev/packages/responsive_scaler)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter package that offers a simple, automatic, and boilerplate-free way to make your app's UI (text, icons, spacing) responsive across different screen sizes.

## Why Responsive Scaler?

Ever feel like making your app responsive involves too much setup? Many solutions, like `screen_util`, are powerful but require you to wrap every single value with special units (`.sp`, `.w`, `.h`). This can add a lot of boilerplate and make your code harder to read.

**Responsive Scaler takes a different approach:**

*   **Zero Boilerplate for Text:** Wrap your app **once**, and all your standard `Text` widgets become responsive automatically. No need to change `Text` to `ResponsiveText`.
*   **Respects Accessibility:** Automatically honors the user's system-level font size settings, ensuring your app is accessible to everyone.
*   **Simple & Intuitive:** Instead of complex calculations, it uses a simple, breakpoint-based scale factor. What you see on a standard phone (`width: ~400px`) is the baseline (1.0x scale).
*   **Easy Integration:** Designed to be dropped into existing production apps with minimal code changes.

## Behind the Scenes: How It Works

The magic lies in Flutter's own `MediaQuery`.

1.  **Calculate Scale Factor:** The package first determines a `scaleFactor` based on the screen's width. It uses simple, logical breakpoints: small phones get a factor < 1.0, and larger devices get a factor > 1.0.
2.  **Modify MediaQuery:** When you use `ResponsiveScaler.scale()`, it takes the existing `MediaQuery` data and creates a new one.
3.  **Inject a New TextScaler:** It replaces the `textScaler` in the new `MediaQuery` with one that incorporates our `scaleFactor`. Crucially, it multiplies this factor with the user's existing accessibility font scaling, preserving their preferences.
4.  **Automatic Scaling:** Because your entire app is now a child of this new `MediaQuery`, every standard `Text` widget underneath it will naturally use the new responsive `textScaler`.

That's it! No stream of values, no complex listeners. Just a simple, inherited scaling factor.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  responsive_scaler: ^latest_version
```

Then, run `flutter pub get` in your terminal.

## How to Use

### 1. The One-Time Setup (Global Scaling)

To make all text in your app responsive, wrap your `MaterialApp` with `ResponsiveScaler.scale`. The best way to do this is with the `builder` property.

```dart
// filepath: lib/main.dart
import 'package:flutter/material.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap your app with ResponsiveApp for automatic scaling
    return ResponsiveApp(
      builder: (context) => MaterialApp(
        title: 'Responsive App',
        home: MyHomePage(),
      ),
    );
  }
}
```

**And you're done!** Now, all your `Text` widgets will scale automatically.

```dart
// This text will now scale automatically on different screen sizes!
Text(
  'This is a headline',
  style: AppTextStyles.headlineMedium, // Your existing text styles work perfectly
)
```

The scaling also applies to any `Text` widget, even if you define the `TextStyle` inline:

```dart
// Even with a manually defined TextStyle, it just works.
Text(
  'Some other text',
  style: TextStyle(
    fontSize: 16, // This will be scaled automatically
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
)
```

### 2. Responsive Spacing

For consistent spacing in `SizedBox`, `Padding`, or `margin`, use the `ResponsiveSpacing` class. It provides spacing based on a percentage of the screen's height or width.

```dart
import 'package:responsive_scaler/responsive_scaler.dart';

// Example in a Column
Column(
  children: [
    Text('Item 1'),
    SizedBox(height: ResponsiveSpacing.heightMedium(context)), // Responsive height
    Text('Item 2'),
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSpacing.widthLarge(context), // Responsive padding
      ),
      child: Text('Item 3'),
    ),
  ],
)
```

### 3. Responsive Icons & Images

You can scale any fixed size (like for icons, SVGs, or image dimensions) using the `scaledSize` helper or the `AppIconSizes` methods.

#### Using `AppIconSizes`

For common icon sizes that follow your design system.

```dart
import 'package:responsive_scaler/responsive_scaler.dart';

Icon(
  Icons.favorite,
  size: AppIconSizes.size28(context), // Provides a scaled size
)
```

#### Using the `scaledSize` Helper

For any custom size you need.

```dart
import 'package:responsive_scaler/responsive_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';

Row(
  children: [
    // Scaling an SVG
    SvgPicture.asset(
      'assets/my_icon.svg',
      width: scaledSize(context, 24), // Base size is 24
    ),
    // Scaling a regular image
    Image.asset(
      'assets/my_image.png',
      height: scaledSize(context, 100), // Base size is 100
    ),
  ],
)
```

### 4. Pre-defined Text Styles

The package includes a set of Material 3-aligned text styles in `AppTextStyles`. Using these helps maintain a consistent look and feel. Since text scaling is automatic, you use them just like you normally would.

For a detailed guide on all available styles and their use cases, see the [AppTextStyles Guide](AppTextStylesGuide.md).

```dart
import 'package:responsive_scaler/responsive_scaler.dart';

Text(
  'Welcome to my app!',
  style: AppTextStyles.displaySmall, // This will be scaled automatically
)
```

#### Customizing Styles with `copyWith`

Need to change the color or make a specific text bold? You can easily customize the pre-defined styles using the `.copyWith()` method. This gives you full control while reusing the base font size and weight.

```dart
Text(
  'This is an important title!',
  // Start with a base style and then customize it
  style: AppTextStyles.titleLarge.copyWith(
    color: Colors.deepPurple,
    fontWeight: FontWeight.w900, // Make it extra bold
  ),
)
```

Enjoy building beautifully responsive apps with less effort!