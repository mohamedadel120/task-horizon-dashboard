import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/dashboard/presentation/widgets/dashboard_stats_row.dart';
import 'package:task_dashboard/features/dashboard/presentation/widgets/quick_actions_card.dart';

class DashboardDesktopView extends StatelessWidget {
  const DashboardDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = context.pagePadding;
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 32.h),
          const DashboardStatsRow(),
          SizedBox(height: 32.h),
          const QuickActionsCard(),
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
            fontSize: 28.sp,
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
}
