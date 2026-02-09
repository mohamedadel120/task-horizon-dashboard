import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class CreateCategoryCard extends StatelessWidget {
  const CreateCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/categories/add'),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.bgLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorManager.grey300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: ColorManager.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 32.sp,
                color: ColorManager.mainColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Create New Category',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Organize your products',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
