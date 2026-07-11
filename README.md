# Responsive Scaler


[![pub version](https://img.shields.io/pub/v/responsive_scaler.svg)](https://pub.dev/packages/responsive_scaler)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Responsive Scaler** is a lightweight, zero-boilerplate scaling engine for Flutter. It provides a linear, clamped scaling system that ensures your UI remains proportional across mobile, tablet, and desktop without the overhead of manual wrapping or step-based breakpoints.

---

## 💎 Key Value Propositions

* **Zero-Boilerplate Text:** Initialize once; all `Text` widgets scale automatically. No `.sp` or `.fontSize` wrappers required.
* **Linear Scaling Engine:** Smooth transitions between screen sizes. No "jarring" jumps when resizing windows.
* **Advanced Clamping:** Industry-first "Double-Layer" clamping (Global + Local) to prevent UI implosion on tiny screens or explosion on 4K monitors.
* **Accessibility Guardrails:** Deep integration with `TextScaler` that respects system settings while capping maximum growth to prevent layout breakage.
* **The "Radius" Philosophy:** Uses the shortest-side logic (`.r`) to ensure padding and icons remain consistent even in landscape orientation.

---

## 📊 The Responsive Landscape

| Feature | **Responsive Scaler** | **ScreenUtil** | **Responsive Framework** |
| :--- | :--- | :--- | :--- |
| **Text Scaling** | **Automatic** (Global Injection) | Manual (`16.sp`) | Breakpoint-based (Not linear) |
| **Effort** | **Set & Forget** | High (Wrap every value) | Medium (Layout logic focus) |
| **Scaling Style** | Smooth Linear | Smooth Linear | Step-based Jumps |
| **Safety** | **Global + Local Clamping** | None (Manual only) | Range-based |
| **Primary Goal** | **Component Scaling** | Pixel Perfection | **Adaptive Layouts** |

> **Pro Tip:** Use **Responsive Scaler** for scaling (fonts, icons, spacing) and **Responsive Framework** for adaptive layouts (changing a Column to a Row). They are the perfect combo.

---

## ⚠️ Migration & Breaking Changes (v0.1.0)

> [!IMPORTANT]
> The global `scale()` function (e.g., `scale(50)`) has been **removed**.
> You must now use the extension methods on `num` types.

```dart
// OLD (Removed)
scale(50)

// NEW Extension Methods

// From previous version
50.scale() // Defaults to width-based scale
50.scale(type: ScaleType.width, minValue: 100, maxValue: 300) 

// ----- RECOMMENDED -----
// Shorthands
50.w  // Width-based
50.h  // Height-based
50.r  // Radius/Minimum-based

// With Clamping
50.wc(minValue: 100, maxValue: 300) // Width-based with clamping
50.hc(minValue: 50) // Height-based with clamping
50.rc(minValue: 25) // Radius-based with clamping
```

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  responsive_scaler: ^latest_version
```

Then run `flutter pub get`.

---

## 🛠 Getting Started

### 1. Initialize the Scaler

In your `main.dart`, call `ResponsiveScaler.init()` **before** `runApp()`. 
You must provide the `designWidth` and `designHeight` from your design file (e.g., Figma).

```dart
import 'package:responsive_scaler/responsive_scaler.dart';

void main() {
  ResponsiveScaler.init(
    designWidth: 375,  // e.g., iPhone Design Width
    designHeight: 812, // e.g., iPhone Design Height
    minScale: 0.8,     // Optional: Minimum scale factor (default 0.8)
    maxScale: 1.4,     // Optional: Maximum scale factor (default 1.4)
    scalingPower: 1.0, // Optional: Controls scaling curve (default 1.0)
    maxAccessibilityScale: 1.8, // Optional: Limit for system text scaling
  );

  runApp(const MyApp());
}
```

### 2. Apply Scaling to the App

Wrap your app using `ResponsiveScaler.scale` in the `MaterialApp` builder.

> [!NOTE]
> Set `useMaxAccessibility: true` to enable the accessibility clamping feature configured in `init()`.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ResponsiveScaler.scale(
          context: context,
          child: child!,
          useMaxAccessibility: true, // Enables accessibility clamping
        );
      },
      home: const HomePage(),
    );
  }
}
```

---

## 📖 Usage Guide

### 1. Automatic Text Scaling

Once initialized, **standard `Text` widgets scale automatically**. You don't need to do anything special.
> [!NOTE]
> Do not use `const` with `Text` widgets

```dart
// This text automatically scales based on screen width/height
// No `const` should be used!!
// Reason: `const` widgets are "frozen" and won't listen to the MediaQuery updates 
// that drive the responsive scaling.
Text(
  'Hello World',
  style: TextStyle(fontSize: 16), 
)

// OR
Text(
  'Hello World',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

### 2. Scaling Sizes & Spacing

For non-text elements (containers, icons, padding), use the extension methods on `num`.

#### Basic Extensions

| Extension | Meaning | Best Used For |
|-----------|---------|---------------|
| `.w` | Width-based scale | Horizontal widths, margins, padding |
| `.h` | Height-based scale | Vertical heights, margins, padding |
| `.r` | Radius-based scale (Min of W/H) | Icons, circular avatars, square containers |

```dart
Container(
  width: 100.w,      // Scales with screen width
  height: 200.h,     // Scales with screen height
  padding: EdgeInsets.all(16.r), // Scales evenly
);
```

#### Clamped Scaling (`.wc`, `.hc`, `.rc`)

Use these to prevent UI elements from becoming too small or too large, regardless of the screen size.

```dart
// Width scaled, but never smaller than 100 or larger than 300
width: 200.wc(minValue: 100, maxValue: 300),

// Height scaled, but never smaller than 50
height: 100.hc(minValue: 50),
```

### 3. Spacing Guidelines

For spacing between widgets, use the `.r` (Radius/Shortest Side) scaling strategy directly with `SizedBox` or padding. This ensures padding, margins, and gaps remain proportional across different screen aspect ratios and orientations without distorting the visual grid.

```dart
Column(
  children: [
    Text("Title"),
    SizedBox(height: 16.r), // Standardized responsive vertical gap
    Text("Subtitle"),
  ],
)
```

#### Standard Spacing Recommendations

| Spacing Size | Value | Usage |
| :--- | :--- | :--- |
| **Extra Small** | `4.r` | Minimal gaps, tight inline spacing |
| **Small** | `8.r` | Small margins, compact item spacing |
| **Medium** | `16.r` | Standard layout margins, list item spacing |
| **Large** | `24.r` | Section separation, outer container padding |
| **Extra Large** | `32.r` | Major page sections, prominent gaps |

---

## 🔍 Deep Dive: Under the Hood

How does Responsive Scaler actually calculate sizes?

### 1. The Core Calculation
The scaler calculates a ratio based on the current screen size vs. your design size.

$$ Scale_{width} = \frac{\text{Current Screen Width}}{\text{Design Width}} $$

$$ Scale_{height} = \frac{\text{Current Screen Height}}{\text{Design Height}} $$

### 2. Clamping Logic
To prevent UI from breaking on extremely large (tablets/desktop) or small (watches/mini) screens, the calculated scale factor is **clamped**.

```dart
FinalScale = clamp(CalculatedScale, minScale, maxScale)
```
*Defined in `init()`.*

### 3. The "Radius" Scale (`.r`)
For elements that should maintain their aspect ratio (like Icons or square Avatars), we use the **Scaling Radius**. This is simply the **minimum** of the width and height scales.

```dart
RadiusScale = min(WidthScale, HeightScale)
```
This ensures that an icon doesn't grow disproportionately huge just because the device is very tall (like a foldable) or very wide (like a tablet).

### 4. Accessibility Protection
For Text, we multiply the `RadiusScale` by the user's System Text Scale (from OS settings).
However, if `useMaxAccessibility` is enabled, we apply a safety cap:

```dart
FinalTextScale = min(RadiusScale * SystemScale, maxAccessibilityScale)
```

This ensures that even if a user sets their phone to "Huge Text", your app's layout won't break completely, while still respecting their need for larger text.

### 5. Split-Screen & Multi-Instance Support
Responsive Scaler features native support for multi-window and split-screen environments (such as iPad multitasking or desktop resizing). 

Instead of relying solely on global static variables, the scaler maintains state for active window contexts. When multiple `ResponsiveScalerWidget`s are active:
- Each window calculates and caches its scale factors (`WindowState`) independently.
- Calculations update dynamically as windows are resized.
- The most recently focused window is used to resolve global scale parameters.

---

## 🏗️ Built with Responsive Scaler

Check out this project to see the package in action:

*   [**muditpurohit.tech**](https://muditpurohit.tech) – A portfolio website that stays perfectly proportioned from mobile to desktop.