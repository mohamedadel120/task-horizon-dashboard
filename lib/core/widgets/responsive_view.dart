import 'package:flutter/material.dart';
import 'package:task_dashboard/core/utils/responsive.dart';

/// Builds either [mobile] or [desktop] child based on screen width.
/// Uses [Breakpoints.tablet] (900): below = mobile, at or above = desktop.
/// Use this when you have separate mobile and desktop view implementations.
class ResponsiveView extends StatelessWidget {
  const ResponsiveView({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  final Widget mobile;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return context.showSidebar ? desktop : mobile;
  }
}
