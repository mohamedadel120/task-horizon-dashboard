import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

/// Empty state for categories list (no categories yet). Used by mobile and desktop views.
class CategoriesEmptyState extends StatelessWidget {
  const CategoriesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: Column(
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.sp,
              color: ColorManager.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Create your first category to start organizing products',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.go('/categories/add'),
              icon: const Icon(Icons.add),
              label: const Text('Create Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.mainColor,
                foregroundColor: ColorManager.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
