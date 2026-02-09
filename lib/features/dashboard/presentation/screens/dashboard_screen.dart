import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
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
          SizedBox(height: 24.h),
          // Placeholder for dashboard content
          Center(
            child: Text(
              'Dashboard content coming soon...',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorManager.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
