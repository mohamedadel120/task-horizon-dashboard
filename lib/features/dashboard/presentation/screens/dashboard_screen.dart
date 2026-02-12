import 'package:flutter/material.dart';
import 'package:task_dashboard/core/widgets/responsive_view.dart';
import 'package:task_dashboard/features/dashboard/presentation/screens/desktop/dashboard_desktop_view.dart';
import 'package:task_dashboard/features/dashboard/presentation/screens/mobile/dashboard_mobile_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveView(
      mobile: DashboardMobileView(),
      desktop: DashboardDesktopView(),
    );
  }
}
