import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/sidebar_menu_item.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/user_profile_card.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Container(
      width: 240.w,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: ColorManager.white,
        border: Border(
          right: BorderSide(color: ColorManager.grey300, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: ColorManager.mainColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.hexagon, color: Colors.white, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Inventra',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Menu Items
          SidebarMenuItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            route: '/dashboard',
            isSelected: currentRoute == '/dashboard',
          ),
          SidebarMenuItem(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            route: '/products',
            isSelected: currentRoute.startsWith('/products'),
          ),
          SidebarMenuItem(
            icon: Icons.category_outlined,
            label: 'Categories',
            route: '/categories',
            isSelected: currentRoute.startsWith('/categories'),
          ),
          SidebarMenuItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Orders',
            route: '/orders',
            badgeCount: 4,
            isSelected: currentRoute == '/orders',
          ),
          SidebarMenuItem(
            icon: Icons.people_outline,
            label: 'Customers',
            route: '/customers',
            isSelected: currentRoute == '/customers',
          ),
          SizedBox(height: 20.h),
          // Settings Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(color: ColorManager.grey300),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SETTINGS',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SidebarMenuItem(
            icon: Icons.settings_outlined,
            label: 'General',
            route: '/settings/general',
            isSelected: currentRoute == '/settings/general',
          ),
          SidebarMenuItem(
            icon: Icons.security_outlined,
            label: 'Security',
            route: '/settings/security',
            isSelected: currentRoute == '/settings/security',
          ),
          const Spacer(),
          // User Profile
          const UserProfileCard(),
        ],
      ),
    );
  }
}
