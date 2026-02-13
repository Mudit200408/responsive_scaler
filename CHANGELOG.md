# 1.0.1 🎉
* Add Deprecate message in `ResponsiveSpacing` class in favor of `.r` extension (e.g., `16.r`)
* Remove `publish_to` field from the `pubspec.yaml` file

# 1.0.0 
* **BREAKING:** `scale(value, minValue, maxValue)` is now removed in favor of `value.scale(minValue, maxValue, type)`
* Add `ScaleType` enum (`width`, `height`, `radius`) for explicit scaling strategies
* Add `designHeight` parameter to `ResponsiveScaler.init()` for height-based scaling
* Add convenient extension getters: `.w`, `.h`, `.r` for quick scaling
* Add clamped extension methods: `.wc()`, `.hc()`, `.rc()` with optional `minValue`/`maxValue`
* Add `widthScale`, `heightScale`, and `radiusScale` static accessors
* Add `ensureInitialized()` safety check
* Deprecate `ResponsiveSpacing` in favor of `.r` extension (e.g., `16.r`)
* Fix logic of `preserveAccessibility` parameter and renamed it to `useMaxAccessibility`
* Improve documentation and README

## 0.1.0
* Make the scaling logic more robust
* Remove AppTextStyles dependency, Redundant since the default TextTheme is already responsive
* Update `scaled(baseSize)` to `scale(baseSize, minValue, maxValue)` for more developer control
* Add `baseSize.scale(minValue, maxValue)` helper function for easier scaling of arbitrary values
* Update the Readme documentation

## 0.0.2
* Updated and improved documentation
* Migrated to flutter_lints 6.0.0 for better linting support

## 0.0.1
* Initial release
* Automatic text scaling with zero boilerplate
* Responsive icons and spacing helpers
* Accessibility support with configurable limits
* Smooth linear scaling with developer-defined design width
* Pre-defined Material 3 text styles
* Easy integration with existing apps