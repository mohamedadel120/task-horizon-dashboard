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
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          const DashboardStatsRow(),
          SizedBox(height: 24.h),
          _buildQuickActions(context),
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
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Welcome back! Here\'s what\'s happening with your inventory.',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          QuickActionTile(
            iconPath: 'assets/icons/product_icon.svg',
            label: 'Products',
            onTap: () => context.go('/products'),
          ),
          SizedBox(height: 12.h),
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
