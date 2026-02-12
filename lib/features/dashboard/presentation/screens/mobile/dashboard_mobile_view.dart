import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/dashboard/presentation/widgets/dashboard_stats_row.dart';
import 'package:task_dashboard/features/dashboard/presentation/widgets/quick_actions_card.dart';

class DashboardMobileView extends StatelessWidget {
  const DashboardMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.pagePadding;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 20.h),
          const DashboardStatsRow(),
          SizedBox(height: 20.h),
          _buildQuickActions(context),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Welcome back! Here\'s what\'s happening with your inventory.',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.grey300),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick actions',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          QuickActionTile(
            iconPath: 'assets/icons/product_icon.svg',
            label: 'Products',
            onTap: () => context.go('/products'),
          ),
          SizedBox(height: 10.h),
          QuickActionTile(
            iconPath: 'assets/icons/categories_icon.svg',
            label: 'Categories',
            onTap: () => context.go('/categories'),
          ),
        ],
      ),
    );
  }
}
