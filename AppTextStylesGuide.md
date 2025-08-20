# AppTextStyles Guide

This document provides a reference for the pre-defined text styles available in the `responsive_scaler` package. These styles are based on the Material 3 design typography scale and are designed to create a clear and consistent visual hierarchy in your application.

When using `ResponsiveScaler`, the `fontSize` of each style is automatically scaled based on the screen size, so you only need to choose the style that semantically fits your content.

---

## Display Styles

Display styles are the largest text on the screen, reserved for short, important text or numerals. They are best used sparingly.

| Style Name | Font Size (Base) | Font Weight | Typical Use Case |
| :--- | :--- | :--- | :--- |
| `displayLarge` | 57 | `w400` (Normal) | Hero text on a landing page, key metric on a dashboard. |
| `displayMedium` | 45 | `w400` (Normal) | A secondary, but still very prominent, piece of text. |
| `displaySmall` | 36 | `w400` (Normal) | Important but smaller display text. |

---

## Headline Styles

Headlines are suitable for high-emphasis text that is shorter than a full paragraph. They work well for page and section titles.

| Style Name | Font Size (Base) | Font Weight | Typical Use Case |
| :--- | :--- | :--- | :--- |
| `headlineLarge` | 32 | `w700` (Bold) | Main page titles. |
| `headlineMedium` | 28 | `w600` (Semi-Bold) | Sub-sections or slightly less important headlines. |
| `headlineSmall` | 24 | `w600` (Semi-Bold) | Smaller section titles or prominent list item titles. |

---

## Title Styles

Titles are smaller than headlines and are typically used for medium-emphasis text that introduces a component or a block of content.

| Style Name | Font Size (Base) | Font Weight | Typical Use Case |
| :--- | :--- | :--- | :--- |
| `titleLarge` | 22 | `w500` (Medium) | Titles of dialogs, cards, or important components. |
| `titleMedium` | 18 | `w500` (Medium) | Subtitles within cards, titles for list items. |
| `titleSmall` | 14 | `w500` (Medium) | Less prominent titles, field labels in forms. |

---

## Body Styles

Body styles are used for the main text content of your application, such as descriptions, articles, and long-form text.

| Style Name | Font Size (Base) | Font Weight | Typical Use Case |
| :--- | :--- | :--- | :--- |
| `bodyLarge` | 16 | `w400` (Normal) | The primary text style for readability in long paragraphs. |
| `bodyMedium` | 14 | `w400` (Normal) | Default body text, captions, or secondary information. |
| `bodySmall` | 12 | `w400` (Normal) | Tertiary text, legal disclaimers, or fine print. |

---

## Label Styles

Label styles are used for utility text inside components like buttons, navigation items, or tags. They are typically short and actionable.

| Style Name | Font Size (Base) | Font Weight | Typical Use Case |
| :--- | :--- | :--- | :--- |
| `labelLarge` | 14 | `w500` (Medium) | Text inside large buttons. |
| `labelMedium` | 12 | `w500` (Medium) | Text inside standard buttons, navigation bar items. |
| `labelSmall` | 11 | `w500` (Medium) | Text for small buttons, chips, or overline text. |