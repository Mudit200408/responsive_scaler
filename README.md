# Responsive Scaler (BETA)

[![pub version](https://img.shields.io/pub/v/responsive_scaler.svg)](https://pub.dev/packages/responsive_scaler)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter package that offers a simple, automatic, and boilerplate-free way to make your app's UI (text, icons, spacing) responsive across different screen sizes.

---

## Why Responsive Scaler?

Ever feel like making your app responsive involves too much setup?  
Many solutions, like `screen_util`, are powerful but require you to wrap every single value with special units (`.sp`, `.w`, `.h`).  
Others like `responsive_framework` rely on breakpoint-based scaling, which can cause sudden jumps in size.

**Responsive Scaler takes a different approach:**

*   **Zero Boilerplate for Text:** Initialize **once**, and all your standard `Text` widgets become responsive automatically.
*   **Developer in Control:** You define your app's `designWidth`, giving you a predictable baseline for scaling.
*   **Smooth, Linear Scaling:** No jarring jumps between breakpoints. UI elements scale smoothly as the screen size changes.
*   **Respects Accessibility:** Automatically honors the user's system-level font size settings while providing a safeguard against excessively large text.
*   **Easy Integration:** Designed to be dropped into existing production apps with minimal code changes.

---

## 📊 Comparison with Other Packages

| Feature | **Responsive Scaler (yours)** | **ScreenUtil** | **Responsive Framework** |
|---------|-------------------------------|----------------|---------------------------|
| **Text Scaling** | ✅ Automatic for all `Text` widgets (no boilerplate) | ❌ Manual (`16.sp`) everywhere | ⚠️ Depends on breakpoints, not automatic |
| **Design Width** | ✅ Developer defines once (`designWidth`) | ✅ Developer defines (`designSize`) | ❌ Breakpoints only (no single baseline) |
| **Boilerplate** | ✅ Minimal (init once, wrap MaterialApp) | ❌ High (every value wrapped) | ⚠️ Medium (must define breakpoints, wrap UI in `ResponsiveWrapper`) |
| **Scaling Style** | ✅ Smooth linear scaling | ✅ Linear scaling but manual | ❌ Breakpoint jumps (sizes change in steps) |
| **Accessibility Respect** | ✅ Built-in (`TextScaler` honors system font scaling + clamp) | ❌ Developer must handle manually | ⚠️ Limited (breakpoints don’t always sync with accessibility) |
| **Use Case** | Apps that want **drop-in, automatic responsiveness** with no boilerplate | Fine-grained control for every pixel, but very verbose | Apps where you want **different layouts at fixed screen widths** |

---

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  responsive_scaler: ^latest_version
```

Then, run `flutter pub get` in your terminal.

## How to Use

### Step 1: Initialize the Scaler

In your `lib/main.dart` file, call `ResponsiveScaler.init()` **before** `runApp()`. This is the most important step.

Provide the `designWidth` of the device you are basing your UI on. For example, if you are making and testing the app on Pixel 9 which has a width of `412`.

```dart
// filepath: lib/main.dart
import 'package:flutter/material.dart';
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  // Initialize the scaler with your design width.
  ResponsiveScaler.init(
    designWidth: 393,
    // Optional: Set min/max scale factors for UI elements.
    minScale: 0.8,
    maxScale: 1.2,
    // Optional: Clamp the final text size for accessibility to prevent it from getting too large.
    maxAccessibilityScale: 1.8,
  );

  runApp(const MyApp());
}
```

### Step 2: Apply Scaling to the App

In your `MyApp` widget, use the `MaterialApp.builder` property to wrap your app with `ResponsiveScaler.scale`.

```dart
// filepath: lib/main.dart
// ... (main function from above)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Scaler Example',
      // Use the builder to apply scaling to the entire app.
      builder: (context, child) {
        // The scale method now reads the global config set in main().
        return ResponsiveScaler.scale(context: context, child: child!);
      },
      home: const MyHomePage(),
    );
  }
}
```

### Step 3: Build Your UI Naturally

Now you can build your UI as you normally would. All text, and any sizes calculated with the helpers, will be responsive.

#### **Text Scaling (Automatic)**

All `Text` widgets are now automatically responsive.

```dart
// This scales automatically based on the init() config.
const Text(
  'Headline from AppTextStyles',
  style: AppTextStyles.headlineMedium,
)

// Even manually styled text scales automatically.
const Text(
  'Manually styled text also works!',
  style: TextStyle(fontSize: 16),
)
```

#### **Responsive Icons, Spacing, and Sizes**

Use the helper functions for consistent scaling on non-text elements.

```dart
Column(
  children: [
    // Responsive Icon Size
    Icon(
      Icons.favorite,
      size: AppIconSizes.size32(context),
    ),

    // Responsive Spacing
    SizedBox(height: ResponsiveSpacing.heightMedium(context)),

    // Responsive Custom Size (e.g., for an SVG)
    SvgPicture.asset(
      'assets/star.svg',
      width: scaledSize(context, 50),
    ),
  ],
)
```

## Pre-defined Text Styles

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


## How It Works (Under the Hood)

The logic is based on a simple, powerful idea: calculate a single scale factor and apply it consistently.

### 1. Global Initialization

When you call `ResponsiveScaler.init(designWidth: 393, ...)`, the package stores your `designWidth`, `minScale`, `maxScale`, and `maxAccessibilityScale` values in global static variables. This configuration is done only once and is available throughout the app's lifecycle.

### 2. The Scaling Calculation

Every time a responsive size is needed, the `getScaleFactor` function is called. It performs two key calculations:

#### A. Ratio Calculation

It calculates a raw scale factor by dividing the device's current width by your design width.

`scale = currentWidth / designWidth`

#### B. Clamping for Control

An unconstrained ratio can lead to ridiculously large or tiny UI elements. To prevent this, the raw `scale` is "clamped" to stay within your `minScale` and `maxScale` limits.

`finalScale = min(maxScale, max(minScale, rawScale))`

#### Example Walkthrough

Let's assume you did this in `main.dart`:
`ResponsiveScaler.init(designWidth: 390, minScale: 0.8, maxScale: 1.5);`

And you want an icon with a base size of `30`.

*   **On a small phone (width: 320px):**
    *   `scale = 320 / 390` which is `~0.82`.
    *   This is within the clamp range `[0.8, 1.5]`.
    *   Final icon size = `30 * 0.82` = **`24.6`**. The icon shrinks.

*   **On a large tablet (width: 900px):**
    *   `scale = 900 / 390` which is `~2.3`.
    *   This is *outside* the clamp range. It gets clamped down to the `maxScale`.
    *   Final icon size = `30 * 1.5` = **`45.0`**. The icon grows, but it doesn't become excessively large.

### 3. Applying the Scale Factor

*   **For Text:** The `ResponsiveScaler.scale()` widget wraps your app in a new `MediaQuery`. It creates a custom `TextScaler` by first multiplying the clamped `finalScale` with the user's system accessibility font size. To prevent text from becoming unreadably large, this **combined value is then clamped again** using the `maxAccessibilityScale` you provided in `init()`. This final, safe value is used to draw all `Text` widgets.

*   **For Icons and Sizes:** When you call `scaledSize(context, 50)`, it simply fetches the same clamped `finalScale` and returns `50 * finalScale`. This guarantees that your icons and spacing scale with the exact same logic as your text.

