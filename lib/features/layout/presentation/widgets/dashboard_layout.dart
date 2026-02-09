import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/app_sidebar.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/app_top_bar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  List<String> _getBreadcrumbs(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location == '/dashboard') return ['Dashboard'];
    if (location == '/categories') return ['Dashboard', 'Categories'];
    if (location == '/categories/add') {
      return ['Dashboard', 'Categories', 'Add Category'];
    }
    if (location == '/products') return ['Dashboard', 'Products'];
    if (location == '/products/add') {
      return ['Dashboard', 'Products', 'Add Product'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgLight,
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                AppTopBar(breadcrumbs: _getBreadcrumbs(context)),
                // Page Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
