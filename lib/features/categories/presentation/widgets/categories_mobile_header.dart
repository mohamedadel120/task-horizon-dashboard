import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

/// Categories screen header for mobile (title, subtitle, Add Category button).
class CategoriesMobileHeader extends StatelessWidget {
  const CategoriesMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Organize your products into catalog groups.',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/categories/add'),
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.mainColor,
              foregroundColor: ColorManager.white,
              minimumSize: const Size(double.infinity, 48),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
