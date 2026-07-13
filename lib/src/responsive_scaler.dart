import 'package:flutter/material.dart';
import 'dart:math';

/// Defines the strategy for scaling values based on device dimensions.
enum ScaleType {
  /// Scales based on the ratio of current screen width to design width.
  width,

  /// Scales based on the ratio of current screen height to design height.
  height,

  /// Scales based on the smaller of the width or height ratios (prevents overflow).
  radius,
}

/// A utility class that provides automatic responsive scaling for Flutter apps.
class ResponsiveScaler {
  // Singleton instance for thread-safe, multi-instance support
  static final ResponsiveScalerService _instance = ResponsiveScalerService._();

  /// Returns the singleton instance
  static ResponsiveScalerService get instance => _instance;

  /// Returns whether the ResponsiveScaler has been initialized.
  static bool get isInitialized => _instance.isInitialized;

  /// Static variables to hold screen data for global access.
  /// Returns the current screen width for the active window.
  static double get screenWidth => _instance.getWindowState().screenWidth;

  /// Sets the screen width for the active window.
  static set screenWidth(double val) =>
      _instance.getWindowState().screenWidth = val;

  /// Returns the current screen height for the active window.
  static double get screenHeight => _instance.getWindowState().screenHeight;

  /// Sets the screen height for the active window.
  static set screenHeight(double val) =>
      _instance.getWindowState().screenHeight = val;

  /// Returns the current width scale factor for the active window.
  static double get widthScale => _instance.getWindowState().widthScale;

  /// Sets the width scale factor for the active window.
  static set widthScale(double val) =>
      _instance.getWindowState().widthScale = val;

  /// Returns the current height scale factor for the active window.
  static double get heightScale => _instance.getWindowState().heightScale;

  /// Sets the height scale factor for the active window.
  static set heightScale(double val) =>
      _instance.getWindowState().heightScale = val;

  /// Returns the current radius scale factor for the active window.
  static double get radiusScale => _instance.getWindowState().radiusScale;

  /// Sets the radius scale factor for the active window.
  static set radiusScale(double val) =>
      _instance.getWindowState().radiusScale = val;

  /// Initializes the ResponsiveScaler with your app's design specifications.
  static void init({
    required double designWidth,
    required double designHeight,
    double minScale = 0.8,
    double maxScale = 1.4,
    double scalingPower = 1.0,
    double? maxAccessibilityScale,
  }) {
    _instance.init(
      designWidth: designWidth,
      designHeight: designHeight,
      minScale: minScale,
      maxScale: maxScale,
      scalingPower: scalingPower,
      maxAccessibilityScale: maxAccessibilityScale,
    );
  }

  /// Resets all static state to initial values.
  static void reset() {
    _instance.reset();
  }

  /// A widget builder that applies automatic scaling to all descendant Text widgets.
  static Widget scale({
    required BuildContext context,
    required Widget child,
    bool useMaxAccessibility = false,
  }) {
    return ResponsiveScalerWidget(
      useMaxAccessibility: useMaxAccessibility,
      child: child,
    );
  }

  /// Ensures that the ResponsiveScaler has been initialized.
  static void ensureInitialized() {
    if (!_instance.isInitialized || !_instance.isScaled) {
      throw StateError(
        'ResponsiveScaler.init() and ResponsiveScaler.scale() must be called first.',
      );
    }
  }
}

/// Service that manages the responsive scaling state and calculations.
class ResponsiveScalerService {
  ResponsiveScalerService._();

  double? _designWidth;
  double? _designHeight;
  double _minScale = 0.8;
  double _maxScale = 1.4;
  double _scalingPower = 1.0;
  double? _maxAccessibilityScale;

  bool _isScaled = false;
  bool _isInitialized = false;

  /// The width design specification.
  double? get designWidth => _designWidth;

  /// The height design specification.
  double? get designHeight => _designHeight;

  /// The minimum scale factor limit.
  double get minScale => _minScale;

  /// The maximum scale factor limit.
  double get maxScale => _maxScale;

  /// The scaling power exponent.
  double get scalingPower => _scalingPower;

  /// The maximum scale allowed when accounting for accessibility text scaling.
  double? get maxAccessibilityScale => _maxAccessibilityScale;

  /// Returns whether a scale calculation has been performed.
  bool get isScaled => _isScaled;

  /// Returns whether the service has been initialized.
  bool get isInitialized => _isInitialized;

  // Per-window state map with LRU eviction
  final Map<GlobalKey, WindowState> _states = {};
  final int _maxStates = 100;
  final Set<GlobalKey> _recentlyAccessed = {};

  GlobalKey? _activeKey;

  /// Map of window states keyed by their unique global key.
  Map<GlobalKey, WindowState> get states => _states;

  /// Set of recently accessed window keys, used for LRU eviction.
  Set<GlobalKey> get recentlyAccessed => _recentlyAccessed;

  /// The key of the currently active/focused window.
  GlobalKey? get activeKey => _activeKey;

  /// Sets the key of the currently active/focused window.
  set activeKey(GlobalKey? key) => _activeKey = key;

  late final WindowState _fallbackState = WindowState()
    .._widthScale = 1.0
    .._heightScale = 1.0
    .._radiusScale = 1.0;

  /// Initializes the responsive scaling service.
  void init({
    required double designWidth,
    required double designHeight,
    double minScale = 0.8,
    double maxScale = 1.4,
    double scalingPower = 1.0,
    double? maxAccessibilityScale,
  }) {
    // Validate design dimensions
    if (designWidth <= 0 || designHeight <= 0) {
      throw ArgumentError(
        'designWidth ($designWidth) and designHeight ($designHeight) must be > 0.',
      );
    }

    // Validate scalingPower
    if (scalingPower < 0.1 || scalingPower > 10.0) {
      throw ArgumentError(
        'scalingPower ($scalingPower) must be between 0.1 and 10.0.',
      );
    }

    // Validate maxAccessibilityScale
    final accessibilityMax = maxAccessibilityScale ?? (maxScale * 1.3);
    if (accessibilityMax < maxScale) {
      throw ArgumentError(
        'maxAccessibilityScale ($accessibilityMax) must be >= maxScale ($maxScale).',
      );
    }

    // Validate config on every re-init
    if (_designWidth == designWidth &&
        _designHeight == designHeight &&
        _minScale == minScale &&
        _maxScale == maxScale &&
        _scalingPower == scalingPower &&
        _maxAccessibilityScale == accessibilityMax) {
      // Config unchanged — skip re-init
      return;
    }

    // Clear old state
    _states.clear();
    _recentlyAccessed.clear();
    _activeKey = null;
    _isScaled = false;
    _isInitialized = false;

    // Double-check concurrent initialization pattern
    if (_isInitialized) return;

    _designWidth = designWidth;
    _designHeight = designHeight;
    _minScale = minScale;
    _maxScale = maxScale;
    _scalingPower = scalingPower;
    _maxAccessibilityScale = accessibilityMax;
    _isInitialized = true;
  }

  /// Resets the responsive scaling service state to initial defaults.
  void reset() {
    _states.clear();
    _recentlyAccessed.clear();
    _activeKey = null;
    _designWidth = null;
    _designHeight = null;
    _minScale = 0.8;
    _maxScale = 1.4;
    _scalingPower = 1.0;
    _maxAccessibilityScale = null;
    _isScaled = false;
    _isInitialized = false;

    // Reset fallback state as well
    _fallbackState.widthScale = 1.0;
    _fallbackState.heightScale = 1.0;
    _fallbackState.radiusScale = 1.0;
    _fallbackState.screenWidth = 0.0;
    _fallbackState.screenHeight = 0.0;
  }

  /// Initializes and returns a new window state for the given global key.
  WindowState initWindowState(GlobalKey key) {
    if (!_states.containsKey(key)) {
      // Evict least recently used if over limit
      if (_states.length >= _maxStates) {
        final toEvict = _states.keys.firstWhere(
          (k) => !_recentlyAccessed.contains(k),
          orElse: () => _states.keys.first,
        );
        _states.remove(toEvict);
        _recentlyAccessed.remove(toEvict);
      }
      _states[key] = WindowState();
    }
    _markAccessed(key);
    return _states[key]!;
  }

  void _markAccessed(GlobalKey key) {
    _recentlyAccessed.remove(key);
    _recentlyAccessed.add(key);
    if (_recentlyAccessed.length > _maxStates) {
      _recentlyAccessed.remove(_recentlyAccessed.first);
    }
  }

  /// Updates the window state corresponding to the given global key using the provided media query data.
  void updateWindowState(
    GlobalKey key,
    MediaQueryData mediaQuery,
    bool useMaxAccessibility,
  ) {
    final state = _states[key];
    if (state != null) {
      state._update(
        mediaQuery: mediaQuery,
        useMaxAccessibility: useMaxAccessibility,
      );
      _markAccessed(key);
      _isScaled = true;
    }
  }

  /// Returns the current window state, defaulting to the fallback state if none exists.
  WindowState getWindowState() {
    if (_activeKey != null && _states.containsKey(_activeKey)) {
      return _states[_activeKey]!;
    }
    if (_states.isNotEmpty) {
      return _states.values.first;
    }
    return _fallbackState;
  }
}

/// Container for the scaling and dimensions state of a specific window.
class WindowState {
  double _widthScale = 1.0;
  double _heightScale = 1.0;
  double _radiusScale = 1.0;
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;

  /// Creates a new [WindowState].
  WindowState();

  /// The width scale factor calculated for this window.
  double get widthScale => _widthScale;

  /// Sets the width scale factor for this window.
  set widthScale(double val) => _widthScale = val;

  /// The height scale factor calculated for this window.
  double get heightScale => _heightScale;

  /// Sets the height scale factor for this window.
  set heightScale(double val) => _heightScale = val;

  /// The radius scale factor calculated for this window.
  double get radiusScale => _radiusScale;

  /// Sets the radius scale factor for this window.
  set radiusScale(double val) => _radiusScale = val;

  /// The screen width of this window.
  double get screenWidth => _screenWidth;

  /// Sets the screen width of this window.
  set screenWidth(double val) => _screenWidth = val;

  /// The screen height of this window.
  double get screenHeight => _screenHeight;

  /// Sets the screen height of this window.
  set screenHeight(double val) => _screenHeight = val;

  void _update({
    required MediaQueryData mediaQuery,
    required bool useMaxAccessibility,
  }) {
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    final service = ResponsiveScaler.instance;
    if (service.designWidth == null || service.designHeight == null) {
      throw StateError(
        'ResponsiveScaler.init() must be called before scaling calculations.',
      );
    }

    final double designWidth;
    final double designHeight;
    if (mediaQuery.orientation == Orientation.landscape) {
      designWidth = max(service.designWidth!, service.designHeight!);
      designHeight = min(service.designWidth!, service.designHeight!);
    } else {
      designWidth = service.designWidth!;
      designHeight = service.designHeight!;
    }

    final rawScaleWidth = pow(
      max(0.0, _screenWidth) / designWidth,
      service.scalingPower,
    ).toDouble();
    _widthScale = rawScaleWidth.clamp(service.minScale, service.maxScale);

    final rawScaleHeight = pow(
      max(0.0, _screenHeight) / designHeight,
      service.scalingPower,
    ).toDouble();
    _heightScale = rawScaleHeight.clamp(service.minScale, service.maxScale);

    final rawScaleRadius = min(rawScaleWidth, rawScaleHeight);
    _radiusScale = rawScaleRadius.clamp(service.minScale, service.maxScale);
  }
}

/// A widget that applies responsive text scaling to its child subtree.
class ResponsiveScalerWidget extends StatefulWidget {
  /// The widget tree below this widget.
  final Widget child;

  /// Whether to use the maximum accessibility scale limit.
  final bool useMaxAccessibility;

  /// Creates a new [ResponsiveScalerWidget].
  const ResponsiveScalerWidget({
    super.key,
    required this.child,
    required this.useMaxAccessibility,
  });

  @override
  State<ResponsiveScalerWidget> createState() => _ResponsiveScalerWidgetState();
}

class _ResponsiveScalerWidgetState extends State<ResponsiveScalerWidget> {
  late final GlobalKey _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey(debugLabel: 'ResponsiveScalerWindow');
    ResponsiveScaler.instance.initWindowState(_key);
  }

  @override
  void dispose() {
    ResponsiveScaler.instance.states.remove(_key);
    ResponsiveScaler.instance.recentlyAccessed.remove(_key);
    if (ResponsiveScaler.instance.activeKey == _key) {
      ResponsiveScaler.instance.activeKey = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mq = MediaQuery.of(context);

        // Update active key and trigger scaling calculation
        ResponsiveScaler.instance.activeKey = _key;
        ResponsiveScaler.instance.updateWindowState(
          _key,
          mq,
          widget.useMaxAccessibility,
        );

        final state = ResponsiveScaler.instance.getWindowState();
        final systemScale = mq.textScaler.scale(1.0);
        final combinedScale = state.radiusScale * systemScale;

        final TextScaler textScaler;
        if (widget.useMaxAccessibility == false) {
          textScaler = TextScaler.linear(combinedScale);
        } else {
          final clampedScale = min(
            ResponsiveScaler.instance.maxAccessibilityScale ??
                (state.radiusScale * 1.3),
            combinedScale,
          );
          textScaler = TextScaler.linear(clampedScale);
        }

        return MediaQuery(
          data: mq.copyWith(textScaler: textScaler),
          child: widget.child,
        );
      },
    );
  }
}
