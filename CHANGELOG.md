# 0.1.0
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