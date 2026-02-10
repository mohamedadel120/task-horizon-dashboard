import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: const Border(
          right: BorderSide(color: ColorManager.grey300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 32.w,
                  height: 32.h,
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
          // Menu Items with SVG icons
          SidebarMenuItem(
            iconPath: 'assets/icons/dashboard_icon.svg',
            label: 'Dashboard',
            route: '/dashboard',
            isSelected: currentRoute == '/dashboard',
          ),
          SidebarMenuItem(
            iconPath: 'assets/icons/product_icon.svg',
            label: 'Products',
            route: '/products',
            isSelected: currentRoute.startsWith('/products'),
          ),
          SidebarMenuItem(
            iconPath: 'assets/icons/categories_icon.svg',
            label: 'Categories',
            route: '/categories',
            isSelected: currentRoute.startsWith('/categories'),
          ),
          SidebarMenuItem(
            iconPath: 'assets/icons/order_icon.svg',
            label: 'Orders',
            route: '/orders',
            badgeCount: 4,
            isSelected: currentRoute == '/orders',
          ),
          SidebarMenuItem(
            iconPath: 'assets/icons/customer_icon.svg',
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
            iconPath: 'assets/icons/general_icon.svg',
            label: 'General',
            route: '/settings/general',
            isSelected: currentRoute == '/settings/general',
          ),
          SidebarMenuItem(
            iconPath: 'assets/icons/security_icon.svg',
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
