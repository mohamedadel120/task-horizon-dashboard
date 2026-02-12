import 'package:flutter/material.dart';

/// Breakpoints used across the app for responsive layout.
/// Use with [ResponsiveBreakpoints] or [BuildContext] extension.
class Breakpoints {
  Breakpoints._();

  /// Mobile: typically phones (portrait and small landscape)
  static const double mobile = 600;

  /// Tablet: tablets and large phones
  static const double tablet = 900;

  /// Desktop: small laptops and up
  static const double desktop = 1200;

  /// Extra small phones (e.g. 320px width)
  static const double mobileSm = 360;
}

/// Responsive helpers for [BuildContext].
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet => screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Use for layout: show drawer instead of permanent sidebar when false.
  bool get showSidebar => screenWidth >= Breakpoints.tablet;

  /// Number of grid columns for category/product grids.
  int get gridCrossAxisCount {
    if (screenWidth < Breakpoints.mobile) return 1;
    if (screenWidth < Breakpoints.tablet) return 2;
    return 3;
  }

  /// Horizontal padding for page content (responsive).
  double get pagePadding {
    if (screenWidth < Breakpoints.mobileSm) return 12;
    if (screenWidth < Breakpoints.mobile) return 16;
    if (screenWidth < Breakpoints.tablet) return 20;
    return 24;
  }

  /// Minimum touch target size (Material: 48x48).
  static const double minTouchTarget = 48;

  /// Safe area insets (for bottom nav, notches, etc.).
  EdgeInsets get safePadding => MediaQuery.paddingOf(this);
}
