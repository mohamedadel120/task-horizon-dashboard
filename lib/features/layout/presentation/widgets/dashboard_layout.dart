import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/app_sidebar.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/app_top_bar.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _getBreadcrumbs(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location == '/dashboard') return ['Dashboard'];
    if (location == '/categories') return ['Dashboard', 'Categories'];
    if (location == '/categories/add') {
      return ['Dashboard', 'Categories', 'Add Category'];
    }
    if (location.startsWith('/categories/edit/')) {
      return ['Dashboard', 'Categories', 'Edit Category'];
    }
    if (location == '/products' || location.startsWith('/products?')) {
      return ['Dashboard', 'Products'];
    }
    if (location == '/products/add') {
      return ['Dashboard', 'Products', 'Add Product'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final showSidebar = context.showSidebar;

    if (showSidebar) {
      return Scaffold(
        backgroundColor: ColorManager.bgLight,
        body: Row(
          children: [
            const AppSidebar(),
            Expanded(
              child: Column(
                children: [
                  AppTopBar(breadcrumbs: _getBreadcrumbs(context)),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgLight,
      drawer: Drawer(
        child: AppSidebar(
          onCloseDrawer: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              breadcrumbs: _getBreadcrumbs(context),
              showMenuButton: true,
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}
